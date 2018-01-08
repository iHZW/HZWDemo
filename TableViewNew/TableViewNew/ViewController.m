//
//  ViewController.m
//  TableViewNew
//
//  Created by HZW on 15/9/6.
//  Copyright (c) 2015年 韩志伟. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "HSViewConrtroller.h"
#import "UIViewController+CWLateralSlide.h"

#define kVerifySuccess      @"指纹验证成功"


@interface ViewController ()

@property (nonatomic, strong) LAContext *lacontext; /**< 指纹识别 */

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    
    self.lacontext = [[LAContext alloc] init];
//    self.lacontext.localizedCancelTitle = @"点一下你试试看";
//    self.lacontext.localizedFallbackTitle = @"试试就试试!";
    self.lacontext.localizedFallbackTitle = @"";//@"输入密码Test";
//    self.lacontext.touchIDAuthenticationAllowableReuseDuration = 3;
    
    [self createLAContext];
    
}


- (void)createUI
{
    UIImageView *imageView = [UIImageView imageViewForImage:[UIImage imageNamed:@"LAContextImage"] withFrame:CGRectZero];
    imageView.layer.cornerRadius = imageView.width/2;
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(PASFactor(100));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(PASFactor(60), PASFactor(60)));
    }];
    
    UIButton *fingerprint = [UIButton buttonWithFrame:CGRectZero target:self action:@selector(clickFinger) bgImage:[UIImage imageNamed:@"touch_id_success"] tag:00123 block:nil];
    [self.view addSubview:fingerprint];
    
    [fingerprint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(PASFactor(50));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(PASFactor(50), PASFactor(50)));
    }];
    
    UILabel *remindLabel = [UILabel labelWithFrame:CGRectZero text:@"请扫描指纹!" textColor:[UIColor purpleColor]];
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:remindLabel];
    
    [remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fingerprint.mas_bottom).offset(PASFactor(30));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(PASFactor(100), PASFactor(40)));
    }];
    
}

#pragma mark  处理点击指纹按钮事件
- (void)clickFinger
{
    NSLog(@"点击指纹识别");
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self createLAContext];
}


- (void)createLAContext
{
    /**< 支持指纹解锁, */
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0 &&
        [self.lacontext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:NULL])
    {
        [self.lacontext evaluatePolicy:LAPolicyDeviceOwnerAuthentication
                       localizedReason:@"请验证已有指纹"
                                 reply:^(BOOL success, NSError * _Nullable error)
        {
             if (success) {
                 [self refreshUI:kVerifySuccess message:nil];
             }else{
                 NSString *errorString = [self getErrorString:error.code];
                 [self refreshUI:@"指纹验证失败" message:errorString];
             }
         }];
    }
    
//    // 判断用户手机系统是否是 iOS 8.0 以上版本
//    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
//        return;
//    }
//
//    // 判断是否支持指纹识别
//    if (![self.lacontext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:NULL]) {
//        return;
//    }
//
//    [self.lacontext evaluatePolicy:LAPolicyDeviceOwnerAuthentication
//            localizedReason:@"请验证已有指纹"
//                      reply:^(BOOL success, NSError * _Nullable error) {
//
//                          // 输入指纹开始验证，异步执行
//                          if (success) {
//
//                              [self refreshUI:[NSString stringWithFormat:kVerifySuccess] message:nil];
//                              //                               [self pushVC];
//                          }else{
//
//                              [self refreshUI:[NSString stringWithFormat:@"指纹验证失败"] message:error.userInfo[NSLocalizedDescriptionKey]];
//                          }
//                      }];
}

//typedef NS_ENUM(NSInteger, LAError)
//{
//    LAErrorAuthenticationFailed,     // 验证信息出错，就是说你指纹不对
//    LAErrorUserCancel               // 用户取消了验证
//    LAErrorUserFallback             // 用户点击了手动输入密码的按钮，所以被取消了
//    LAErrorSystemCancel             // 被系统取消，就是说你现在进入别的应用了，不在刚刚那个页面，所以没法验证
//    LAErrorPasscodeNotSet           // 用户没有设置TouchID
//    LAErrorTouchIDNotAvailable      // 用户设备不支持TouchID
//    LAErrorTouchIDNotEnrolled       // 用户没有设置手指指纹
//    LAErrorTouchIDLockout           // 用户错误次数太多，现在被锁住了
//    LAErrorAppCancel                // 在验证中被其他app中断
//    LAErrorInvalidContext           // 请求验证出错
//} NS_ENUM_AVAILABLE(10_10, 8_0);


- (NSString *)getErrorString:(NSInteger)errorCode
{
    NSString *errorString = nil;
    switch (errorCode) {
        case LAErrorAuthenticationFailed:
            errorString = @"";
            break;
        case LAErrorUserCancel:
            errorString = @"用户取消了验证";
            break;
        case LAErrorUserFallback:
            errorString = @"用户点击了手动输入密码的按钮，所以被取消了";
            break;
        case LAErrorSystemCancel:
            errorString = @"被系统取消，就是说你现在进入别的应用了，不在刚刚那个页面，所以没法验证";
            break;
        case LAErrorPasscodeNotSet:
            errorString = @"用户没有设置TouchID";
            break;
        case LAErrorTouchIDNotAvailable:
            errorString = @"用户设备不支持TouchID";
            break;
        case LAErrorTouchIDNotEnrolled:
            errorString = @"用户没有设置手指指纹";
            break;
        case LAErrorTouchIDLockout:
            errorString = @"用户错误次数太多，现在被锁住了";
            break;
        case LAErrorAppCancel:
            errorString = @"在验证中被其他app中断了";
            break;
        case LAErrorInvalidContext:
            errorString = @"请求验证出错";
            break;

        default:
            errorString = @"密码不正确";
            break;
    }
    return errorString;
}

/**< 主线程刷新UI */
- (void)refreshUI:(NSString *)str message:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
        UIAlertController *alertCtrl =[UIAlertController alertControllerWithTitle:str message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertCtrl animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertCtrl dismissViewControllerAnimated:YES completion:nil];
                if ([str isEqualToString:kVerifySuccess]) {
                    /**< 验证成功 界面消失 */
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            });
        }];
    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
