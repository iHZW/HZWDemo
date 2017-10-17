//
//  ClickMoreAndMoreCell.m
//  TableViewNew
//
//  Created by HZW on 16/1/29.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "ClickMoreAndMoreCell.h"
#import "CustomButton.h"
//#import <UITableView+FDTemplateLayoutCell.h>

@implementation ClickMoreAndMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLabel.textColor = [UIColor blueColor];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(PASFactor(15));
            make.top.equalTo(self).offset(7.5);
            make.size.mas_equalTo(CGSizeMake(PASFactor(85), 30));
        }];
        
        
//        self.orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.orderBtn.frame = CGRectMake(200, 0, 100, 45);
//        [self.orderBtn setTitle:@"下单" forState:UIControlStateNormal];
//        [self.orderBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [self.contentView addSubview:self.orderBtn];
        
        
//        self.ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, 100, 30)];
//        self.ageLabel.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:self.ageLabel];
        
        self.clipsToBounds = YES;
    }
    return self;
}

/**< 加载年龄label */
/**< 优化点不用每个cell都创建这个UI  只有展开的的时候才创建加载 */
- (void)loadAgeLabel
{
    if (!self.ageLabel)
    {
        self.ageLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.ageLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.ageLabel];
        
        [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self).offset(PASFactor(15));
            make.size.mas_equalTo(CGSizeMake(PASFactor(100), 30));
        }];
    }
}


- (void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    if (_isSelect) {
        if (!self.ageLabel) {
            [self loadAgeLabel];
        }
    }else{
        if (self.ageLabel) {
            [self.ageLabel removeFromSuperview];
            self.ageLabel = nil;
        }
    }
//    self.cellHeight = self.isSelect ? CGRectGetMaxY(self.ageLabel.frame) + PASFactor(5) : CGRectGetMaxY(self.nameLabel.frame) + PASFactor(5);
}

- (CGFloat)getCellHeight
{
    return self.isSelect ? CGRectGetMaxY(self.ageLabel.frame) + PASFactor(5) : CGRectGetMaxY(self.nameLabel.frame) + PASFactor(5);
}


- (void)configWithArray:(BookModel *)model
{
    self.nameLabel.text = model.name;
    self.ageLabel.text = model.age;
}


- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
