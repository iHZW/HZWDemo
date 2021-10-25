//
//  PASCommonUtil.m
//  PASecuritiesApp
//
//  Created by vince on 16/3/16.
//  Copyright © 2016年 PAS. All rights reserved.
//

#import "PASCommonUtil.h"
#import "JSONModel.h"
#import "PASDefine.h"
//#import "PASConfigration.h"
#import "PASConfigDefine.h"
#import "PASDataCache.h"
#import "CommonFileFunc.h"

@implementation PASCommonUtil


+ (NSString *)getFourValidateString
{
    NSMutableSet *set = [NSMutableSet set];
    
    while ([set.allObjects count]<4) {
        int num = rand()%10;
        [set addObject:[NSString stringWithFormat:@"%d",num]];
    }
    NSString *result = [[set allObjects] componentsJoinedByString:@""];
    return result;
}

+ (void)setObject:(nullable NSObject *)obj forKey:(nonnull NSString *)key
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (obj) {
        [userDefault setObject:obj forKey:key];
    } else {
        [userDefault removeObjectForKey:key];
    }
    [userDefault synchronize];
}

+ (nullable NSString *)getStringWithKey:(nonnull NSString *)key
{
    if (key &&[key isKindOfClass:[NSString class]]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    } else {
        return @"";
    }
    
}

+ (nullable NSObject *)getObjectWithKey:(nonnull NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (nullable NSData *)getDataWithKey:(nonnull NSString *)key{
    return [[NSUserDefaults standardUserDefaults] dataForKey:key];
}
+ (nullable NSArray*)getArrayWithKey:(nonnull NSString*)key{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:key];
}
+ (nullable NSDictionary*)getDicWithKey:(nonnull NSString*)key{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
}
+ (void)removeForKey:(nonnull NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}


+ (nullable NSString *)getJsonFormatStringFromString:(nullable NSString *)orignString
{
    NSString *result = orignString;
    if ([orignString isKindOfClass:[NSString class]]) {
        NSRange startRange = [result rangeOfString:@"{"];
        if (startRange.location != NSNotFound) {
            result = [result substringFromIndex:startRange.location];
        }
        
        NSRange endRange = [result rangeOfString:@"}" options:NSBackwardsSearch];
        if (endRange.location != NSNotFound) {
            result = [result substringToIndex:(endRange.location+endRange.length)];
        }
        return result;
    }
    
    return nil;
}

+ (nullable NSString *)getJsonFormatStringFromData:(nonnull NSData *)orignData
{
    return [[self class] getJsonFormatStringFromString:[[NSString alloc] initWithData:orignData encoding:NSUTF8StringEncoding]];
}

+ (nullable id)parseData:(nullable id)sourceData toClass:(nullable Class)toClass
{
    if (sourceData && toClass) {
        NSError *error = nil;
        id outputData = nil;
        if ([sourceData isKindOfClass:[NSDictionary class]])
        {
            outputData = [[toClass alloc] initWithDictionary:sourceData error:&error];
        }
        else if ([sourceData isKindOfClass:[NSString class]])
        {
            outputData = [[toClass alloc] initWithString:sourceData error:&error];
        }
        else if ([sourceData isKindOfClass:[NSData class]])
        {
            outputData = [[toClass alloc] initWithData:sourceData error:&error];
        }
        return outputData;
    }
    
    return sourceData;
}

+ (void)getModelFromData:(nullable id)sourceData
                 toModel:(nullable Class)toModel
           responseBlock:(nullable void (^)(__nullable id obj))block
{
    
    if (sourceData) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            id resultObj = nil;
            id jsonObj = sourceData;
            if ([sourceData isKindOfClass:[NSString class]]) {
                jsonObj = [PASCommonUtil getJsonFormatStringFromString:sourceData];
            } else if ([sourceData isKindOfClass:[NSData class]]) {
                jsonObj = [PASCommonUtil getJsonFormatStringFromData:sourceData];
            }
            
            resultObj = [PASCommonUtil parseData:jsonObj toClass:toModel];
            if (!resultObj) {
                resultObj = sourceData;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(resultObj);
                }
            });
            
        });
    } else {
        if (block) {
            block(nil);
        }
    }
}


/**
 *  检测是不是手机号，资金绑定手机号专用
 *
 *  @return yes 是手机号
 */
+ (BOOL)checkIsPhone:(nullable NSString *)num
{
    
    if([num length] <= 0){//没有取到手机号，不要弹出去绑定手机
        return NO;
    }
    
    if ([num hasPrefix:@"1"] && num.length == 11) {
        return YES;
    }
    return NO;
    
}

//取出登录时长：秒
//+ (nullable NSString *)getLoginLongTime
//{
//    NSString *loginLongStr = [[NSString alloc]initWithData:(NSData *)[[self class] getObjectWithKey:KEY_LOGINLONG] encoding:NSUTF8StringEncoding];
//    if ([loginLongStr length] <= 0) {
//        loginLongStr = @"360";
//    }
//    if ([Environment isEqualToString:PASUAT] ||[Environment isEqualToString:PASFAT]) {
//        loginLongStr = [NSString stringWithFormat:@"%0.f",[loginLongStr floatValue] * 6];
//    }else{
//        loginLongStr = [NSString stringWithFormat:@"%0.f",[loginLongStr floatValue] * 60];
//    }
//    return loginLongStr;
//}

+ (CGFloat)getFinalScreenValue:(CGFloat)originalValue
{
    if (IS_IPHONE_6P) {
        CGFloat reduceValue = 0.0;
        
        CGFloat tempValue = originalValue*1.104;;
        CGFloat remainderValue = tempValue - (long)tempValue;
        if (remainderValue > 0.05 &&remainderValue <= 0.505) {
            reduceValue = 0.5;
        }
                             
        return ceil(tempValue) - reduceValue;
    } else {
        return originalValue;
    }
}

+ (void)saveCmsDataToCache:(nullable NSString *)localFileName
                 cacheName:(nullable NSString *)cacheFileName
{
    NSString *cacheFilePath = [CommonFileFunc getNetWorkingDataCaches:cacheFileName];
    if (![CommonFileFunc fileExistsAtPath:cacheFilePath]) {
        NSString *localFilePath = [[NSBundle mainBundle] pathForResource:localFileName ofType:@"json"];
        NSData *fileData = [NSData dataWithContentsOfFile:localFilePath];
        
        if ([fileData length]) {
            [[PASDataCache sharedDataCache] saveData:fileData toCacheWithPath:cacheFilePath];
        }
        
    }
    
}

/**
 *  清除所有的存储本地的数据
 */
+ (void)clearAllUserDefaultsData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id  key in dic) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
}

@end
