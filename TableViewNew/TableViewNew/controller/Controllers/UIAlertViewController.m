//
//  UIAlertViewController.m
//  TableViewNew
//
//  Created by HZW on 15/12/16.
//  Copyright © 2015年 韩志伟. All rights reserved.
//

#import "UIAlertViewController.h"
#import "SJAvatarBrowser.h"
#import "UIRemindView.h"

@interface UIAlertViewController ()
{
    NSTimer *_timer;
    UIRemindView *_bgView;
    BOOL  end;
}
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIRemindView *bgView;



@end

@implementation UIAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createImageUI];
    
//    [self createSegmentUI];
    
    [self newUISegment];
    
    
//    [NSThread detachNewThreadSelector:@selector(runOnNewThread) toTarget:self withObject:nil];
//    while (!end) {
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    }
    
}

- (void)createImageUI
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 80 + (IS_IPHONE_X ? 20 : 0), 100, 20);
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(clickCome:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake( 50, 150, 100, 100)];
    self.imageView.image = [UIImage imageNamed:@"1.11"];
    self.imageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.imageView];
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
}

/*
 UISegmentedControl *segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(80.0f, 8.0f, 200.0f, 30.0f) ];
 [segmentedControl insertSegmentWithTitle:@"Food to eat" atIndex:0 animated:YES];
 [segmentedControl insertSegmentWithTitle:@"Food to avoid" atIndex:1 animated:YES];
 segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
 segmentedControl.momentary = YES;
 segmentedControl.multipleTouchEnabled=NO;
 [segmentedControl addTarget:self action:@selector(Selectbutton:) forControlEvents:UIControlEventValueChanged];
 UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];  //自定义UIBarButtonItem，封装定义好的UIsegmented。
 [segmentedControl release];
 self.navigationItem.rightBarButtonItem = segButton;  //添加到导航栏中
 [segButton release];
 
 NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],UITextAttributeTextColor,  [UIFont fontWithName:Helvetica size:16.f],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
 [segmentedControl setTitleTextAttributes:dic forState:UIControlStateSelected];
 
 */

- (void)createSegmentUI
{
    UISegmentedControl *segMentCtrl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(100, 400, 200, 30)];
    [segMentCtrl insertSegmentWithTitle:@"first" atIndex:0 animated:YES];
    [segMentCtrl insertSegmentWithTitle:@"second" atIndex:1 animated:YES];
    segMentCtrl.momentary = YES;
    segMentCtrl.multipleTouchEnabled = NO;
    [segMentCtrl addTarget:self action:@selector(selectSegment:) forControlEvents:UIControlEventValueChanged];
    

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],UITextAttributeTextColor,  [UIFont systemFontOfSize:20],UITextAttributeFont ,[UIColor grayColor],UITextAttributeTextShadowColor ,nil];
    
    [segMentCtrl setTitleTextAttributes:dic forState:UIControlStateSelected];
    
    [self.view addSubview:segMentCtrl];
   
}

 - (void)newUISegment
 {
     [super viewDidLoad];
     UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"温度",@"风力", nil]];
     UIImage *segmentSelected = [UIImage imageNamed:@"list_ico"];
//     [[UIImage imageNamed:@"00.jpg"]
//     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
     //为了改变字的位置 更居中一点
     UIImage *segmentUnselected = [UIImage imageNamed:@"list_ico_d"];
//     [[UIImage imageNamed:@"1.1"]
//     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
     
     UIImage *segmentSelectedUnselected =
     [UIImage imageNamed:@"1.11"];
     UIImage *segUnselectedSelected =
     [UIImage imageNamed:@"list_ico"];
     UIImage *segmentUnselectedUnselected =
     [UIImage imageNamed:@"list_ico_d"];
     
     [sc setBackgroundImage:segmentUnselected
     forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
     [sc setBackgroundImage:segmentSelected
     forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
     
//     [sc setDividerImage:segmentUnselectedUnselected
//     forLeftSegmentState:UIControlStateNormal
//     rightSegmentState:UIControlStateNormal
//     barMetrics:UIBarMetricsDefault];
//     [sc setDividerImage:segmentSelectedUnselected
//     forLeftSegmentState:UIControlStateSelected
//     rightSegmentState:UIControlStateNormal
//     barMetrics:UIBarMetricsDefault];
//     [sc
//     setDividerImage:segUnselectedSelected
//     forLeftSegmentState:UIControlStateNormal
//     rightSegmentState:UIControlStateSelected
//     barMetrics:UIBarMetricsDefault];
     sc.frame = CGRectMake(100, 400, 250, 44);
     [self.view addSubview:sc];
 
 }





- (void)selectSegment:(UISegmentedControl *)segment
{
    NSInteger  index = segment.selectedSegmentIndex;
    NSLog(@"indx =  %ld",(long)index);
    switch (index) {
        case 0:
            [self selectView1];
            segment.selectedSegmentIndex = 0;
            [segment setImage:[UIImage imageNamed:@"segmented_price_all_selected.png"] forSegmentAtIndex:0];
            [segment setImage:[UIImage imageNamed:@"segmented_price_free.png"] forSegmentAtIndex:1];
            
            break;
            case 1:
            [self selectView2];
            segment.selectedSegmentIndex = 1;
            [segment setImage:[UIImage imageNamed:@"segmented_price_all_selected.png"] forSegmentAtIndex:0];
            [segment setImage:[UIImage imageNamed:@"segmented_price_free.png"] forSegmentAtIndex:1];
            
            break;
            
        default:
            break;
    }
    
}

- (void)selectView1
{
    
}

- (void)selectView2
{
    
}

- (void)runOnNewThread
{
    sleep(1);
    [self performSelectorOnMainThread:@selector(setEnd) withObject:nil waitUntilDone:NO];
}

- (void)setEnd
{
    end = YES;
}




- (void)magnifyImage
{
    NSLog(@"局部放大");
    [SJAvatarBrowser showImage:self.imageView];//调用方法
}

- (void)clickCome:(UIButton *)sender
{
    _bgView = [[UIRemindView alloc]initWithFrame:CGRectMake(180, 150, 100, 100)];
    [self.view addSubview:_bgView];
    
    if (_bgView) {
        
    }else{
//        _bgView = [[UIView alloc]initWithFrame:CGRectMake(180, 150, 100, 100)];
//        _bgView.backgroundColor = [UIColor greenColor];
//        _bgView.alpha = 0.5;
//        [self.view addSubview:_bgView];
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 80, 70, 20)];
//        titleLabel.text = @"牛逼";
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        [_bgView addSubview:titleLabel];
//        
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
//        [_timer fireDate];

    }

   
}

