//
//  DataFormatterFunc+JSON.m
//  TZYJ_IPhone
//
//  Created by Howard on 15/8/6.
//
//

#import "DataFormatterFunc+JSON.h"

@implementation DataFormatterFunc(JSON)

/**
 *  从对应字典数据中，获取指定键值的NSString类型数据
 *
 *  @param key  字段键值名称
 *  @param dict 对应字典数据
 *
 *  @return 返回指定键值的NSString类型的数据(如果数据非法返回 @"")
 */
+ (NSString *)strValueForKey:(id)key ofDict:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]])
        return [self formatJsonValue:[dict objectForKey:key]];
    else
        return @"";
}

/**
 *  从对应字典数据中，获取指定键值的NSNumber类型数据
 *
 *  @param key  字段键值名称
 *  @param dict 对应字典数据
 *
 *  @return 返回指定键值的NSNumber类型数据(如果数据非法返回 @(0))
 */
+ (NSNumber *)numberValueForKey:(id)key ofDict:(NSDictionary *)dict
{
    NSNumber *val   = @(0);
    
    if ([dict isKindOfClass:[NSDictionary class]])
    {
        id objVal       = [dict objectForKey:key];
        
        if (objVal && objVal != [NSNull null])
        {
            if ([objVal isKindOfClass:[NSNumber class]])
                val = objVal;
            else if ([objVal isKindOfClass:[NSString class]])
            {
#if ! __has_feature(objc_arc)
                NSNumberFormatter *f = [[[NSNumberFormatter alloc] init] autorelease];
#else
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
#endif
                val = [f numberFromString:objVal];
            }
        }
    }
    
    return val;
}

/**
 *  从对应字典数据中，获取指定键值的NSArray类型数据
 *
 *  @param key  字段键值名称
 *  @param dict 对应字典数据
 *
 *  @return 返回指定键值的NSArray类型数据(如果数据非法返回 @[])
 */
+ (NSArray *)arrayValueForKey:(id)key ofDict:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]])
    {
        id obj = [dict objectForKey:key];
        
        if (obj == [NSNull null])
            return @[];
        else if ([obj isKindOfClass:[NSArray class]])
            return [NSArray arrayWithArray:obj];
        else
            return @[];
    }
    else
        return @[];
}

/**
 *  从对应字典数据中，获取指定键值的NSDictionary类型数据
 *
 *  @param key  字段键值名称
 *  @param dict 对应字典数据
 *
 *  @return 返回指定键值的NSDictionary类型数据(如果数据非法返回 @{})
 */
+ (NSDictionary *)dictionaryValueForKey:(id)key ofDict:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]])
    {
        id obj = [dict objectForKey:key];
        
        if (obj == [NSNull null])
            return @{};
        else if ([obj isKindOfClass:[NSDictionary class]])
            return obj;
        else
            return @{};
    }
    else
        return @{};
}

/**
 *  将JSON对象转换为NSDictionary对象
 *
 *  @param jsonObj JSON数据对象
 *
 *  @return 返回转换后字典对象(如果JSON对象非字典类型，则返回nil)
 */
+ (NSDictionary *)convertDictionary:(id)jsonObj
{
    NSDictionary *retDic = [jsonObj isKindOfClass:[NSDictionary class]] ? (NSDictionary *)jsonObj : nil;
    return retDic;
}

/**
 *  将JSON对象转换为NSArray对象
 *
 *  @param jsonObj JSON数据对象
 *
 *  @return 返回转换数组对象(如果JSON对象非数组类型，则返回nil)
 */
+ (NSArray *)convertArray:(id)jsonObj
{
    NSArray *retArr = [jsonObj isKindOfClass:[NSArray class]] ? (NSArray *)jsonObj : nil;
    return retArr;
}

/**
 *  从网络地址把JSON数据解释成对象
 *
 *  @param urlStr 链接地址
 *  @param err    错误信息
 *
 *  @return JSON对象
 */
+ (id)jsonObjectFromUrl:(NSString *)urlStr error:(NSError **)error
{
    NSURL * url = [NSURL URLWithString:urlStr];
    NSString * jsonStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:error];
    
    if (error != nil && *error != nil) {
        CMLogInfo(@"get url json error: %@", *error);
        return nil;
    }
    
    //    CMLogInfo(@"---json url string is:%@", jsonStr);
    if (jsonStr == nil)
        return nil;
    
    return [self jsonObjectFromString:jsonStr error:error];
}

