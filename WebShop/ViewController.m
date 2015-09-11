//
//  ViewController.m
//  WebShop
//
//  Created by walter on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import "ViewController.h"

#define PageNumberOfScrollView 4

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray* arrayImageView;

@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;
@property (nonatomic, strong) UIButton* btnStart;

@property (nonatomic, strong) UIViewController* firstMainFlowCtrl;
@property (nonatomic, strong) UIPageControl* pageControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        
        [self addImages];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
    }
    else
    {
        [self goToMainUI];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addImages
{
    
    UIStoryboard* storyboardMain = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.firstMainFlowCtrl = [storyboardMain instantiateViewControllerWithIdentifier:@"firstMainFlowCtrl"];
    self.firstMainFlowCtrl.view.userInteractionEnabled = YES;
    [self.view addSubview:self.firstMainFlowCtrl.view];
    
    self.arrayImageView = [[NSMutableArray alloc] init];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    CGSize scrollSize;
    
    scrollSize.height = self.view.frame.size.height;
    scrollSize.width  = PageNumberOfScrollView*self.view.frame.size.width;
    
    self.scrollView.contentSize =  scrollSize;
    self.scrollView.bounces = NO;
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.5*(self.view.frame.size.width -120),self.view.frame.size.height - 60, 120, 30)];
    self.pageControl.numberOfPages = PageNumberOfScrollView;
    [self.pageControl addTarget:self action:@selector(goPage:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.pageControl];
    
    self.pageControl.hidden = YES;
    
    
    for (int i = 0; i < PageNumberOfScrollView; i++) {
        
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"bg%d.png",i + 1]];
        
        
        UIImageView*  imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width,0,self.view.frame.size.width,self.view.frame.size.height)];
        
        
        imageView.image = image;
        
        [self.scrollView addSubview:imageView];
        
        [self.arrayImageView addObject:imageView];
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(self.view.frame.size.width*0.5 - 80, self.view.frame.size.height*0.8 - 10 , 160, 50);
        
        
        btn.userInteractionEnabled = YES;
        [btn addTarget:self action:@selector(goMain:) forControlEvents:UIControlEventTouchUpInside ];
        
        [imageView addSubview:btn];
        
        [imageView addSubview:btn];
        
        imageView.userInteractionEnabled = YES;
    }
    
    
}

- (void)goToMainUI
{
    UIStoryboard* storyboardMain = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.firstMainFlowCtrl = [storyboardMain instantiateViewControllerWithIdentifier:@"firstMainFlowCtrl"];
    self.firstMainFlowCtrl.view.userInteractionEnabled = YES;
    
    [self.view addSubview:self.firstMainFlowCtrl.view];
    
}


- (void)goMain:(UIButton*)btn
{
    
    [UIView animateWithDuration:1  delay:0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         self.scrollView.alpha = 0.0;
                         [self.pageControl removeFromSuperview];
        
                         
                     } completion:^(BOOL finished){}];
    
}


#pragma scrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        
        self.pageControl.currentPage = self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
        
    }
    
}


- (void)goPage:(UIPageControl*)pageCtrl
{
    [self.scrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width*pageCtrl.currentPage, 0, self.scrollView.frame.size.height, self.scrollView.frame.size.height) animated:YES];
    
}


@end
