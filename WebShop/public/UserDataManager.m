//
//  UserDataManager.m
//  WebShop
//
//  Created by lijingyou on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import "UserDataManager.h"



@implementation UserDataManager

@synthesize userId;

+ (UserDataManager*)shareManager
{
    static UserDataManager* instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[UserDataManager alloc] init];
        
        //[instance fakeDate];
        
        [instance readUserData];
    });
    
    return instance;
}

- (void)fakeDate
{
    self.userId = @"1";
    self.userType = @"1";

}


- (void)writeUserData
{
    
    NSString *doc = [self documentsDirectory];
    NSString *path = [doc stringByAppendingPathComponent:@"UserData"];
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self.userLoginInfo];
    BOOL success = [archivedData writeToFile:path atomically:YES];


}

- (void)readUserData
{
    NSString *doc = [self documentsDirectory];
    NSString *path = [doc stringByAppendingPathComponent:@"UserData"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UserLoginInfo*dic = nil;
    if (data != nil) {
        dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        self.userLoginInfo = dic;
    }


}

- (NSString*)documentsDirectory
{
    NSString *documentsDirectory = nil;
    
    //documentDirectory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    if (docDir != nil) {
        documentsDirectory = [[NSString alloc] initWithFormat:@"%@", [docDir stringByAppendingPathComponent:@"User"]];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return  documentsDirectory;
}


@end
