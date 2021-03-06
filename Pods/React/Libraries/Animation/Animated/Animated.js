/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 * @providesModule Animated
 * @flow
 */
'use strict';

var Easing = require('Easing');
var Image = require('Image');
var InteractionManager = require('InteractionManager');
var Interpolation = require('Interpolation');
var React = require('React');
var Set = require('Set');
var SpringConfig = require('SpringConfig');
var Text = require('Text');
var View = require('View');
var invariant = require('invariant');

var flattenStyle = require('flattenStyle');
var requestAnimationFrame = require('requestAnimationFrame');

import type InterpolationConfigType from 'Interpolation';

type EndResult = {finished: bool};
type EndCallback = (result: EndResult) => void;

// Note(vjeux): this would be better as an interface but flow doesn't
// support them yet
class Animated {
  attach(): void {}
  detach(): void {}
  __getValue(): any {}
  getAnimatedValue(): any { return this.__getValue(); }
  addChild(child: Animated) {}
  removeChild(child: Animated) {}
  getChildren(): Array<Animated> { return []; }
}

// Important note: start() and stop() will only be called at most once.
// Once an animation has been stopped or finished its course, it will
// not be reused.
class Animation {
  __active: bool;
  __onEnd: ?EndCallback;
  start(
    fromValue: number,
    onUpdate: (value: number) => void,
    onEnd: ?EndCallback,
    previousAnimation: ?Animation,
  ): void {}
  stop(): void {}
  // Helper function for subclasses to make sure onEnd is only called once.
  __debouncedOnEnd(result: EndResult) {
    var onEnd = this.__onEnd;
    this.__onEnd = null;
    onEnd && onEnd(result);
  }
}

class AnimatedWithChildren extends Animated {
  _children: Array<Animated>;

  constructor() {
    super();
    this._children = [];
  }

  addChild(child: Animated): void {
    if (this._children.length === 0) {
      this.attach();
    }
    this._children.push(child);
  }

  removeChild(child: Animated): void {
    var index = this._children.indexOf(child);
    if (index === -1) {
      console.warn('Trying to remove a child that doesn\'t exist');
      return;
    }
    this._children.splice(index, 1);
    if (this._children.length === 0) {
      this.detach();
    }
  }

  getChildren(): Array<Animated> {
    return this._children;
  }
}

/**
 * Animated works by building a directed acyclic graph of dependencies
 * transparently when you render your Animated components.
 *
 *               new Animated.Value(0)
 *     .interpolate()        .interpolate()    new Animated.Value(1)
 *         opacity               translateY      scale
 *          style                         transform
 *         View#234                         style
 *                                         View#123
 *
 * A) Top Down phase
 * When an Animated.Value is updated, we recursively go down through this
 * graph in order to find leaf nodes: the views that we flag as needing
 * an update.
 *
 * B) Bottom Up phase
 * When a view is flagged as needing an update, we recursively go back up
 * in order to build the new value that it needs. The reason why we need
 * this two-phases process is to deal with composite props such as
 * transform which can receive values from multiple parents.
 */
function _flush(rootNode: AnimatedValue): void {
  var animatedStyles = new Set();
  function findAnimatedStyles(node) {
    if (typeof node.update === 'function') {
      animatedStyles.add(node);
    } else {
      node.getChildren().forEach(findAnimatedStyles);
    }
  }
  findAnimatedStyles(rootNode);
  animatedStyles.forEach(animatedStyle => animatedStyle.update());
}

type TimingAnimationConfig = {
  toValue: number;
  easing?: (value: number) => number;
  duration?: number;
  delay?: number;
};

var easeInOut = Easing.inOut(Easing.ease);

class TimingAnimation extends Animation {
  _startTime: number;
  _fromValue: number;
  _toValue: number;
  _duration: number;
  _delay: number;
  _easing: (value: number) => number;
  _onUpdate: (value: number) => void;
  _animationFrame: any;
  _timeout: any;

  constructor(
    config: TimingAnimationConfig,
  ) {
    super();
    this._toValue = config.toValue;
    this._easing = config.easing || easeInOut;
    this._duration = config.duration !== undefined ? config.duration : 500;
    this._delay = config.delay || 0;
  }

