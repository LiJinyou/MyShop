/* This file provided by Facebook is for non-commercial testing and evaluation
 * purposes only.  Facebook reserves all rights not expressly granted.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "QuoteWithBackgroundComponent.h"

@implementation QuoteWithBackgroundComponent

+ (instancetype)newWithBackgroundImage:(UIImage *)backgroundImage
                        quoteComponent:(CKComponent *)quoteComponent

{
  return [super newWithComponent:
          [CKBackgroundLayoutComponent
           newWithComponent:quoteComponent
           background:
           [CKComponent
            newWithView:{
              [UIImageView class],
              {
                {@selector(setImage:), backgroundImage},
                {@selector(setContentMode:), @(UIViewContentModeScaleAspectFill)},
                {@selector(setClipsToBounds:), @YES},
              }
            }
            size:{90,90}]]];
}

@end
