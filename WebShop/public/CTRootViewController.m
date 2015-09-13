//
//  DEMOViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "CTRootViewController.h"
#import "ProvinceCtrl.h"
#import "GetCityCtrl.h"
#import "ParserDataManager.h"

@interface CTRootViewController ()<NSXMLParserDelegate>
@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (strong,nonatomic) NSMutableArray *arrayOfProvince;
@property (strong,nonatomic) NSMutableArray *arrayOfCity;
@property (strong,nonatomic) NSMutableArray *arrayOfRegion;
@end

@implementation CTRootViewController

- (void)awakeFromNib
{
    self.arrayOfProvince=[[NSMutableArray alloc]init];
    self.arrayOfCity=[[NSMutableArray alloc]init];
    
    [self parseData];
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"ProductDetail" bundle:nil];
    
    
    
    self.menuViewController = [story instantiateViewControllerWithIdentifier:@"ProvinceCtrl"];
    
    // Create frosted view controller
    //
    
    self.direction =  REFrostedViewControllerDirectionRight;
}

-(void)parseData
{
    
    NSString *strPathXml = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"xml"];
    
    //将xml文件转换成data类型
    NSData *data = [[NSData alloc] initWithContentsOfFile:strPathXml];
 
    
    self.xmlParser = [[NSXMLParser alloc]initWithData:data];
    
    self.xmlParser.delegate = self;
    [self.xmlParser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
   
    if([elementName isEqualToString:@"Province"])
    {
        
        [self.arrayOfProvince addObject:[attributeDict objectForKey:@"FullName"]];
        
        
    }
    else if([elementName isEqualToString:@"City"])
    {
        [self.arrayOfCity addObject:[attributeDict objectForKey:@"FullName"]];
    }
    else if([elementName isEqualToString:@"Region"])
    {
        [self.arrayOfRegion addObject:[attributeDict objectForKey:@"FullName"]];
    }
}

/* 当解析器找到开始标记和结束标记之间的字符时，调用这个方法解析当前节点的所有字符 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    
}

/* 当解析器对象遇到xml的结束标记时，调用这个方法完成解析该节点 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
}

/* 解析xml出错的处理方法 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
}

/* 解析xml文件结束 */
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
    NSLog(@"解析:%@",self.arrayOfProvince);
    
    [ParserDataManager shareManager].arrayOfProvince=self.arrayOfProvince;
    [[ParserDataManager shareManager] writeProvinceData];
    
    [ParserDataManager shareManager].arrayOfCity=self.arrayOfCity;
    [[ParserDataManager shareManager] writeCityData];
}

@end
