//
//  PASMyInfoMationCollectionViewCell.m
//  TableViewNew
//
//  Created by HZW on 16/6/23.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "PASMyInfoMationCollectionViewCell.h"

@implementation PASMyInfoMationCollectionViewCell

@end


@implementation MyInformationOneCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 50, 50)];
        self.titleLabel.textColor = [UIColor redColor];
        self.titleLabel.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:self.titleLabel];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, 50, 50)];
        self.nameLabel.textColor = [UIColor blueColor];
        self.nameLabel.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.nameLabel];
        
    }
    return self;
}

- (NSArray *)configWith:(NSDictionary *)dic
{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSDictionary *dict in dic)
    {
    }
    return arr;
}


@end


@implementation MyInformationTwoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI
{
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 50, 30)];
    self.nameLabel.textColor = [UIColor grayColor];
    self.nameLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.nameLabel];
    
    self.ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 30, 30)];
    self.ageLabel.textColor = [UIColor purpleColor];
    self.ageLabel.backgroundColor = [UIColor greenColor];

    [self.contentView addSubview:self.ageLabel];
}

@end
