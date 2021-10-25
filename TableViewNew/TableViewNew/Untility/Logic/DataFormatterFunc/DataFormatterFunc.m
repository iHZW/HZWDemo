//
//  DataFormatterFunc.m
//  TZYJ_IPhone
//
//  Created by Howard on 15/8/6.
//
//

#import "DataFormatterFunc.h"
#import "DataFormatterFunc+JSON.h"

#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define kNumbers     @"0123456789"
#define kNumbersPeriod  @"0123456789."

@implementation DataFormatterFunc

#pragma mark - private's method
+ (void)itoa:(NSInteger)n c:(char *)c
{
    NSInteger i,sign;
    
    if((sign=n) < 0)
    {
        n=-n;
    }
    i=0;
    
    do
    {
        c[i++]=n%10+'0';
    }while ((n/=10)>0);
    
    if(sign<0)
        c[i++]='-';
    c[i]='\0';
}

+ (BOOL)checkInputWithType:(NSString *)string formatType:(NSString *)formatType
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:formatType] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    
    return basic;
}

#pragma mark - public's method
/**
 *  将数值型转换字符串
 *
 *  @param v   转换数值
 *  @param len 最后字符串显示长度(如果数据总长度大于len,则从前往后截取位数, len数值保留足够大位数)
 *  @param dig 小数位数
 *
 *  @return 返回转换后字符串
 */
+ (NSString *)formatDStr:(double)v len:(NSInteger)len dig:(NSInteger)dig
{
    NSInteger ln, rn;
    char floatstr[64];
    char temp[2];
    char formatStr[10];
    char formatStr2[10] = {'%'};
    
    [[self class] itoa:dig c:temp];
    sprintf(formatStr, ".%sf", temp);
    strcat(formatStr2, formatStr);
    sprintf(floatstr, formatStr2, v);
    
    NSString * vv = [NSString stringWithUTF8String:floatstr];
    NSString *strRetVal;
    
    NSRange rang 	= [vv rangeOfString:@"."];
    ln 				= rang.location;
    rn 				= [vv length] - ln - 1;
    
    if (rang.location != NSNotFound)
    {
        NSRange subrangL, subrangR;
        NSString *rightstr;
        subrangL.location 	= 0;
        subrangL.length 	= MAX(ln, 0);
        NSString *leftstr 	= [vv substringWithRange:subrangL];
        subrangR.location 	= ln + 1;
        subrangR.length 	= MAX(rn, 0);
        NSString *rightstrO = [vv substringWithRange:subrangR];
        NSInteger over 		= [vv length] - len;
        
        if (over > 0)
        {
            NSRange r;
            r.location 	= 0;
            r.length 	= MIN([rightstrO length] - over, [rightstrO length]);
            rightstr 	= [rightstrO substringWithRange:r];
        }
        else
            rightstr = rightstrO;
        
        if ([rightstr length] > 0 && [leftstr length] < len)
            strRetVal = [NSString stringWithFormat:@"%@.%@", leftstr, rightstr];
        else
            strRetVal = leftstr;
    }
    else
        strRetVal = vv;
    
    return strRetVal;
}

