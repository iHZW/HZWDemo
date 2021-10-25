//
//  CommonNewFileFunc.h
//  TableViewNew
//
//  Created by HZW on 2018/3/23.
//  Copyright © 2018年 韩志伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonNewFileFunc : NSObject


/**
 获取Document目录下的全路径

 @param fileName 文件名
 @return 全路径
 */
+ (NSString *)getDoucmentFilePath:(NSString *)fileName;


/**
 获取LibraryCaches目录下的全路径

 @param fileName 文件名
 @return 全部径
 */
+ (NSString *)getLibraryCachesFilePath:(NSString *)fileName;



/**
 获取floader目录下某个文件的全路径

 @param directorPath 路径
 @param fileName 文件名
 @return 改路径不存在就创建
 */
+ (NSString *)getFloaderFilePath:(NSString *)directorPath fileName:(NSString *)fileName;



/**
 *  检测指定路径文件夹是否存在
 *
 *  @param filepath 指定目录路径
 *
 *  @return BOOL(YES-存在， NO-不存在)
 */
+ (BOOL)checkDir:(NSString *)filepath;



@end
