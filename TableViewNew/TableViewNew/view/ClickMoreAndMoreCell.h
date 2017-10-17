//
//  ClickMoreAndMoreCell.h
//  TableViewNew
//
//  Created by HZW on 16/1/29.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"
@class CustomButton;

@interface ClickMoreAndMoreCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *ageLabel;
//@property (nonatomic, strong) UIButton *orderBtn; /**< 下单按钮 */
//@property (nonatomic, strong) CustomButton *orderBtn;
@property (nonatomic, assign) CGFloat cellHeight; /**< cell的高度 */

@property (nonatomic, assign) BOOL isSelect; /**< 是否选中 */

- (void)configWithArray:(BookModel *)model;


- (BOOL)canBecomeFirstResponder;

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender;

- (CGFloat)getCellHeight;

@end
