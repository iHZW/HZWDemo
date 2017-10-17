//
//  PASCommonUtil.h
//  PASecuritiesApp
//
//  Created by vince on 16/3/16.
//  Copyright © 2016年 PAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PASCommonUtil : NSObject

/**
 *  获取四位验证码
 *
 *  @return <#return value description#>
 */
+ (nullable NSString *)getFourValidateString;

//userdefault存取
+ (nullable NSString *)getStringWithKey:(nonnull NSString *)key;
+ (void)setObject:(nullable NSObject *)obj forKey:(nonnull NSString *)key;
+ (nullable NSObject *)getObjectWithKey:(nonnull NSString *)key;

+ (nullable NSData *)getDataWithKey:(nonnull NSString*)key;
+ (nullable NSArray *)getArrayWithKey:(nonnull NSString*)key;
+ (nullable NSDictionary *)getDicWithKey:(nonnull NSString*)key;
+ (void)removeForKey:(nonnull NSString*)key;

/**
 *  去除json字符串前后垃圾字符
 *
 *  @return json格式字符串
 */
+ (nullable NSString *)getJsonFormatStringFromString:(nullable NSString *)orignString;

+ (nullable NSString *)getJsonFormatStringFromData:(nonnull NSData *)orignData;

/**
 *  去除json字符串前后垃圾字符
 *
 *  @return json格式字符串
 */
+ (nullable id)parseData:(nullable id)sourceData toClass:(nullable Class)toClass;

///
+ (void)getModelFromData:(nullable id)sourceData
                 toModel:(nullable Class)toModel
           responseBlock:(nullable void (^)(__nullable id obj))block;

+ (BOOL)checkIsPhone:(nullable NSString *)num;

#pragma mark-



/**
 *  获取登录时长秒
 *
 *  @return 
 */
+ (nullable NSString *)getLoginLongTime;

/**
 *  根据屏幕获取新尺寸
 *
 *  @param originalValue 原始尺寸
 *
 *  @return 最终尺寸
 */
+ (CGFloat)getFinalScreenValue:(CGFloat)originalValue;


/**
 *  读取本地文件数据进网络缓存
 *
 *  @param localFileName 本地文件名
 *  @param cacheFileName 缓存文件名
 */
+ (void)saveCmsDataToCache:(nullable NSString *)localFileName
                 cacheName:(nullable NSString *)cacheFileName;


/**
 *  清除所有的存储本地的数据
 */
+ (void)clearAllUserDefaultsData;


@end
