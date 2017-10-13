//
//  NSTimer+Util.h
//  TableViewNew
//
//  Created by HZW on 2017/10/13.
//  Copyright © 2017年 韩志伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Util)


/**
 暂停
 */
- (void)util_suspend;


/**
 唤醒
 */
- (void)util_resume;


/**
 手动延迟一个周期
 */
- (void)util_nextCycle;

@end
