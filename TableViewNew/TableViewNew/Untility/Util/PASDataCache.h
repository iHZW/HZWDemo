//
//  PASDataCache.h
//  PASecuritiesApp
//
//  Created by Weirdln on 16/4/26.
//  Copyright © 2016年 PAS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PASCacheObjectBlock)(NSString *key, id object);

@interface PASDataCache : NSObject

+ (instancetype)sharedDataCache;

#pragma mark -- 统一的cache

/**
 *  根据key获取对应的缓存数据（同步）
*/
- (id)objectFromCacheWithKey:(NSString *)key;

/**
 *  根据key获取对应的缓存数据（异步）
 *
 *  @param cacheBlock 回调的block
 */
- (void)objectFromCacheWithKey:(NSString *)key cacheBlock:(PASCacheObjectBlock)cacheBlock;

/**
 *  保存数据到缓存中
 */
- (BOOL)saveObject:(id)object toCacheWithKey:(NSString *)key;

/**
 *  移除key对应的数据
 */
- (void)removeFromCacheWithKey:(NSString *)key;

/**
 *  清除所有保存在默认cache中的数据
 */
- (void)clearAllCache;

#pragma mark -- 自定义路径

/**
 *  从指定路径读取缓存
 */
- (NSData *)objectFromCacheWithPath:(NSString *)path;

/**
 *  保存缓存到指定的路径
 */
- (BOOL)saveData:(NSData *)data toCacheWithPath:(NSString *)path;

/**
 *  移除指定目录的缓存文件
 */
- (void)removeFromCacheWithPath:(NSString *)path;

/**
 *  根据相对路径生成完整路径，以home为前缀
 */
+ (NSString *)absolutePathWithPath:(NSString *)path;

/**
 *  根据对应相对路径和Directory生成完整路径
 */
+ (NSString *)absolutePathWithPath:(NSString *)path inDirectory:(NSSearchPathDirectory)directory;

@end
