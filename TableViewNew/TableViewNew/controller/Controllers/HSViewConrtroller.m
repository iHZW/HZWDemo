//
//  HSViewConrtroller.m
//  TableViewNew
//
//  Created by HZW on 15/9/6.
//  Copyright (c) 2015年 韩志伟. All rights reserved.
//

#import "HSViewConrtroller.h"
#import "BookModel.h"
#import "BookCell.h"
#import "PickImageController.h"
#import "MyImagePickerController.h"
#import "DetialViewController.h"
#import "ThirdViewController.h"
#import "UIAlertViewController.h"
#import "ClickMoreCellControl.h"
#import "TestOrder.h"
#import "TestWebView.h"
#import "GifTestViewController.h"
#import "MyInformationCollectionViewController.h"
#import "WaterFallCollectionViewController.h"
#import "WaterFallViewController_2.h"
#import "URLHTTP.h"
#import "GYZActionSheet.h"
#import "IndexTopItem.h"
#import "XDGestureConfigVC.h"
#import "ThirdDetailViewController.h"
#import "ViewController.h"
#import "TestDrawViewController.h"
#import "UIViewController+TestCategary.h"
#import "LeftViewController.h"
#import "TestBasicsViewController.h"
#import "ZWWeakObject.h"
#import "NSTimer+Util.h"


#define WMAIN   [[UIScreen mainScreen] bounds].size.width
#define HMAIN   [[UIScreen mainScreen] bounds].size.height


#define RemindString    @"niuniu"

#define kNotificationKeyName   @"keyName"

/**< 枚举类型的两种写法 */
typedef enum {
    BuyType,
    SaleType
}QuickSaleType;

typedef NS_ENUM(NSInteger ,QuickSaleTyped){
    BuyTyped,
    SaleTyped
};


@interface HSViewConrtroller ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
    UITableView *_tbView;
    NSMutableArray *_dataArray;
    UIImageView *_imageView;//图片
}
@property (nonatomic,strong) UIScrollView *headerScrollView;

@property (nonatomic, strong) NSTimer *zwTimer;

@property (nonatomic, strong) UIImageView *imageView;

/**
 1:UIActionSheetDelegate  相机代理
 2:UIImagePickerControllerDelegate 相册代理
 */

/**< 
 初始化NSIndexPath
 NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:4];
 */


/** 
 新工程需要改文件
 Build Settings——>搜索 bitcode ——>设置 Enable Bitcode = NO 
 */


/*
 获取当前时间(格式化后的)
 + (NSString*)stringToday{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	return [dateFormatter stringFromDate:[NSDate date]];
 }
 **/



@end

@implementation HSViewConrtroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self cw_registerShowIntractiveWithEdgeGesture];
    /**< 判断打开了验证指纹识别功能  进入指纹识别界面 */
    NSString *switchName = [PASCommonUtil getStringWithKey:SwitchStateKey];
    if ([switchName isEqualToString:kSwitchOpen]) {
        ViewController *ctrl = [[ViewController alloc] init];
        [self presentViewController:ctrl animated:YES completion:nil];
    }
    
    [self createNav];

    // Do any additional setup after loading the view.
//    self.automaticallyAdjustsScrollViewInsets = NO;
//
//    [self createPlainData];
//    [self createPlainUI];
//    self.title = @"无敌666";
    [self createGroupData];
    [self createGroupTableView];
    [HSViewConrtroller shareInstance].passName = @"无敌666";
//
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyShowRefreshInfo:) name:RemindString object:nil];

    /**< 防止循环引用使用中间件 ZWWeakObject */
    [self testWeakTimer];
}


- (void)testWeakTimer
{
    ZWWeakObject *weakObject = [ZWWeakObject proxyWithWeakObjec:self];
    self.zwTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:weakObject selector:@selector(refreshData:) userInfo:nil repeats:YES];
}

- (void)refreshData:(NSTimer *)sender
{
    NSLog(@"11111");
}

