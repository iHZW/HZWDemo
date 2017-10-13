//
//  CMNotificationCenter.m
//  TableViewNew
//
//  Created by HZW on 2017/10/13.
//  Copyright © 2017年 韩志伟. All rights reserved.
//

#import "CMNotificationCenter.h"

@interface CMNotificationObserverRecord : NSObject
{
    //    id __unsafe_unretained object;      // anonymous object of interest id observer; // anonymous observer
    SEL selector;   // selector to call
}

@property (readwrite, weak) id object;
@property (readwrite, weak) id observer;
@property (readwrite, assign) SEL selector;

@end


@implementation CMNotificationObserverRecord
@synthesize object;
@synthesize observer;
@synthesize selector;

- (void)dealloc
{
    self.object     = nil;
    self.observer   = nil;
    self.selector   = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

@end


@interface CMNotificationCenter ()
@property (readwrite, strong) NSMutableDictionary *observersDictionary;

@end


@implementation CMNotificationCenter
+ (id)defaultCenter
{
    // The shared "default" instance created as needed
    static id sharedNotificationCenter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNotificationCenter = [[CMNotificationCenter alloc] init];
    });
    
    return sharedNotificationCenter;
}

// Designated initializer
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.observersDictionary = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    self.observersDictionary = nil;
    [super dealloc];
}
#endif

/**
 *  添加观察者
 *
 *  @param notificationObserver 观察者对象
 *  @param notificationSelector 执行方法
 *  @param notificationName     注册通知名称
 *  @param objectOfInterest     引用对象
 */
- (void)addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString *)notificationName object:(id)objectOfInterest
{
    // This class requires a non-nil notificationName, NSNotification
    // has no corresponding restriction.
    if (notificationName)
    {
        CMNotificationObserverRecord *newRecord = [[CMNotificationObserverRecord alloc] init];
        [newRecord setObject:objectOfInterest];
        [newRecord setObserver:notificationObserver];
        [newRecord setSelector:notificationSelector];
        
        // There is an array of observer records for each notification name
        NSMutableArray *observers = [_observersDictionary objectForKey:notificationName];
        
        if (nil != observers)
        {
            [observers addObject:newRecord];
        }
        else
        {
            // This is the first observer record for notificationName so
            // create the array to store this observer record and all
            // future observer records for the same notificationName.
            [_observersDictionary setObject:[NSMutableArray arrayWithObject:newRecord] forKey:notificationName];
        }
        
#if !__has_feature(objc_arc)
        [newRecord release];
#endif
    }
}

/**
 *  移除观察者对象
 *
 *  @param notificationObserver 观察者对象
 */
- (void)removeObserver:(id)notificationObserver
{
    if (notificationObserver)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.observersDictionary];
        
        for (NSString *key in dic.allKeys)
        {
            NSMutableArray *observers = [dic objectForKey:key];
            for (NSInteger i = [observers count] - 1; i >= 0; i--)
            {
                if (![[observers objectAtIndex:i] observer] ||notificationObserver == [[observers objectAtIndex:i] observer])
                {
                    [observers removeObjectAtIndex:i];
                }
            }
        }
    }
}

/**
 *  移除指定注册通知名称的观察者对象
 *
 *  @param notificationObserver 观察者对象
 *  @param notificationName     注册通知名称
 */
- (void)removeObserver:(id)notificationObserver name:(NSString *)notificationName
{
    if (notificationObserver)
    {
        NSMutableArray *observers = [self.observersDictionary objectForKey:notificationName];
        for (NSInteger i = [observers count] - 1; i >= 0; i--)
        {
            CMNotificationObserverRecord *currentObserverRecord = [observers objectAtIndex:i];
            id observer = currentObserverRecord.observer;
            if (observer == notificationObserver)
            {
                [observers removeObjectAtIndex:i];
            }
        }
    }
}

/**
 *  移除指定注册通知名称的观察者对象
 *
 *  @param notificationObserver 观察者对象
 *  @param notificationName     注册通知名称
 *  @param objectOfInterest     引用对象
 */
- (void)removeObserver:(id)notificationObserver name:(NSString *)notificationName object:(id)objectOfInterest
{
    if (notificationObserver)
    {
        NSMutableArray *observers = [self.observersDictionary objectForKey:notificationName];
        for (NSInteger i = [observers count] - 1; i >= 0; i--)
        {
            CMNotificationObserverRecord *currentObserverRecord = [observers objectAtIndex:i];
            id observer = currentObserverRecord.observer;
            if (observer == notificationObserver)
            {
                [observers removeObjectAtIndex:i];
            }
        }
    }
}

/**
 *  消息通知观察者
 *
 *  @param aNotification NSNotification类型参数
 */
- (void)postNotification:(NSNotification *)aNotification
{
    if (aNotification && [aNotification name])
    {
        NSArray *observers = [_observersDictionary objectForKey:[aNotification name]];
        
        for (NSInteger i = [observers count] - 1; i >= 0; i--)
        {
            id currentObserverRecord = nil;
            if (i < observers.count) {
                currentObserverRecord = [observers objectAtIndex:i];
            }
            id observer = [currentObserverRecord observer];
            if (observer)
            {
                // observer is either interested in notifications for all
                // objects or at least this object.
                //                CMLogDebug(@"====[currentObserverRecord observer]:%@ sel:%@", observer, NSStringFromSelector([currentObserverRecord selector]));
                if ([observer respondsToSelector:[currentObserverRecord selector]])
                {
                    IMP doAction = [observer methodForSelector:[currentObserverRecord selector]];
                    void (*func)(id, SEL, id) = (void *)doAction;
                    func(observer, [currentObserverRecord selector], aNotification);
                    //                [observer performSelector:[currentObserverRecord selector] withObject:aNotification];
                }
            }
        }
    }
}

/**
 *  消息通知观察者
 *
 *  @param aName            注册通知名称
 *  @param objectOfInterest 引用对象
 *  @param userInfo         自定义参数
 */
- (void)postNotificationName:(NSString *)aName object:(id)objectOfInterest userInfo:(NSDictionary *)userInfo
{
    // This method creates a suitable NSNotification instances and
    // then posts it.
#if !__has_feature(objc_arc)
    NSNotification *newNotification = [[[NSNotification alloc] initWithName:aName object:objectOfInterest userInfo:userInfo] autorelease];
#else
    NSNotification *newNotification = [[NSNotification alloc] initWithName:aName object:objectOfInterest userInfo:userInfo];
#endif
    [self postNotification:newNotification];
}

@end
