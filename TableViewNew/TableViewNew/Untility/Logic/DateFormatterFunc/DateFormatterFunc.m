//
//  DateFormatterFunc.m
//  TZYJ_IPhone
//
//  Created by Weirdln on 15/12/4.
//  modify by vince
//


#import "DateFormatterFunc.h"

#define KDefaultFormatter [DateFormatterFunc sharedDateFormatter]

static NSDateFormatter *defaultFormatter;
@implementation DateFormatterFunc

+ (NSString *)getInfoFormatDateStringWithDateString:(NSString *)dateString format:(NSString *)format
{
    NSDate *date = [DateFormatterFunc getDateFromDateStr:dateString format:format];
    if (!date) {
        return dateString;
    }
    NSString *currentTimeYear = [DateFormatterFunc getDateStringFromDate:[NSDate date] format:@"yyyy"];
    NSString *newTimeYear = [DateFormatterFunc getDateStringFromDate:date format:@"yyyy"];
    
    NSString *currentTimeyMd = [DateFormatterFunc getDateStringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
    NSString *newTimeyMd = [DateFormatterFunc getDateStringFromDate:date format:@"yyyy-MM-dd"];
    
    NSString *resultFormat = @"yyyy-MM-dd HH:mm";
    if ([currentTimeyMd isEqualToString:newTimeyMd]) {
        resultFormat = @"HH:mm";
    }else if ([currentTimeYear isEqualToString:newTimeYear]){
        resultFormat = @"MM-dd HH:mm";
    }
    NSString *newDateStr = [DateFormatterFunc getDateStringFromDate:date format:resultFormat];
    return newDateStr;
    
}

+ (NSString *)getCurrentDateString
{
    NSString *format = @"yyyy-MM-dd HH:mm:ss";
    [KDefaultFormatter setDateFormat:format];
    NSString *resultString = [DateFormatterFunc getDateStringFromDate:[NSDate date] format:format];
    return resultString;
}

+ (NSString *)getDateStringFromDate:(NSDate *)date format:(NSString *)format
{
    if ([format length]<=0) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    [KDefaultFormatter setDateFormat:format];
    NSString *resultString = [KDefaultFormatter stringFromDate:date];
    return resultString ?: @"";
}

+ (NSDate *)getDateFromDateStr:(NSString *)dateStr format:(NSString *)format
{
    if ([format length]<=0) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    [KDefaultFormatter setDateFormat:format];
    NSDate *resultDate = [KDefaultFormatter dateFromString:dateStr];
    return resultDate;
}

+ (NSString *)formatStrToDateStr:(NSString *)inputStr
                        inFormat:(NSString *)inFormat
                       outFormat:(NSString *)outFormat
{
    [KDefaultFormatter setDateFormat:inFormat];
    [KDefaultFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *date=[KDefaultFormatter dateFromString:inputStr];
    
    [KDefaultFormatter setDateFormat:outFormat];
    NSString *resultStr = [KDefaultFormatter stringFromDate:date];
    CMLogDebug(@"returnStr: %@",resultStr);
    return resultStr ?: @"";
}

/**
 *  根据日期格式获取日期date
 *
 *  @param date   日期数据
 *  @param format 格式
 *
 *  @return <#return value description#>
 */
+ (NSString *)formatDateToDateStr:(NSDate *)date format:(NSString *)format
{
    [KDefaultFormatter setDateFormat:format];
    NSString *resultStr = [KDefaultFormatter stringFromDate:date];
    return resultStr ?: @"";
}

+ (NSString*)calcListRemainTime:(NSString*)listRemainTime inputFormat:(NSString *)inputFormat
{
    if ([inputFormat length]<=0) {
        inputFormat = @"yyyyMMddHHmmss";
    }
    
    NSString *hangEndDateStr = listRemainTime;
    [KDefaultFormatter setDateFormat:inputFormat];
    [KDefaultFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *hangEndDate = [KDefaultFormatter dateFromString:hangEndDateStr];
    
    [KDefaultFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    hangEndDateStr = [KDefaultFormatter stringFromDate:hangEndDate];
    
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...
    NSDate *today = [NSDate date];    //得到当前时间
    
    NSTimeInterval interval = [hangEndDate timeIntervalSinceDate:today];
    CMLogDebug(@"interval: %f",interval);
    
    //从NSDate中取出年月日，时分秒，但是只能取一次
    [endTime setYear:[[hangEndDateStr substringWithRange:NSMakeRange(0, 4)] intValue]];
    [endTime setMonth:[[hangEndDateStr substringWithRange:NSMakeRange(5, 2)] intValue]];
    [endTime setDay:[[hangEndDateStr substringWithRange:NSMakeRange(8, 2)] intValue]];
    [endTime setHour:[[hangEndDateStr substringWithRange:NSMakeRange(11, 2)] intValue]];
    [endTime setMinute:[[hangEndDateStr substringWithRange:NSMakeRange(14, 2)] intValue]];
    [endTime setSecond:[[hangEndDateStr substringWithRange:NSMakeRange(17, 2)] intValue]];
    NSDate *todate = [cal dateFromComponents:endTime]; //把目标时间装载入date
    
    //用来得到具体的时差，是为了统一成北京时间
    unsigned int unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit| NSHourCalendarUnit| NSMinuteCalendarUnit| NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:todate options:0];
    NSString *shi = [NSString stringWithFormat:@"%ld", (long)[d hour]];
    if ([d hour] < 10) {
        shi = [NSString stringWithFormat:@"0%ld",(long)[d hour]];
    }
    NSString *fen = [NSString stringWithFormat:@"%ld", (long)[d minute]];
    if([d minute] < 10) {
        fen = [NSString stringWithFormat:@"0%ld",(long)[d minute]];
    }
    NSString *miao = [NSString stringWithFormat:@"%ld", (long)[d second]];
    if([d second] < 10) {
        miao = [NSString stringWithFormat:@"0%ld",(long)[d second]];
    }
    
    NSString *returnStr = nil;
    if(interval <= 0) {
        
        //计时结束，do_something
        returnStr = @"0天00小时00分00秒";
        
    } else {
        
        CMLogDebug(@"month:%ld shi:%@, fen:%@, miao:%@",(long)([d month]*30 + [d day]), shi, fen, miao);
        //计时尚未结束，do_something
        returnStr = [NSString stringWithFormat:@"%ld天%@小时%@分%@秒",(long)([d month]*30+[d day]),shi,fen,miao];
        
    }
    return returnStr;
}

+ (NSDateFormatter *)sharedDateFormatter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultFormatter = [[NSDateFormatter alloc] init];
    });
    return defaultFormatter;
}

