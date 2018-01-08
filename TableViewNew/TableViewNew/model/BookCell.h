//
//  BookCell.h
//  TableViewNew
//
//  Created by HZW on 15/9/7.
//  Copyright (c) 2015年 韩志伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

#define WMAIN   [[UIScreen mainScreen] bounds].size.width
#define HMAIN   [[UIScreen mainScreen] bounds].size.height

@interface BookCell : UITableViewCell
{
    UILabel *_nameLabel;
    UILabel *_ageLabel;
    UIImageView *_imageView;
    UIButton *_leftBtn;
    UIButton *_rightBtn;
    UILabel *_contentLabel;
    
//    UIButton *_leftBtn;
}

@property (nonatomic, strong) UIButton *rightBtn;


/**
 *  传递参数
 *
 *  @param model 数据模型
 */
- (void)configModel:(BookModel*)model;

@end
