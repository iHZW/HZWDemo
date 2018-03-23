//
//  BookModel.m
//  TableViewNew
//
//  Created by HZW on 15/9/7.
//  Copyright (c) 2015年 韩志伟. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel
////请求数据Jeson数据的时候需要实现的方法
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key
//{
//    
//}


/**< 归档 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.age forKey:@"age"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.cellHeight] forKey:@"cellHeight"];
}

/**< 解归档 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ([super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeObjectForKey:@"age"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.cellHeight = [[aDecoder decodeObjectForKey:@"cellHeight"] floatValue];
    }
    return self;
}

- (NSComparisonResult)sortNameAscend:(BookModel *)model
{
    return [@(self.name.intValue) compare:@(model.name.intValue)];
}

- (NSComparisonResult)sortNameDescend:(BookModel *)model
{
    NSLog(@"%d",model.name.intValue);
    
    if (self.name.intValue > model.name.intValue) {
        return NSOrderedAscending;
    }else if (self.name.intValue < model.name.intValue){
        return NSOrderedDescending;
    }else{
        return NSOrderedSame;
    }
}


- (NSComparisonResult)sortAgeAscend:(BookModel *)model
{
    return [@(self.age.intValue) compare:@(model.age.intValue)];
}

- (NSComparisonResult)sortAgeDescend:(BookModel *)model
{
    long ret = [self.age compare:model.age];
    if (ret == 0) {
        return NSOrderedSame;
    }else if (ret >0){
        return NSOrderedDescending;
    }else{
        return NSOrderedAscending;
    }
    
}






@end
