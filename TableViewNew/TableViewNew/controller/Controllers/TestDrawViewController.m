//
//  TestDrawViewController.m
//  TableViewNew
//
//  Created by HZW on 2017/12/20.
//  Copyright © 2017年 韩志伟. All rights reserved.
//

#import "TestDrawViewController.h"
#import "TestDrawView.h"

@interface TestDrawViewController ()

@property (nonatomic, strong) TestDrawView *testDrawView; /**< 绘制区间View */

@end

@implementation TestDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    
    [self.view addSubview:self.testDrawView];
    [self.testDrawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - PASFactor(20), PASFactor(200)));
    }];
    
    
    // Do any additional setup after loading the view.
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
