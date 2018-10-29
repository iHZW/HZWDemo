//
//  PickImageController.m
//  TableViewNew
//
//  Created by HZW on 15/9/6.
//  Copyright (c) 2015年 韩志伟. All rights reserved.
//

#import "PickImageController.h"
#import "HSViewConrtroller.h"
#import "Masonry.h"
#import "UIView+Create.h"
#import "GCDCommon.h"
#import "FlashTagView.h"
#import "CaptchView.h"
#import "MyLabel.h"
#import "YBPopupMenu.h"
#import "TestPopViewXibCell.h"

#define TITLES @[@"修改", @"删除", @"扫一扫",@"付款",@"测试"]
#define ICONS  @[@"motify",@"delete",@"saoyisao",@"pay",@"delete"]
#define kPopBtnSize   CGSizeMake(60, 60)
#define kPopBtnSideSpace    5

//  http://blog.csdn.net/lsy2013/article/details/42965805图片判断类型   pan/  jpg /  jpeg

@interface PickImageController ()<YBPopupMenuDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, assign) NSInteger longPressIndex;

@property (nonatomic, assign) NSInteger tapIndex;

@property (nonatomic, strong) UIImageView *imageView1;

@property (nonatomic, strong) UIView *flashingView; /**< 闪烁view */

@property (nonatomic, strong) UILabel *bgLabel; /**< 变色背景label */

@property (nonatomic, strong) FlashTagView *flashTagView;  /**< 闪烁view */

@property (nonatomic, strong) CaptchView *captchView; /**< 动态验证码 */

@property (nonatomic, strong) MyLabel *myLabel; /**< 置底的label */

@property (nonatomic, strong) UITextField *popTextField;

@property (nonatomic, strong) UIButton *leftTopBtn;

@property (nonatomic, strong) UIButton *rightTopBtn;

@property (nonatomic, strong) UIButton *leftBottomBtn;

@property (nonatomic, strong) UIButton *rightBottomBtn;

@property (nonatomic, strong) YBPopupMenu *testPopupMenu;


@end

@implementation PickImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    self.longPressIndex       = 0;
    self.tapIndex             = 0;
    
//    [self testString];//处理字符串
//    [self testBtn];//添加按钮
    [self testTedtField];//处理字符串
//    [self createTextView];//同上

    [self createButtonFrame];
    
    
    
    UISwitch *mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(100, 200, 0, 0 )];
//    [mySwitch setOn:YES animated:YES];
    [mySwitch addTarget:self action:@selector(switchState:) forControlEvents:UIControlEventTouchUpInside];
    BOOL siwtchState = [[PASCommonUtil getStringWithKey:SwitchStateKey] isEqualToString:kSwitchOpen] ? YES : NO;
    [mySwitch setOn:siwtchState animated:NO];

    [self.view addSubview:mySwitch];

   BOOL boll = [self validateNumber:@"niuniunij"];
    NSLog(@" ******%d",boll);
    
    [self createIndicatorView]; /**< 加载旋转状态视图 */
    [self textFieldTestString]; /**< 字符串处理 */
    [self createUISlider];  /**< 自定义UISlider */
    
    [self createGestureRecognizerTestView]; /**< 手势测试 */

    [self flashTest]; /**< 闪烁测试 */
    
    [self createCaptchView]; /**< 动态验证码 */
    
    [self createSelfhoold]; /**< 置底的label */
    /**< 弹出框popView */
    [self createPopBtn];
}

/**< 弹出框 */
- (void)createPopBtn
{
    [self.view addSubview:self.leftTopBtn];
    [self.view addSubview:self.rightTopBtn];
    [self.view addSubview:self.leftBottomBtn];
    [self.view addSubview:self.rightBottomBtn];
    
    CGSize btnSize = kPopBtnSize;
    [self.leftTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kPopBtnSideSpace);
        make.top.equalTo(self.view.mas_top).offset(70);
        make.size.mas_equalTo(btnSize);
    }];
    
    [self.rightTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-kPopBtnSideSpace);
        make.top.equalTo(self.view.mas_top).offset(70);
        make.size.mas_equalTo(btnSize);
    }];
    
    [self.leftBottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kPopBtnSideSpace);
        make.bottom.equalTo(self.view.mas_bottom).offset(-70);
        make.size.mas_equalTo(btnSize);
    }];
    
    [self.rightBottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-kPopBtnSideSpace);
        make.bottom.equalTo(self.view.mas_bottom).offset(-70);
        make.size.mas_equalTo(btnSize);
    }];
}

