//
//  ZWWeakObject.m
//  TableViewNew
//
//  Created by HZW on 2018/10/26.
//  Copyright © 2018 韩志伟. All rights reserved.
//

#import "ZWWeakObject.h"

@interface ZWWeakObject ()

@property(nonatomic, weak) id weakObject;

@end

@implementation ZWWeakObject

- (instancetype)initWithWeakObjec:(id)obj
{
    _weakObject = obj;
    return self;
}

+(instancetype)proxyWithWeakObjec:(id)obj
{
    return [[ZWWeakObject alloc] initWithWeakObjec:obj];
}


- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return _weakObject;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    void *null = NULL;
    [anInvocation setReturnValue:&null];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [_weakObject respondsToSelector:aSelector];
}


@end
