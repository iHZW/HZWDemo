//
//  FlashTagView.m
//  TableViewNew
//
//  Created by HZW on 16/11/28.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "FlashTagView.h"
#import "Masonry.h"

@interface FlashTagView ()

@property (nonatomic, strong) UIImageView *imageView1; /**< 需要改变的imageView */

@property (nonatomic, strong) UIImageView *imageView2; /**< 中心的imageView */

@end

@implementation FlashTagView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageView1 = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.imageView1];
        
        self.imageView2 = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.imageView2];
    }
    return self;
}

- (void)setFlashImageName:(NSString *)flashImageName
{
    _flashImageName = flashImageName;
    [self.imageView1 setImage:[UIImage imageNamed:self.flashImageName]];
    [self.imageView2 setImage:[UIImage imageNamed:self.flashImageName]];
}

- (void)startFlashTagView
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    animation.values = @[[NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)], [NSValue valueWithCGRect:CGRectMake(0, 0, 15, 15)]];
    animation.keyTimes = @[@(0), @(1)];
    
    CAKeyframeAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacity.values = @[@(.6),@(0.3)];
    opacity.keyTimes = @[@(0), @(1)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation,opacity];
    group.duration = 1.f;
    group.repeatCount = 0;
    group.removedOnCompletion = NO;
    
    CALayer *layer = self.imageView1.layer;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [layer addAnimation:group forKey:@""];
    });
}

@end