- (UIButton *)leftTopBtn
{
    if (!_leftTopBtn) {
        _leftTopBtn = [self getDefaultBtn:0];
    }
    return _leftTopBtn;
}

- (UIButton *)rightTopBtn
{
    if (!_rightTopBtn) {
        _rightTopBtn = [self getDefaultBtn:1];
    }
    return _rightTopBtn;
}

- (UIButton *)leftBottomBtn
{
    if (!_leftBottomBtn) {
        _leftBottomBtn = [self getDefaultBtn:2];
    }
    return _leftBottomBtn;
}

- (UIButton *)rightBottomBtn
{
    if (!_rightBottomBtn) {
        _rightBottomBtn = [self getDefaultBtn:3];
    }
    return _rightBottomBtn;
}

#pragma mark ------------------------------一:popView 依赖点击的View(根据传入的View一自动适配最适合的方向,)------------------------------------
- (UIButton *)getDefaultBtn:(NSInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn addTarget:self action:@selector(clickDefaultBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    return btn;
}

/**< 切换开关状态 */
- (void)switchState:(UISwitch *)sender
{
    if (sender.on) {
        [PASCommonUtil setObject:kSwitchOpen forKey:SwitchStateKey];
    }else{
        [PASCommonUtil setObject:kSwitchClose forKey:SwitchStateKey];
    }
    
#pragma mark ------------------------------二:popView 依赖点击的View------------------------------------
    [YBPopupMenu showRelyOnView:sender titles:@[@"111",@"222",@"333",@"444",@"555",@"666",@"777",@"888"] icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.priorityDirection=  YBPopupMenuArrowDirectionBottom;
        popupMenu.borderWidth = 1;
        popupMenu.borderColor = [UIColor greenColor];
    }];
    
}


- (MyLabel *)myLabel
{
    if (!_myLabel) {
        _myLabel = [[MyLabel alloc] initWithFrame:CGRectZero];
        _myLabel.backgroundColor = [UIColor whiteColor];
        _myLabel.textAlignment = NSTextAlignmentCenter;
        _myLabel.verticalAlignment = VerticalAlignmentBottom;
        _myLabel.text = @"火箭发射";
        _myLabel.font = PASFont(14);
    }
    return _myLabel;
}


- (void)createSelfhoold
{
    [self.view addSubview:self.myLabel];
    [self.myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.captchView.mas_bottom).offset(30);
        make.left.equalTo(self.captchView);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(60);
    }];
    
}



/**< 点击不同位置弹出对应的PodView */
- (void)clickDefaultBtn:(UIButton *)sender
{
    [YBPopupMenu showRelyOnView:sender titles:TITLES icons:ICONS menuWidth:120 delegate:self];
    
    switch (sender.tag) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
            
        default:
            break;
    }
    
}


#pragma mark ------------------------------三:popView 根据手指触摸的位置显示 ------------------------------------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(self.flashingView.frame, point)) {
        [self showCustomPopupMenuWithPoint:point];
    }else
    {
        [self showDarkPopupMenuWithPoint:point];
    }
}


- (void)showCustomPopupMenuWithPoint:(CGPoint)point
{
    [YBPopupMenu showAtPoint:point titles:TITLES icons:nil menuWidth:120 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.dismissOnSelected = YES;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
        popupMenu.type = YBPopupMenuTypeDefault;
        popupMenu.cornerRadius = 20;
        popupMenu.rectCorner = UIRectCornerAllCorners;//UIRectCornerTopLeft| UIRectCornerTopRight;
        popupMenu.tag = 100;
        //如果不加这句默认是 UITableViewCellSeparatorStyleNone 的
//        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    }];
}

- (void)showDarkPopupMenuWithPoint:(CGPoint)point
{
    [YBPopupMenu showAtPoint:point titles:TITLES icons:nil menuWidth:120 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.dismissOnSelected = NO;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
        popupMenu.offset = 10;
        popupMenu.type = YBPopupMenuTypeDark;
        popupMenu.cornerRadius = 8;
        popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }];
}





