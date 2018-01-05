//
//  DataFormatterFunc.h
//  TZYJ_IPhone
//
//  Created by Howard on 15/8/6.
//
//

#import <Foundation/Foundation.h>

#define PASArrayAtIndex(array,i) [DataFormatterFunc checkArray:array index:i] //数组中获取index值防止crash

#define TransToString(s)  [DataFormatterFunc validStringValue:s]

@interface DataFormatterFunc : NSObject

/**
 *  将数值型转换字符串
 *
 *  @param v   转换数值
 *  @param len 最后字符串显示长度(如果数据总长度大于len,则从前往后截取位数, len数值保留足够大位数)
 *  @param dig 小数位数
 *
 *  @return 返回转换后字符串
 */
+ (NSString *)formatDStr:(double)v len:(NSInteger)len dig:(NSInteger)dig;

+ (BOOL)isPureInt:(NSString *)string;

+ (BOOL)isPureFloat:(NSString *)string;

+ (BOOL)isPureAlpha:(NSString *)string;

+ (BOOL)isPureAlphaNumber:(NSString *)string;

+ (BOOL)isPureNumber:(NSString *)string;

/**
 *  是否是nil或者null
 *
 *  @param object
 *
 *  @return
 */
+ (BOOL)bolNull:(NSObject *)object;

/**
 *  是否是长度大于0的字符串
 *
 *  @param string 字符串
 *
 *  @return 返回结果
 */
+ (BOOL)bolString:(NSString *)string;

/**
 *  格式化json字段的值
 *
 *  @param value json
 *
 *  @return 返回NSString类型数据
 对应键值数据转换做如下处理
 1.[NSNull null]     ==>  @""
 2. NSString         ==> 直接返回
 3. NSNumber         ==> 转换NSString类型后返回
 4. NSArray          ==> 将数组元素用 @"," 拼接后返回
 */
+ (NSString *)formatJsonValue:(id)value;

/**
 *  检测string的有效性
 *
 *  @param string 字符串对象
 *
 *  @return 返回非nil,非[NSNull null] 字符串
 */
+ (NSString *)validStringValue:(NSString *)string;

/**
 *  检测字典的有效性
 *
 *  @param dictionary 字典对象
 *
 *  @return 返回非nil的字典对象
 */
+ (NSDictionary *)validDictionaryValue:(NSDictionary *)dictionary;

/**
 * 检测数组有效性
 *
 *  @param array 数组对象
 *
 *  @return 非空数组对象
 */
+ (NSArray *)validArrayValue:(NSArray *)array;

/**
 防止数组越界
 
 @param array 数组对象
 @param index 下标
 @return
 */
+ (id)checkArray:(NSArray *)array index:(NSUInteger)index;

/**
 *  将JSON对象序列化二进制数据
 *
 *  @param obj JSON对象
 *  @param err NSError错误信息
 *
 *  @return 返回二进制数据
 */
+ (NSData *)dataFromJSONObject:(id)obj error:(NSError **)err;

/**
 *  将JSON对象序列化二进制数据
 *
 *  @param obj    JSON对象
 *  @param option NSJSONWritingOptions
 *  @param err    NSError错误信息
 *
 *  @return 返回二进制数据
 */
+ (NSData *)dataFromJSONObjectWithOption:(id)obj options:(NSJSONWritingOptions)option error:(NSError **)err;

/**
 *  将JSON对象序列化二UTF8String
 *
 *  @param obj JSON对象
 *  @param err NSError错误信息
 *
 *  @return 返回UTF8String
 */
+ (NSString *)stringFromJSONObject:(id)obj error:(NSError **)err;
/**
 *  将JSON对象序列化二UTF8String
 *
 *  @param obj    JSON对象
 *  @param option NSJSONWritingOptions
 *  @param err    NSError错误信息
 *
 *  @return 返回UTF8String
 */
+ (NSString *)stringFromJSONObjectWithOption:(id)obj options:(NSJSONWritingOptions)option error:(NSError **)err;

/**
 *  根据二进制数据生成JSON对象
 *
 *  @param data 二进制数据
 *  @param err  NSError错误信息
 *
 *  @return JSON对象
 */
+ (id)jsonObjectFromData:(NSData *)data error:(NSError **)err;

/**
 *  根据二进制数据生成JSON对象
 *
 *  @param data   二进制数据
 *  @param option NSJSONReadingOptions
 *  @param err    NSError错误信息
 *
 *  @return JSON对象
 */
+ (id)jsonObjectFromDataWithOption:(NSData *)data options:(NSJSONReadingOptions)option error:(NSError **)err;

/**
 *  根据字符串信息返回JSON对象
 *
 *  @param str JSON字符串信息
 *  @param err NSError错误信息
 *
 *  @return JSON对象
 */
+ (id)jsonObjectFromString:(NSString *)str error:(NSError **)err;

/**
 *  根据字符串信息返回JSON对象
 *
 *  @param str    JSON字符串信息
 *  @param option NSJSONReadingOptions
 *  @param err    NSError错误信息
 *
 *  @return JSON对象
 */
+ (id)jsonObjectFromStringWithOption:(NSString *)str options:(NSJSONReadingOptions)option error:(NSError **)err;

/**
 *  将字典格式化成JSON字符串
 *
 *  @param dict 字典数据
 *
 *  @return JSON字符串
 */
+ (NSString *)formatJsonStrWithDictionary:(NSDictionary *)dict;

/**
 *  将数组格式化成JSON字符串
 *
 *  @param array 数组数据
 *
 *  @return JSON字符串
 */
+ (NSString *)formatJsonStrWithArray:(NSArray *)array;

/**
 *  将JSON字符串解析为字典数据
 *
 *  @param jsonStr JSON字符串
 *
 *  @return 字典数据
 */
+ (NSDictionary *)parseToDict:(NSString *)jsonStr;

/**
 *  将JSON二进制数据解析为字典数据
 *
 *  @param jsonData JSON二进制数据
 *
 *  @return 字典数据
 */
+ (NSDictionary *)parseDataToDict:(NSData *)jsonData;

/**
 *  将JSON字符串解析为数组数据
 *
 *  @param jsonStr JSON字符串
 *
 *  @return 数组数据
 */
+ (NSArray *)parseToArray:(NSString *)jsonStr;

/**
 *  将JSON二进制数据解析为数组数据
 *
 *  @param jsonData JSON二进制数据
 *
 *  @return 数组数据
 */
+ (NSArray *)parseDataToArray:(NSData *)jsonData;
/**
 *  获取市场类型
 *
 *  @param stockType 恒生股票类型
 *
 *  @return 市场类型
 */
+ (NSString *)marketType:(NSInteger)stockType;

/**
 解决float 除法精度问题  A/B
 
 @param value A
 @param decimal B
 @return 结果
 */
+ (float)decimalNumberForFloat:(float)value decimal:(float)decimal;

/**
 将字典转化为get请求url字符串
 
 @param dict
 @return
 */
+ (NSString *)parseDictionaryToUrlStr:(NSDictionary *)dict;

/**
 乘法
 */
+ (NSString *)decimalNumberWithMultiplyingBy:(NSString *)decimal1 by:(NSString *)decimal2;
/**
 加法
 */
+ (NSString *)decimalNumberWithAddBy:(NSString *)decimal1 by:(NSString *)decimal2;


@end