+ (NSString *)currentSystemHMSTime
{
    NSDate *date = [NSDate date];
    return [DateFormatterFunc formatDateToDateStr:date format:@"HH:mm:ss"];
}

+ (NSTimeInterval)getDateFrom:(NSString *)fromDate toDate:(NSString *)toDate format:(NSString *)format
{
    NSTimeInterval time = 0;
    
    if ([fromDate length] > 0 && [toDate length] > 0)
    {
        NSDateFormatter * formatter = KDefaultFormatter;
        [formatter setDateFormat:format];
        NSDate * dateDeadLine = [formatter dateFromString:toDate];
        NSDate * dateNow = [formatter dateFromString:fromDate];
        time = [dateDeadLine timeIntervalSinceDate:dateNow];
    }
    
    return time;
}

/**
 *  将某个时间设置为想要的时间 例如 一年后 一个月后等
 *
 *  @param endDate
 */
+ (NSDate *)getWantEndDate:(NSDate *)mydate year:(NSInteger)year month:(NSInteger )month day:(NSInteger)day
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:year];
    [adcomps setMonth:month];
    [adcomps setDay:day];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    
    return newdate;
    //    NSString *beforDate = [dateFormatter stringFromDate:newdate];
    //    DebugLog(@"---前两个月 =%@",beforDate);
}


@end