  start(
    fromValue: number,
    onUpdate: (value: number) => void,
    onEnd: ?EndCallback,
  ): void {
    this.__active = true;
    this._fromValue = fromValue;
    this._onUpdate = onUpdate;
    this.__onEnd = onEnd;

    var start = () => {
      if (this._duration === 0) {
        this._onUpdate(this._toValue);
        this.__debouncedOnEnd({finished: true});
      } else {
        this._startTime = Date.now();
        this._animationFrame = requestAnimationFrame(this.onUpdate.bind(this));
      }
    };
    if (this._delay) {
      this._timeout = setTimeout(start, this._delay);
    } else {
      start();
    }
  }

  onUpdate(): void {
    var now = Date.now();
    if (now >= this._startTime + this._duration) {
      if (this._duration === 0) {
        this._onUpdate(this._toValue);
      } else {
        this._onUpdate(
          this._fromValue + this._easing(1) * (this._toValue - this._fromValue)
        );
      }
      this.__debouncedOnEnd({finished: true});
      return;
    }

    this._onUpdate(
      this._fromValue +
        this._easing((now - this._startTime) / this._duration) *
        (this._toValue - this._fromValue)
    );
    if (this.__active) {
      this._animationFrame = requestAnimationFrame(this.onUpdate.bind(this));
    }
  }

  stop(): void {
    this.__active = false;
    clearTimeout(this._timeout);
    window.cancelAnimationFrame(this._animationFrame);
    this.__debouncedOnEnd({finished: false});
  }
}

type DecayAnimationConfig = {
  velocity: number | {x: number, y: number};
  deceleration?: number;
};

type DecayAnimationConfigSingle = {
  velocity: number;
  deceleration?: number;
};

class DecayAnimation extends Animation {
  _startTime: number;
  _lastValue: number;
  _fromValue: number;
  _deceleration: number;
  _velocity: number;
  _onUpdate: (value: number) => void;
  _animationFrame: any;

  constructor(
    config: DecayAnimationConfigSingle,
  ) {
    super();
    this._deceleration = config.deceleration || 0.998;
    this._velocity = config.velocity;
  }

  start(
    fromValue: number,
    onUpdate: (value: number) => void,
    onEnd: ?EndCallback,
  ): void {
    this.__active = true;
    this._lastValue = fromValue;
    this._fromValue = fromValue;
    this._onUpdate = onUpdate;
    this.__onEnd = onEnd;
    this._startTime = Date.now();
    this._animationFrame = requestAnimationFrame(this.onUpdate.bind(this));
  }

  onUpdate(): void {
    var now = Date.now();

    var value = this._fromValue +
      (this._velocity / (1 - this._deceleration)) *
      (1 - Math.exp(-(1 - this._deceleration) * (now - this._startTime)));

    this._onUpdate(value);

    if (Math.abs(this._lastValue - value) < 0.1) {
      this.__debouncedOnEnd({finished: true});
      return;
    }

    this._lastValue = value;
    if (this.__active) {
      this._animationFrame = requestAnimationFrame(this.onUpdate.bind(this));
    }
  }

  stop(): void {
    this.__active = false;
    window.cancelAnimationFrame(this._animationFrame);
    this.__debouncedOnEnd({finished: false});
  }
}

type SpringAnimationConfig = {
  toValue: number | AnimatedValue | {x: number, y: number} | AnimatedValueXY;
  overshootClamping?: bool;
  restDisplacementThreshold?: number;
  restSpeedThreshold?: number;
  velocity?: number | {x: number, y: number};
  bounciness?: number;
  speed?: number;
  tension?: number;
  friction?: number;
};

type SpringAnimationConfigSingle = {
  toValue: number | AnimatedValue;
  overshootClamping?: bool;
  restDisplacementThreshold?: number;
  restSpeedThreshold?: number;
  velocity?: number;
  bounciness?: number;
  speed?: number;
  tension?: number;
  friction?: number;
};

function withDefault<T>(value: ?T, defaultValue: T): T {
  if (value === undefined || value === null) {
    return defaultValue;
  }
  return value;
}