//- (void)timeChange
//{
//    static int time = 0;
//    if (time == 1) {
//        [_bgView removeFromSuperview];
//        _bgView = nil;
//        time = 0;
//        [_timer invalidate];
//        _timer = nil;
//    }
//    time ++;
//}



/*
 #import "SegmentedControlTestViewController.h"
 @implementation SegmentedControlTestViewController
 @synthesize segmentedControl;
 
 
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",nil];
 //初始化UISegmentedControl
 UISegmentedControl *segmentedTemp = [[UISegmentedControl alloc]initWithItems:segmentedArray];
 segmentedControl = segmentedTemp;
 segmentedControl.frame = CGRectMake(60.0, 10.0, 200.0, 50.0);
 
 [segmentedControl setTitle:@"two" forSegmentAtIndex:1];//设置指定索引的题目
 [segmentedControl setImage:[UIImage imageNamed:@"lan.png"] forSegmentAtIndex:3];//设置指定索引的图片
 [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"mei.png"] atIndex:2 animated:NO];//在指定索引插入一个选项并设置图片
 [segmentedControl insertSegmentWithTitle:@"insert" atIndex:3 animated:NO];//在指定索引插入一个选项并设置题目
 [segmentedControl removeSegmentAtIndex:0 animated:NO];//移除指定索引的选项
 [segmentedControl setWidth:70.0 forSegmentAtIndex:2];//设置指定索引选项的宽度
 [segmentedControl setContentOffset:CGSizeMake(10.0,10.0) forSegmentAtIndex:1];//设置选项中图片等的左上角的位置
 
 //获取指定索引选项的图片imageForSegmentAtIndex：
 UIImageView *imageForSegmentAtIndex = [[UIImageView alloc]initWithImage:[segmentedControl imageForSegmentAtIndex:1]];
 imageForSegmentAtIndex.frame = CGRectMake(60.0, 100.0, 30.0, 30.0);
 
 //获取指定索引选项的标题titleForSegmentAtIndex
 UILabel *titleForSegmentAtIndex = [[UILabel alloc]initWithFrame:CGRectMake(100.0, 100.0, 30.0, 30.0)];
 titleForSegmentAtIndex.text = [segmentedControl titleForSegmentAtIndex:0];
 
 //获取总选项数segmentedControl.numberOfSegments
 UILabel *numberOfSegments = [[UILabel alloc]initWithFrame:CGRectMake(140.0, 100.0, 30.0, 30.0)];
 numberOfSegments.text = [NSString stringWithFormat:@"%d",segmentedControl.numberOfSegments];
 
 //获取指定索引选项的宽度widthForSegmentAtIndex：
 UILabel *widthForSegmentAtIndex = [[UILabel alloc]initWithFrame:CGRectMake(180.0, 100.0, 70.0, 30.0)];
 widthForSegmentAtIndex.text = [NSString stringWithFormat:@"%f",[segmentedControl widthForSegmentAtIndex:2]];
 
 segmentedControl.selectedSegmentIndex = 2;//设置默认选择项索引
 segmentedControl.tintColor = [UIColor redColor];
 segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;//设置样式
 segmentedControl.momentary = YES;//设置在点击后是否恢复原样
 
 [segmentedControl setEnabled:NO forSegmentAtIndex:4];//设置指定索引选项不可选
 BOOL enableFlag = [segmentedControl isEnabledForSegmentAtIndex:4];//判断指定索引选项是否可选
 NSLog(@"%d",enableFlag);
 
 [self.view addSubview:widthForSegmentAtIndex];
 [self.view addSubview:numberOfSegments];
 [self.view addSubview:titleForSegmentAtIndex];
 [self.view addSubview:imageForSegmentAtIndex];
 [self.view addSubview:segmentedControl];
 
 [widthForSegmentAtIndex release];
 [numberOfSegments release];
 [titleForSegmentAtIndex release];
 [segmentedTemp release];
 [imageForSegmentAtIndex release];
 
 //移除所有选项
 //[segmentedControl removeAllSegments];
 [super viewDidLoad];
 }
 
 
 - (void)didReceiveMemoryWarning {
 // Releases the view if it doesn't have a superview.
 [super didReceiveMemoryWarning];
 
 // Release any cached data, images, etc that aren't in use.
 }
 - (void)viewDidUnload {
 // Release any retained subviews of the main view.
 // e.g. self.myOutlet = nil;
 }
 
 - (void)dealloc {
 [segmentedControl release];
 [super dealloc];
 }
 @end
 
 */





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
