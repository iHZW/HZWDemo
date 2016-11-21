//
//  GYZSheetView.m
//  GYZCustomActionSheet
//  
//  Created by GYZ on 16/6/20.
//  Copyright © 2016年 GYZ. All rights reserved.
//

#import "GYZSheetView.h"
#import "GYZSheetCell.h"
#import "GYZCommon.h"

#define GYZSHEETCELL @"GYZSheetCell"

@implementation GYZSheetView

// 代码创建输入框视图
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        
        self.divLine = [[UIView alloc]init];
        self.divLine.backgroundColor = kGrayLineColor;
        [self addSubview:self.divLine];
        
        self.tableView = [[UITableView alloc]init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.tableView.tableFooterView = [self createFootView];
        self.tableView.tableFooterView.hidden = YES;
        [self addSubview:self.tableView];
        
        [self.tableView registerClass:[GYZSheetCell class] forCellReuseIdentifier:GYZSHEETCELL];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.divLine.frame = CGRectMake(0, 0, self.frame.size.width, kLineHeight);
    self.tableView.frame = CGRectMake(0, MaxY(self.divLine), WIDTH(self), HEIGHT(self));
}


- (UIView *)createFootView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 50)];
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    createBtn.frame = CGRectMake(10, 0, 100, 50);
    [createBtn setTitle:@"新建分组" forState:UIControlStateNormal];
    [createBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [createBtn addTarget:self.delegate action:@selector(sheetViewSelectFootView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:createBtn];
    return view;
}


- (void)sheetViewSelectFootView
{
    if ([self.delegate respondsToSelector:@selector(sheetViewSelectFootView)]) {
        [self.delegate  sheetViewSelectFootView];
    }
}


#pragma mark - UITableView数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYZSheetCell *cell= [tableView dequeueReusableCellWithIdentifier:GYZSHEETCELL forIndexPath:indexPath];
    
    if (self.showFootView) {
        self.tableView.tableFooterView.hidden = NO;
    }
    if (_cellTextColor) {
        cell.myLabel.textColor = _cellTextColor;
    }
    cell.myLabel.text = _dataSource[indexPath.row];
    
    if (_cellTextFont) {
        cell.myLabel.font = _cellTextFont;
    }
    
    if (_cellTextStyle == NSTextStyleLeft) {
        cell.myLabel.textAlignment = NSTextAlignmentLeft;
    } else if (_cellTextStyle == NSTextStyleRight){
        cell.myLabel.textAlignment = NSTextAlignmentRight;
    } else {
        cell.myLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    if (_showTableDivLine) {
        cell.tableDivLine.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger index = indexPath.row;
    GYZSheetCell *cell = (GYZSheetCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *cellTitle = cell.myLabel.text;
    
    if ([self.delegate respondsToSelector:@selector(sheetViewDidSelectIndex:selectTitle:)]) {
        [self.delegate sheetViewDidSelectIndex:index selectTitle:cellTitle];
    }
}


@end
