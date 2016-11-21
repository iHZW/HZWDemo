//
//  CMLogManagement.h
//  PASecuritiesApp
//
//  Created by Howard on 16/3/7.
//  Copyright © 2016年 PAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonTemplate.h"


/**
 *  日志级别
 */
typedef NS_ENUM(NSInteger, LogLevelType) {
    /**
     *  打开所有日志记录
     */
    LogLevelAll             = 0,
    /**
     *  指出细粒度信息事件对调试应用程序是非常有帮助的
     */
    LogLevelDebug           = 1,
    /**
     *  消息在粗粒度级别上突出强调应用程序的运行过程
     */
    LogLevelInfomation      = 2,
    /**
     *  出现潜在错误的情形
     */
    LogLevelWarning         = 3,
    /**
     *  发生错误事件，但仍然不影响系统的继续运行
     */
    LogLevelError           = 4,
    /**
     *  严重的错误事件将会导致应用程序的退出
     */
    LogLevelFatal           = 5,
    /**
     *  禁用所有日志记录
     */
    LogLevelDisable         = 100,
};

/**
 *  Log输出形式
 */
typedef NS_ENUM(NSInteger, LogOutputType) {
    /**
     *  输出到控制台
     */
    LogOutputConsole,
    /**
     *  输出到文件
     */
    LogOutputFile,
};


/**
 *  具有日志级别的日志信息
 *
 *  @param file       记录日志所在的文件名称
 *  @param function   记录日志所在的函数名称
 *  @param lineNumber 代码所在行数
 *  @param level      日志级别(DISABLE、FATAL、ERROR、WARN、INFO、DEBUG、ALL)
 *  @param format     日志内容，格式化字符串
 *  @param ...        不定参数...
 */
void WriteLevelLog(const char *file, const char* function, int lineNumber, LogLevelType level, NSString* format, ...);

#define CMLogDebug(format, ...)         WriteLevelLog(__FILE__, __FUNCTION__, __LINE__, LogLevelDebug, format, ##__VA_ARGS__)
#define CMLogInfo(format, ...)          WriteLevelLog(__FILE__, __FUNCTION__, __LINE__, LogLevelInfomation, format, ##__VA_ARGS__)
#define CMLogWarning(format, ...)       WriteLevelLog(__FILE__, __FUNCTION__, __LINE__, LogLevelWarning, format, ##__VA_ARGS__)
#define CMLogError(format, ...)         WriteLevelLog(__FILE__, __FUNCTION__, __LINE__, LogLevelError, format, ##__VA_ARGS__)
#define CMLogFatal(format, ...)         WriteLevelLog(__FILE__, __FUNCTION__, __LINE__, LogLevelFatal, format, ##__VA_ARGS__)

@interface CMLogManagement : NSObject

//< 日志级别 (DISABLE、FATAL、ERROR、WARN、INFO、DEBUG、ALL) 默认LogLevelAll
@property (nonatomic)LogLevelType logLevel;

//< 日志输出类型 默认 LogOutputConsole
@property (nonatomic, setter=setOutputType:)LogOutputType outputType;

//< 日志文件最大容量 默认 80K
@property unsigned long long maxFileSize;

//< 当前日志数
@property (readonly) NSUInteger logsCount;

DEFINE_SINGLETON_T_FOR_HEADER(CMLogManagement)

/**
 *  添加Log日志信息
 *
 *  @param entryInfo 日志信息
 */
- (void)appendLogEntryInfo:(id)entryInfo;

@end
