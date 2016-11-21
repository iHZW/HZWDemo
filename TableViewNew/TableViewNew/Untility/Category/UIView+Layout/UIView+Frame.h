//
//  UIView+Frame.h
//  TZYJ_IPhone
//
//  Created by Weirdln on 15/9/30.
//
//

#import <QuartzCore/QuartzCore.h>

@interface UIView (Frame)

// x,y
- (CGFloat)x;
- (CGFloat)y;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;

// height, width
- (CGFloat)height;
- (CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width;
- (void)heightEqualToView:(UIView *)view;
- (void)widthEqualToView:(UIView *)view;

// bottom,right
- (CGFloat)bottom;
- (CGFloat)right;

// size
- (CGSize)size;
- (void)setSize:(CGSize)size;

// origin
- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;

// center
- (CGFloat)centerX;
- (CGFloat)centerY;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;

- (void)setOriginX:(CGFloat)x;
- (void)setOriginY:(CGFloat)y;

@end
