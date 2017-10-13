//
//  NSTimer+Util.m
//  TableViewNew
//
//  Created by HZW on 2017/10/13.
//  Copyright © 2017年 韩志伟. All rights reserved.
//

#import "NSTimer+Util.h"

@implementation NSTimer (Util)


- (void)util_suspend
{
    [self setFireDate:[NSDate distantFuture]];
}


- (void)util_resume
{
    [self setFireDate:[NSDate distantPast]];
}


- (void)util_nextCycle
{
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeInterval]];
}


@end
