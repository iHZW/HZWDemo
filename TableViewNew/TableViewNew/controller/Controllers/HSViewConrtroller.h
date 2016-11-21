//
//  HSViewConrtroller.h
//  TableViewNew
//
//  Created by HZW on 15/9/6.
//  Copyright (c) 2015年 韩志伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBA(rgbaValue) [UIColor colorWithRed:((float)((rgbaValue & 0xFF0000) >> 24))/255.0 green:((float)((rgbaValue & 0xFF00) >> 16))/255.0 blue:((float)((rgbaValue & 0xFF00) >> 8))/255.0 alpha:((float)(rgbaValue & 0xFF))/100.0]

typedef void(^HsViewBlock)(BOOL isSuccess);


@interface HSViewConrtroller : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy)NSString *passName;
@property (nonatomic, copy) HsViewBlock backBlock;

+ (HSViewConrtroller *)shareInstance;


@end
