//
//  UIImage+Addition.h
//  JCYProduct
//
//  Created by Howard on 15/10/24.
//  Copyright © 2015年 Howard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

+ (UIImage*)imageWithPointNum:(NSInteger)num radius:(CGFloat)radius space:(CGFloat)space color:(UIColor*)color;

//截屏view
+ (UIImage *)screenShotsImageInView:(UIView *)view size:(CGSize)size;

//压缩图片
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
@end
