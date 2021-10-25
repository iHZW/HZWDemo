//
//  GifView.m
//  TableViewNew
//
//  Created by HZW on 16/6/15.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "GifView.h"
#import "NSTimer+Util.h"


@implementation GifView

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)filePath
{
    if (self == [super initWithFrame:frame])
    {
        _gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount] forKey:(NSString *)kCGImagePropertyGIFDictionary];
        _gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:filePath], (CFDictionaryRef)self.gifProperties);
        _count = CGImageSourceGetCount(self.gif);
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(play) userInfo:nil repeats:YES];
        [_timer fire];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame data:(NSData *)data
{
    if (self == [super initWithFrame:frame])
    {
        self.gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount] forKey:(NSString *)kCGImagePropertyGIFDictionary];
        self.gif = CGImageSourceCreateWithData((CFDataRef)data, (CFDictionaryRef)self.gifProperties);
        _count = CGImageSourceGetCount(self.gif);
        _timer = [ NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(play) userInfo:nil repeats:YES];
        [_timer fire];
    }
    return self;
}

- (void)play
{
    _index ++;
    _index = _index%_count;
    CGImageRef ref = CGImageSourceCreateImageAtIndex(self.gif, _index, (CFDictionaryRef)self.gifProperties);
    self.layer.contents = (__bridge id)ref;
    CFRelease(ref);
    NSLog(@"play");
}


- (void)dealloc
{
    CFRelease(self.gif);
}

- (void)stopGif
{
    [_timer util_suspend]; /**< 关闭定时器 */
//    [_timer util_resume]; /**< 开启定时器 */
    
    [_timer setFireDate:[NSDate distantFuture]]; /**< 关闭定时器 */
//    [_timer setFireDate:[NSDate distantPast]];   /**< 开启定时器 */
}









@end
