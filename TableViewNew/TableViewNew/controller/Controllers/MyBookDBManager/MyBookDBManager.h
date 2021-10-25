//
//  MyBookDBManager.h
//  TableViewNew
//
//  Created by HZW on 2018/2/7.
//  Copyright © 2018年 韩志伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBookDBManager : NSObject
/**< 声明 */
DEFINE_SINGLETON_T_FOR_HEADER(MyBookDBManager)

//+ (MyBookDBManager *)shareInstance;

- (void)openDB;

@end
