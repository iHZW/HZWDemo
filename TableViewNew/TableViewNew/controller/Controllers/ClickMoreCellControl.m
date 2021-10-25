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
#import <objc/runtime.h>

static NSString *kCellID = @"CellID";
//#define kCellID   @"kCellId"

@interface ClickMoreCellControl ()<UITableViewDataSource,
UITableViewDelegate>
{
//    UITableView *_tableView;
}
@property (nonatomic, strong) UITableView *tbView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSIndexPath *selectIndex;
@property (nonatomic, assign) BOOL isOpen;


@end

@implementation ClickMoreCellControl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.selectIndex = nil;
    [self createData];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    
}

/**< 完全pop成功后回调方法
 
 这个方法可以监听右滑返回
 */

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    if (!parent) {
        NSLog(@"pop success");
        
        [self testMethod];
    }
}

- (void)testMethod
{
    /**< runtime  存储一个值
     objc_setAssociatedObject(id _Nonnull object, const void * _Nonnull key,
     id _Nullable value, objc_AssociationPolicy policy);
     
     (id _Nonnull object,  值需要存在那个对象里
     const void * _Nonnull key, 保存值的Key
     id _Nullable value, 需要保存的值
     objc_AssociationPolicy policy 变量的属性  OBJC_ASSOCIATION_RETAIN_NONATOMIC
     )
     */
    objc_setAssociatedObject(self, @"mySelf", self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    /**<
     objc_getAssociatedObject(id _Nonnull object, const void * _Nonnull key)
     
     (id _Nonnull object,  从哪个对象获取值
     const void * _Nonnull key  获取值的Key
     )
     */
    
    UIViewController *controller = objc_getAssociatedObject(self, @"mySelf");
    objc_removeAssociatedObjects(controller);
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
    self.tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    self.tbView.backgroundColor = [UIColor clearColor];
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    
//    self.tbView.estimatedSectionFooterHeight = 0;
//    self.tbView.estimatedSectionHeaderHeight = 0;
//    self.tbView.estimatedRowHeight = 0;
    [self.view addSubview:self.tbView];
    [self.tbView registerClass:[ClickMoreAndMoreCell class] forCellReuseIdentifier:kCellID];
    
//#ifdef __IPHONE_11_0
//    if ([self.tbView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
//        self.tbView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
//#endif
    

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
    CGFloat height = 45;
    if (indexPath.row == self.selectIndex.row && self.selectIndex != nil ) {

//        ClickMoreAndMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
//
//        height = [cell getCellHeight];
        if (self.isOpen == YES) {
            return 80;
        }else{
            return 45;
        }
//        BookModel *model = self.dataArray[indexPath.row];
//        if (model.cellHeight) {
//            height = model.cellHeight;
//        }
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ClickMoreAndMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    cell.isSelect = self.selectIndex && self.selectIndex.row == indexPath.row ? YES : NO ;
    
    
//    cell.orderBtn.indexPath = indexPath;
//    [cell.orderBtn addTarget:self action:@selector(clickOrder:) forControlEvents:UIControlEventTouchUpInside];

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
        self.selectIndex = nil;
    }else{
        indexPaths = [NSArray arrayWithObjects:indexPath,self.selectIndex, nil];
        self.isOpen = YES;
        self.selectIndex = indexPath;
    }
//    [self.tbView reloadData];
    [self.tbView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];

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
