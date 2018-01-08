//
//  ThirdDetailViewController.m
//  TableViewNew
//
//  Created by HZW on 15/11/16.
//  Copyright © 2015年 韩志伟. All rights reserved.
//

#import "ThirdDetailViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MediaToolbox/MediaToolbox.h>

typedef  NS_ENUM(NSInteger , SelectType){
    /**< 拍照 */
    SelectTypeForPhoto,
    /**< 打电话 */
    SelectTypeForPhone,
    /**< 发短信 */
    SelectTypeForTexing,
    /**< 开启闪光灯 */
    SelectTypeForFlashLight
};

static  NSArray *titleArray = nil;
static  NSArray *selectArray = nil;

@interface ThirdDetailViewController ()<UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
{
    

}

@property (nonatomic, strong) UITextField *textFieldA;
@property (nonatomic, strong) UITextField *textFieldB;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *afterMutableArray;
@property (nonatomic, strong) NSArray *beforeArray;
@property (nonatomic, strong) NSArray *afterArray;
@property (nonatomic, strong) UILabel *contentLabel; /**< 显示label内容 */
@property (nonatomic, strong) UIActionSheet *actionSheet; /**< 弹出框 */


@property (nonatomic,strong) AVCaptureSession * captureSession;
@property (nonatomic,strong) AVCaptureDevice * captureDevice;
@property (nonatomic, assign) BOOL isOpen; //判断是否开启


@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) NSString *movieUrl; /**< 视频地址 */


@end


@implementation ThirdDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    titleArray = @[@"拍照",@"打电话",@"发短信",@"闪光灯"];
    selectArray = @[@"select1",@"select2",@"select3",@"select4"];
    self.isOpen = NO;

    [self createData];
    
    /**< 视频测试 */
    [self createMovieView];
#ifndef FINISH_TEST
    [self createView];
#endif
    
/**< FIRST_OBJECT_TRUE 为真 执行第一个 ,否则只想第二个 */
#ifdef FIRST_OBJECT_TRUE
#define kTESTVALUE       2
#else
#define kTESTVALUE       3
#endif
    
    NSLog(@"kTESTVALUE = %@",@(kTESTVALUE));
    
    /**< 添加app调用系统功能的方法 */
    [self createAlreatSheet];

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect rect = self.view.frame;
    
    switch (_drawerType) {
        case DrawerDefaultLeft:
            [self.view.superview sendSubviewToBack:self.view];
            break;
        case DrawerTypeMaskLeft:
            rect.size.width = CGRectGetWidth(self.view.frame) * 0.75;
            break;
        default:
            break;
    }
    
    self.view.frame = rect;
}


- (void)createData
{
    self.dataArray = [NSMutableArray array];
    self.beforeArray = [NSArray arrayWithObjects:@"2",@"4",@"1", nil];
    _dataArray = [NSMutableArray arrayWithArray:self.beforeArray];
    
    self.afterArray = [NSArray array];
    self.afterArray = [self arraySort];
    
}


- (NSArray *)arraySort
{
    NSArray *array = [self.beforeArray sortedArrayUsingSelector:@selector(compare:)];
    
    return array;
}


- (void)createView
{
    self.textFieldA = [[UITextField alloc]initWithFrame:CGRectMake(50, 80, 200, 40)];
    _textFieldA.borderStyle = UITextBorderStyleRoundedRect;
    NSMutableString *str = [NSMutableString string];
    for (NSInteger i=0; i<[_beforeArray count]; i++) {
        [str appendString:[NSString stringWithFormat:@"%@",self.beforeArray[i]]];
    }
    _textFieldA.text = str;
    [self.view addSubview:_textFieldA];
    
    
    self.textFieldB = [[UITextField alloc]initWithFrame:CGRectMake(50, 140, 200, 40)];
    _textFieldB.borderStyle = UITextBorderStyleRoundedRect;
    
    NSMutableString *str2 = [NSMutableString string];
    for (NSInteger i=0; i<[_afterArray count]; i++) {
        [str2 appendString:[NSString stringWithFormat:@"%@",self.afterArray[i]]];
    }
    _textFieldB.text = str2;
    [self.view addSubview:_textFieldB];
    
    self.contentLabel =[[UILabel alloc]initWithFrame:CGRectZero];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = @"asdfsdfqwerqweqeacsqewrqwerqwexqwexqweroqjpwjix;npiuehquixnfqc;;;";
    CGFloat height = [self.contentLabel.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    self.contentLabel.adjustsFontSizeToFitWidth = YES;
    self.contentLabel.frame = CGRectMake(50, 200, 100, height);
    [self.view addSubview:self.contentLabel];
}



- (void)createMovieView
{
//    self.movieUrl = @"http://baidu.iqiyi.com/kan/aBCE3?fr=v.baidu.com/4";
//    NSURL *url = [NSURL fileURLWithPath:self.movieUrl];
//    NSString *urlString = @"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
    NSString *urlString = @"http://v7.pstatp.com/4f0d692b1f438810ac4ff9ec030fce13/5a434793/video/m/220f01538132b8548488fd9fe13c85db95411537491000018a4e62627b6/";
    NSURL* url = [NSURL URLWithString:urlString];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [self.view addSubview:self.moviePlayer.view];
//    self.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;// 不需要进度条
    self.moviePlayer.view.frame = CGRectMake(10, 350, kMainScreenWidth - 20, 300);
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(movieFinishedCallback:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:self.moviePlayer ];
    [self.moviePlayer prepareToPlay];
//    [self.navigationController presentMoviePlayerViewControllerAnimated:self.moviePlayer];

}

- (void) movieFinishedCallback:(NSNotification*) aNotification
{
    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
//    [self.navigationController dismissMoviePlayerViewControllerAnimated];
}

- (void)createAlreatSheet
{
    UIButton *systemBtn = [UIButton buttonWithFrame:CGRectZero target:self action:@selector(clickSystemBtn) bgImage:nil tag:0101 block:nil];
    [systemBtn setTitle:@"系统功能" forState:UIControlStateNormal];
    systemBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:systemBtn];
    
    [systemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"系统功能列表" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"打电话",@"发短信",@"闪光灯", nil];
    self.actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [self.view addSubview:self.actionSheet];
    
}