/**
 *  从文件路径提取JSON数据并解析成JSON对象
 *
 *  @param filePath 文件路径
 *  @param err      错误信息
 *
 *  @return JSON对象
 */
+ (id)jsonObjectFromFilePath:(NSString *)filePath error:(NSError **)error
{
    NSString * jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:error];
    
    if (error != nil && *error != nil) {
        CMLogInfo(@"get file json error: %@", *error);
        return nil;
    }
    
    if (jsonStr == nil)
        return nil;
    
    return [self jsonObjectFromString:jsonStr error:error];
}

@end

//以下是为了适配jsonkit给string等类添加的category
//jason解码
////////////
#pragma mark Methods for serializing a single NSString.
////////////
@implementation NSString (JSONDeserializing)

- (id)objectByJSONString
{
    return [self objectByJSONStringWithParseOptions:kNilOptions error:noErr];
}

- (id)objectByJSONStringWithParseOptions:(NSJSONReadingOptions)option error:(NSError **)err
{
    return [DataFormatterFunc jsonObjectFromStringWithOption:self options:option error:err];
}

@end

////////////
#pragma mark Deserializing methods
////////////
@implementation NSData (JSONDeserializing)
// The NSData MUST be UTF8 encoded JSON.
- (id)objectByJSONData
{
    return [self objectByJSONDataWithParseOptions:kNilOptions error:noErr];
}

- (id)objectByJSONDataWithParseOptions:(NSJSONReadingOptions)option error:(NSError **)err
{
    return [DataFormatterFunc jsonObjectFromDataWithOption:self options:option error:err];
}

@end

//json编码
@implementation NSString (JSONSerializing)

////////////
#pragma mark Methods for serializing a single NSString.
////////////

// Useful for those who need to serialize just a NSString.  Otherwise you would have to do something like [NSArray arrayWithObject:stringToBeJSONSerialized], serializing the array, and then chopping of the extra ^\[.*\]$ square brackets.

// NSData returning methods...
- (NSData *)toJSONData
{
    return [self toJSONDataWithOptions:kNilOptions error:noErr];
}

- (NSData *)toJSONDataWithOptions:(NSJSONWritingOptions)opiton error:(NSError **)err;
{
    return [DataFormatterFunc dataFromJSONObjectWithOption:self options:opiton error:err];
}

// NSString returning methods...

- (NSString *)toJSONString
{
    return [self toJSONStringWithOptions:kNilOptions error:noErr];
}

- (NSString *)toJSONStringWithOptions:(NSJSONWritingOptions)opiton error:(NSError **)err
{
    return [DataFormatterFunc stringFromJSONObjectWithOption:self options:opiton error:err];
}

@end

@implementation NSArray (JSONKitSerializing)

// NSData returning methods...
- (NSData *)toJSONData
{
    return [self toJSONDataWithOptions:kNilOptions error:noErr];
}

- (NSData *)toJSONDataWithOptions:(NSJSONWritingOptions)opiton error:(NSError **)err;
{
    return [DataFormatterFunc dataFromJSONObjectWithOption:self options:opiton error:err];
}

// NSString returning methods...

- (NSString *)toJSONString
{
    return [self toJSONStringWithOptions:kNilOptions error:noErr];
}
- (NSString *)toJSONStringWithOptions:(NSJSONWritingOptions)opiton error:(NSError **)err
{
    return [DataFormatterFunc stringFromJSONObjectWithOption:self options:opiton error:err];
}
@end

@implementation NSDictionary (JSONKitSerializing)

// NSData returning methods...

// NSData returning methods...
- (NSData *)toJSONData
{
    return [self toJSONDataWithOptions:kNilOptions error:noErr];
}
- (NSData *)toJSONDataWithOptions:(NSJSONWritingOptions)opiton error:(NSError **)err;
{
    return [DataFormatterFunc dataFromJSONObjectWithOption:self options:opiton error:err];
}

// NSString returning methods...

- (NSString *)toJSONString
{
    return [self toJSONStringWithOptions:kNilOptions error:noErr];
}

- (NSString *)toJSONStringWithOptions:(NSJSONWritingOptions)opiton error:(NSError **)err
{
    return [DataFormatterFunc stringFromJSONObjectWithOption:self options:opiton error:err];
}

@end
