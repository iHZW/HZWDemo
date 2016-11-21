//
//  MyImagePickerController.m
//  TableViewNew
//
//  Created by HZW on 15/10/1.
//  Copyright (c) 2015年 韩志伟. All rights reserved.
//

#import "MyImagePickerController.h"

@implementation MyImagePickerController

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 60, 35);
        btn.titleLabel.text = @" 取 消 ";
        UIBarButtonItem *cancleItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationController.navigationItem.rightBarButtonItem = cancleItem;
    }
    return self;
}


@end
