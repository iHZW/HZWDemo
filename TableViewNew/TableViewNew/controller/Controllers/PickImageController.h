//
//  PickImageController.h
//  TableViewNew
//
//  Created by HZW on 15/9/6.
//  Copyright (c) 2015年 韩志伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^colorBlock)(UIColor *color);


@interface PickImageController : UIViewController


@property (nonatomic,strong)NSString *string;/**< 传参 */

@property (nonatomic, copy) colorBlock block;


+ (PickImageController *)shareInstance;


@end
