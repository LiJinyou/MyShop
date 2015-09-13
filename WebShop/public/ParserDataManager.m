//
//  ParserDataManager.m
//  WebShop
//
//  Created by lijingyou on 15/9/13.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import "ParserDataManager.h"

@interface ParserDataManager ()<NSXMLParserDelegate>
@property (nonatomic, strong) NSXMLParser *xmlParser;

@end

@implementation ParserDataManager

+ (ParserDataManager*)shareManager
{
    static ParserDataManager* instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[ParserDataManager alloc] init];
        
        [instance readProvinceData];
        [instance readCityData];
    });
    
    return instance;
}



- (void)writeProvinceData
{
    
    NSString *doc = [self documentsDirectory];
    NSString *path = [doc stringByAppendingPathComponent:@"ArrayOfProvince"];
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self.arrayOfProvince];
    BOOL success = [archivedData writeToFile:path atomically:YES];
    
}

- (void)readProvinceData
{
    NSString *doc = [self documentsDirectory];
    NSString *path = [doc stringByAppendingPathComponent:@"ArrayOfProvince"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (data != nil) {
        self.arrayOfProvince = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
    }
}

- (NSString*)documentsDirectory
{
    NSString *documentsDirectory = nil;
    
    //documentDirectory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    if (docDir != nil) {
        documentsDirectory = [[NSString alloc] initWithFormat:@"%@", [docDir stringByAppendingPathComponent:@"Province"]];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return  documentsDirectory;
}


- (void)writeCityData
{
    
    NSString *doc = [self documentsDirectory];
    NSString *path = [doc stringByAppendingPathComponent:@"ArrayOfCity"];
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self.arrayOfCity];
    BOOL success = [archivedData writeToFile:path atomically:YES];
    
}

- (void)readCityData
{
    NSString *doc = [self documentsCityDirectory];
    NSString *path = [doc stringByAppendingPathComponent:@"ArrayOfCity"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (data != nil) {
        self.arrayOfCity = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
    }
}

- (NSString*)documentsCityDirectory
{
    NSString *documentsDirectory = nil;
    
    //documentDirectory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    if (docDir != nil) {
        documentsDirectory = [[NSString alloc] initWithFormat:@"%@", [docDir stringByAppendingPathComponent:@"City"]];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return  documentsDirectory;
}

@end




