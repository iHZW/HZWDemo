
//
//  TestBasicsViewController.m
//  TableViewNew
//
//  Created by HZW on 2018/8/7.
//  Copyright © 2018年 韩志伟. All rights reserved.
//

#import "TestBasicsViewController.h"

static NSString *tableViewCellID = @"tableViewCellID";

/**< 测试一些tableView的基础 */
@interface TestBasicsViewController () <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView; /**< tableView */

@property (nonatomic, assign) NSInteger index;


@end

@implementation TestBasicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 0;
    
    [self.view addSubview:self.mainTableView];
    
//    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view.mas_bottom);
//        make.top.equalTo(self.view.mas_top).offset(kSysStatusBarHeight+kNavToolBarHeight);
//    }];
//
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}


- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kSysStatusBarHeight+kNavToolBarHeight, kMainScreenWidth, 600) style:UITableViewStylePlain];
//        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewCellID];
//        _mainTableView.estimatedRowHeight = 100;
//        _mainTableView.estimatedSectionHeaderHeight = 0.01;
//        _mainTableView.estimatedSectionFooterHeight = 0.01;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"调用了%@次",@(self.index));
    self.index++;
//
    NSInteger height = 100;//50 + arc4random()%30;
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID];
    if (cell == nil) {
        
//        self.index++;
//        NSLog(@"调用了%@次",@(self.index));

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"测试%@",@(indexPath.row)];
    return cell;
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



@interface CYLUser ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, assign) CYLUserGender gender;

@end


@implementation CYLUser

- (instancetype)initWithName:(NSString *)name age:(NSUInteger)age gender:(CYLUserGender)gender
{
    if (self = [super init]) {
        _name = [name copy];
        _age = age;
        _gender = gender;
    }
    return self;
}

+ (instancetype)initWithName:(NSString *)name age:(NSUInteger)age gender:(CYLUserGender)gender
{
    CYLUser *user = [[CYLUser alloc] initWithName:name age:age gender:gender];
//    user.name = name;
//    user.age = age;
//    user.gender = gender;
    return user;
}


- (id)copyWithZone:(NSZone *)zone
{
    CYLUser *user = [CYLUser allocWithZone:zone];
    user.name = self.name;
    user.age = self.age;
    user.gender = self.gender;
    return user;
}

@end



