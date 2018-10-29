//
//  TestPopViewCell.m
//  TableViewNew
//
//  Created by HZW on 2018/10/29.
//  Copyright © 2018 韩志伟. All rights reserved.
//

#import "TestPopViewCell.h"

@implementation TestPopViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.badge];
        [self.contentView addSubview:self.statusLabel];
        
        
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        
    }
    return self;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