class SpringAnimation extends Animation {
  _overshootClamping: bool;
  _restDisplacementThreshold: number;
  _restSpeedThreshold: number;
  _initialVelocity: ?number;
  _lastVelocity: number;
  _startPosition: number;
  _lastPosition: number;
  _fromValue: number;
  _toValue: any;
  _tension: number;
  _friction: number;
  _lastTime: number;
  _onUpdate: (value: number) => void;
  _animationFrame: any;

  constructor(
    config: SpringAnimationConfigSingle,
  ) {
    super();

    this._overshootClamping = withDefault(config.overshootClamping, false);
    this._restDisplacementThreshold = withDefault(config.restDisplacementThreshold, 0.001);
    this._restSpeedThreshold = withDefault(config.restSpeedThreshold, 0.001);
    this._initialVelocity = config.velocity;
    this._lastVelocity = withDefault(config.velocity, 0);
    this._toValue = config.toValue;

    var springConfig;
    if (config.bounciness !== undefined || config.speed !== undefined) {
      invariant(
        config.tension === undefined && config.friction === undefined,
        'You can only define bounciness/speed or tension/friction but not both',
      );
      springConfig = SpringConfig.fromBouncinessAndSpeed(
        withDefault(config.bounciness, 8),
        withDefault(config.speed, 12),
      );
    } else {
      springConfig = SpringConfig.fromOrigamiTensionAndFriction(
        withDefault(config.tension, 40),
        withDefault(config.friction, 7),
      );
    }
    this._tension = springConfig.tension;
    this._friction = springConfig.friction;
  }

  start(
    fromValue: number,
    onUpdate: (value: number) => void,
    onEnd: ?EndCallback,
    previousAnimation: ?Animation,
  ): void {
    this.__active = true;
    this._startPosition = fromValue;
    this._lastPosition = this._startPosition;

    this._onUpdate = onUpdate;
    this.__onEnd = onEnd;
    this._lastTime = Date.now();

    if (previousAnimation instanceof SpringAnimation) {
      var internalState = previousAnimation.getInternalState();
      this._lastPosition = internalState.lastPosition;
      this._lastVelocity = internalState.lastVelocity;
      this._lastTime = internalState.lastTime;
    }
    if (this._initialVelocity !== undefined &&
        this._initialVelocity !== null) {
      this._lastVelocity = this._initialVelocity;
    }
    this.onUpdate();
  }

  getInternalState(): Object {
    return {
      lastPosition: this._lastPosition,
      lastVelocity: this._lastVelocity,
      lastTime: this._lastTime,
    };
  }

