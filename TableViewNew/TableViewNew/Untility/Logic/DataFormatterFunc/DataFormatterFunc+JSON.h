//
//  DataFormatterFunc+JSON.h
//  TZYJ_IPhone
//
//  Created by Howard on 15/8/6.
//
//

#import "DataFormatterFunc.h"

@interface DataFormatterFunc(JSON)

/**
 *  从对应字典数据中，获取指定键值的NSString类型数据
 *
 *  @param key  字段键值名称
 *  @param dict 对应字典数据
 *
 *  @return 返回指定键值的NSString类型的数据(如果数据非法返回 @"")
 */
+ (NSString *)strValueForKey:(id)key ofDict:(NSDictionary *)dict;

/**
 *  从对应字典数据中，获取指定键值的NSNumber类型数据
 *
 *  @param key  字段键值名称
 *  @param dict 对应字典数据
 *
 *  @return 返回指定键值的NSNumber类型数据(如果数据非法返回 @(0))
 */
+ (NSNumber *)numberValueForKey:(id)key ofDict:(NSDictionary *)dict;

/**
 *  从对应字典数据中，获取指定键值的NSArray类型数据
 *
 *  @param key  字段键值名称
 *  @param dict 对应字典数据
 *
 *  @return 返回指定键值的NSArray类型数据(如果数据非法返回 @[])
 */
+ (NSArray *)arrayValueForKey:(id)key ofDict:(NSDictionary *)dict;

/**
 *  从对应字典数据中，获取指定键值的NSDictionary类型数据
 *
 *  @param key  字段键值名称
 *  @param dict 对应字典数据
 *
 *  @return 返回指定键值的NSDictionary类型数据(如果数据非法返回 @{})
 */
+ (NSDictionary *)dictionaryValueForKey:(id)key ofDict:(NSDictionary *)dict;

/**
 *  将JSON对象转换为NSDictionary对象
 *
 *  @param jsonObj JSON数据对象
 *
 *  @return 返回转换后字典对象(如果JSON对象非字典类型，则返回nil)
 */
+ (NSDictionary *)convertDictionary:(id)jsonObj;

/**
 *  将JSON对象转换为NSArray对象
 *
 *  @param jsonObj JSON数据对象
 *
 *  @return 返回转换数组对象(如果JSON对象非数组类型，则返回nil)
 */
+ (NSArray *)convertArray:(id)jsonObj;

/**
 *  从网络地址把JSON数据解释成对象
 *
 *  @param urlStr 链接地址
 *  @param err    错误信息
 *
 *  @return JSON对象
 */
+ (id)jsonObjectFromUrl:(NSString *)urlStr error:(NSError **)error;

/**
 *  从文件路径提取JSON数据并解析成JSON对象
 *
 *  @param filePath 文件路径
 *  @param err      错误信息
 *
 *  @return JSON对象
 */
+ (id)jsonObjectFromFilePath:(NSString *)filePath error:(NSError **)error;

@end


#pragma mark - Deserializing methods

@interface NSString (JSONDeserializing)

- (id)objectByJSONString;
- (id)objectByJSONStringWithParseOptions:(NSJSONReadingOptions)option error:(NSError **)err;

@end

@interface NSData (JSONDeserializing)

// The NSData MUST be UTF8 encoded JSON.
- (id)objectByJSONData;
- (id)objectByJSONDataWithParseOptions:(NSJSONReadingOptions)option error:(NSError **)err;

@end


#pragma mark - Serializing methods

@interface NSString (JSONKitSerializing)
// Convenience methods for those that need to serialize the receiving NSString (i.e., instead of having to serialize a NSArray with a single NSString, you can "serialize to JSON" just the NSString).
// Normally, a string that is serialized to JSON has quotation marks surrounding it, which you may or may not want when serializing a single string, and can be controlled with includeQuotes:
// includeQuotes:YES `a "test"...` -> `"a \"test\"..."`
// includeQuotes:NO  `a "test"...` -> `a \"test\"...`
- (NSData *)toJSONData;     // Invokes JSONDataWithOptions:kNilOptions
- (NSData *)toJSONDataWithOptions:(NSJSONWritingOptions)opiton error:(NSError **)err;
- (NSString *)toJSONString; // Invokes JSONStringWithOptions:kNilOptions
- (NSString *)toJSONStringWithOptions:(NSJSONWritingOptions)opiton error:(NSError **)err;

@end

@interface NSArray (JSONKSerializing)

- (NSData *)toJSONData;
- (NSData *)toJSONDataWithOptions:(NSJSONWritingOptions)opiton error:(NSError **)err;
- (NSString *)toJSONString;
- (NSString *)toJSONStringWithOptions:(NSJSONWritingOptions)opiton error:(NSError **)err;

@end


@interface NSDictionary (JSONKitSerializing)

- (NSData *)toJSONData;
- (NSData *)toJSONDataWithOptions:(NSJSONWritingOptions)opiton error:(NSError **)err;
- (NSString *)toJSONString;
- (NSString *)toJSONStringWithOptions:(NSJSONWritingOptions)opiton error:(NSError **)err;

@end

