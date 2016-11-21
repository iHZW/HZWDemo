//
//  ClickMoreCell.m
//  TableViewNew
//
//  Created by HZW on 16/1/19.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "ClickMoreCellControl.h"
#import "ClickMoreAndMoreCell.h"
#import "BookModel.h"
#import "CustomButton.h"

@interface ClickMoreCellControl ()<UITableViewDataSource,
UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic, strong) UITableView *tbView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSIndexPath *selectIndex;
@property (nonatomic, assign) BOOL isOpen;


@end

@implementation ClickMoreCellControl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self createData];
    [self createUI];
}


- (void)createData
{
    self.dataArray = [NSMutableArray array];
    for (NSInteger i=0; i<20; i++) {
        BookModel *model = [[BookModel alloc]init];
        model.name = [NSString stringWithFormat:@"第几个%@",@(i)];
        model.age = [NSString stringWithFormat:@"%@岁",@(i)];
        [self.dataArray addObject:model];
    }
}

- (void)createUI
{
    self.tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) style:UITableViewStylePlain];
    self.tbView.backgroundColor = [UIColor clearColor];
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    [self.view addSubview:self.tbView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
    [self.tbView addGestureRecognizer:longPress];

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
    if (indexPath.row == self.selectIndex.row && self.selectIndex != nil ) {
        if (self.isOpen == YES) {
            return 100;
        }else{
            return 45;
        }
    }
    return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CellID";
    ClickMoreAndMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ClickMoreAndMoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    else{
        for (UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
    }
    
    if (indexPath.row == self.selectIndex.row && self.selectIndex != nil) {
        if (self.isOpen == YES) {
            cell.ageLabel.hidden = NO;
        }else{
            cell.ageLabel.hidden = YES;
        }
    }else{
        cell.ageLabel.hidden = YES;
    }
    
    CustomButton *orderBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame = CGRectMake(200, 0, 100, 45);
    [orderBtn setTitle:@"下单" forState:UIControlStateNormal];
    orderBtn.indexPath = indexPath;
    [orderBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(clickOrder:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:orderBtn];
    
    [cell configWithArray:self.dataArray[indexPath.row]];
    
    return cell;
}


#pragma mark  点击下单
- (void)clickOrder:(CustomButton *)sender
{
    NSIndexPath *indexPath = sender.indexPath;
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    if (self.selectIndex.row == indexPath.row && self.selectIndex != nil) {
        self.isOpen = !self.isOpen;
    }else{
        indexPaths = [NSArray arrayWithObjects:indexPath,self.selectIndex, nil];
        self.isOpen = YES;
    }
    self.selectIndex = indexPath;
    [self.tbView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
//    ClickMoreAndMoreCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.selectIndex.row == indexPath.row && self.selectIndex != nil) {
        self.isOpen = !self.isOpen;
//        cell.hidden = !cell.hidden;
    }else{
        indexPaths = [NSArray arrayWithObjects:indexPath,self.selectIndex, nil];
        self.isOpen = YES;
//        cell.hidden = NO;
    }
    
    
    
    self.selectIndex = indexPath;
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
    NSLog(@"点击");
}


- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.tbView];
        NSIndexPath * indexPath = [self.tbView indexPathForRowAtPoint:point];
        NSLog(@"indexPath.row=%@",@(indexPath.row));
        if(indexPath == nil)
            return ;
        
        ClickMoreAndMoreCell *cell = [self.tbView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        
        UIMenuController *menVC = [UIMenuController sharedMenuController];
        if (menVC.menuVisible)
        {
            [menVC setMenuVisible:NO animated:YES];
        }else
        {
            UIMenuItem *item1 = [[UIMenuItem alloc]initWithTitle:@"置顶" action:@selector(clickString1:)];
            UIMenuItem *item2 = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(clickString2:)];
            UIMenuItem *item3 = [[UIMenuItem alloc]initWithTitle:@"修改" action:@selector(clickString3:)];
            UIMenuItem *item4 = [[UIMenuItem alloc]initWithTitle:@"标红" action:@selector(clickString4:)];
            
            menVC.menuItems = @[item1,item2,item3,item4];
    
            [menVC setTargetRect:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height) inView:cell];
            [menVC setMenuVisible:YES animated:YES];
        }

    }
}


- (void) menuWillShow:(NSNotification *)notification
{
//    self.selectionStyle = UITableViewCellSelectionStyleBlue;
//    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(emailableCell:selectCellAtIndexPath:)]) {
//        [self.delegate emailableCell:self selectCellAtIndexPath:self.indexPath];
//    }
//    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuWillHide:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}


- (void) menuWillHide:(NSNotification *)notification
{
//    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(emailableCell:deselectCellAtIndexPath:)]) {
//        [self.delegate emailableCell:self deselectCellAtIndexPath:self.indexPath];
//    }
//    
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}




- (void)clickString1:(UIMenuController *)menuCtrl
{
    NSIndexPath *indexPath = [self.tbView indexPathForSelectedRow];
    NSLog(@"indexPAth==%@",@(indexPath.row));
}

- (void)clickString2:(UIMenuController *)menuCtrl
{
    
}

- (void)clickString3:(UIMenuController *)menuCtrl
{
    
}

- (void)clickString4:(UIMenuController *)menuCtrl
{
    
}

//- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
//{
//    return YES;
//}
//
//
//- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
//{
//    
//}


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