  onUpdate(): void {
    var position = this._lastPosition;
    var velocity = this._lastVelocity;

    var tempPosition = this._lastPosition;
    var tempVelocity = this._lastVelocity;

    // If for some reason we lost a lot of frames (e.g. process large payload or
    // stopped in the debugger), we only advance by 4 frames worth of
    // computation and will continue on the next frame. It's better to have it
    // running at faster speed than jumping to the end.
    var MAX_STEPS = 64;
    var now = Date.now();
    if (now > this._lastTime + MAX_STEPS) {
      now = this._lastTime + MAX_STEPS;
    }

    // We are using a fixed time step and a maximum number of iterations.
    // The following post provides a lot of thoughts into how to build this
    // loop: http://gafferongames.com/game-physics/fix-your-timestep/
    var TIMESTEP_MSEC = 1;
    var numSteps = Math.floor((now - this._lastTime) / TIMESTEP_MSEC);

    for (var i = 0; i < numSteps; ++i) {
      // Velocity is based on seconds instead of milliseconds
      var step = TIMESTEP_MSEC / 1000;

      // This is using RK4. A good blog post to understand how it works:
      // http://gafferongames.com/game-physics/integration-basics/
      var aVelocity = velocity;
      var aAcceleration = this._tension * (this._toValue - tempPosition) - this._friction * tempVelocity;
      var tempPosition = position + aVelocity * step / 2;
      var tempVelocity = velocity + aAcceleration * step / 2;

      var bVelocity = tempVelocity;
      var bAcceleration = this._tension * (this._toValue - tempPosition) - this._friction * tempVelocity;
      tempPosition = position + bVelocity * step / 2;
      tempVelocity = velocity + bAcceleration * step / 2;

      var cVelocity = tempVelocity;
      var cAcceleration = this._tension * (this._toValue - tempPosition) - this._friction * tempVelocity;
      tempPosition = position + cVelocity * step / 2;
      tempVelocity = velocity + cAcceleration * step / 2;

      var dVelocity = tempVelocity;
      var dAcceleration = this._tension * (this._toValue - tempPosition) - this._friction * tempVelocity;
      tempPosition = position + cVelocity * step / 2;
      tempVelocity = velocity + cAcceleration * step / 2;

      var dxdt = (aVelocity + 2 * (bVelocity + cVelocity) + dVelocity) / 6;
      var dvdt = (aAcceleration + 2 * (bAcceleration + cAcceleration) + dAcceleration) / 6;

      position += dxdt * step;
      velocity += dvdt * step;
    }

    this._lastTime = now;
    this._lastPosition = position;
    this._lastVelocity = velocity;

    this._onUpdate(position);
    if (!this.__active) { // a listener might have stopped us in _onUpdate
      return;
    }

    // Conditions for stopping the spring animation
    var isOvershooting = false;
    if (this._overshootClamping && this._tension !== 0) {
      if (this._startPosition < this._toValue) {
        isOvershooting = position > this._toValue;
      } else {
        isOvershooting = position < this._toValue;
      }
    }
    var isVelocity = Math.abs(velocity) <= this._restSpeedThreshold;
    var isDisplacement = true;
    if (this._tension !== 0) {
      isDisplacement = Math.abs(this._toValue - position) <= this._restDisplacementThreshold;
    }

    if (isOvershooting || (isVelocity && isDisplacement)) {
      if (this._tension !== 0) {
        // Ensure that we end up with a round value
        this._onUpdate(this._toValue);
      }

      this.__debouncedOnEnd({finished: true});
      return;
    }
    this._animationFrame = requestAnimationFrame(this.onUpdate.bind(this));
  }

  stop(): void {
    this.__active = false;
    window.cancelAnimationFrame(this._animationFrame);
    this.__debouncedOnEnd({finished: false});
  }
}

type ValueListenerCallback = (state: {value: number}) => void;

var _uniqueId = 1;

class AnimatedValue extends AnimatedWithChildren {
  _value: number;
  _offset: number;
  _animation: ?Animation;
  _tracking: ?Animated;
  _listeners: {[key: string]: ValueListenerCallback};

  constructor(value: number) {
    super();
    this._value = value;
    this._offset = 0;
    this._animation = null;
    this._listeners = {};
  }

  detach() {
    this.stopAnimation();
  }

  __getValue(): number {
    return this._value + this._offset;
  }

  setValue(value: number): void {
    if (this._animation) {
      this._animation.stop();
      this._animation = null;
    }
    this._updateValue(value);
  }

  setOffset(offset: number): void {
    this._offset = offset;
  }

  flattenOffset(): void {
    this._value += this._offset;
    this._offset = 0;
  }

  addListener(callback: ValueListenerCallback): string {
    var id = String(_uniqueId++);
    this._listeners[id] = callback;
    return id;
  }

  removeListener(id: string): void {
    delete this._listeners[id];
  }

  removeAllListeners(): void {
    this._listeners = {};
  }

  animate(animation: Animation, callback: ?EndCallback): void {
    var handle = InteractionManager.createInteractionHandle();
    var previousAnimation = this._animation;
    this._animation && this._animation.stop();
    this._animation = animation;
    animation.start(
      this._value,
      (value) => {
        this._updateValue(value);
      },
      (result) => {
        this._animation = null;
        InteractionManager.clearInteractionHandle(handle);
        callback && callback(result);
      },
      previousAnimation,
    );
  }

  stopAnimation(callback?: ?(value: number) => void): void {
    this.stopTracking();
    this._animation && this._animation.stop();
    this._animation = null;
    callback && callback(this.__getValue());
  }

  stopTracking(): void {
    this._tracking && this._tracking.detach();
    this._tracking = null;
  }

  track(tracking: Animated): void {
    this.stopTracking();
    this._tracking = tracking;
  }

  interpolate(config: InterpolationConfigType): AnimatedInterpolation {
    return new AnimatedInterpolation(this, Interpolation.create(config));
  }

