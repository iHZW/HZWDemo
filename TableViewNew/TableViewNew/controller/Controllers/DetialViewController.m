//
//  DetialViewController.m
//  TableViewNew
//
//  Created by HZW on 15/11/11.
//  Copyright © 2015年 韩志伟. All rights reserved.
//

#import "DetialViewController.h"


#define WMAIN   [[UIScreen mainScreen] bounds].size.width
#define HMAIN   [[UIScreen mainScreen] bounds].size.height

@interface DetialViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
    UITableView *_tbView;
    NSInteger _selection;
    
}

@end

@implementation DetialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    _selection = -1;
    [self createData];
    [self createTableView];
}

- (void)createTableView
{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WMAIN, HMAIN) style:UITableViewStylePlain];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.showsHorizontalScrollIndicator = NO;
    _tbView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tbView];
    
}

- (void)createData
{
    _dataArray = [NSMutableArray array];
    for (NSInteger i=0; i<10; i++) {
        NSMutableArray *sectionArray = [NSMutableArray array];
        for (NSInteger i=0; i<3; i++) {
            NSString *str = [NSString stringWithFormat:@"第%ld个",i];
            [sectionArray addObject:str];
        }
        [_dataArray addObject:sectionArray];
    }
}



//返回多少组;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, HMAIN-64, WMAIN, 30)];
    label.text = @"此账号为:niuniu";
    label.textAlignment  =NSTextAlignmentCenter;
    _tbView.tableFooterView = label;
    
    return [_dataArray count];
}
//每组返回多少个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == _selection) {
        NSArray *sectionArray = _dataArray[section];
        return [sectionArray count];
    }else{
        return 0;
    }
    
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor clearColor];
    NSArray *sectionArray = _dataArray[indexPath.section];
    cell.textLabel.text = sectionArray[indexPath.row];
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WMAIN, 30)];
    view.backgroundColor = [UIColor grayColor];
    UITapGestureRecognizer *h = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    view.tag = 100+section;
    [view addGestureRecognizer:h];
    view.userInteractionEnabled = YES;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 200, 25)];
    label.text = [NSString stringWithFormat:@"第%ld组",section];
    [view addSubview:label];
    return view;
}

- (void)tapAction:(UIGestureRecognizer *)g
{
    UIView *view = (UIView *)g.view;
    NSInteger section = view.tag - 100;
    NSLog(@"**** %ld",section);
        if (section == _selection) {
            //选中的组
            _selection = -1;
            [_tbView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            //未选中的组
            _selection = section;
            [_tbView reloadData];
        }
}


- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return YES;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    
    NSLog(@"longPress");
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
