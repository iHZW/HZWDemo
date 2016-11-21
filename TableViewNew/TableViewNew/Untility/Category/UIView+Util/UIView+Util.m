//
//  UIView+Util.m
//  PASecuritiesApp
//
//  Created by Weirdln on 16/9/30.
//  Copyright © 2016年 PAS. All rights reserved.
//

#import "UIView+Util.h"

static NSInteger bgImageTag = -11111;

@implementation UIView (PASUtil)

-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    UIImageView *view = (UIImageView *)[self viewWithTag:bgImageTag];
    if (!view) {
        UIImageView *v = [[UIImageView alloc] initWithImage:backgroundImage];
        v.frame = self.bounds;
        v.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        v.tag = bgImageTag;
        [self addSubview:v];
    }else{
        view.frame = self.bounds;
        [view setImage:backgroundImage];
    }
}

-(UIImage *)backgroundImage
{
    return [(UIImageView*)[self viewWithTag:bgImageTag] image];
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}
-(CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}
-(UIColor*)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}
-(void)setBorderColor:(UIColor*)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

-(CGFloat)borderWidth
{
    return self.layer.borderWidth;
}
-(void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

#pragma mark -- Corner

- (void)setCornerRadius:(float)cornerRadius borderWidth:(float)borderWidth borderColor:(UIColor *)borderColor
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth =borderWidth;
    if (borderColor)
    {
        self.layer.borderColor = borderColor.CGColor;
    }
    self.clipsToBounds = YES;
}

- (void)applyRoundedCorners:(UIRectCorner)corners withRadius:(CGFloat)radius
{
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                  byRoundingCorners:corners
                                                        cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
    self.clipsToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