  _updateValue(value: number): void {
    this._value = value;
    _flush(this);
    for (var key in this._listeners) {
      this._listeners[key]({value: this.__getValue()});
    }
  }
}

type ValueXYListenerCallback = (value: {x: number; y: number}) => void;
class AnimatedValueXY extends AnimatedWithChildren {
  x: AnimatedValue;
  y: AnimatedValue;
  _listeners: {[key: string]: {x: string; y: string}};

  constructor(valueIn?: ?{x: number | AnimatedValue; y: number | AnimatedValue}) {
    super();
    var value: any = valueIn || {x: 0, y: 0};  // @flowfixme: shouldn't need `: any`
    if (typeof value.x === 'number' && typeof value.y === 'number') {
      this.x = new AnimatedValue(value.x);
      this.y = new AnimatedValue(value.y);
    } else {
      invariant(
        value.x instanceof AnimatedValue &&
        value.y instanceof AnimatedValue,
        'AnimatedValueXY must be initalized with an object of numbers or ' +
        'AnimatedValues.'
      );
      this.x = value.x;
      this.y = value.y;
    }
    this._listeners = {};
  }

  setValue(value: {x: number; y: number}) {
    this.x.setValue(value.x);
    this.y.setValue(value.y);
  }

  setOffset(offset: {x: number; y: number}) {
    this.x.setOffset(offset.x);
    this.y.setOffset(offset.y);
  }

  flattenOffset(): void {
    this.x.flattenOffset();
    this.y.flattenOffset();
  }

  __getValue(): {x: number; y: number} {
    return {
      x: this.x.__getValue(),
      y: this.y.__getValue(),
    };
  }

  stopAnimation(callback?: ?() => number): void {
    this.x.stopAnimation();
    this.y.stopAnimation();
    callback && callback(this.__getValue());
  }

  addListener(callback: ValueXYListenerCallback): string {
    var id = String(_uniqueId++);
    var jointCallback = ({value: number}) => {
      callback(this.__getValue());
    };
    this._listeners[id] = {
      x: this.x.addListener(jointCallback),
      y: this.y.addListener(jointCallback),
    };
    return id;
  }

  removeListener(id: string): void {
    this.x.removeListener(this._listeners[id].x);
    this.y.removeListener(this._listeners[id].y);
    delete this._listeners[id];
  }

  getLayout(): {[key: string]: AnimatedValue} {
    return {
      left: this.x,
      top: this.y,
    };
  }

  getTranslateTransform(): Array<{[key: string]: AnimatedValue}> {
    return [
      {translateX: this.x},
      {translateY: this.y}
    ];
  }
}

class AnimatedInterpolation extends AnimatedWithChildren {
  _parent: Animated;
  _interpolation: (input: number) => number | string;

  constructor(parent: Animated, interpolation: (input: number) => number | string) {
    super();
    this._parent = parent;
    this._interpolation = interpolation;
  }

  __getValue(): number | string {
    var parentValue: number = this._parent.__getValue();
    invariant(
      typeof parentValue === 'number',
      'Cannot interpolate an input which is not a number.'
    );
    return this._interpolation(parentValue);
  }

  interpolate(config: InterpolationConfigType): AnimatedInterpolation {
    return new AnimatedInterpolation(this, Interpolation.create(config));
  }

  attach(): void {
    this._parent.addChild(this);
  }

  detach(): void {
    this._parent.removeChild(this);
  }
}

class AnimatedTransform extends AnimatedWithChildren {
  _transforms: Array<Object>;

  constructor(transforms: Array<Object>) {
    super();
    this._transforms = transforms;
  }

  __getValue(): Array<Object> {
    return this._transforms.map(transform => {
      var result = {};
      for (var key in transform) {
        var value = transform[key];
        if (value instanceof Animated) {
          result[key] = value.__getValue();
        } else {
          result[key] = value;
        }
      }
      return result;
    });
  }

  getAnimatedValue(): Array<Object> {
    return this._transforms.map(transform => {
      var result = {};
      for (var key in transform) {
        var value = transform[key];
        if (value instanceof Animated) {
          result[key] = value.getAnimatedValue();
        } else {
          // All transform components needed to recompose matrix
          result[key] = value;
        }
      }
      return result;
    });
  }

