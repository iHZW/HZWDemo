//
//  CommonNewFileFunc.m
//  TableViewNew
//
//  Created by HZW on 2018/3/23.
//  Copyright © 2018年 韩志伟. All rights reserved.
//

#import "CommonNewFileFunc.h"

@implementation CommonNewFileFunc


/**
 获取Document目录下的全路径

 @param fileName <#fileName description#>
 @return <#return value description#>
 */
+ (NSString *)getDoucmentFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucmentDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",doucmentDirectory,fileName];
    return filePath;
}


/**
 获取LibraryCaches目录下的全路径

 @param fileName <#fileName description#>
 @return <#return value description#>
 */
+ (NSString *)getLibraryCachesFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",libraryDirectory,fileName];
    return filePath;
}

/**
 获取floader目录下某个文件的全路径
 
 @param directorPath 路径
 @param fileName 文件名
 @return 改路径不存在就创建
 */
+ (NSString *)getFloaderFilePath:(NSString *)directorPath fileName:(NSString *)fileName
{
    NSString *filePath = nil;
    NSFileManager *myFile = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL isExist = [myFile fileExistsAtPath:directorPath isDirectory:&isDir];
    BOOL bRet = YES;
    if (!isExist) {
        bRet = [myFile createDirectoryAtPath:directorPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (bRet) {
            filePath = [NSString stringWithFormat:@"%@/%@",directorPath,fileName];
        }
    }{
        filePath = [NSString stringWithFormat:@"%@/%@",directorPath,fileName];
    }
    return filePath;
}


/**
 *  检测指定路径文件夹是否存在
 *
 *  @param filepath 指定目录路径
 *
 *  @return BOOL(YES-存在， NO-不存在)
 */
+ (BOOL)checkDir:(NSString *)filepath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = YES;
    BOOL isDir;
    if (![fileManager fileExistsAtPath:filepath isDirectory:&isDir]) {
        NSError *error = nil;
        if (![fileManager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:&error]) {
            isExist = NO;
        }
    }
    return isExist;
}




@end
