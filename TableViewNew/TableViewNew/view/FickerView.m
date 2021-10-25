//
//  FickerView.m
//  TableViewNew
//
//  Created by HZW on 16/11/23.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "FickerView.h"
#import "Masonry.h"


@interface FickerView()

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;

@end

@implementation FickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView1 = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.imageView1];
        
        self.imageView2 = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.imageView2];
    }
    
    return self;
}

- (void)setImageName:(NSString *)imageName
{
    [self.imageView1 setImage:[UIImage imageNamed:imageName]];
    [self.imageView2 setImage:[UIImage imageNamed:imageName]];
}


- (void)createImage2
{
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:imageView2];
    
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageView1);
        make.size.equalTo(self.imageView1);
    }];
}

- (void)startFlashing
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    animation.values = @[[NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)], [NSValue valueWithCGRect:CGRectMake(0, 0, 15, 15)], [NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)]];
    animation.keyTimes = @[@(0), @(1), @(1)];

    CAKeyframeAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacity.values = @[@1.0,@0.5,@1.0];
    opacity.keyTimes = @[@(0), @(1), @(1)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation,opacity];
    group.duration = 1.f;
    group.repeatCount = 1;
    group.removedOnCompletion = NO;
    
    CALayer *layer = self.imageView1.layer;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [layer addAnimation:group forKey:@""];
    });
}



@end