  attach(): void {
    this._transforms.forEach(transform => {
      for (var key in transform) {
        var value = transform[key];
        if (value instanceof Animated) {
          value.addChild(this);
        }
      }
    });
  }

  detach(): void {
    this._transforms.forEach(transform => {
      for (var key in transform) {
        var value = transform[key];
        if (value instanceof Animated) {
          value.removeChild(this);
        }
      }
    });
  }
}

class AnimatedStyle extends AnimatedWithChildren {
  _style: Object;

  constructor(style: any) {
    super();
    style = flattenStyle(style) || {};
    if (style.transform) {
      style = {
        ...style,
        transform: new AnimatedTransform(style.transform),
      };
    }
    this._style = style;
  }

  __getValue(): Object {
    var style = {};
    for (var key in this._style) {
      var value = this._style[key];
      if (value instanceof Animated) {
        style[key] = value.__getValue();
      } else {
        style[key] = value;
      }
    }
    return style;
  }

  getAnimatedValue(): Object {
    var style = {};
    for (var key in this._style) {
      var value = this._style[key];
      if (value instanceof Animated) {
        style[key] = value.getAnimatedValue();
      }
    }
    return style;
  }

  attach(): void {
    for (var key in this._style) {
      var value = this._style[key];
      if (value instanceof Animated) {
        value.addChild(this);
      }
    }
  }

  detach(): void {
    for (var key in this._style) {
      var value = this._style[key];
      if (value instanceof Animated) {
        value.removeChild(this);
      }
    }
  }
}

class AnimatedProps extends Animated {
  _props: Object;
  _callback: () => void;

  constructor(
    props: Object,
    callback: () => void,
  ) {
    super();
    if (props.style) {
      props = {
        ...props,
        style: new AnimatedStyle(props.style),
      };
    }
    this._props = props;
    this._callback = callback;
    this.attach();
  }

  __getValue(): Object {
    var props = {};
    for (var key in this._props) {
      var value = this._props[key];
      if (value instanceof Animated) {
        props[key] = value.__getValue();
      } else {
        props[key] = value;
      }
    }
    return props;
  }

  getAnimatedValue(): Object {
    var props = {};
    for (var key in this._props) {
      var value = this._props[key];
      if (value instanceof Animated) {
        props[key] = value.getAnimatedValue();
      }
    }
    return props;
  }

  attach(): void {
    for (var key in this._props) {
      var value = this._props[key];
      if (value instanceof Animated) {
        value.addChild(this);
      }
    }
  }

  detach(): void {
    for (var key in this._props) {
      var value = this._props[key];
      if (value instanceof Animated) {
        value.removeChild(this);
      }
    }
  }

  update(): void {
    this._callback();
  }
}

function createAnimatedComponent(Component: any): any {
  var refName = 'node';

  class AnimatedComponent extends React.Component {
    _propsAnimated: AnimatedProps;

    componentWillUnmount() {
      this._propsAnimated && this._propsAnimated.detach();
    }

    setNativeProps(props) {
      this.refs[refName].setNativeProps(props);
    }

    componentWillMount() {
      this.attachProps(this.props);
    }

    attachProps(nextProps) {
      var oldPropsAnimated = this._propsAnimated;

      // The system is best designed when setNativeProps is implemented. It is
      // able to avoid re-rendering and directly set the attributes that
      // changed. However, setNativeProps can only be implemented on leaf
      // native components. If you want to animate a composite component, you
      // need to re-render it. In this case, we have a fallback that uses
      // forceUpdate.
      var callback = () => {
        if (this.refs[refName].setNativeProps) {
          var value = this._propsAnimated.getAnimatedValue();
          this.refs[refName].setNativeProps(value);
        } else {
          this.forceUpdate();
        }
      };

      this._propsAnimated = new AnimatedProps(
        nextProps,
        callback,
      );

      // When you call detach, it removes the element from the parent list
      // of children. If it goes to 0, then the parent also detaches itself
      // and so on.
      // An optimization is to attach the new elements and THEN detach the old
      // ones instead of detaching and THEN attaching.
      // This way the intermediate state isn't to go to 0 and trigger
      // this expensive recursive detaching to then re-attach everything on
      // the very next operation.
      oldPropsAnimated && oldPropsAnimated.detach();
    }

    componentWillReceiveProps(nextProps) {
      this.attachProps(nextProps);
    }

    render() {
      return (
        <Component
          {...this._propsAnimated.__getValue()}
          ref={refName}
        />
      );
    }
  }

  return AnimatedComponent;
}

