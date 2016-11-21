//
//  UIRemindView.m
//  TableViewNew
//
//  Created by HZW on 15/12/29.
//  Copyright © 2015年 韩志伟. All rights reserved.
//

#import "UIRemindView.h"

@implementation UIRemindView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUIWith:frame.size];
    }
    return self;
}

- (void)createUIWith:(CGSize)size
{
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    self.view.backgroundColor = [UIColor greenColor];
    self.view.alpha = 0.5;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 80, 70, 20)];
    titleLabel.text = @"牛逼";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [ self.view addSubview:titleLabel];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    [self.timer fireDate];
    [self addSubview: self.view];
    
}


- (void)timeChange
{
    static int time = 0;
    if (time == 1) {
        [self removeFromSuperview];
        time = 0;
        [_timer invalidate];
        _timer = nil;
    }
    time ++;
}



@end
