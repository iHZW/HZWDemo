//
//  NSObject+Customizer.m
//  TableViewNew
//
//  Created by HZW on 2017/10/13.
//  Copyright © 2017年 韩志伟. All rights reserved.
//

#import "NSObject+Customizer.h"
#import <objc/runtime.h>


const NSString *kRefreshType        = @"refreshType";      // 刷新方式
const NSString *kForceRefresh       = @"forceRefresh";     // 是否强制刷新
const NSString *kReqPageNo          = @"reqPageNo";        // 请求叶号
const NSString *kReqPos             = @"reqPos";           // 请求位置
const NSString *kReqNum             = @"reqNum";           // 请求数目

static const char *ObjectTagKey = "ObjectTag";

@implementation NSObject (Customizer)
@dynamic objectTag;

- (NSString *)objectTag
{
    NSString *tag = objc_getAssociatedObject(self, ObjectTagKey);
    if ([tag length] <= 0)
    {
        tag = [NSObject uuidString];
        self.objectTag = tag;
    }
    return tag;
}

- (void)setObjectTag:(NSString *)newObjectTag
{
    objc_setAssociatedObject(self, ObjectTagKey, newObjectTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSString *)uuidString
{
    CFUUIDRef uuid          = CFUUIDCreate(NULL);
    NSString *uuidString    = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    
    return uuidString;
}

+ (BOOL)isSingleton
{
    return NO;
}


@end
