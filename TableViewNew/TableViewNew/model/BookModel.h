//
//  BookModel.h
//  TableViewNew
//
//  Created by HZW on 15/9/7.
//  Copyright (c) 2015年 韩志伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookModel : NSObject

@property (nonatomic,copy) NSString *name; /**< 书名 */
@property (nonatomic,copy) NSString *age; /**< 年龄 */
@property (nonatomic, copy) NSString *content; /**< 文本 */

@property (nonatomic, assign) CGFloat cellHeight; /**< cell的高度 */

//按照名字升序
- (NSComparisonResult)sortNameAscend:(BookModel *)model;
//按照名字降序
- (NSComparisonResult)sortNameDescend:(BookModel *)model;
//按照年龄升序
- (NSComparisonResult)sortAgeAscend:(BookModel *)model;
//按照年龄降序
- (NSComparisonResult)sortAgeDescend:(BookModel *)model;


@end