#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    //推荐回调
    NSLog(@"点击了 %@ 选项",ybPopupMenu.titles[index]);
}

- (void)ybPopupMenuBeganDismiss
{
    if (self.popTextField.isFirstResponder) {
        [self.popTextField resignFirstResponder];
    }
}

- (UITableViewCell *)ybPopupMenu:(YBPopupMenu *)ybPopupMenu cellForRowAtIndex:(NSInteger)index
{
    if (ybPopupMenu.tag != 100) {
        return nil;
    }
    static NSString * identifier = @"TestPopViewXibCell";
    TestPopViewXibCell * cell = [ybPopupMenu.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TestPopViewXibCell" owner:self options:nil] firstObject];
    }
    
    cell.titleLabel.text = TITLES[index];
    cell.iconImageView.image = [UIImage imageNamed:ICONS[index]];
    
    switch (index) {
        case 0:
            cell.statusLabel.hidden = NO;
            cell.badge.hidden = YES;
            break;
        case 2:
            cell.statusLabel.hidden = YES;
            cell.badge.hidden = NO;
            break;
        default:
            cell.statusLabel.hidden = YES;
            cell.badge.hidden = YES;
            break;
    }
    
    cell.lineView.hidden = index == (TITLES.count-1) ? YES : NO;

    return cell;
}







#pragma mark  --------------- captchView  动态验证码---------------------

- (void)createCaptchView
{
    self.captchView = [[CaptchView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.captchView];
    
    [self.captchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(500);
        make.left.mas_equalTo(self.view).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 40));
    }];
    
    @pas_weakify_self
    [self.captchView setClickBlock:^(id capthview) {
        @pas_strongify_self
        [self action_clickValidate];
    }];
}

- (void)action_clickValidate
{
    /**< 在这里编写点击验证码之后需要处理的代码 */
}

#pragma mark  --------------- 闪烁view ---------------------
- (void)flashTest
{
    [self createFlashing]; /**< 添加闪烁view */
    [self createFickerLabel]; /**<  添加闪烁Label*/
    [self createFickerButton]; /**< 闪烁Button */
}

- (CAAnimationGroup *)getCAAnimationGroup
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    animation.values = @[[NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)], [NSValue valueWithCGRect:CGRectMake(0, 0, 15, 15)]];
    animation.keyTimes = @[@(0), @(1)];
    
    CAKeyframeAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacity.values = @[@(1.0),@(0.5),@(1.0)];
    opacity.keyTimes = @[@(0), @(1)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation,opacity];
    group.duration = 1.f;
    group.repeatCount = 0;
    group.removedOnCompletion = NO;
    
    return group;
}

