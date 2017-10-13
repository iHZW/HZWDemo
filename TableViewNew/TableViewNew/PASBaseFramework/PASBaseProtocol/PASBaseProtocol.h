//
//  PASBaseProtocol.h
//  TableViewNew
//
//  Created by HZW on 2017/10/13.
//  Copyright © 2017年 韩志伟. All rights reserved.
//

#ifndef PASBaseProtocol_h
#define PASBaseProtocol_h

#define kThemeChangeNotification @"ThemeChangeNotification"


typedef void (^CMThemeChangeCallback) (NSDictionary *userInfo);

@protocol PASBaseProtocol <NSObject>

/**
 对象标识

 @return <#return value description#>
 */
- (NSString *)objectID;

@optional

/**
 对应业务层页面统一标记
 */
- (void)pageID;

/**
 数据刷新处理

 @param userInfo 字典数据键值为  kRefreshType, kForceRefresh, kReqPageNo, kReqPos, kReqNum信息
 */
- (void)refreshData:(NSDictionary *)userInfo;

/**
 *  换肤通知处理函数
 *
 *  @param notification 通知参数
 */
- (void)notifyThemeChange:(NSNotification *)notification;

/**
 *  网络层数据返回通知处理函数
 *
 *  @param notification 通知参数
 */
- (void)notifyNetLayerResponse:(NSNotification *)notification;

/**
 *  StatusBarFrameChange
 *
 *  @param notification 通知参数
 */
- (void)notifyStatusBarFrameChange:(NSNotification *)notification;

/**
 *  换肤通知处理函数
 *
 *  @param callback   CMThemeChangeCallback
 *  @param identifier 换肤标记
 */
- (void)attachThemeChangeCallback:(CMThemeChangeCallback)callback identifier:(NSString *)identifier;

/**
 *  清空所有观察者
 */
- (void)removeAllObservers;

/**
 *  导航栏背景颜色设置
 */
- (UIColor *)navigationBGColor;

/**
 *  底部TabBar北京颜色
 */
- (UIColor *)tabBarBGColor;

@end

#endif /* PASBaseProtocol_h */



