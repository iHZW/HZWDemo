//
//  ThirdViewController.m
//  TableViewNew
//
//  Created by HZW on 15/11/13.
//  Copyright © 2015年 韩志伟. All rights reserved.
//

#import "ThirdViewController.h"
#import "BookModel.h"
#import "ThirdDetailViewController.h"
#import "ThirdCell.h"


#define WMAIN   [[UIScreen mainScreen] bounds].size.width
#define HMAIN   [[UIScreen mainScreen] bounds].size.height

@interface  ThirdViewController()<UITableViewDataSource,UITableViewDelegate>
{
    // 当前的编辑模式
    UITableViewCellEditingStyle _editingStyle;
    BOOL _isAllSelect;
    NSMutableArray *_selectArr;
}

@property (nonatomic, strong) UITableView *tableView;/**< 表 */
@property (nonatomic, retain) NSMutableArray *data;/**< 数据源 */
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) NSMutableArray *deleteArray;/**< 删除数组 */
@property (nonatomic, strong) UIButton *btnName;

@property (nonatomic, assign) BOOL isOK;


@end

@implementation ThirdViewController
#pragma mark - 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.data = [NSMutableArray array];
    self.deleteArray = [NSMutableArray array];
    _selectArr = [NSMutableArray array];
    
    [self createData];
    
    for (NSInteger i=0; i<_data.count; i++) {
        NSString *s = @"0";
        [_selectArr addObject:s];
    }
    
    NSLog(@"%@",_selectArr);
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WMAIN, HMAIN) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.tableView.tableHeaderView = [self createHeadeView];

    // 设置tableView可不可以选中
    //self.tableView.allowsSelection = NO;
    
    // 允许tableview多选
//    self.tableView.allowsMultipleSelection = YES;
    
    // 编辑模式下是否可以选中
    //self.tableView.allowsSelectionDuringEditing = NO;
    
    // 编辑模式下是否可以多选
    //self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    // 获取被选中的所有行
    // [self.tableView indexPathsForSelectedRows]
    
    // 获取当前可见的行
    // [self.tableView indexPathsForVisibleRows];
}


#pragma mark   -  排序
//  ascending   升\降序   attributesToSortBy  排序字段
+ (NSArray *) MR_sortAscending:(BOOL)ascending attributes:(NSArray *)attributesToSortBy
{
    NSMutableArray *attributes = [NSMutableArray array];
    
    for (NSString *attributeName in attributesToSortBy)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attributeName ascending:ascending];
        [attributes addObject:sortDescriptor];
    }
    
    return attributes;
}



- (void)createData
{
    for (int i = 0; i<20; i++) {
        BookModel *model = [[BookModel alloc]init];
        NSString *textName = [NSString stringWithFormat:@"sds%idd", i];
        model.name = textName;
        NSString *textAge = [NSString stringWithFormat:@"%i",20-i];
        model.age = textAge;
        if (i%2 == 0) {
            model.content = [NSString stringWithFormat:@"dasdasdasdasds%if",i];
        }else{
            model.content = [NSString stringWithFormat:@"亲，欢迎您通%i**%i过以下方式与我们的营销顾问取得联系，交流您再营销推广工作中遇到的问题，营销顾问将免费为您提供咨询服务。",i,i+1];
        }
        [self.data addObject:model];
    }
    NSLog(@"******%@",self.data);
}

