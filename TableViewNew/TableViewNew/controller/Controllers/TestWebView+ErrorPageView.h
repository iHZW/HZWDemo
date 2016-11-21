//
//  TestWebView+ErrorPageView.h
//  TableViewNew
//
//  Created by HZW on 16/5/30.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "TestWebView.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface TestWebView (ErrorPageView)<NJKWebViewProgressDelegate,UIWebViewDelegate>

/**< 添加进度条 */
- (void)createProgressView;

@end
