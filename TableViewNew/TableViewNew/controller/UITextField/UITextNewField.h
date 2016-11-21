//
//  UITextNewField.h
//  TableViewNew
//
//  Created by HZW on 15/11/20.
//  Copyright © 2015年 韩志伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextNewField : UITextField


- (CGRect)textRectForBounds;//重写来重置文字区域

- (void)drawTextInRect;  //改变绘文字属性.重写时调用super可以按默认图形属性绘制,若自己完全重写绘制函数，就不用调用super了.

- (void)placeholderRectForBounds;//重写来重置占位符区域

- (void)drawPlaceholderInRect;//重写改变绘制占位符属性.重写时调用super可以按默认图形属性绘制,若自己完全重写绘制函数，就不用调用super了

- (CGRect)borderRectForBounds;//重写来重置边缘区域

- (CGRect)editingRectForBounds;//重写来重置编辑区域

- (CGRect)clearButtonRectForBounds;//重写来重置clearButton位置,改变size可能导致button的图片失真

- (void)leftViewRectForBounds;

- (void)rightViewRectForBounds;


//– ()textRectForBounds:　　    //重写来重置文字区域
//– drawTextInRect:　　       //改变绘文字属性.重写时调用super可以按默认图形属性绘制,若自己完全重写绘制函数，就不用调用super了.
//– placeholderRectForBounds:　　//重写来重置占位符区域
//– drawPlaceholderInRect:　　//重写改变绘制占位符属性.重写时调用super可以按默认图形属性绘制,若自己完全重写绘制函数，就不用调用super了
//– borderRectForBounds:　　//重写来重置边缘区域
//– editingRectForBounds:　　//重写来重置编辑区域
//– clearButtonRectForBounds:　　//重写来重置clearButton位置,改变size可能导致button的图片失真
//– leftViewRectForBounds:
//– rightViewRectForBounds:


@end
