//
//  starView.h
//  eCarter
//
//  Created by lijingyou on 15/7/4.
//  Copyright (c) 2015年 kinsuft173. All rights reserved.
//

#import <UIKit/UIKit.h>
#define star_1 @"Evaluation_1"
#define star_0 @"Evaluation_0"
#define star_half @"Evaluation_0.5"


@interface starView : UIView

@property (strong,nonatomic)NSArray *array_Star;
@property (assign) CGFloat whichValue;

@property (weak, nonatomic) IBOutlet UIButton *btn_image1;
@property (weak, nonatomic) IBOutlet UIButton *btn_image2;
@property (weak, nonatomic) IBOutlet UIButton *btn_image3;
@property (weak, nonatomic) IBOutlet UIButton *btn_image4;
@property (weak, nonatomic) IBOutlet UIButton *btn_image5;




@property (weak, nonatomic) IBOutlet UIImageView *img_star1;
@property (weak, nonatomic) IBOutlet UIImageView *img_star2;
@property (weak, nonatomic) IBOutlet UIImageView *img_star3;
@property (weak, nonatomic) IBOutlet UIImageView *img_star4;
@property (weak, nonatomic) IBOutlet UIImageView *img_star5;

-(void)setStarForValue:(CGFloat)value;
@end
