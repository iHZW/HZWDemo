//
//  GifTestViewController.m
//  TableViewNew
//
//  Created by HZW on 16/6/14.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "GifTestViewController.h"
#import <ImageIO/ImageIO.h>
#import "GifView.h"


#define ViewHeight    ((HMAIN-64)/3)


@interface GifTestViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *loadGifWebView;
@property (nonatomic, strong)UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) GifView *gifView;

@end


@implementation GifTestViewController

#pragma mark  初始化 (懒加载)
- (UIWebView *)loadGifWebView
{
    if (_loadGifWebView == nil)
    {
        _loadGifWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, WMAIN, ViewHeight)];
        _loadGifWebView.backgroundColor = [UIColor whiteColor];
        _loadGifWebView.scalesPageToFit = YES;
    }
    
    return _loadGifWebView;
}

//- (UIActivityIndicatorView *)indicatorView
//{
//    if (_indicatorView == nil)
//    {
//        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        _indicatorView.center = self.view.center;
//        _indicatorView.color = [UIColor lightGrayColor];
//        [_indicatorView setHidesWhenStopped:YES];
//    }
//    
//    return _indicatorView;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
   
    [self loadTwoGifMethod];
    [self loadeGifView];
    [self loadThreeGifMethod];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.gifView stopGif];
    
}

#pragma mark  - 加载gif方法一:
- (void)loadeGifView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"gif"];
    CGRect frame = CGRectMake(0, 64+ViewHeight, WMAIN, ViewHeight);
    UIImageView *imageView = [self imageViewWithGIFFile:path frame:frame];
    [self.view addSubview:imageView];
}


#pragma mark - #import <ImageIO/ImageIO.h>
- (UIImageView *)imageViewWithGIFFile:(NSString *)file frame:(CGRect)frame
{
    return [self imageViewWithGIFData:[NSData dataWithContentsOfFile:file] frame:frame];
}
- (UIImageView *)imageViewWithGIFData:(NSData *)data frame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    // 加载gif文件数据
    //NSData *gifData = [NSData dataWithContentsOfFile:file];
    
    // GIF动画图片数组
    NSMutableArray *frames = nil;
    // 图像源引用
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    // 动画时长
    CGFloat animationTime = 0.f;
    if (src) {
        // 获取gif图片的帧数
        size_t count = CGImageSourceGetCount(src);
        // 实例化图片数组
        frames = [NSMutableArray arrayWithCapacity:count];
        
        for (size_t i = 0; i < count; i++) {
            // 获取指定帧图像
            CGImageRef image = CGImageSourceCreateImageAtIndex(src, i, NULL);
            
            // 获取GIF动画时长
            NSDictionary *properties = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, i, NULL);
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (image) {
                [frames addObject:[UIImage imageWithCGImage:image]];
                CGImageRelease(image);
            }
        }
        CFRelease(src);
    }
    [imageView setImage:[frames objectAtIndex:0]];
    [imageView setBackgroundColor:[UIColor redColor]];
    [imageView setAnimationImages:frames];
    [imageView setAnimationDuration:animationTime];
    [imageView startAnimating];
    
    return imageView;
}


#pragma mark  - 加载gif图图方法二:
- (void)loadTwoGifMethod
{
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"gif"]];
    [self.loadGifWebView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    [self.view addSubview:self.loadGifWebView];
//    [self.loadGifWebView addSubview:self.indicatorView];
}

//#pragma mark - UIWebViewDelegate 代理
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    [self.indicatorView startAnimating];
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    [self.indicatorView stopAnimating];
//}
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    [self.indicatorView stopAnimating];
//}


#pragma mark  - 加载gif图图方法三:
- (void)loadThreeGifMethod
{
    NSString *pathString = [[NSBundle mainBundle]pathForResource:@"1" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"gif"]];
    
//   gifView = [[GifView alloc] initWithFrame:CGRectMake(0, 64+2*ViewHeight, WMAIN, ViewHeight) filePath:pathString];
    self.gifView = [[GifView alloc]initWithFrame:CGRectMake(0, 64+2*ViewHeight, WMAIN, ViewHeight) data:gifData];
    
    self.gifView.tag = 2016;
    [self.view addSubview:self.gifView];
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    GifView *gifView = (GifView *)[self.view viewWithTag:2016];
    [gifView stopGif];
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