/**< 创建导航 */
- (void)createNav
{
   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(leftClick)];
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 3)];
//    [btn setTitle:@"左侧抽屉" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    [self.navigationItem setLeftBarButtonItem:barItem];
}

/**< 注册手势 */
- (void)cw_registerShowIntractiveWithEdgeGesture
{
    // 注册手势驱动
    __weak typeof(self)weakSelf = self;
    [self cw_registerShowIntractiveWithEdgeGesture:NO transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        //NSLog(@"direction = %ld", direction);
        if (direction == CWDrawerTransitionDirectionLeft) { // 左侧滑出
            [weakSelf leftClick];
        } else if (direction == CWDrawerTransitionDirectionRight) { // 右侧滑出
            [weakSelf rightClick];
        }
    }];
}

- (void)leftClick
{
    [self testViewCategary:@"💯"];
    // 自己随心所欲创建的一个控制器
    LeftViewController *vc = [[LeftViewController alloc] init];
    
    // 这个代码与框架无关，与demo相关，因为有兄弟在侧滑出来的界面，使用present到另一个界面返回的时候会有异常，这里提供各个场景的解决方式，需要在侧滑的界面present的同学可以借鉴一下！处理方式在leftViewController的viewDidAppear:方法内
    vc.drawerType = DrawerDefaultLeft;
    
    // 调用这个方法
    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:nil];
}


- (void)rightClick
{
    
}


- (void)notifyShowRefreshInfo:(NSNotificationCenter *)notificationCenter
{
    NSLog(@"牛逼");

}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];  /**< 移除通知 */
}

#pragma -- 计算字符串的长度
//CGSize size = [@"这个是测试字段” sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f],NSStrokeColorAttributeName: [UIColor greenColor], NSForegroundColorAttributeName:[UIColor greenColor]}];
//               CGSize statuseStrSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
//               NSLog(@"%@",NSStringFromCGSize(statuseStrSize));

#pragma mark  -- UIPickerView   修改显示文字
//6.0
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
//
//          forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel* pickerLabel = (UILabel*)view;
//    if (!pickerLabel){
//        pickerLabel = [[UILabel alloc] init];
//        // Setup label properties - frame, font, colors etc
//        //adjustsFontSizeToFitWidth property to YES
//        pickerLabel.adjustsFontSizeToFitWidth = YES;
//        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
//        [pickerLabel setBackgroundColor:[UIColor clearColor]];
//        [pickerLabel setFont:PASFacFont(20)];
//    }
//    // Fill the label text here
//    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
//    return pickerLabel;
//    
//}


#pragma mark  cell显示不全  调用系统的方法
/**<     
 cell在屏幕中显示不完成
 
 [self.mainTableView scrollRectToVisible:rect animated:YES];
 
 传去点击cell的CGRect就可以显示完整的cell;
 */



#pragma mark  时间格式化
/**<     
 NSDate *currentDate = [NSDate date];//获取当前时间，日期
 格式化的时间
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
 self.endString = [dateFormatter stringFromDate:currentDate];
 NSLog(@"dateString:%@",self.endString);
 
 NSTimeInterval timeStamp= [currentDate timeIntervalSince1970];(UTC时间 秒)
 self.endString  = [NSString stringWithFormat:@"%f",timeStamp]; 
 */


#pragma mark   - 修改webView字体大小
/*
[_webVie stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '50%'"];//修改百分比即可
 **/


#pragma mark   - 多次调用发送请求处理思路(避免快速点击发送请求)
/*
 - (void)sendSearchDelay:(NSString*)text
 {
     countReq ++;
     NSInteger nowIndex = countReq;

 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     if (nowIndex == countReq) {
         [self requestSearchData:text];
     }else{
          NSLog(@"sendSearchDelay cut %d,%d",(int)nowIndex,(int)countReq);
     }
 });
 }
 **/



