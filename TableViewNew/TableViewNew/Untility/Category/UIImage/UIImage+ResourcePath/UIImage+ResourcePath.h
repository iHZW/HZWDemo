//
//  UIImage+ResourcePath.h
//  LXIphone
//
//  Copyright (c) 2012年 xzq2325. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResourcePath)

+ (UIImage*)imageWithResourcePathofFile:(NSString*)path;

//适配iphone5的图片test.png 自动寻图test-568h.png
+ (UIImage *)adaptedimage:(NSString *)name;


+ (UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color;
//绘制纯色图片
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)imageCutImageInView:(UIView *)view frame:(CGRect)frame;
+ (NSString *)pathCutImageInView:(UIView *)view frame:(CGRect)frame;

/**
 *  返回三角形
 *
 *  @param fillColor   中间填充色
 *  @param pathColor   边框颜色
 *  @param orientation 直角的指向
 *  @param size        size
 *
 *  @return 图片
 */
+ (UIImage *)createTriangleImageWithfillColor:(UIColor *)fillColor
                                    pathColor:(UIColor *)pathColor
                                  orientation:(UIInterfaceOrientation)orientation
                                         size:(CGSize)size;

+ (UIImage *)image3xWithNamed:(NSString *)name bundle:(NSBundle *)bundle;

+ (UIImage *)image3xWithNamed:(NSString *)name;

+ (UIImage *)scaleImageNamed:(NSString *)name scale:(CGFloat)factor bundle:(NSBundle *)bundle;

+ (UIImage *)scaleImageNamed:(NSString *)name scale:(CGFloat)factor;

@end