class AnimatedTracking extends Animated {
  _value: AnimatedValue;
  _parent: Animated;
  _callback: ?EndCallback;
  _animationConfig: Object;
  _animationClass: any;

  constructor(
    value: AnimatedValue,
    parent: Animated,
    animationClass: any,
    animationConfig: Object,
    callback?: ?EndCallback,
  ) {
    super();
    this._value = value;
    this._parent = parent;
    this._animationClass = animationClass;
    this._animationConfig = animationConfig;
    this._callback = callback;
    this.attach();
  }

  __getValue(): Object {
    return this._parent.__getValue();
  }

  attach(): void {
    this._parent.addChild(this);
  }

  detach(): void {
    this._parent.removeChild(this);
  }

  update(): void {
    this._value.animate(new this._animationClass({
      ...this._animationConfig,
      toValue: (this._animationConfig.toValue: any).__getValue(),
    }), this._callback);
  }
}

type CompositeAnimation = {
  start: (callback?: ?EndCallback) => void;
  stop: () => void;
};

var maybeVectorAnim = function(
  value: AnimatedValue | AnimatedValueXY,
  config: Object,
  anim: (value: AnimatedValue, config: Object) => CompositeAnimation
): ?CompositeAnimation {
  if (value instanceof AnimatedValueXY) {
    var configX = {...config};
    var configY = {...config};
    for (var key in config) {
      var {x, y} = config[key];
      if (x !== undefined && y !== undefined) {
        configX[key] = x;
        configY[key] = y;
      }
    }
    var aX = anim((value: AnimatedValueXY).x, configX);
    var aY = anim((value: AnimatedValueXY).y, configY);
    // We use `stopTogether: false` here because otherwise tracking will break
    // because the second animation will get stopped before it can update.
    return parallel([aX, aY], {stopTogether: false});
  }
  return null;
};

var spring = function(
  value: AnimatedValue | AnimatedValueXY,
  config: SpringAnimationConfig,
): CompositeAnimation {
  return maybeVectorAnim(value, config, spring) || {
    start: function(callback?: ?EndCallback): void {
      var singleValue: any = value;
      var singleConfig: any = config;
      singleValue.stopTracking();
      if (config.toValue instanceof Animated) {
        singleValue.track(new AnimatedTracking(
          singleValue,
          config.toValue,
          SpringAnimation,
          singleConfig,
          callback
        ));
      } else {
        singleValue.animate(new SpringAnimation(singleConfig), callback);
      }
    },

    stop: function(): void {
      value.stopAnimation();
    },
  };
};

var timing = function(
  value: AnimatedValue | AnimatedValueXY,
  config: TimingAnimationConfig,
): CompositeAnimation {
  return maybeVectorAnim(value, config, timing) || {
    start: function(callback?: ?EndCallback): void {
      var singleValue: any = value;
      var singleConfig: any = config;
      singleValue.stopTracking();
      if (config.toValue instanceof Animated) {
        singleValue.track(new AnimatedTracking(
          singleValue,
          config.toValue,
          TimingAnimation,
          singleConfig,
          callback
        ));
      } else {
        singleValue.animate(new TimingAnimation(singleConfig), callback);
      }
    },

    stop: function(): void {
      value.stopAnimation();
    },
  };
};

var decay = function(
  value: AnimatedValue | AnimatedValueXY,
  config: DecayAnimationConfig,
): CompositeAnimation {
  return maybeVectorAnim(value, config, decay) || {
    start: function(callback?: ?EndCallback): void {
      var singleValue: any = value;
      var singleConfig: any = config;
      singleValue.stopTracking();
      singleValue.animate(new DecayAnimation(singleConfig), callback);
    },

    stop: function(): void {
      value.stopAnimation();
    },
  };
};

