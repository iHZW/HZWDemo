//
//  TestOrder.m
//  TableViewNew
//
//  Created by HZW on 16/2/22.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "TestOrder.h"
#import "ThirdViewController.h"

@interface TestOrder ()<UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tbView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSIndexPath *selectPath;
@property (nonatomic, strong) CustomButton *stretchBtn;


@end

@implementation TestOrder

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    [self createUI];
    [self createData];
    [self test1];
}

- (void) test1
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict setDictionary:<#(nonnull NSDictionary *)#>
}


- (void)createUI
{
    self.tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WMAIN, HMAIN) style:UITableViewStylePlain];
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    [self.view addSubview:self.tbView];
    
//#ifdef __IPHONE_11_0
//    if ([self.tbView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
//        self.tbView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
//#endif
    
}

- (void)createData
{
    self.dataArray = [NSMutableArray array];
    for (NSInteger i=0; i<20; i++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"%@",@(i)]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectPath.row == indexPath.row && self.selectPath != nil) {
        if (self.isOpen) {
            return 100;
        }
    }
    return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }else{
        for (UIView *v in [cell.contentView subviews]) {
            [v removeFromSuperview];
        }
    }

    cell.textLabel.text = self.dataArray[indexPath.row];
    
    CustomButton *btn = [CustomButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(WMAIN-100, 0, 100, 45);
    [btn setTitle:@"排序" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(orderNew:) forControlEvents:UIControlEventTouchUpInside];
    btn.indexPath = indexPath;
    [cell.contentView addSubview:btn];
    
    self.stretchBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    self.stretchBtn.frame = CGRectMake(WMAIN-200, 0, 100, 45);
    [self.stretchBtn setTitle:@"展开" forState:UIControlStateNormal];
    if (self.selectPath.row == indexPath.row && self.selectPath != nil) {
        self.stretchBtn.selected = self.isOpen;
        [self.stretchBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    [self.stretchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.stretchBtn addTarget:self action:@selector(stretchCell:) forControlEvents:UIControlEventTouchUpInside];
    self.stretchBtn.indexPath = indexPath;
    [cell.contentView addSubview:self.stretchBtn];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThirdViewController *ctrl = [[ThirdViewController alloc]init];
    [self.navigationController pushViewController:ctrl animated:YES];
    

}

- (void)orderNew:(CustomButton *)sender
{
    CustomButton *btn = sender;
    btn.selected = !btn.selected;
    NSArray *newArray ;
    newArray = [(NSArray *)self.dataArray sortedArrayUsingFunction:RowDiffPer_AscSort context:nil];
//    if (btn.selected) {
//       newArray = [(NSArray *)self.dataArray sortedArrayUsingFunction:Row_Sescend context:nil];
//    }else{
//        newArray = [(NSArray *)self.dataArray sortedArrayUsingFunction:RowDiffPer_AscSort context:nil];
//    }
    self.dataArray = [NSMutableArray arrayWithArray:newArray];
    [self.tbView reloadData];
}





- (void)stretchCell:(CustomButton *)sender
{
    NSIndexPath *indexPath = sender.indexPath;
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    if (self.selectPath != nil && self.selectPath.row == indexPath.row) {
        self.isOpen = !self.isOpen;
    }else{
        indexPaths = [NSArray arrayWithObjects:indexPath,self.selectPath, nil];
        self.isOpen = YES;
    }
    self.selectPath = indexPath;
    [self.tbView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    CGSize upSize = CGSizeMake(0, indexPath.row * 45) ;
    CGRect rect = CGRectMake(0, upSize.height, WMAIN, 100);
    [self.tbView scrollRectToVisible:rect animated:YES];

}



NSInteger RowDiffPer_AscSort(id row1, id row2, void *context)
{
    NSInteger  _row1 = [row1 integerValue];
    NSInteger  _row2 = [row2 integerValue];
    
    if (_row2 == 1) {
        _row2 = 999;
    }else if (_row1 == 1)
    {
        _row1 = 999;
    }

   NSInteger result = _row1 > _row2 ? NSOrderedAscending : (_row1 < _row2 ? NSOrderedDescending : NSOrderedSame);
    return result;
}


NSInteger Row_Sescend(id row1, id row2, void *context)
{
    NSString *_row1 = row1;
    NSString *_row2 = row2;
    
//    if ([_row1 isEqualToString:@"we9l"]) {
//        _row1 = @"zzzzzzzzz";
//    }else if ([_row2 isEqualToString:@"we9l"]){
//        _row2 = @"zzzzzzzzz";
//    }
    
    NSInteger teger = [_row1 compare:_row2];
//    if (teger == NSOrderedAscending) {
//        return NSOrderedDescending;
//    }else if (teger == NSOrderedDescending)
//    {
//        return NSOrderedAscending;
//    }else{
//        return NSOrderedSame;
//    }
    return teger;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
