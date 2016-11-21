//
//  CMLogManagement.m
//  PASecuritiesApp
//
//  Created by Howard on 16/3/7.
//  Copyright © 2016年 PAS. All rights reserved.
//

#import "CMLogManagement.h"
#import <signal.h>
#import <pthread.h>
#import <libkern/OSAtomic.h>
#import <execinfo.h>
#import "DateFormatterFunc.h"
#import "CommonFileFunc.h"


static const NSUInteger LOGFILE_MAXSIZE = 80 * 1024 * 1024;       // 80K

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
void WriteLevelLog(const char *file, const char* function, int lineNumber, LogLevelType level, NSString* format, ...)
{
    CMLogManagement* manager = [CMLogManagement sharedCMLogManagement];
    
    if (!format) return;
    
    if (level >= manager.logLevel || manager.logLevel == LogLevelAll) // 先检查当前程序设置的日志输出级别。如果这条日志不需要输出，就不用做字符串格式化
    {
        va_list args;
        va_start(args, format);
        NSString* str = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
        if (manager.outputType == LogOutputFile)
        {
            NSProcessInfo *process  = [NSProcessInfo processInfo];
            mach_port_t tid         = pthread_mach_thread_np(pthread_self());
            NSString *functionName  = function ? [NSString stringWithUTF8String:function] : @"";
            
            if (!str)
                str = @"";
            
            // NSDictionary中加入所有需要记录到日志中的信息
            NSString *logStr = [[NSString alloc] initWithFormat:@"%@ %@[%d:%x] %@ [line:%@] [level:%@] %@", [DateFormatterFunc formatDateToDateStr:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss.SSS"], process.processName, process.processIdentifier, tid, functionName, @(lineNumber), @(level), str];
            [manager appendLogEntryInfo:logStr];
#if !__has_feature(objc_arc)
            [logStr release];
#endif
        }
        else    // 默认 LogOutputFile 输出到控制台
        {
//            NSLog(@"file:%s func:%s line:%@ logLevel:%@ %@", file, function, @(lineNumber), @(level), str);
            NSLog(@"func:%s line:%@ logLevel:%@ %@", function, @(lineNumber), @(level), str);
        }
        
#if !__has_feature(objc_arc)
        [str release];
#endif
    }
}


@interface CMLogManagement ()
{
    NSCondition *_signal;
    NSThread *_logThread;
}

@property (nonatomic, strong) NSMutableArray *queue;    //< 日志队列信息
@property (nonatomic, copy) NSString *logFileName;      //< 日志文件路径
@property (nonatomic) BOOL threadStatus;                //< 线程状态

@end


@implementation CMLogManagement

DEFINE_SINGLETON_T_FOR_CLASS(CMLogManagement)

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.outputType = LogOutputConsole;
        _logLevel       = LogLevelInfomation;
        _maxFileSize    = LOGFILE_MAXSIZE;
    }
    
    return self;
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    self.queue          = nil;
    self.logFileName    = nil;
    [_signal release];
    [_logThread release];
    [super dealloc];
}
#endif

- (void)startLogToFileAction
{
    [self checkLogFileStatus];
    
    if (!_queue)
    {
        _queue = [NSMutableArray array];
    }
    
    if (!_signal)
    {
        _signal = [[NSCondition alloc] init];
    }
    
    if (!_logThread)
    {
        _threadStatus = YES;
        _logThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadProc) object:nil];
        [_logThread setName:@"LogThread"];
        [_logThread start];
    }
    else
    {
        _threadStatus = YES;
        [_logThread start];
    }
}

- (void)setOutputType:(LogOutputType)type
{
    _outputType = type;
    
    if (type == LogOutputFile)
    {
        [self startLogToFileAction];
    }
    else
    {
        _threadStatus = NO;
        
        if (_logThread)
        {
            [_logThread cancel];
        }
    }
}

- (void)threadProc
{
    do
    {
        @autoreleasepool {
            for ( int i = 0; i < 20; i++ )
            {
                [_signal lock];
                while ([_queue count ] == 0 && _threadStatus) // NSMutableArray* _queue，其它线程将日志加入_queue，日志线程负责输出到文件和控制台
                    [_signal wait]; // NSCondition* _signal
                
                NSArray* items = [NSArray arrayWithArray:_queue];
                _logsCount -= [items count];
                [_queue removeAllObjects];
                [_signal unlock];
                
                if ([items count] > 0)
                {
                    [self checkLogFileStatus];
                    [self logToFile:items];     // 输出到文件以及控制台
                }
            }
            
            // 每20次输出日志执行一次NSAutoreleasePool的release
            // 保证既不太频繁也不太滞后
        }
        
    } while (_threadStatus);
}

/**
 *  添加Log日志信息
 *
 *  @param entryInfo 日志信息
 */
- (void)appendLogEntryInfo:(id)entryInfo
{
    [_signal lock];
    _logsCount += 1;
    [_queue addObject:entryInfo];
    [_signal signal];
    [_signal unlock];
}

/**
 *  日志落本地文件
 *
 *  @param logArrInfo 日志信息组
 */
- (void)logToFile:(NSArray *)logArrInfo
{
    if (_logFileName && [logArrInfo count] > 0)
    {
        NSString *logStr = [logArrInfo componentsJoinedByString:@"\r\n"];
        logStr = [NSString stringWithFormat:@"%@\r\n", logStr];
        NSString *logFilePath = [CommonFileFunc getLibraryCachesFilePath:[NSString stringWithFormat:@"Log/%@", _logFileName]];
        
        FILE *logFileHandle = fopen([logFilePath UTF8String], "ab+");
        
        if (logFileHandle)
        {
            NSData *logData = [logStr dataUsingEncoding:NSUTF8StringEncoding];
            fwrite([logData bytes], [logData length], 1, logFileHandle);
            fclose(logFileHandle);
        }
    }
}

/**
 *  检测文件状态
 */
- (void)checkLogFileStatus
{
    if (!_logFileName)
    {
        [CommonFileFunc createDirector:[CommonFileFunc getLibraryCachesFilePath:@"Log"]];
        self.logFileName = [NSString stringWithFormat:@"%@.log", [DateFormatterFunc formatDateToDateStr:[NSDate date] format:@"yyyyMMdd HH:mm:ss.SSS"]];
    }
    else
    {
        NSString *filePath = [CommonFileFunc getLibraryCachesFilePath:[NSString stringWithFormat:@"Log/%@", self.logFileName]];
        if ([CommonFileFunc fileSizeForPath:filePath] > _maxFileSize)
            self.logFileName = [NSString stringWithFormat:@"%@.log", [DateFormatterFunc formatDateToDateStr:[NSDate date] format:@"yyyyMMdd HH:mm:ss.SSS"]];
    }
}

@end
