//
//  ZWWeakObject.h
//  TableViewNew
//
//  Created by HZW on 2018/10/26.
//  Copyright © 2018 韩志伟. All rights reserved.
//

/**< 中间件proxy  解决timer循环引用的问题 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWWeakObject : NSObject

- (instancetype)initWithWeakObjec:(id)obj;

+ (instancetype)proxyWithWeakObjec:(id)obj;

@end

NS_ASSUME_NONNULL_END
