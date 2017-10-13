//
//  NSObject+Customizer.h
//  TableViewNew
//
//  Created by HZW on 2017/10/13.
//  Copyright © 2017年 韩志伟. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *kRefreshType;      // 刷新方式
extern NSString *kForceRefresh;     // 是否强制刷新
extern NSString *kReqPageNo;        // 请求叶号
extern NSString *kReqPos;           // 请求位置
extern NSString *kReqNum;           // 请求数目

/**
 *  数据列表刷新类型
 */
typedef NS_ENUM(NSInteger, RefreshDataType){
    /**
     *  收到消息更新新数据（有提示）
     */
    refreshDataTypeRefreshNotif         = 0,
    /**
     *  收到消息更新新数据（无提示）
     */
    refreshDataTypeRefreshNotifNoTip    = 1,
    /**
     *  下拉刷新数据
     */
    refreshDataTypeRefreshPulling       = 2,
    /**
     *  累计更新数据
     */
    refreshDataTypeAppending            = 3,
};

@interface NSObject (Customizer)

@property (nonatomic, retain) NSString *objectTag;      // < 为对象生成一个UUID标记值

/**
 *  为对象生成一个UUID标记值
 *
 *  @return 返回UUID标记值
 */
+ (NSString *)uuidString;

/**
 *  是否是单例类(默认NO)
 */
+ (BOOL)isSingleton;

@end
