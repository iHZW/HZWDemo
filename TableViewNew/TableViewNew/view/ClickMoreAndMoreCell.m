//
//  ClickMoreAndMoreCell.m
//  TableViewNew
//
//  Created by HZW on 16/1/29.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "ClickMoreAndMoreCell.h"

@implementation ClickMoreAndMoreCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7.5, 85, 30)];
        self.nameLabel.textColor = [UIColor blueColor];
        [self.contentView addSubview:self.nameLabel];
        
//        self.orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.orderBtn.frame = CGRectMake(200, 0, 100, 45);
//        [self.orderBtn setTitle:@"下单" forState:UIControlStateNormal];
//        [self.orderBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [self.contentView addSubview:self.orderBtn];
        
        self.ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, 100, 30)];
        self.ageLabel.backgroundColor = [UIColor redColor];
//        self.ageLabel.hidden = YES;
        [self.contentView addSubview:self.ageLabel];
    }
    return self;
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
