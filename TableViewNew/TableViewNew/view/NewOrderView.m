//
//  NewOrderView.m
//  TableViewNew
//
//  Created by HZW on 2017/12/29.
//  Copyright © 2017年 韩志伟. All rights reserved.
//

#import "NewOrderView.h"
#define kLeftSpace    15

@implementation NewOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor grayColor];
        [self loadSubView];
    }
    return self;
}

- (void)loadSubView
{
    [self addSubview:self.nameLabel];
    [self addSubview:self.textView];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(kLeftSpace);
        make.width.mas_equalTo(100);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.nameLabel.mas_right).offset(20);
        make.right.equalTo(self).offset(-kLeftSpace);
        make.bottom.equalTo(self).offset(-10);
    }];
    
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = PASFont(20);
    }
    return _nameLabel;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.layer.borderColor = [UIColor blackColor].CGColor;
        _textView.layer.borderWidth = .5;
        _textView.cornerRadius = 4;
        _textView.font = PASFont(15);
    }
    return _textView;
}



@end