- (void)createFickerButton
{
    /**< 666 */
    UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashBtn setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
    [flashBtn addTarget:self action:@selector(fickerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [flashBtn setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:flashBtn];
    
    [flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(450);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
}

- (void)fickerBtnAction:(UIButton *)sender
{
    CALayer *layer = sender.imageView.layer;
    performBlockDelay(dispatch_get_main_queue(), .3, ^{
        [layer addAnimation:[self getCAAnimationGroup] forKey:nil];
    });
}

- (void)createFlashTagView
{
    self.flashTagView = [[FlashTagView alloc] initWithFrame:CGRectZero];
    self.flashTagView.flashImageName = @"flash";
    [self.view addSubview:self.flashTagView];
}


 /**<  添加闪烁Label*/
- (void)createFickerLabel
{
//    self.bgLabel = [UIView viewForColor:[[UIColor blueColor] colorWithAlphaComponent:0.6] withFrame:CGRectZero];
    self.bgLabel                        = [[UILabel alloc] initWithFrame:CGRectMake(200, 450, 10, 10)];
    self.bgLabel.backgroundColor        = [UIColorFromRGB(0x4bc3ff) colorWithAlphaComponent:0.4];
    self.bgLabel.userInteractionEnabled = YES;
    self.bgLabel.layer.cornerRadius = CGRectGetHeight(self.bgLabel.frame) * 0.5;
    self.bgLabel.clipsToBounds = YES;
    [self.view addSubview:self.bgLabel];
    
//    [self.bgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(450);
//        make.centerX.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(5, 5));
//    }];
//    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgLabelAction:)];
    [self.bgLabel addGestureRecognizer:tap];
    
}

- (void)bgLabelAction:(id)sender
{
//    self.bgLabel.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
//    CAKeyframeAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//    opacity.values = @[@(0.1),@(0.6)];
////    opacity.keyTimes = @[@(0),@(1)];
//    opacity.duration = 1.0f;
//    opacity.repeatCount = 1;
//    opacity.removedOnCompletion = NO;
//    opacity.delegate = self;
//    
//    CALayer *layer = self.bgLabel.layer;
//    
//    performBlockDelay(dispatch_get_main_queue(), .3, ^{  /**< 延迟.3秒执行 */
//        [layer addAnimation:opacity forKey:@""];
//    });
    
//    self.bgLabel.transform              = CGAffineTransformMakeScale(1, 1);
//
//    [UIView animateWithDuration:1 animations:^{
//        self.bgLabel.transform = CGAffineTransformMakeScale(2.2, 2.2);
//    }completion:^(BOOL finished) {
//        self.bgLabel.size = CGSizeMake(10, 10);
//        self.bgLabel.layer.cornerRadius = CGRectGetHeight(self.bgLabel.frame) * 0.5;
//        self.bgLabel.clipsToBounds = YES;
//    }];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:3.0];
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fillMode = kCAFillModeRemoved;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.duration = 0.75;
    
    [self.bgLabel.layer addAnimation:scaleAnimation forKey:nil];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.bgLabel.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
    
}
/**< 添加闪烁view */
- (void)createFlashing
{
     self.flashingView = [UIView viewForColor:[UIColor blueColor] withFrame:CGRectZero];
    [self.view addSubview:self.flashingView];
    
    [self.flashingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(15);
        make.top.mas_equalTo(330);
        make.height.mas_equalTo(50);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction)];
    [self.flashingView addGestureRecognizer:tap];
    
//    self.imageView1 = [UIImageView imageViewForImage:[UIImage imageNamed:@"flash"] withFrame:CGRectZero];
//    [view addSubview:self.imageView1];
//    
//    [self.imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view.mas_left).offset(15);
//        make.top.mas_equalTo(10);
//        make.size.mas_equalTo(CGSizeMake(5, 5));
//    }];
//    
//    UIImageView * imageView2 = [UIImageView imageViewForImage:[UIImage imageNamed:@"flash"] withFrame:CGRectZero];
//    [view addSubview:imageView2];
//    
//    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.imageView1);
//        make.size.mas_equalTo(CGSizeMake(5, 5));
//    }];
    
    self.flashTagView = [[FlashTagView alloc] initWithFrame:CGRectMake(15, 10, 5, 5)];
    self.flashTagView.flashImageName = @"flash";
    [self.flashingView addSubview:self.flashTagView];
    
//    [self.flashTagView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view.mas_left).offset(15);
//        make.top.mas_equalTo(10);
//        make.size.mas_equalTo(CGSizeMake(5, 5));
//    }];
    
}

- (void)tapViewAction
{
    [self.flashTagView startFlashTagView];
    self.flashTagView.centerX += 2;
    self.flashTagView.centerY += 1;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    animation.values = @[[NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)], [NSValue valueWithCGRect:CGRectMake(0, 0, 15, 15)]];
    animation.keyTimes = @[@(0), @(1)];
    
    CAKeyframeAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacity.values = @[@(1.0),@(0.5),@(1.0)];
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

#pragma mark  --------------- 手势测试 ---------------------
- (void)createGestureRecognizerTestView
{
    UIView *guestureView = [UIView viewForColor:UIColorFromRGB(0xe2233e) withFrame:CGRectZero];
    [self.view addSubview:guestureView];
    
    [guestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(280);
        make.left.right.equalTo(self.view).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    /**< 点击 */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [guestureView addGestureRecognizer:tap];
    
    /**< 长按 */
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 1;
    longPress.numberOfTouchesRequired = 1;
    [guestureView addGestureRecognizer:longPress];

    /**< 轻扫 (方向左)*/
    UISwipeGestureRecognizer *swipeGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeActionLeft:)];
    swipeGest.direction = UISwipeGestureRecognizerDirectionLeft;
    [guestureView addGestureRecognizer:swipeGest];
    
}

/**< 向左滑动触发事件 */
- (void)swipeActionLeft:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        self.view.backgroundColor = [UIColor blueColor];
    }
}

