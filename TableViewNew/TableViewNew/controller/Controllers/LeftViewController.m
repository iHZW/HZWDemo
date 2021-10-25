//
//  LeftViewController.m
//  TableViewNew
//
//  Created by HZW on 2018/1/8.
//  Copyright © 2018年 韩志伟. All rights reserved.
//

#import "LeftViewController.h"
#import "DetialViewController.h"

@interface LeftViewController ()
{
    
}

@property (nonatomic, strong) UIButton *testBtn;


@end

@implementation LeftViewController


+ (LeftViewController *)shareInstance
{
    static LeftViewController *leftCtrl = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        leftCtrl = [[LeftViewController alloc] init];
    });
    
    return leftCtrl;
}

//+ (LeftViewController *)shareInstance
//{
//    static LeftViewController *leftCtrl = nil;
//    @synchronized (self) {
         // 这个方法相比较而言效率比较低
//        if (!leftCtrl) {
//            leftCtrl = [[LeftViewController alloc] init];
//        }
//    }
//    return leftCtrl;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect rect = self.view.frame;
    
    switch (_drawerType) {
        case DrawerDefaultLeft:
            [self.view.superview sendSubviewToBack:self.view];
            break;
        case DrawerTypeMaskLeft:
            rect.size.width = CGRectGetWidth(self.view.frame) * 0.75;
            break;
        default:
            break;
    }
    
    self.view.frame = rect;
}


- (void)createUI
{
    self.testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.testBtn setTitle:@"去详情" forState:UIControlStateNormal];
    self.testBtn.backgroundColor = [UIColor grayColor];
    [self.testBtn addTarget:self action:@selector(gotoDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.testBtn];
    [self.testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
}

- (void)gotoDetail
{    
    DetialViewController *ctrl = [[DetialViewController alloc] init];
    [self cw_pushViewController:ctrl];
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
