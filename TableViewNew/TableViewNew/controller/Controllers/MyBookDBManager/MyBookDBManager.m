//
//  MyBookDBManager.m
//  TableViewNew
//
//  Created by HZW on 2018/2/7.
//  Copyright © 2018年 韩志伟. All rights reserved.
//

#import "MyBookDBManager.h"
#import "FMDatabaseAdditions.h"

#define kMyBookDBPath     @"MyBookData.db"

@interface MyBookDBManager()

@property (nonatomic, strong) FMDatabase *db;


@end

@implementation MyBookDBManager

/**< 创建单利 */
DEFINE_SINGLETON_T_FOR_CLASS(MyBookDBManager)

//+ (MyBookDBManager *)shareInstance
//{
//    static MyBookDBManager *manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[MyBookDBManager alloc] init];
//    });
//    return manager;
//}

- (void)openDB
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:kMyBookDBPath];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    if (![database open]) {
        NSLog(@"数据库打开失败！");
    }
}


@end