/**< 轻按触发事件 */
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    UIColor *armColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:arc4random()%256/255.0];
    self.view.backgroundColor = armColor;
    NSLog(@"%ld",(long)self.tapIndex);
    self.tapIndex += 1;
}

/**< 长按触发事件 */
- (void)longPressAction:(UILongPressGestureRecognizer *)sender
{
    /**< 在干吗? */
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:arc4random()%256/255.0];
        NSLog(@"%ld",self.longPressIndex);
        self.longPressIndex += 1;
    }
}


#pragma mark   -- 自定义UISlider
- (void)createUISlider
{
//    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectZero];
//    [self.view addSubview:slider];
    
    UIImage *stetchLeftTrack  = [UIImage imageNamed:@"list_ico_"];
    UIImage *stetchRightTrack = [UIImage imageNamed:@"list_ico_d_"];

    //滑块图片
    UIImage *thumbImage       = [UIImage imageNamed:@"1.1"];

    //创建slider
    UISlider *slider          = [[UISlider alloc] initWithFrame:CGRectZero];
    slider.backgroundColor    = [UIColor clearColor];
    slider.value              = 1.0;
    slider.minimumValue       = 0.5;
    slider.maximumValue       = 1.0;
    
    //设置轨道的图片
    [slider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [slider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    
    //设置滑块的图片
    [slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [slider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    [slider setValue:0.5 animated:YES];
    
    //滑动滑块添加事件
    //滑动过程中不断触发事件
    [slider addTarget:self action:@selector(onThumb:) forControlEvents:UIControlEventValueChanged];
    //滑动完成添加事件
    //滑动完成后触发事件
    [slider addTarget:self action:@selector(endThumb:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:slider];
    
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(250);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    
    
}

- (void)onThumb:(UISlider *)slider
{
    
}

- (void)endThumb:(UISlider *)slider
{
    
}



#pragma mark  -- 创建indicatorView   加载旋转状态视图
- (void)createIndicatorView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [btn setFrame:CGRectMake(50, 150, 100, 40)];
    [btn setTitle:@"保存!!!" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.left.mas_equalTo(50);
        make.top.mas_equalTo(150);
    }];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [indicatorView startAnimating]; // 开始旋转
    indicatorView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:indicatorView];
    
    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn.mas_left);
        make.top.equalTo(btn.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}

#pragma mark  ------------- 字符串处理 ---------------------
/**< 字符串处理 */
- (void)textFieldTestString
{
    NSString *newString = @"15290400128?niubi";
    NSRange rgn = [newString rangeOfString:@"?"];
    if (rgn.location != NSNotFound) {
        newString = [newString substringToIndex:rgn.location];
    }
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectZero];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textColor = [UIColor redColor];
    textField.text = newString;
    textField.delegate = self;
    self.popTextField = textField;
    [self.view addSubview:self.popTextField];
    
    [self.popTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(400);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(35);
    }];
}