var sequence = function(
  animations: Array<CompositeAnimation>,
): CompositeAnimation {
  var current = 0;
  return {
    start: function(callback?: ?EndCallback) {
      var onComplete = function(result) {
        if (!result.finished) {
          callback && callback(result);
          return;
        }

        current++;

        if (current === animations.length) {
          callback && callback(result);
          return;
        }

        animations[current].start(onComplete);
      };

      if (animations.length === 0) {
        callback && callback({finished: true});
      } else {
        animations[current].start(onComplete);
      }
    },

    stop: function() {
      if (current < animations.length) {
        animations[current].stop();
      }
    }
  };
};

type ParallelConfig = {
  stopTogether?: bool; // If one is stopped, stop all.  default: true
}
var parallel = function(
  animations: Array<CompositeAnimation>,
  config?: ?ParallelConfig,
): CompositeAnimation {
  var doneCount = 0;
  // Make sure we only call stop() at most once for each animation
  var hasEnded = {};
  var stopTogether = !(config && config.stopTogether === false);

  var result = {
    start: function(callback?: ?EndCallback) {
      if (doneCount === animations.length) {
        callback && callback({finished: true});
        return;
      }

      animations.forEach((animation, idx) => {
        var cb = function(endResult) {
          hasEnded[idx] = true;
          doneCount++;
          if (doneCount === animations.length) {
            doneCount = 0;
            callback && callback(endResult);
            return;
          }

          if (!endResult.finished && stopTogether) {
            result.stop();
          }
        };

        if (!animation) {
          cb({finished: true});
        } else {
          animation.start(cb);
        }
      });
    },

    stop: function(): void {
      animations.forEach((animation, idx) => {
        !hasEnded[idx] && animation.stop();
        hasEnded[idx] = true;
      });
    }
  };

  return result;
};

var delay = function(time: number): CompositeAnimation {
  // Would be nice to make a specialized implementation
  return timing(new AnimatedValue(0), {toValue: 0, delay: time, duration: 0});
};

var stagger = function(
  time: number,
  animations: Array<CompositeAnimation>,
): CompositeAnimation {
  return parallel(animations.map((animation, i) => {
    return sequence([
      delay(time * i),
      animation,
    ]);
  }));
};

type Mapping = {[key: string]: Mapping} | AnimatedValue;

/**
 *  Takes an array of mappings and extracts values from each arg accordingly,
 *  then calls setValue on the mapped outputs.  e.g.
 *
 *  onScroll={this.AnimatedEvent(
 *    [{nativeEvent: {contentOffset: {x: this._scrollX}}}]
 *    {listener}  // optional listener invoked asynchronously
 *  )
 *  ...
 *  onPanResponderMove: this.AnimatedEvent([
 *    null,                               // raw event arg
 *    {dx: this._panX},                   // gestureState arg
 *  ]),
 *
 */
type EventConfig = {listener?: ?Function};
var event = function(
  argMapping: Array<?Mapping>,
  config?: ?EventConfig,
): () => void {
  return function(...args): void {
    var traverse = function(recMapping, recEvt, key) {
      if (typeof recEvt === 'number') {
        invariant(
          recMapping instanceof AnimatedValue,
          'Bad mapping of type ' + typeof recMapping + ' for key ' + key +
            ', event value must map to AnimatedValue'
        );
        recMapping.setValue(recEvt);
        return;
      }
      invariant(
        typeof recMapping === 'object',
        'Bad mapping of type ' + typeof recMapping + ' for key ' + key
      );
      invariant(
        typeof recEvt === 'object',
        'Bad event of type ' + typeof recEvt + ' for key ' + key
      );
      for (var key in recMapping) {
        traverse(recMapping[key], recEvt[key], key);
      }
    };
    argMapping.forEach((mapping, idx) => {
      traverse(mapping, args[idx], 'arg' + idx);
    });
    if (config && config.listener) {
      config.listener.apply(null, args);
    }
  };
};

module.exports = {
  delay,
  sequence,
  parallel,
  stagger,

  decay,
  timing,
  spring,

  event,

  Value: AnimatedValue,
  ValueXY: AnimatedValueXY,
  __PropsOnlyForTests: AnimatedProps,
  View: createAnimatedComponent(View),
  Text: createAnimatedComponent(Text),
  Image: createAnimatedComponent(Image),
  createAnimatedComponent,
};
