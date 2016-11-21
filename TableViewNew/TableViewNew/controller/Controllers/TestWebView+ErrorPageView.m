//
//  TestWebView+ErrorPageView.m
//  TableViewNew
//
//  Created by HZW on 16/5/30.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "TestWebView+ErrorPageView.h"
#import <objc/runtime.h>

static const char *ObjectProgressViewKey    = "ObjectProgressView";
static const char *ObjectProgressKey        = "ObjectProgress";

@interface TestWebView()

@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;

@end

@implementation TestWebView (ErrorPageView)

/**< 分类中添加属性 */
- (NJKWebViewProgressView *)progressView
{
    return objc_getAssociatedObject(self, ObjectProgressViewKey);
}

- (void )setProgressView:(NJKWebViewProgressView *)obj
{
    objc_setAssociatedObject(self, ObjectProgressViewKey, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NJKWebViewProgress *)progressProxy
{
    return objc_getAssociatedObject(self, ObjectProgressKey);
}

- (void)setProgressProxy:(NJKWebViewProgress *)obj
{
    objc_setAssociatedObject(self, ObjectProgressKey, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (void)createProgressView
{
    self.progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progressProxy;
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self.navigationController.navigationBar addSubview:self.progressView];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}


#pragma mark  - NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:YES];
}

@end
