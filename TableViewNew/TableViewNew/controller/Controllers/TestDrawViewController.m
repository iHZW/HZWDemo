//
//  TestDrawViewController.m
//  TableViewNew
//
//  Created by HZW on 2017/12/20.
//  Copyright © 2017年 韩志伟. All rights reserved.
//

#import "TestDrawViewController.h"
#import "TestDrawView.h"
#import "NewOrderView.h"
#import <objc/runtime.h>


static NSString *titles0[] = {@"one",@"two",@"three",@"four"};
static NSString *titles1[] = {@"A",@"B",@"C",@"D"};

#define kBetweenSpace     10
#define kOrderViewHeight  100

@interface TestDrawViewController ()

@property (nonatomic, strong) TestDrawView *testDrawView; /**< 绘制区间View */

@property (nonatomic, strong) UIScrollView *mainScrollView; /**< 控制主界面的滚动视图 */

@property (nonatomic, strong) NewOrderView *oneOrderView;

@property (nonatomic, strong) NSMutableArray *textArray;


@end

@implementation TestDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self testRunTime];
    
    
    self.title = @"区间统计";
    self.view.backgroundColor = [UIColor grayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadUI];
    
    NSInteger count = dimof(titles0);
    NSLog(@"count=%@",@(count));
//    [self.view addSubview:self.testDrawView];
//    [self.testDrawView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - PASFactor(20), PASFactor(200)));
//    }];
//
    
    // Do any additional setup after loading the view.
}


- (void)testRunTime
{
    /**< 创建新类 objc_allocateClassPair */
    Class newClass = objc_allocateClassPair([UIView class] , "TestNewView" , 0);
    /**< 为新类增加新的方法  class_addMethod */
    class_addMethod(newClass, @selector(loveView), (IMP)loveFunction, 0);
    /**< 为新类添加属性 */
    objc_property_attribute_t type = {"T" , "@\"NSString\""};
    objc_property_attribute_t ownership = {"C" , ""};
        
}

void loveFunction(id self , SEL _cmd)
{
    NSLog(@"输出这个方法");
    NSLog(@"这里输出isa 指针指向的Class 使用%@",object_getClass([NSObject class]));
    NSLog(@"输出这个对象%@",[NSObject class]);
}

- (void)loveView
{
    NSLog(@"测试runtime创建的新类 方法调用");
}


- (void)loadUI
{
    [self.view addSubview:self.mainScrollView];
    
//    [self createTestDrawView];
    [self loadSubViews];
}

- (void)loadSubViews
{
//    self.oneOrderView = [[NewOrderView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.mainScrollView.frame), 100)];
//    self.oneOrderView.nameLabel.text = titles0[0];
//    self.oneOrderView.textView.text = @"asdasdasdasdqeqw1we123412341452431234123qwe12341234";
//    [self.mainScrollView addSubview:self.oneOrderView];
    
    for (NSInteger i=0; i<dimof(titles0); i++) {
        NewOrderView *tempOrderView = [[NewOrderView alloc] initWithFrame:CGRectMake(0, kBetweenSpace+(kOrderViewHeight + kBetweenSpace)*i, CGRectGetWidth(self.mainScrollView.frame), kOrderViewHeight)];
        tempOrderView.nameLabel.text = titles0[i];
        tempOrderView.textView.text = [NSString stringWithFormat:@"就是嗨 == 就你嗨 == %@",titles0[i]];
//        [tempOrderView.clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        tempOrderView.imageUrl = @"http://img5.duitang.com/uploads/item/201206/06/20120606174422_LZSeE.thumb.700_0.jpeg";
        [self.textArray addObject:tempOrderView.textView];
        [self.mainScrollView addSubview:tempOrderView];
    }
    
    [self updateMainScrollViewContentSize];
}

//- (void)clickBtnAction:(UIButton *)sender
//{
//
//}

- (void)updateMainScrollViewContentSize
{
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.width, 1000);
}


- (NSMutableArray *)textArray
{
    if (!_textArray) {
        _textArray = [NSMutableArray array];
    }
    return _textArray;
}

- (void)createTestDrawView
{
    [self.mainScrollView addSubview:self.testDrawView];
    [self.testDrawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.mainScrollView);
        make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - PASFactor(20), PASFactor(200)));
    }];
}



- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kSysStatusBarHeight+kNavToolBarHeight, CGRectGetWidth(self.view.frame), kMainScreenHeight - kSysStatusBarHeight-kNavToolBarHeight)];
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.backgroundColor = [UIColor purpleColor];
    }
    return _mainScrollView;
}

- (TestDrawView *)testDrawView
{
    if (_testDrawView == nil) {
        _testDrawView = [[TestDrawView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth - PASFactor(20), PASFactor(200))];
    }
    return _testDrawView;
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