#pragma mark  - textField   中文输入法处理高亮状态文字不发送请求
//// 搜索框值发生变化
//- (void)textFieldChanged: (id)sender
//{
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
//    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
//        UITextRange *selectedRange = [_textField markedTextRange];
//        //获取高亮部分
//        UITextPosition *position = [_textField positionFromPosition:selectedRange.start offset:0];
//        
//        if (!position) { // 没有高亮选择的字，则发送请求
//            [self performSelector:@selector(sendDetailRequestAfterDelay) withObject:self afterDelay:0.3]; //300毫秒
//            NSLog(@"没有高亮选择的字");
//        }else { // 有高亮选择的字符串，不发送请求
//            NSLog(@"有高亮选择的字");
//            
//        }
//    }else{
//        /**< 发送请求 */
//        [self performSelector:@selector(sendDetailRequestAfterDelay) withObject:self afterDelay:0.3]; //300毫秒
//    }
//}



#pragma mark    字典转换为字符串   NSDictionary  转换为  NSString
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}



#pragma mark   -- 字符串转换为字典   NSString  转换为  NSDictionary
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


#pragma mark   -- 通知
- (void)nsnotificationcenter
{
    /**< 添加监听 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:kNotificationKeyName object:nil];
    
}
/**< 响应事件 */
- (void)notification:(NSNotification *)notification
{
    /**< 接收信息 */
    NSString *string = notification.object;
    NSLog(@"%@",string);
}

- (void)dealloc
{
    /**< 移除通知 */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationKeyName object:nil];
}

/**< 发送通知 */
- (void)postNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyName object:@"牛逼" userInfo:nil];
}



- (void)createPlainData
{
    _dataArray = [NSMutableArray array];
    for (NSInteger i=0; i<20; i++) {
        BookModel *model = [[BookModel alloc]init];
        model.name = [NSString stringWithFormat:@"第%ld个人",i];
        model.age = [NSString stringWithFormat:@"%ld岁",i+1];
        [_dataArray addObject:model];
    }
    
}


+ (HSViewConrtroller *)shareInstance
{
    static HSViewConrtroller *ctrl = nil;
    static dispatch_once_t onceTocen;
    dispatch_once(&onceTocen, ^{
        if (ctrl) {
            ctrl = [[HSViewConrtroller alloc]init];
        }
    });
    return ctrl;
}


#pragma mark   actionSheetView调用方法
/**
 *  actionSheetView
 *
 *  @param 调用方法
 */
- (void)loadPopSheetWith
{
    NSArray *titleArray = @[@"1",@"2",@"3"];
    /**<
     ///默认样式
     GYZSheetStyleDefault = 0,
     ///像微信样式
     GYZSheetStyleWeiChat,
     ///TableView样式(无取消按钮)
     GYZSheetStyleTable,
     */
    GYZActionSheet *actionSheet = [[GYZActionSheet alloc] initSheetWithTitle:nil style:GYZSheetStyleTable itemTitles:titleArray];
    actionSheet.cellTextStyle = NSTextStyleCenter;
    actionSheet.itemTextColor = [UIColor blackColor];
    actionSheet.showFootView = YES;
    actionSheet.spaceHeight = 1;
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
//        if([PASManagerSelfStock isIncludeAllGroupsWithCodeInfo:codeInfo withGroupName:title]){
//            [[HsViewController sharedManager] displayStockDetailNotification:[NSString stringWithFormat:@"已加入 %@ 中",title]];
//        }else{
//            [PASManagerSelfStock addWithGroupName:title codeInfo:codeInfo block:^(BOOL isSuccess) {
//                if (isSuccess)
//                {
//                    [[HsViewController sharedManager] displayStockDetailNotification:[NSString stringWithFormat:@"%@ 添加到 %@ 分组成功", [codeInfo getCode],title]];
//                }else
//                {
//                    [[HsViewController sharedManager] displayStockDetailNotification:kRemindString];
//                }
//            }];
//        }
    }];
    
    [actionSheet didFinishSelectLastLine:^{
//        NSString *pageName = @"selfstockgroup";
//        [[HsViewController sharedManager] addNormalPage:pageName];
    }];
}




