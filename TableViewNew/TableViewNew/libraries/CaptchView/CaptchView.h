//
//  CaptchView.h
//  PASecuritiesApp
//
//  Created by vince on 2017/10/11.
//  Copyright © 2017年 PAS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(id);

@interface CaptchView : UIView

@property (nonatomic, retain) NSMutableString *changeString;  //验证码的字符串
@property (nonatomic, copy) ClickBlock clickBlock;//点击事件

/**
 * 更新验证码
 */
- (void)action_changeCaptch;
@end
