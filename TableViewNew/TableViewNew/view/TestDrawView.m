//
//  TestDrawView.m
//  TableViewNew
//
//  Created by HZW on 2017/12/20.
//  Copyright © 2017年 韩志伟. All rights reserved.
//

#import "TestDrawView.h"

#define kImageViewWidth    PASFactor(30)
#define kCloseBtnWidth     PASFactor(25)

@interface TestDrawView()

@property (nonatomic, strong) UIView *mainView; /**< 移动展示的View */

@property (nonatomic, strong) UIImageView *leftImageView; /**< 左侧图片 */

@property (nonatomic, strong) UIImageView *rightImageView; /**< 右侧图片 */

@property (nonatomic, strong) UIButton *closeBtn; /**< 关闭按钮 */

@property (nonatomic, assign) BOOL isCanMove; /**< 判断可以移动 */

@property (nonatomic, assign) BOOL isLeftMove; /**< 判断是做移动 */

@property (nonatomic, assign) CGFloat itemWidth; /**< 移动的最小间距 */


@end

@implementation TestDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.itemWidth = 5.;
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    self.mainView = [UIView viewForColor:[UIColor blueColor] withFrame:CGRectMake(30, -1, 50, self.height+2)];
    self.mainView.layer.borderWidth = 1;
    self.mainView.layer.borderColor = [UIColor redColor].CGColor;
    [self addSubview:self.mainView];
    
    self.leftImageView = [UIImageView imageViewForImage:[UIImage imageNamed:@"market_sectionview_drag"] withFrame:CGRectMake(CGRectGetMinX(self.mainView.frame) - kImageViewWidth/2, CGRectGetMidY(self.mainView.frame), kImageViewWidth, kImageViewWidth)];
    self.leftImageView.backgroundColor = [UIColor grayColor];
    self.leftImageView.userInteractionEnabled = YES;
    self.leftImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.leftImageView];
    
    self.rightImageView = [UIImageView imageViewForImage:[UIImage imageNamed:@"market_sectionview_drag"] withFrame:CGRectMake(CGRectGetMaxX(self.mainView.frame) - kImageViewWidth/2, CGRectGetMidY(self.mainView.frame), kImageViewWidth, kImageViewWidth)];
    self.rightImageView.userInteractionEnabled = YES;
    self.rightImageView.backgroundColor = [UIColor grayColor];
    self.rightImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.rightImageView];
    
    self.closeBtn = [UIButton buttonWithFrame:CGRectZero target:self action:@selector(clickCloseBtn) bgImage:[UIImage imageNamed:@"market_sectionview_close"] tag:00130 block:nil];
    self.closeBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:self.closeBtn];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mainView);
        make.size.mas_equalTo(CGSizeMake(kCloseBtnWidth, kCloseBtnWidth));
        make.top.equalTo(self);
    }];
}

/**< 关闭 */
- (void)clickCloseBtn
{
    if ([self superview]) {
        [self removeFromSuperview];
    }
}


#pragma mark  --左移
- (void)moveLeftWithPoint:(CGPoint)point
{
    CGFloat maxX = CGRectGetMaxX(self.mainView.frame);
    CGFloat minX = point.x;
    CGFloat midY = point.y;
    if (minX + self.itemWidth > maxX) {
        minX = maxX - self.itemWidth;
    }
    if (midY < self.leftImageView.height/2) {
        midY = self.leftImageView.height/2;
    }
    if (midY > self.mainView.height - self.leftImageView.height/2) {
        midY = self.mainView.height - self.leftImageView.height/2;
    }
    minX = MAX(.0, minX);
    self.mainView.frame = CGRectMake(minX, -1, maxX - minX, self.height+2);
    self.leftImageView.center = CGPointMake(minX, midY);
    
}

#pragma mark  --右移
- (void)moveRightWithPoint:(CGPoint)point
{
    CGFloat minX = CGRectGetMinX(self.mainView.frame);
    CGFloat maxX = point.x;
    CGFloat midY = point.y;
    
    if (minX + self.itemWidth > maxX) {
        maxX = minX + self.itemWidth;
    }
//    else if (maxX > CGRectGetMaxX(self.frame)){
//        maxX = CGRectGetMaxX(self.frame);
//    }
    
    if (midY < self.rightImageView.height/2) {
        midY = self.rightImageView.height/2;
    }
    
    if (midY > self.mainView.height - self.rightImageView.height/2) {
        midY = self.mainView.height - self.rightImageView.height/2;
    }
    
    maxX = MIN(CGRectGetWidth(self.frame), maxX);
    
    self.mainView.frame  =CGRectMake(minX, -1, maxX - minX, self.height + 2);
    self.rightImageView.center = CGPointMake(maxX, midY);
}

- (BOOL)canResetTagViewWithLeftPoint:(CGPoint)point {
    if (self.mainView.width > self.itemWidth || point.x + self.itemWidth < CGRectGetMaxX(self.mainView.frame)) {
        return YES;
    }
    return NO;
}

- (BOOL)canResetTagViewWithRightPoint:(CGPoint)point {
    if (self.mainView.width > self.itemWidth || point.x - self.itemWidth > CGRectGetMinX(self.mainView.frame)) {
        return YES;
    }
    return NO;
}

#pragma mark   delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGRect leftR = CGRectMake(self.leftImageView.frame.origin.x-10, self.leftImageView.frame.origin.y-10, self.leftImageView.frame.size.width+10, self.leftImageView.frame.size.height+20);
    CGRect rightR = CGRectMake(self.rightImageView.frame.origin.x, self.rightImageView.frame.origin.y-10, self.rightImageView.frame.size.width+10, self.rightImageView.frame.size.height+20);
    /**< 判断可移动 点击到左右按钮才可以滑动 */
    if (CGRectContainsPoint(leftR, point) || CGRectContainsPoint(rightR, point)) {
        self.isCanMove = YES;
        self.isLeftMove = CGRectContainsPoint(leftR, point);
    } else {
        self.isCanMove = NO;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (self.isCanMove)
    {
        if (self.isLeftMove){
            if ([self canResetTagViewWithLeftPoint:point]) {
                [self moveLeftWithPoint:point];

            }
        }else{
            if ([self canResetTagViewWithRightPoint:point]) {
                [self moveRightWithPoint:point];
                
            }
        }
    }
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
