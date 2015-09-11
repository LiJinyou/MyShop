//
//  LoginViewController.m
//  WebShop
//
//  Created by walter on 15/9/9.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import "LoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Common.h"

typedef void (^ReturnBack)(BOOL);

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
}

-(void)initUI
{
    [self.txtUsername.rac_textSignal subscribeNext:^(id x) {
        //NSLog(@"%@",x);
    }];
    
    RACSignal *validUsernameSignal=[self.txtUsername.rac_textSignal map:^id(NSString *text) {
        return @([self isValidUsername:text]);
    }];
    
    RACSignal *validPasswordSignal=[self.txtPassword.rac_textSignal map:^id(NSString *text) {
        return @([self isValidUsername:text]);
    }];
    
    RAC(self.txtUsername,backgroundColor)=[validUsernameSignal map:^id(NSNumber *usernameValid) {
        return [usernameValid boolValue]?[UIColor clearColor]:[UIColor yellowColor];
    }];
    
    RAC(self.txtPassword,backgroundColor)=[validPasswordSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue]?[UIColor clearColor]:[UIColor yellowColor];
    }];
    
    RACSignal *signUpActiveSignal=[RACSignal combineLatest:@[validUsernameSignal,validPasswordSignal] reduce:^id(NSNumber *usernameValid,NSNumber *passwordValid){
        return @([usernameValid boolValue]&&[passwordValid boolValue]);
    }];
    
    [signUpActiveSignal subscribeNext:^(NSNumber  *signupActive) {
        if ([signupActive boolValue]) {
            self.btnLogin.enabled=YES;
            [self.btnLogin setBackgroundColor:[UIColor redColor]];
        }
        else
        {
            self.btnLogin.enabled=NO;
            [self.btnLogin setBackgroundColor:[UIColor whiteColor]];
        }
    }];
    
    [[[[self.btnLogin rac_signalForControlEvents:UIControlEventTouchUpInside]
      doNext:^(id x) {
          self.btnLogin.enabled=NO;
      } ]
      
      flattenMap:^id(id value) {
          return [self signInSignal];
      }]
     subscribeNext:^(NSNumber  *signIn) {
         self.btnLogin.enabled=YES;
         BOOL success=[signIn boolValue];
         
         if (success) {
             [Common addAlertViewWithTitel:@"登陆成功"];
         }
         else
         {
             [Common addAlertViewWithTitel:@"失败"];
         }
     }] ;
    
}

-(RACSignal*)signInSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self signInWithUserName:self.txtUsername.text password:self.txtPassword.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

-(void)signInWithUserName:(NSString*)username password:(NSString*)password complete:(ReturnBack)completeBlock
{
    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, (int16_t)(NSEC_PER_SEC*2.0));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        BOOL success=[username isEqualToString:@"user"]&&[password isEqualToString:@"password"];
        completeBlock(success);
    });
}


-(BOOL)isValidUsername:(NSString*)text
{
    return text.length>3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