- (void)createButtonFrame
{
    UIView *testView = [[UIView alloc]initWithFrame:CGRectMake(200, 150, 80, 60)];
    testView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:testView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(-30, 5, 50, 50);
    [btn addTarget:self action:@selector(clickShareBtn) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [testView addSubview:btn];
}

- (void)clickShareBtn
{
    NSLog(@"分享");
}

//过滤数字;(判断字符串是否是数字)
- (BOOL)validateNumber:(NSString *) textString
{
    NSString* number=@"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

//- (void)viewWillAppear:(BOOL)animated{
//    
//    // Called when the view is about to made visible. Default does nothing
//    [super viewWillAppear:animated];
//    
//    //去除导航栏下方的横线
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nil"]
//                       forBarPosition:UIBarPositionBottom
//                           barMetrics:UIBarMetricsDefault];
//    
//}

- (void)clickBtn:(id)sender
{
//    UIColor *color = [UIColor redColor];
    //赋值
//    self.block([UIColor blueColor]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"niuniu" object:nil];

    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.block != nil) {
        self.block([UIColor redColor]);
    }
}



- (void)createTextView
{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(50, 100, 300, 100)];
    [textView setEditable:NO];
    textView.backgroundColor = [UIColor lightGrayColor];
    NSString *str = @"niuniansdivoinao aada";
    NSString *strs = nil;
//    strs = [str capitalizedString];/**< 字符串首字母大写 */
    strs = [str lowercaseString];/**< 将字符串中所有的的大写字母转换为小写 */
    strs = [str uppercaseString];/**< 将字符串中所有的的小写字母转换为大写 */
    NSString *string1 = @"niuniunihaihaoma";
    NSString*string2 = @"niuNiunihaihaoma";
    NSComparisonResult result1 = [string1 compare:string2];/**< 区分大小写比较结果 */ //大 返回1，相等返回0， 小于返回-1
    NSComparisonResult result2 = [string1 caseInsensitiveCompare:string2];/**< 不区分大小写比较大小 */
    
    BOOL ret = [str hasPrefix:@"niu"];/**< 判断字符串是否包含头字符串 */
    BOOL ret2 = [str hasSuffix:@"aada"];/**< 判断字符串书否包含尾字符串 */
    char a = [str characterAtIndex:0];//下标位置处的字符
    NSRange range = {2,[str length]-2-1};// 结构体初始化，其中第一个2指的是起始位置，后一个是长度
    NSString *tetString = [str substringWithRange:range];
    NSRange range1 = [str rangeOfString:@"divo"];/**< 查找字符串是否包含字符串 */
    if (range1.location != NSNotFound) {//判断不等于NSNotFound
    NSLog(@"***%lu\n***%ld",(unsigned long)range1.location,range1.length);//location:起始位置,
    }
    
    textView.text = tetString;
    NSLog(@"******\n%ld\n%ld\n%d\n%d\n%c",result1,result2,ret,ret2,a);//打印显示结果
    [self.view addSubview:textView];
}



#pragma mark   -- 修改textField 的 placeholder 的颜色
- (void)testTedtField
{
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(50, 100, 200, 50)];
    textField.placeholder = @"您好:";
    /**
     *  修改textField 的 placeholder 的颜色
     */
    [textField setValue:[UIColor blueColor] forKeyPath:@"_placeholderLabel.textColor"];
    NSMutableString *string = [NSMutableString stringWithFormat:@"23456"];
    textField.text = [self clipString:string];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing; /**< 清除按钮 */
    textField.borderStyle = UITextBorderStyleRoundedRect; /**< 边框样式 */
    textField.clearsOnBeginEditing = YES;  /**< 开始编辑清空textField内容 */
    [self.view addSubview:textField];
}

//处理字符串
- (NSString *)clipString:(NSMutableString *)str
{
    NSInteger count1 = [str length];
    NSInteger count2 = 6 - count1;
    NSMutableString *mutableString = [NSMutableString string];
    for (NSInteger i=0; i< count2; i++) {
        //拼接在后边(可变字符串)
        [mutableString appendFormat:@"0"];
    }
//    在某个小标位置添加某个字符串;
    [str insertString:mutableString atIndex:0];
    [str insertString:@":" atIndex:2];
    NSString *backTime = [str substringToIndex:5];/**< 获取指定长度的字符串，是从头开始截取到5下标的内容 */
//    NSLog(@"%@",[str substringFromIndex:n]);//从指定位置开始向后截取字符串，一直到结束
//    NSRange range = {4,4};//结构体初始化，其中第一个4指的位置，后一个是长度
    
    return backTime;
}


//测试用的Button
- (void)testBtn
{
    UIButton *btn1 = [self createBtnFrame:CGRectMake(100, 100, 50, 50) title:nil titleColor:[UIColor redColor] setBackgroundImage:[UIImage imageNamed:@"1.1"]];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [self createBtnFrame:CGRectMake(100, 160, 100, 100) title:nil titleColor:[UIColor redColor] setBackgroundImage:[UIImage imageNamed:@"1.11"]];
    [self.view addSubview:btn2];
}


