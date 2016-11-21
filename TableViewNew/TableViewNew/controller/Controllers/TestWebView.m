
//
//  TestWebView.m
//  TableViewNew
//
//  Created by HZW on 16/5/17.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "TestWebView.h"
#import "TestWebView+ErrorPageView.h"

@interface TestWebView ()<UIWebViewDelegate>
{
    UIAlertView *_myAlert;
    UIView *_progressBarView;
}
@property (nonatomic, strong) NSURLRequest *urlRequest;


@end

@implementation TestWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self createWebView];
    [self createBtn];
    [self createProgressView];
}


#pragma mark  -  webView加载   info.plist文件中添加键值对(解决webview加载不出来的问题)
/**<
 NSAppTransportSecurity(NsDictionary) - (Bool)NSAllowsArbitraryLoads(YES)
 */


- (void)createWebView
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WMAIN, HMAIN)];
//    [self.webView setUserInteractionEnabled:NO];
    [self.webView setDelegate:self];
//    [self.webView setOpaque:NO];//使网页透明
    [self.view addSubview:self.webView];
    
    [self loadNewWEb];
}

- (void)createBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 30);
    [btn setTitle:@"百度" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)clickRight
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)loadNewWEb
{
    NSString *path = @"http://www.baidu.com";
    NSURL *url = [NSURL URLWithString:path];
    self.urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:self.urlRequest];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
//    [self.webView loadRequest:request];

}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar addSubview:_progressView];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [_progressView removeFromSuperview];
//}


#pragma mark  - WebViewDelegate

#pragma mark - webViewDelegagte
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorTimedOut)
    {
        /**< 加载错误界面 */
        [self loadErrorPage:self.webView];
    }
}


/**< 本地html文件中的404 */
- (void)loadErrorPage:(UIWebView *)webView
{
    // 载入error page 页面
    NSString* htmlPath  = [[NSBundle mainBundle] pathForResource:@"ErrorPage/404" ofType:@"html"];
    NSURL *url          = [NSURL fileURLWithPath:htmlPath];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}


//
//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [self showWaiting];
//    [self.activityIndicator startAnimating];
//}

//数据加载完
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [self.activityIndicator stopAnimating];
//    UIView *view = (UIView *)[self.view viewWithTag:103];
//    [view removeFromSuperview];
//    [self hideWaiting];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
