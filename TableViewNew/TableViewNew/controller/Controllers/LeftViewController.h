//
//  LeftViewController.h
//  TableViewNew
//
//  Created by HZW on 2018/1/8.
//  Copyright © 2018年 韩志伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CWLateralSlide.h"

@interface LeftViewController : UIViewController

@property (nonatomic, assign) DrawerType drawerType;


+ (LeftViewController *)shareInstance;


@end