- (void)createPlainUI
{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,[[UIScreen mainScreen] bounds].size.width , [[UIScreen mainScreen] bounds].size.height-64) style:UITableViewStylePlain];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.backgroundColor = [UIColor clearColor];
    _tbView.estimatedRowHeight = 0;
    _tbView.estimatedSectionHeaderHeight = 0;
    _tbView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tbView];
    
    //让adjustContentInset值不受SafeAreaInset值的影响。
#ifdef __IPHONE_11_0
    if ([_tbView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            _tbView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
#endif

    _tbView.scrollsToTop = YES;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(_tbView.frame.size.width-40, _tbView.frame.size.height-40, 30, 30);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    btn.layer.cornerRadius = 5;
    btn.alpha = 0.6;
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}


#pragma mark  点击Top滚动到顶部
- (void)clickBtn
{
    _tbView.scrollsToTop = YES;
//    [_tbView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];/**< 点击按钮使tableView滑动到顶部; */
    [_tbView setContentOffset:CGPointZero animated:YES];/**< 点击按钮使tableView滑动到顶部; */
    
}

- (void)createGroupData
{
    _dataArray = [NSMutableArray array];
    
    for (NSInteger i=0; i<8; i++) {
        NSMutableArray *sectionArray = [NSMutableArray array];
        for (NSInteger j=0; j<5; j++) {
            BookModel *model = [[BookModel alloc]init];
            model.name = [NSString stringWithFormat:@"第%ld组",i];
            model.age = [NSString stringWithFormat:@"第%ld个",j];
            [sectionArray addObject:model];
        }
        [_dataArray  addObject:sectionArray];
    }
}

- (UIView *)getIndexItemView
{
    IndexTopItem *topItem = [[IndexTopItem alloc] initWithFrame:CGRectMake(0, 0, WMAIN, 200) dataArray:[NSMutableArray arrayWithArray:@[@"1",@"2"]]];
    
    return topItem;
}



- (UIView *)getHeadView
{
    UIView *temp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WMAIN, 200)];
    
    _headerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WMAIN, 200)];
    UIImageView *img = [[UIImageView alloc] initWithFrame:self.headerScrollView.frame];
    img.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    img.contentMode = UIViewContentModeScaleAspectFill;//拉伸的样式
    img.image = [UIImage imageNamed:@"00.jpg"];
    [_headerScrollView addSubview:img];
    [temp addSubview:_headerScrollView];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 10, 80, 80)];
    _imageView.layer.borderWidth = 2;
    _imageView.layer.borderColor = [UIColor yellowColor].CGColor;
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.layer.cornerRadius = 40;
    _imageView.clipsToBounds = YES;
    [temp addSubview:_imageView];
    return temp;
    
}

#pragma mark  拉伸效果

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tbView) {
        [self layoutHeaderScrollerViewForOffset:scrollView.contentOffset];
    }
}

- (void)layoutHeaderScrollerViewForOffset:(CGPoint)offset
{
    if (offset.y > 0) {
//        return;
    }else{
        CGFloat delta = 0.0f;
        CGRect headerFrame ;
        headerFrame = CGRectMake(0, 0, WMAIN, 200);
        CGRect rect = headerFrame;
        delta = fabs(MIN(0.0f, offset.y));
        rect.origin.y -= delta;
//        rect.origin.x -= delta;
        rect.size.height += delta;
//        rect.size.width += delta;

        self.headerScrollView.frame = rect;
    }
    
}


- (void)createGroupTableView
{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + (IS_IPHONE_X ? 20 : 0), WMAIN, HMAIN-20) style:UITableViewStylePlain];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉分割线
    _tbView.backgroundColor = [UIColor whiteColor];
    _tbView.estimatedRowHeight = 0;
    _tbView.estimatedSectionHeaderHeight = 0;
    _tbView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tbView];
//    _tbView.tableHeaderView = [self getHeadView];
    _tbView.tableHeaderView = [self getIndexItemView];
    