- (UIView *)createHeadeView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WMAIN, 100)];
    headView.backgroundColor = [UIColor whiteColor];
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(15, 5, 80, 50);
    [_editBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_editBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _editBtn.backgroundColor = [UIColor grayColor];
    _editBtn.layer.cornerRadius = 10;
    [_editBtn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_editBtn];
    
    _btnName = [self createBtnFrame:CGRectMake(140, 5, 80, 50) title:@"名字" titleColor:[UIColor blueColor] setBackgroundImage:nil btnControlState:UIControlStateNormal];
    [_btnName addTarget:self action:@selector(clickNameBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_btnName];
    
    
    UIButton *btnAge = [self createBtnFrame:CGRectMake(260, 5, 80, 50) title:@"年龄" titleColor:[UIColor blueColor] setBackgroundImage:nil btnControlState:UIControlStateNormal];
    [btnAge addTarget:self action:@selector(clickAgeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:btnAge];
    
    return headView;
}

- (void)clickNameBtn:(UIButton *)sender
{
    UIButton *btn = sender;
    if ([btn.titleLabel.text isEqualToString:@"名字"]) {
        [btn setTitle:@"名字!" forState:UIControlStateNormal];
        [_data sortUsingSelector:@selector(sortNameDescend:)];
    }else if ([btn.titleLabel.text isEqualToString:@"名字!"]){
        [self.btnName setTitle: @"名字~" forState:UIControlStateNormal];
        [_data sortUsingSelector:@selector(sortNameAscend:)];
    }else if ([btn.titleLabel.text isEqualToString:@"名字~"]){
        [btn setTitle:@"名字" forState:UIControlStateNormal];
        [_data sortUsingSelector:@selector(sortNameDescend:)];
    }
    [self.tableView reloadData];
}

- (void)clickAgeBtn:(id)sender
{
    UIButton *btn = sender;
    if ([btn.titleLabel.text isEqualToString:@""]) {
        
    }
}



- (UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor setBackgroundImage:(UIImage *)backGroungImage btnControlState:(UIControlState )btnControlState
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    //    [btn setBackgroundImage:backGroungImage forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setImage:backGroungImage forState:btnControlState];
    
    return btn;
}


- (void)clickEditBtn:(id)sender
{
    NSString *title = self.editBtn.titleLabel.text;
    if ([title isEqualToString:@"删除"]) {
        [self.tableView setEditing:YES];
        [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
        _tableView.allowsSelectionDuringEditing = YES;
//        self.editBtn.titleLabel.text = @"完成";
    }else if ([title isEqualToString:@"完成"]){
        [_data removeObjectsInArray:_deleteArray];/**< 从数据源删除 */
        [_deleteArray removeAllObjects];/**< 清空删除数组 */
        [self.tableView setEditing:NO];
        [self.editBtn setTitle:@"删除" forState:UIControlStateNormal];
        
        for (NSInteger i=[_selectArr count]-1; i>=0 ; i--) {
            if ([_selectArr[i] isEqualToString:@"1"]) {
                [_selectArr removeObjectAtIndex:i];
            }
        }
        NSLog(@"%@",_selectArr);
        [self.tableView reloadData];
        
    }
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.data = nil;
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

#pragma mark - 代理方法
#pragma mark 设置Cell的高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   CGFloat height = [ThirdCell configModel:self.data[indexPath.row]];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellID";
    
    ThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.isAllSelect = _isAllSelect;
    if (cell == nil) {
        cell = [[ThirdCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    BookModel *model = _data[indexPath.row];
    
    [cell configModel:model];
    
    for (NSInteger i=0; i<_selectArr.count; i++) {
        if (indexPath.row == i) {
            if ([_selectArr[i] isEqualToString:@"1"]) {
                cell.leftBtn.backgroundColor = [UIColor yellowColor];
            }else {
                cell.leftBtn.backgroundColor = [UIColor blueColor];
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中效果;
    return cell;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}



//-(void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    if (editing)//编辑状态
//    {
//        if (self.editingStyle == (UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete)){ //编辑多选状态
//            if (![self viewWithTag:TagVale])  //编辑多选状态下添加一个自定义的图片来替代原来系统默认的圆圈，注意这个图片在选中与非选中的时候注意切换图片以模拟系统的那种效果
//            {
//                UIImage* img = [UIImage imageNamed:@"dot.png"];
//                UIImageView* editDotView = [[UIImageView alloc] initWithImage:img];
//                editDotView.tag = TagVale;
//                editDotView.frame = CGRectMake(10,15,20,20);
//                [self addSubView:editDotView];
//                [editDotView release],editDotView = nil;
//            }
//        }
//    }
//    else {
//        //非编辑模式下检查是否有dot图片，有的话删除
//        UIView* editDotView = [self viewWithTag:TagValue];
//        if (editDotView)
//        {
//            [editDotView removeFromSuperview];
//        }
//    }
//}



//默认删除模式
//修改为多选删除状态
- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;//UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        BookModel *model = _data[indexPath.row];
        if (![_deleteArray containsObject:model]) {
            [_deleteArray addObject:model];
            
        }
//        for (NSInteger i=0; i<_data.count; i++) {
//            NSIndexPath *idx = [NSIndexPath indexPathForRow:i inSection:0];
//            ThirdCell *cell = [_tableView cellForRowAtIndexPath:idx];
//            cell.leftBtn.backgroundColor = [UIColor blueColor];
////            _isAllSelect = YES;
//        }
        
//        for (UITableViewCell *cell in [_tableView.subviews[0] subviews]) {
//            if ([cell isKindOfClass:[ThirdCell class]]) {
//                ThirdCell *cell1 = (ThirdCell *)cell;
//                cell1.leftBtn.backgroundColor = [UIColor blueColor];
//                
//                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isSelect"];
//            }
//        }
        ThirdCell *vell = [_tableView cellForRowAtIndexPath:indexPath];
//        NSLog(@"%ld",indexPath.row);
        [_selectArr removeObjectAtIndex:indexPath.row];
        [_selectArr insertObject:@"1" atIndex:indexPath.row];
        vell.leftBtn.backgroundColor = [UIColor yellowColor];
       
    }
    if (!tableView.editing) {
        ThirdDetailViewController *detailCtrl = [[ThirdDetailViewController alloc]init];
        [self.navigationController pushViewController:detailCtrl animated:YES];
    }
    [_tableView reloadData];


}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        BookModel *model = _data[indexPath.row];
        if ([_deleteArray containsObject:model]) {
            [_deleteArray removeObject:model];
        }
    }
}


#pragma mark 只有实现这个方法，编辑模式中才允许移动Cell
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // NSLog(@"from(%i)-to(%i)", sourceIndexPath.row, destinationIndexPath.row);
    // 更换数据的顺序
    [_selectArr exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