+ (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isPureFloat:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

+ (BOOL)isPureAlpha:(NSString *)string
{
    return [[self class] checkInputWithType:string formatType:kAlpha];
}

+ (BOOL)isPureAlphaNumber:(NSString *)string
{
    return [[self class] checkInputWithType:string formatType:kAlphaNum];
}

+ (BOOL)isPureNumber:(NSString *)string
{
    return [[self class] checkInputWithType:string formatType:kNumbers];
}

+ (BOOL)bolNull:(NSObject *)object
{
    BOOL result = NO;
    if ((object == [NSNull null])||object == nil) {
        result = YES;
    }
    return result;
}

+ (BOOL)bolString:(NSString *)string
{
    BOOL result = ![DataFormatterFunc bolNull:string];
    if (result) {
        if ([string isKindOfClass:[NSString class]]) {
            result = string.length;
        } else {
            result = NO;
        }
    }
    return result;
}

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
+ (NSString *)formatJsonValue:(id)value
{
    if (value == [NSNull null])
        return @"";
    else if ([value isKindOfClass:[NSString class]])
        return value;
    else if ([value isKindOfClass:[NSNumber class]])
        return [(NSNumber *)value stringValue];
    else if ([value isKindOfClass:[NSArray class]])
        return [(NSArray *)value componentsJoinedByString:@","];
    
    return @"";
}

/**
 *  检测string的有效性
 *
 *  @param string 字符串对象
 *
 *  @return 返回非nil,非[NSNull null] 字符串
 */
+ (NSString *)validStringValue:(NSString *)string
{
    NSString *retVal = !string ? @"" : [DataFormatterFunc formatJsonValue:string];
    return retVal;
}

+ (NSDictionary *)validDictionaryValue:(NSDictionary *)dictionary
{
    NSDictionary *dict = [dictionary isKindOfClass:[NSDictionary class]] ? dictionary : [NSDictionary dictionary];
    return dict;
}

+ (NSArray *)validArrayValue:(NSArray *)array
{
    NSArray *resultArr = [array isKindOfClass:[NSArray class]] ? array : [NSArray array];
    return resultArr;
}

/**
 防止数组越界
 
 @param array 数组对象
 @param index 下标
 @return
 */
+ (id)checkArray:(NSArray *)array index:(NSUInteger)index
{
    if (index >= [array count]) {
        return nil;
    }
    
    id value = [array objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

/**
 *  将JSON对象序列化二进制数据
 *
 *  @param obj JSON对象
 *  @param err NSError错误信息
 *
 *  @return 返回二进制数据
 */
+ (NSData *)dataFromJSONObject:(id)obj error:(NSError **)err
{
    return [self dataFromJSONObjectWithOption:obj options:kNilOptions error:err];
}

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
{
    if(![NSJSONSerialization isValidJSONObject:obj])
    {
        return nil;
    }
    return [NSJSONSerialization dataWithJSONObject:obj options:option error:err];
}

/**
 *  将JSON对象序列化二UTF8String
 *
 *  @param obj JSON对象
 *  @param err NSError错误信息
 *
 *  @return 返回UTF8String
 */
+ (NSString *)stringFromJSONObject:(id)obj error:(NSError **)err
{
    return [self stringFromJSONObjectWithOption:obj options:kNilOptions error:err];
}

/**
 *  将JSON对象序列化二UTF8String
 *
 *  @param obj    JSON对象
 *  @param option NSJSONWritingOptions
 *  @param err    NSError错误信息
 *
 *  @return 返回UTF8String
 */
+ (NSString *)stringFromJSONObjectWithOption:(id)obj options:(NSJSONWritingOptions)option error:(NSError **)err
{
    if (![NSJSONSerialization isValidJSONObject:obj])
    {
        return nil;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:option error:err];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/**
 *  根据二进制数据生成JSON对象
 *
 *  @param data 二进制数据
 *  @param err  NSError错误信息
 *
 *  @return JSON对象
 */
+ (id)jsonObjectFromData:(NSData *)data error:(NSError **)err
{
    return [self jsonObjectFromDataWithOption:data options:kNilOptions error:err];
}

/**
 *  根据二进制数据生成JSON对象
 *
 *  @param data   二进制数据
 *  @param option NSJSONReadingOptions
 *  @param err    NSError错误信息
 *
 *  @return JSON对象
 */
+ (id)jsonObjectFromDataWithOption:(NSData *)data options:(NSJSONReadingOptions)option error:(NSError **)err
{
    return [NSJSONSerialization JSONObjectWithData:data options:option error:err];
}

/**
 *  根据字符串信息返回JSON对象
 *
 *  @param str JSON字符串信息
 *  @param err NSError错误信息
 *
 *  @return JSON对象
 */
+ (id)jsonObjectFromString:(NSString *)str error:(NSError **)err
{
    return [self jsonObjectFromStringWithOption:str options:kNilOptions error:err];
}

/**
 *  根据字符串信息返回JSON对象
 *
 *  @param str    JSON字符串信息
 *  @param option NSJSONReadingOptions
 *  @param err    NSError错误信息
 *
 *  @return JSON对象
 */
+ (id)jsonObjectFromStringWithOption:(NSString *)str options:(NSJSONReadingOptions)option error:(NSError **)err
{
    return [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:option error:err];
}

/**
 *  将字典格式化成JSON字符串
 *
 *  @param dict 字典数据
 *
 *  @return JSON字符串
 */
+ (NSString *)formatJsonStrWithDictionary:(NSDictionary *)dict
{
    NSString *retVal = [dict toJSONString];
    
    return retVal;
}

/**
 *  将数组格式化成JSON字符串
 *
 *  @param array 数组数据
 *
 *  @return JSON字符串
 */
+ (NSString *)formatJsonStrWithArray:(NSArray *)array
{
    NSString *retVal = [array toJSONString];
    return retVal;
}

/**
 *  将JSON字符串解析为字典数据
 *
 *  @param jsonStr JSON字符串
 *
 *  @return 字典数据
 */
+ (NSDictionary *)parseToDict:(NSString *)jsonStr
{
    NSError *err = nil;
    id jsonValue = [self jsonObjectFromString:jsonStr error:&err];
    
    return [DataFormatterFunc convertDictionary:jsonValue];
}

/**
 *  将JSON二进制数据解析为字典数据
 *
 *  @param jsonData JSON二进制数据
 *
 *  @return 字典数据
 */
+ (NSDictionary *)parseDataToDict:(NSData *)jsonData
{
    NSError *err = nil;
    id jsonValue = [self jsonObjectFromData:jsonData error:&err];
    
    return [DataFormatterFunc convertDictionary:jsonValue];
}

/**
 *  将JSON字符串解析为数组数据
 *
 *  @param jsonStr JSON字符串
 *
 *  @return 数组数据
 */
+ (NSArray *)parseToArray:(NSString *)jsonStr
{
    NSError *err = nil;
    id jsonValue = [self jsonObjectFromString:jsonStr error:&err];
    
    return [DataFormatterFunc convertArray:jsonValue];
}

/**
 *  将JSON二进制数据解析为数组数据
 *
 *  @param jsonData JSON二进制数据
 *
 *  @return 数组数据
 */
+ (NSArray *)parseDataToArray:(NSData *)jsonData
{
    NSError *err = nil;
    id jsonValue = [self jsonObjectFromData:jsonData error:&err];
    
    return [DataFormatterFunc convertArray:jsonValue];
}
/**
 *  获取市场类型
 *
 *  @param stockType 恒生股票类型
 *
 *  @return 市场类型
 */
+ (NSString *)marketType:(NSInteger)stockType
{
    NSString *retVal = @"";
    
    NSInteger type = (stockType & 0xffff) >> 8;
    
    if (type == 0x11)
    {
        retVal = @"SH";
    }
    else if (type == 0x12)
    {
        retVal = @"SZ";
    }
    
    return retVal;
}

/**
 解决float 除法精度问题  A/B
 
 @param value A
 @param decimal B
 @return 结果
 */
+ (float)decimalNumberForFloat:(float)value decimal:(float)decimal
{
    NSDecimalNumber* n1 = [NSDecimalNumber decimalNumberWithString:[NSString    stringWithFormat:@"%f",value]];
    NSDecimalNumber* n2 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",decimal]];
    NSDecimalNumber* n3 = [n1 decimalNumberByDividingBy:n2];
    return [n3 floatValue];
}

+ (NSString *)decimalNumberWithMultiplyingBy:(NSString *)decimal1 by:(NSString *)decimal2
{
    
    NSDecimalNumber* n1 = [NSDecimalNumber decimalNumberWithString:decimal1];
    NSDecimalNumber* n2 = [NSDecimalNumber decimalNumberWithString:decimal2];
    if (n1 == [NSDecimalNumber notANumber]) {
        n1 = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    if (n2 == [NSDecimalNumber notANumber]) {
        n2 = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    NSDecimalNumber* n3 = [n1 decimalNumberByMultiplyingBy:n2];
    return [n3 stringValue];
}

+ (NSString *)decimalNumberWithAddBy:(NSString *)decimal1 by:(NSString *)decimal2
{
    NSDecimalNumber* n1 = [NSDecimalNumber decimalNumberWithString:decimal1];
    NSDecimalNumber* n2 = [NSDecimalNumber decimalNumberWithString:decimal2];
    if (n1 == [NSDecimalNumber notANumber]) {
        n1 = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    if (n2 == [NSDecimalNumber notANumber]) {
        n2 = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    
    NSDecimalNumber* n3 = [n1 decimalNumberByAdding:n2];
    return [n3 stringValue];
}

/**12
 将字典转化为get请求url字符串
 
 @param dict
 @return
 */
+ (NSString *)parseDictionaryToUrlStr:(NSDictionary *)dict{
    NSArray *keys;
    NSUInteger i, count;
    NSString *key = @"";
    NSString *value = @"";
    NSMutableString *url = [NSMutableString stringWithString:@"?"];
    keys = [dict allKeys];
    count = [keys count];
    for (i = 0; i < count; i++)
    {
        key = [keys objectAtIndex: i];
        value = [dict objectForKey: key];
        NSLog (@"Key: %@ for value: %@", key, value);
        [url appendString:key];
        [url appendString:@"="];
        [url appendString:value];
        if (i != count-1) {
            [url appendString:@"&"];
        }
    }
    return url;
}

@end