#ifdef __IPHONE_11_0
    if ([_tbView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            _tbView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
#endif
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(WMAIN-50, HMAIN-50, 30, 30);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    btn.layer.cornerRadius = 15;
    btn.alpha = 0.6;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"Top" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

#pragma mark  --  /**< 判断某一视图是不是另一个视图的子视图 */
- (BOOL)isSubView
{
    BOOL isSubView = [_tbView isDescendantOfView:self.view];
    NSLog(@"isSubView = %d",isSubView);
    return isSubView;
}




#pragma mark -  UITableView代理

//返回多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

//返回多少行//每一组返回多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = _dataArray[section];
    return array.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
//返回每个Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
//{
//    return 60;
//}


//显示Cell上的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellId = @"CellId";
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (nil == cell) {
        cell = [[BookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    [cell.rightBtn addTarget:self action:@selector(clickAddAction:) forControlEvents:UIControlEventTouchUpInside];
//    else
//    {
//        for (UIView *v in [cell.contentView subviews]) {
//            [v removeFromSuperview];
//        }
//    }
    
    NSArray *sectionArray = _dataArray[indexPath.section];
    BookModel *model = sectionArray[indexPath.row];
    /**< 设置cell的样式 */
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell configModel:model];
    return cell;
}

/**< actionSheet  弹出样式 */
- (void)clickAddAction:(UIButton *)sender
{
    [self loadPopSheetWith];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tbView deselectRowAtIndexPath:indexPath animated:NO];
    
    /**< 点击cell暂停定时器 */
    if (self.zwTimer) {
        [self.zwTimer util_suspend];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RemindString object:nil];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
                [self selectImage];
    }else if(indexPath.section == 0 && indexPath.row == 1)
    {
#pragma mark  Block调用
        PickImageController *ctrl = [[PickImageController alloc]init];
        @pas_weakify_self
        ctrl.block = ^(UIColor * color){
            @pas_strongify_self
            self.imageView.backgroundColor = color;
        };
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 2)
    {
        DetialViewController *ctrl = [[DetialViewController alloc]init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 3)
    {
        ThirdViewController *ctrl = [[ThirdViewController alloc]init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 4)
    {
        UIAlertViewController *alert = [[UIAlertViewController alloc]init];
        [self.navigationController pushViewController:alert animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        ClickMoreCellControl *moreCtrl = [[ClickMoreCellControl alloc]init];
        [self.navigationController pushViewController:moreCtrl animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 1)
    {
        TestOrder *orderCtrl = [[TestOrder alloc]init];
        [self.navigationController pushViewController:orderCtrl animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 2)
    {
        TestWebView *webCtrl = [[TestWebView alloc]init];
        [self.navigationController pushViewController:webCtrl animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 3)
    {
        GifTestViewController *gifCtrl = [[GifTestViewController alloc]init];
        [self.navigationController pushViewController:gifCtrl animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 4)
    {
        MyInformationCollectionViewController *collectView = [[MyInformationCollectionViewController alloc]init];
        [self.navigationController pushViewController:collectView animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 0)
    {
        WaterFallCollectionViewController *ctrl = [[WaterFallCollectionViewController alloc]init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 1)
    {
        WaterFallViewController_2 *ctrl = [[WaterFallViewController_2 alloc]init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 2)
    {
        URLHTTP *http = [[URLHTTP alloc]init];
        [self.navigationController pushViewController:http animated:YES];
        
    }else if (indexPath.section == 2 && indexPath.row == 3)
    {
        /**< 手势密码界面 */
        XDGestureConfigVC *ctrl = [[XDGestureConfigVC alloc] init];
        
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 4)
    {
        TestDrawViewController *ctrl = [[TestDrawViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if (indexPath.section == 3 && indexPath.row == 0)
    {
        TestBasicsViewController *basics = [[TestBasicsViewController alloc] init];
        [self.navigationController pushViewController:basics animated:YES];
    }
    else
    {
        ThirdDetailViewController *detailCtrl = [[ThirdDetailViewController alloc]init];
        [self.navigationController pushViewController:detailCtrl animated:YES];
    }
    
}


#pragma mark -  选择图片(相机/相册)

- (void)selectImage
{
    UIActionSheet *sheet ;
    /**
     *  判断相册还是拍照
     */
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    
    [sheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 2:
                    // 取消

                    return;
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:RemindString object:nil];

                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}



/**
 *  裁剪图片
 *
 *  @param image 传入图盘
 *  @param size  传入图片大小
 *
 *  @return 返回裁剪后的图片    ****方法一:
 */
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}


//裁剪图片的第二种方法;
- (UIImage *)croppedImage:(UIImage *)image
{
    if (image) {
    CGRect rectMax = CGRectMake(0, 0, 200, 200);
    CGImageRef subImageRdf = CGImageCreateWithImageInRect(image.CGImage, rectMax);
    UIGraphicsBeginImageContext(rectMax.size);
    CGContextRef subContextRef = UIGraphicsGetCurrentContext();
    CGContextDrawImage(subContextRef, rectMax, subImageRdf);
    UIImage *imageNew = [UIImage imageWithCGImage:subImageRdf];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRdf);
    return imageNew;
    }
    return nil;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    UIImage *imageNew = [self scaleImage:image toSize:CGSizeMake(200,200)];
    [self saveImage:imageNew withName:@"currentImage.png"];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
//    isFullScreen = NO;
    [_imageView setImage:savedImage];
    _imageView.tag = 100;
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSLog(@"*******++++++%@",currentImage);
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.05);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /**< 唤醒定时器 */
    if (self.zwTimer) {
        [self.zwTimer util_resume];
    }

    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    NSData * imageData = [NSData dataWithContentsOfFile:fullPath];
    _imageView.image = [UIImage imageWithData:imageData];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.zwTimer) {
        [self.zwTimer util_suspend];
    }
}


//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//
//    isFullScreen = !isFullScreen;
//    UITouch *touch = [touches anyObject];
//    
//    CGPoint touchPoint = [touch locationInView:self.view];
//    
//    CGPoint imagePoint = self.imageView.frame.origin;
//    //touchPoint.x ，touchPoint.y 就是触点的坐标
//    
//    // 触点在imageView内，点击imageView时 放大,再次点击时缩小
//    if(imagePoint.x <= touchPoint.x && imagePoint.x +self.imageView.frame.size.width >=touchPoint.x && imagePoint.y <=  touchPoint.y && imagePoint.y+self.imageView.frame.size.height >= touchPoint.y)
//    {
//        // 设置图片放大动画
//        [UIView beginAnimations:nil context:nil];
//        // 动画时间
//        [UIView setAnimationDuration:1];
//        
//        if (isFullScreen) {
//            // 放大尺寸
//            
//            self.imageView.frame = CGRectMake(0, 0, 320, 480);
//        }
//        else {
//            // 缩小尺寸
//            self.imageView.frame = CGRectMake(50, 65, 90, 115);
//        }
//        
//        // commit动画
//        [UIView commitAnimations];
//        
//    }
//    
//}





- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    //section的header的背景视图
//    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WMAIN, 40)];
//    headerImageView.image = [UIImage imageNamed:@"header"];
//    
//    //创建标签，显示是在第几组
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 120, 40)];
//    label.text = [NSString stringWithFormat:@"第%ld组",section];
//    [headerImageView addSubview:label];
//    return headerImageView;
//    return nil;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WMAIN, 20)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    return view;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WMAIN, 40)];
//    headerImageView.image = [UIImage imageNamed:@"header"];
//    
//    //创建标签，显示是在第几组
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 120, 60)];
//    label.text = [NSString stringWithFormat:@"第%ld组",section];
//    [headerImageView addSubview:label];
//    return headerImageView;
//    return nil;
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, -0.5, WMAIN, 1)];
    view.backgroundColor = [UIColor blackColor];
    
    return view;

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
