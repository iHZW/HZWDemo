//
//  ThirdCell.h
//  TableViewNew
//
//  Created by HZW on 15/11/24.
//  Copyright © 2015年 韩志伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

@interface ThirdCell : UITableViewCell
{
    UILabel *_nameLabel;
    UILabel *_ageLabel;
    UILabel *_contentLabel;
    UILabel *_marLabel;
//    UIButton *_leftBtn;
    UITextField *_textField;
}

@property(nonatomic, strong) UIButton *leftBtn;
@property(nonatomic, assign) BOOL isAllSelect;

- (void)configModel:(BookModel*)model;

+ (CGFloat)configModel:(BookModel *)model;

- (void)setSelected;

@end
