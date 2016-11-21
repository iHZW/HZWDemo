//
//  DateFormatterFunc.h
//  TZYJ_IPhone
//
//  Created by Weirdln on 15/12/4.
//
//

#import <Foundation/Foundation.h>

@interface DateFormatterFunc : NSObject

+ (NSDateFormatter *)sharedDateFormatter;

/**
 *  获取NSString *format = @"yyyy-MM-dd HH:mm:ss";格式的当前时间字符串
 *
 *  @return 字符串
 */
+ (NSString *)getCurrentDateString;

/**
 *  根据时间及时间格式获取对应的时间字符串
 *
 *  @param date   时间
 *  @param format 输出的时间格式
 *
 *  @return <#return value description#>
 */
+ (NSString *)getDateStringFromDate:(NSDate *)date format:(NSString *)format;

/**
 *  根据输入的时间格式及时间字符串获取日期date
 *
 *  @param dateStr 时间字符串
 *  @param format  输入的时间格式
 *
 *  @return <#return value description#>
 */
+ (NSDate *)getDateFromDateStr:(NSString *)dateStr format:(NSString *)format;

/**
 *  根据日期格式获取日期date
 *
 *  @param date   日期数据
 *  @param format 格式
 *
 *  @return <#return value description#>
 */
+ (NSString *)formatDateToDateStr:(NSDate *)date format:(NSString *)format;

/**
 *  获取输出格式的时间
 *
 *  @param inputStr  时间字符串
 *  @param inFormat  时间输入格式
 *  @param outFormat 时间输出格式
 *
 *  @return 输出格式字符串
 */
+ (NSString *)formatStrToDateStr:(NSString *)inputStr
                        inFormat:(NSString *)inFormat
                       outFormat:(NSString *)outFormat;


/**
 *  获取0天00小时00分00秒格式字符串
 *
 *  @param listRemainTime 时间字符串
 *
 *  @param inputFormat 时间格式
 *  @return 返回0天00小时00分00秒字格式符串
 */
+ (NSString*)calcListRemainTime:(NSString*)listRemainTime inputFormat:(NSString *)inputFormat;

/**
 *  获取当前时间的时分秒，格式如HH:mm:ss
 *
 *  @return 返回时间字符串
 */
+ (NSString *)currentSystemHMSTime;

/**
 *  获取资讯格式时间
 *
 *  @param dateString 传入时间
 *  @param format     传入时间格式
 *
 *  @return 返回资讯格式时间
 */
+ (NSString *)getInfoFormatDateStringWithDateString:(NSString *)dateString format:(NSString *)format;

+ (NSTimeInterval)getDateFrom:(NSString *)fromDate toDate:(NSString *)toDate format:(NSString *)format;

/**
 *  将某个时间设置为想要的时间 例如 一年后 一个月后等
 *
 *  @param endDate
 */
+ (NSDate *)getWantEndDate:(NSDate *)mydate year:(NSInteger)year month:(NSInteger )month day:(NSInteger)day;

@end
