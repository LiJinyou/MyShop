//
//  CommentDetailCell.h
//  WebShop
//
//  Created by walter on 15/9/11.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewForStar;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgFirst;
@property (weak, nonatomic) IBOutlet UIImageView *imgSecond;
@property (weak, nonatomic) IBOutlet UIImageView *imgThird;

@end