/**< 系统功能按钮 */
- (void)clickSystemBtn
{
    [self.actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *urlString = nil;
//    @"拍照",@"打电话",@"发短信",@"闪光灯"
    switch (buttonIndex) {
        case 0:/**< 拍照 */
            [self addCarema];
            break;
        case 1:/**< 打电话 */
        {
            /**< 方法一 */
            UIWebView *callWebView = [[UIWebView alloc] init];
            NSURL *telURL = [NSURL URLWithString:@"tel:18516638588"];
            [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
            [self.view addSubview:callWebView];
            /**< 方法二 系统的*/
            urlString = @"tel:18516638588";
            break;
        }
        case 2:/**< 发短信 */
        {
            urlString = @"sms://18516638588";
            break;
        }
        case 3:/**< 闪光灯 */
        {
//            [self openFlash];
            [self openSystemFlash];
            break;
        }
        case 4:/**< 取消 */
            break;
        case 5: /**< 发邮件 */
        {
            urlString = @"mailto://1182883474@qq.com";
            break;
        }
        default:
            break;
    }
    
    if (urlString != nil) {
        [self configURL:urlString];
    }

}


-(void)addCarema
{
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;  //是否可编辑
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self presentModalViewController:picker animated:YES];
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}

//拍摄完成后要执行的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)configURL:(NSString *)urlString
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}


/**< 开启系统的 */
- (void)openSystemFlash
{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    //修改前必须先锁定
    [device lockForConfiguration:nil];
    
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([device hasFlash])
    {
        if (device.flashMode == AVCaptureTorchModeOff)
        {
            device.flashMode = AVCaptureFlashModeOn;
            device.torchMode = AVCaptureTorchModeOn;
        }
        else if (device.flashMode == AVCaptureFlashModeOn)
        {
            device.flashMode = AVCaptureFlashModeOff;
            device.torchMode = AVCaptureTorchModeOff;
        }
    }
    /**< 存储闪光灯的值 */
    [PASCommonUtil setObject:[NSNumber numberWithInteger:device.flashMode] forKey:@"systemFlash"];
    
    [device unlockForConfiguration];
}


- (void)openFlash {
    
    if (!self.isOpen) {
        if([self.captureDevice hasTorch] && [self.captureDevice hasFlash])
        {
            if(self.captureDevice.torchMode == AVCaptureTorchModeOff)
            {
                [self.captureSession beginConfiguration];
                [self.captureDevice lockForConfiguration:nil];
                [self.captureDevice setTorchMode:AVCaptureTorchModeOn];
                [self.captureDevice setFlashMode:AVCaptureFlashModeOn];
                [self.captureDevice unlockForConfiguration];
                [self.captureSession commitConfiguration];
            }
        }
        [self.captureSession startRunning];
        self.isOpen = YES;
    } else {
        
        [self.captureSession beginConfiguration];
        [self.captureDevice lockForConfiguration:nil];
        if(self.captureDevice.torchMode == AVCaptureTorchModeOn)
        {
            [self.captureDevice setTorchMode:AVCaptureTorchModeOff];
            [self.captureDevice setFlashMode:AVCaptureFlashModeOff];
        }
        [self.captureDevice unlockForConfiguration];
        [self.captureSession commitConfiguration];
        [self.captureSession stopRunning];
        self.isOpen = NO;
    }
    
}

-(AVCaptureSession *)captureSesion
{
    if(_captureSession == nil)
    {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}

-(AVCaptureDevice *)captureDevice
{
    if(_captureDevice == nil)
    {
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _captureDevice;
}




@end
