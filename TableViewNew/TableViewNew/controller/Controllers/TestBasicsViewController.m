
//
//  TestBasicsViewController.m
//  TableViewNew
//
//  Created by HZW on 2018/8/7.
//  Copyright © 2018年 韩志伟. All rights reserved.
//

#import "TestBasicsViewController.h"

#import "FormulaStringCalcUtility.h"

static NSString *tableViewCellID = @"tableViewCellID";

//static NSArray *staticArray = @[@"+",@"-",@"*"];

/**< 测试一些tableView的基础 */
@interface TestBasicsViewController () <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView; /**< tableView */

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray *lastArray; /**< 最终的结果数组 */

@property (nonatomic, strong) NSArray *staticArray;

@end

@implementation TestBasicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 0;
    
    [self.view addSubview:self.mainTableView];
    
    self.staticArray = @[@"+",@"-",@"*"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self configIndex:6 dataArray:[NSMutableArray arrayWithArray:@[@"+",@"-",@"*"]]];
        
        NSLog(@"self.lastArray = %@",self.lastArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            /**< 做一些UI刷新的事儿*/
            NSLog(@"equalTo100Array = %@",[self getEqualTo100Array]);
        });
    });
    
    
//    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view.mas_bottom);
//        make.top.equalTo(self.view.mas_top).offset(kSysStatusBarHeight+kNavToolBarHeight);
//    }];
//
    
//    NSInteger index = 0;
    
    NSArray *array = [NSArray array];
    NSLog(@"%@",array);

    void(^testBlock)() = ^{
        
//        NSLog(@"index = %@",@(index));
        NSArray *array = [NSArray array];
        NSLog(@"%@",array);
    };
    testBlock();
    NSLog(@"[testBlock() class]%@",[testBlock class]);
    
    
    
}



/**
 返回

 @param str 需要拼接的字符(这里就是 +/-/(*))
 @param dataArray 已经拼接好的数组
 @return 新的拼接后的数组
 */
- (NSMutableArray *)configWithString:(NSString *)str dataArray:(NSMutableArray *)dataArray
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSString *name in dataArray) {
        NSString *tempString = [NSString stringWithFormat:@"%@/%@",str,name];
        [resultArray addObject:tempString];
    }
    return resultArray;
}


//- (NSMutableArray *)configIndex:(NSInteger)index head:(NSString *)head dataArray:(NSMutableArray *)dataArray
//{
//    NSMutableArray *resultArray = [NSMutableArray array];
//    if (index >= 0) {
//        NSString *headString = head;
//
//        NSMutableArray *tempArray = [NSMutableArray array];
//        [tempArray addObject:[self configWithString:headString dataArray:dataArray]];
//
//        for (NSMutableArray *array in tempArray) {
//            for (NSInteger i=0; i<array.count; i++) {
//                [resultArray addObject:array[i]];
//            }
//        }
//    }
//    return resultArray;
//}



/**
 用递归获取所有组合方式

 @param index 第几个位置(总共8个位置  我们开始传入6最后一个位置的可能性数组已经确定就是  @[@"+",@"-",@"*"])
 @param dataArray 最终输出所有组合结果
 */
- (void)configIndex:(NSInteger)index dataArray:(NSMutableArray *)dataArray
{
    if (index < 0) {
        return;
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSInteger i=0; i<self.staticArray.count; i++) {
        NSString *tempString = self.staticArray[i];
        [tempArray addObject:[self configWithString:tempString dataArray:dataArray]];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSMutableArray *array in tempArray) {
        for (NSInteger i=0; i<array.count; i++) {
            [result addObject:array[i]];
        }
    }
    self.lastArray = [NSMutableArray arrayWithArray:result];
    
    index--;
    [self configIndex:index dataArray:self.lastArray];
}


- (NSMutableArray *)getEqualTo100Array
{
    /**< 将3^8 符号组合  和  1,2....9 进行组合获取最终的数学表达式 */
    NSMutableArray *array = [NSMutableArray array];
    NSArray *numArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    for (NSInteger i=0; i<self.lastArray.count; i++) {
        NSString *lastString = self.lastArray[i];
        NSArray *lastArray = [lastString componentsSeparatedByString:@"/"];
        NSString *tempString = @"";
        
        for (NSInteger j=0; j<numArray.count; j++) {
            
            if (j<lastArray.count) {
                NSString *nextString = lastArray[j];
                if ([nextString isEqualToString:@"*"]) {
                    nextString = @"";
                }
                tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%@%@",numArray[j],nextString]];
            }else{
                tempString = [tempString stringByAppendingString:numArray[j]];
            }
        }
        [array addObject:tempString];
    }
    
    /**< 计算数学表达式结果是100  将符合条件的数学表达式输出 */
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSInteger i=0; i<array.count; i++) {
        
        NSString *result = [FormulaStringCalcUtility calcComplexFormulaString:array[i]];
        
        if ([result integerValue] == 100) {
            [resultArray addObject:array[i]];
        }
    }
    return resultArray;
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


- (NSMutableArray *)lastArray
{
    if (!_lastArray) {
        _lastArray = [NSMutableArray array];
    }
    return _lastArray;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"currentThreadOne = %@",[NSThread currentThread]);
//        /**< 子线程刷新UI会检测到 */
//        [self.mainTableView reloadData];
//    });
    
//    dispatch_async(dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT), ^{
//        NSLog(@"currentThreadTwo = %@",[NSThread currentThread]);
//        [self.mainTableView reloadData];
//
//    });
    

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



