//
//  ShoppingListCtrl.m
//  WebShop
//
//  Created by walter on 15/9/9.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import "ShoppingListCtrl.h"
#import <ComponentKit/ComponentKit.h>
#import "SombreQuoteComponent.h"
#import "QuoteContext.h"
#import "Quote.h"
#import "DetailProdutCtrl.h"

@interface ShoppingListCtrl ()<CKComponentProvider, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property (strong,nonatomic) NSMutableArray *arrayOfData;
@end

@implementation ShoppingListCtrl
{
    CKCollectionViewDataSource *_dataSource;
    
    CKComponentFlexibleSizeRangeProvider *_sizeRangeProvider;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        _sizeRangeProvider = [CKComponentFlexibleSizeRangeProvider providerWithFlexibility:CKComponentSizeRangeFlexibleHeight];
        
        self.title = @"商品列表";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    
    self.arrayOfData=[[NSMutableArray alloc]initWithObjects:@{
                                                              
                                                            @"text": @"I have the simplest tastes. I am always satisfied with the best.",
                                                              @"image": @"bg2",
                                                            @"background": @"bg1",
                                                              },
                      @{
                        @"text": @"A thing is not necessarily true because a man dies for it.",
                        @"image": @"bg2",
                        @"background": @"bg1",
                        },
                      @{
                        @"text": @"A poet can survive everything but a misprint.",
                        @"image": @"bg2",
                        @"background": @"bg1",
                        },
                      @{
                        @"text": @"He is really not so ugly after all, provided, of course, that one shuts one's eyes, and does not look at him.",
                        @"image": @"bg2",
                        @"background": @"bg1",
                        }, nil];
    
    
    // Preload images for the component context that need to be used in component preparation. Components preparation
    // happens on background threads but +[UIImage imageNamed:] is not thread safe and needs to be called on the main
    // thread. The preloaded images are then cached on the component context for use inside components.
    NSSet *imageNames = [NSSet setWithObjects:
                         @"bg0",@"bg1",@"bg2",@"bg3",
                         nil];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    
    QuoteContext *context = [[QuoteContext alloc] initWithImageNames:imageNames];
    
    _dataSource = [[CKCollectionViewDataSource alloc] initWithCollectionView:self.collectionView
                                                 supplementaryViewDataSource:nil
                                                           componentProvider:[self class]
                                                                     context:context                                                 cellConfigurationFunction:nil];
    // Insert the initial section
    CKArrayControllerSections sections;
    sections.insert(0);
    [_dataSource enqueueChangeset:{sections, {}} constrainedSize:{}];
    
    
//    CKArrayControllerInputItems items;
//    items.insert([NSIndexPath indexPathForRow:0 inSection:0], @"test");
//    items.insert([NSIndexPath indexPathForRow:1 inSection:0], @"helloworld");
//    items.insert([NSIndexPath indexPathForRow:2 inSection:0], @"me");
//    items.insert([NSIndexPath indexPathForRow:3 inSection:0], @"he");
//    [_dataSource enqueueChangeset:{{}, items}
//                    constrainedSize:[_sizeRangeProvider sizeRangeForBoundingSize:CGSizeMake(96, 100)]];
   
    
   [self _enqueuePage:self.arrayOfData];
}

-(void)initUI
{
    [[NSNotificationCenter defaultCenter] addObserverForName:@"componentInfo" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        DetailProdutCtrl *vc=[[DetailProdutCtrl alloc]initWithNibName:@"DetailProdutCtrl" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
}

- (void)_enqueuePage:(NSMutableArray *)array
{
   
    // Convert the array of quotes to a valid changeset
    CKArrayControllerInputItems items;
    for (NSInteger i = 0; i < [array count]; i++) {
        
        
        items.insert([NSIndexPath indexPathForRow:i inSection:0], array[i]);
    }
    [_dataSource enqueueChangeset:{{}, items}
                  constrainedSize:[_sizeRangeProvider sizeRangeForBoundingSize:CGSizeMake(96, 100)]];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataSource sizeForItemAtIndexPath:indexPath];
   
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_dataSource announceWillAppearForItemInCell:cell];
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_dataSource announceDidDisappearForItemInCell:cell];
}

#pragma mark - CKComponentProvider

+ (CKComponent *)componentForModel:(NSDictionary*)dict context:(QuoteContext *)context
{
    return [SombreQuoteComponent newWithText:dict context:context];
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrolledToBottomWithBuffer(scrollView.contentOffset, scrollView.contentSize, scrollView.contentInset, scrollView.bounds)) {
        
    }
}

static BOOL scrolledToBottomWithBuffer(CGPoint contentOffset, CGSize contentSize, UIEdgeInsets contentInset, CGRect bounds)
{
    CGFloat buffer = CGRectGetHeight(bounds) - contentInset.top - contentInset.bottom;
    const CGFloat maxVisibleY = (contentOffset.y + bounds.size.height);
    const CGFloat actualMaxY = (contentSize.height + contentInset.bottom);
    return ((maxVisibleY + buffer) >= actualMaxY);
}

@end
