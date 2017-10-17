//
//  PASDefine.h
//  PASecuritiesApp
//
//  Created by vince on 16/3/15.
//  Copyright © 2016年 PAS. All rights reserved.
//

#ifndef PASDefine_h
#define PASDefine_h

//#import "NSObject+UUID.h"
#import "AppDelegate.h"

/**
 *  URL identifier
 */
#define kPASURLId       @"com.pingan.stock"

/**
 *  安e理财Scheme命令
 */
#define kPASchemeName   [[PASNavigator sharedPASNavigator] schemeNameWithURLId:kPASURLId]

/**
 *  布点适配宏
 */
#define __PASBI

/**
 *  开启布点
 */
#define TALKINGDATA_ENABLED

/**
 *  平安证券域名
 */
#define kPASchemeHost   @"stock.pingan.com"

#define kPAAppName      @"平安证券"

#define SYS_CLIENTVER   [PASSiteAddressManager appVersion]

#ifndef APPSTORE_ONLY

#define __BACKDOOR

#endif

#define kPASAppLunchFirstTime			@"app_launch_first_time"	   //程序第一次启动

// 根视图
#define kAppRootViewController [PASNavigator sharedPASNavigator].rootViewController

// 当前导航栏控制器
#define kCurrentNavigationController [PASNavigator sharedPASNavigator].currentNavigationController

// 当前导航栏顶部视图
#define kNavigationTopViewController [PASNavigator sharedPASNavigator].visibleViewController

// 最上层展示视图页面控制器
#define kTopViewController [[PASNavigator sharedPASNavigator] getCurrentTopViewController]

// window
#define kAppKeyWindow [UIApplication sharedApplication].keyWindow

#define Environment [PASSiteAddressManager getCurrentEnvironment]

/**
 *  新版本Rest接口请求 requestId 定义
 */
#define kRequestId      [NSString stringWithFormat:@"AYLCAPP%@", [NSObject shortUUIDString]]

#define KAccountSaveInfoKey             @"accountSaveInfoKey"

#define kHsTalkingDataEnabled			@"talkingdata_enabled"	//是否调用平安的talkingData配置项


#define KNotificationWithLogoutName @"UserLogoutNotification"
#define KNotificationWithLoginName  @"UserLoginNotification"

#define USERSERVICERSA_ENABLED      // 账户体系是否进行RSA加密处理

#define InvokeBlockAtMainQueue(block) dispatch_async(dispatch_get_main_queue(), ^{  (block); })

//版本号区分定义
#define IOS11_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")
#define IOS10_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10")
#define IOS9_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9")
#define IOS8_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")
#define IOS7_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")

//编译警告兼容处理
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
#define kEraCalendarUnit NSCalendarUnitEra
#define kYearCalendarUnit NSCalendarUnitYear
#define kMonthCalendarUnit NSCalendarUnitMonth
#define kDayCalendarUnit NSCalendarUnitDay
#define kHourCalendarUnit NSCalendarUnitHour
#define kMinuteCalendarUnit NSCalendarUnitMinute
#define kSecondCalendarUnit NSCalendarUnitSecond

#define kWeekdayOrdinalCalendarUnit NSCalendarUnitWeekdayOrdinal
#define kWeakCalendarUnit NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth
#define kWeekdayCalendarUnit NSCalendarUnitWeekday
#define kQuarterCalendarUnit NSCalendarUnitQuarter
#define kWeekOfMonthCalendarUnit NSCalendarUnitWeekOfMonth
#define kWeekOfYearCalendarUnit NSCalendarUnitWeekOfYear
#define kYearForWeekOfYearCalendarUnit NSCalendarUnitYearForWeekOfYear
#define kCalendarCalendarUnit NSCalendarUnitCalendar
#define kTimeZoneCalendarUnit NSCalendarUnitTimeZone
#define kGregorianCalendar NSCalendarIdentifierGregorian

#else 
#define kEraCalendarUnit NSEraCalendarUnit
#define kYearCalendarUnit NSYearCalendarUnit
#define kMonthCalendarUnit NSMonthCalendarUnit
#define kDayCalendarUnit NSDayCalendarUnit
#define kHourCalendarUnit NSHourCalendarUnit
#define kMinuteCalendarUnit NSMinuteCalendarUnit
#define kSecondCalendarUnit NSSecondCalendarUnit

#define kWeekdayOrdinalCalendarUnit NSWeekdayOrdinalCalendarUnit
#define kWeakCalendarUnit NSWeekCalendarUnit
#define kWeekdayCalendarUnit NSWeekdayCalendarUnit
#define kQuarterCalendarUnit NSQuarterCalendarUnit
#define kWeekOfMonthCalendarUnit NSWeekOfMonthCalendarUnit
#define kWeekOfYearCalendarUnit NSWeekOfYearCalendarUnit
#define kYearForWeekOfYearCalendarUnit NSYearForWeekOfYearCalendarUnit
#define kCalendarCalendarUnit NSCalendarCalendarUnit
#define kTimeZoneCalendarUnit NSTimeZoneCalendarUnit
#define kGregorianCalendar NSGregorianCalendar

#endif


#endif /* PASDefine_h */
