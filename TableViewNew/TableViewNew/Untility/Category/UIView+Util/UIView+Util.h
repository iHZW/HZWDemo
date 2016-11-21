//
//  UIView+Util.h
//  PASecuritiesApp
//
//  Created by Weirdln on 16/9/30.
//  Copyright © 2016年 PAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PASUtil)

@property(nonatomic,assign) UIImage *backgroundImage;

@property(nonatomic,assign) CGFloat cornerRadius;
@property(nonatomic,assign) UIColor *borderColor;
@property(nonatomic,assign) CGFloat borderWidth;

#pragma mark -- Corner
// 设置圆角和边框
- (void)setCornerRadius:(float)cornerRadius borderWidth:(float)borderWidth borderColor:(UIColor *)borderColor;

// 设置每个角圆角
- (void)applyRoundedCorners:(UIRectCorner)corners withRadius:(CGFloat)radius;

@end
