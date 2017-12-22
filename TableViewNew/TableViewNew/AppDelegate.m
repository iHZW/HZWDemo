//
//  AppDelegate.m
//  TableViewNew
//
//  Created by HZW on 15/9/6.
//  Copyright (c) 2015年 韩志伟. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "HSViewConrtroller.h"
#import "BackGroundView.h"
#import "PASCommonUtil.h"

#define kWidth     60

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    
    UIViewController *tempCtrl = nil;

//    ViewController *viewCtrl = [[ViewController alloc] init];
    HSViewConrtroller *ctrl = [[HSViewConrtroller alloc]init];
    tempCtrl = ctrl;
    UINavigationController *navCtrl = [[UINavigationController alloc]initWithRootViewController:tempCtrl];
    self.window.rootViewController = navCtrl;
    [self.window makeKeyAndVisible];
    
    /**< 添加一个全屏的吸附屏幕边缘的按钮 */
    UIButton *circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    circleBtn.frame = CGRectMake(100, 100, kWidth, kWidth);
    circleBtn.layer.cornerRadius = kWidth/2;
    circleBtn.backgroundColor = [UIColor blueColor];
    [self.window.rootViewController.view addSubview:circleBtn];
    
    UIPanGestureRecognizer *pangGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [circleBtn addGestureRecognizer:pangGesture];
    
    return YES;
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:self.window.rootViewController.view];
    CGFloat centerX = translation.x + panGesture.view.center.x;
    CGFloat centerY = translation.y + panGesture.view.center.y;
    CGFloat adjustX = 0;
    CGFloat adjustY = 0;

    panGesture.view.center = CGPointMake(centerX, centerY);
    [panGesture setTranslation:CGPointZero inView:self.window.rootViewController.view];

    if (panGesture.state == UIGestureRecognizerStateEnded ||
        panGesture.state == UIGestureRecognizerStateCancelled)
    {
        /**< 计算偏移x坐标 */
        if (centerX > kMainScreenWidth/2) {
            adjustX = kMainScreenWidth - kWidth/2;
        }else{
            adjustX = kWidth/2;
        }
        
        /**< 计算偏移y坐标 */
        if (centerY < kWidth/2) {
            adjustY = kWidth/2;
        }else if (centerY > kMainScreenHeight - kWidth/2){
            adjustY = kMainScreenHeight - kWidth/2;
        }else{
            adjustY = centerY;
        }

        [UIView animateWithDuration:0.5 animations:^{
            panGesture.view.center = CGPointMake(adjustX, adjustY);
        }];
    }
}




#pragma mark  禁止横屏(实现方法)
/**< 这个是整个APP所有的界面都不支持横屏 */
//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    return UIInterfaceOrientationMaskPortrait;
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    /**< 将要进入后台 */
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /**< APP进入后台添加模糊图片 */
    [BackGroundView showBackGroundView];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /**< APP从后台唤醒移除模糊图片 */
    [BackGroundView removeBackGroundView];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