- (UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor setBackgroundImage:(UIImage *)backGroungImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
//    [btn setBackgroundImage:backGroungImage forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setImage:backGroungImage forState:UIControlStateNormal];
    
    return btn;
}



- (void)testString
{
    //处理字符串
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(50, 100, 200, 45)];
    [textField setEnabled:NO];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.placeholder = [PickImageController shareInstance].string;
    textField.backgroundColor = [UIColor clearColor];
    textField.borderStyle = UITextBorderStyleNone;
    textField.textColor = [UIColor whiteColor];
//    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    textField.keyboardType = UIKeyboardTypeNamePhonePad;
//    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0 , 0,10, 10)];
    label.text = @"+";
    label.textColor = [UIColor redColor];
    textField.leftView = label;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
#pragma mark  改变边框颜色,
    /*
     _answerTextView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 10.0, 300.0, 390.0)];
     
     [_answerTextView setEditable:NO];
     
     _answerTextView.layer.backgroundColor = [[UIColor clearColor] CGColor];
     
     _answerTextView.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]CGColor];
     
     _answerTextView.layer.borderWidth = 3.0;
     
     _answerTextView.layer.cornerRadius = 8.0f;
     
     [_answerTextView.layer setMasksToBounds:YES];
     */
    
    
#pragma mark   再次编辑清空输入文字
    textField.clearsOnBeginEditing = YES;//再次编辑清空输入文字;
    /**
     *  设置输入框为密码格式显示"*";
     */
    //    textField.secureTextEntry = YES;
    textField.placeholder = [HSViewConrtroller shareInstance].passName;
    
    [PickImageController shareInstance].string = @"你好吗?";
    
    [self.view addSubview:textField];
    
    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 200, 200, 100)];
    [self.view addSubview:testLabel];
    //    NSArray *arrayT = @[@"wode",@"nide",@"tade"];
    //    NSMutableArray *array = [NSMutableArray arrayWithArray:arrayT];
    NSString *string = @"78902";
    NSMutableString *testString = [NSMutableString stringWithFormat:@"%@",string];
    //    for (NSString *str in array) {
    ////        if ([array lastObject]) {
    ////            [testString appendFormat:@"%@",str];
    ////            testLabel.text = testString;
    ////        }//else {
    ////            [testString appendFormat:@"%@,",str];
    ////            testLabel.text = testString;
    ////        }
    //        [testString appendFormat:@"%@,",str];
    ////        if ([array lastObject]) {
    ////            [testString appendFormat:@"%@",str];
    //////            testLabel.text = testString;
    ////        }
    //    }
    
    if ([testString length] == 5) {
        //在指定位置添加某个字符或者字符串;
        [testString insertString:@"0" atIndex:0];
    }
    NSString *testNewString = [testString substringToIndex:4];//从头到结束位置(index下标)
   // testNewString = [testString substringFromIndex:1];//从第几个开始(index下标)
    NSLog(@"********%@",testNewString);
    //    NSString *stringNew = [testString substringToIndex:[testString length]-1];
    testLabel.text = testNewString;

}

+ (PickImageController *)shareInstance
{
    static PickImageController *picker = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        picker = [[PickImageController alloc]init];
    });
    return picker;
}

#pragma mark  -- 滑动隐藏键盘

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.testPopupMenu = [YBPopupMenu showRelyOnView:textField titles:@[@"密码必须为数字、大写字母、小写字母和特殊字符中至少三种的组合，长度不少于8且不大于20"] icons:nil menuWidth:CGRectGetWidth(textField.frame) otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.delegate = self;
        popupMenu.showMaskView = NO;
        popupMenu.isShowShadow = NO;
        popupMenu.dismissOnTouchOutside = YES;
        popupMenu.dismissOnSelected = YES;
        popupMenu.itemHeight = 60;
        popupMenu.fontSize = 12;
        popupMenu.borderWidth = 1;
        popupMenu.borderColor = [UIColor brownColor];
        popupMenu.textColor = [UIColor brownColor];
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionBottom;
        popupMenu.maxVisibleCount = 1;

    }];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.testPopupMenu dismiss];
    return YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
