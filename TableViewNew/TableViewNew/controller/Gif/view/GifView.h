//
//  GifView.h
//  TableViewNew
//
//  Created by HZW on 16/6/15.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@interface GifView : UIView
{
    CGImageSourceRef _gif;
    NSDictionary *_gifProperties;
    size_t _index;
    size_t _count;
    NSTimer *_timer;
}

@property (nonatomic, assign) CGImageSourceRef gif;
@property (nonatomic, strong) NSDictionary *gifProperties;


- (id)initWithFrame:(CGRect)frame filePath:(NSString *)filePath;


- (id)initWithFrame:(CGRect)frame data:(NSData *)data;


- (void)stopGif;   /**< 关闭动画 */


@end
