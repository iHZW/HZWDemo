//
//  BackGroundView.m
//  TableViewNew
//
//  Created by HZW on 16/12/1.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "BackGroundView.h"


#define kBackGroundViewKey      20161201

#define screenScale ([UIScreen mainScreen].scale)

@implementation BackGroundView


+ (void)showBackGroundView
{
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:kMainScreenBounds];
//    imageView.image        = [UIImage imageNamed:@"00.jpg"];
//    imageView.tag          = kBackGroundViewKey;

//    [[[UIApplication sharedApplication] keyWindow] addSubview:imageView];
    
    
    /**< 毛玻璃效果   方法一:*/  //http://www.jb51.net/article/78113.htm  毛玻璃和图片模糊化处理
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:kMainScreenBounds];
    bgImgView.image = [UIImage imageNamed:@"00.jpg"];
    bgImgView.tag = kBackGroundViewKey;
    [[[UIApplication sharedApplication] keyWindow]addSubview:bgImgView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:kMainScreenBounds];
    toolbar.barStyle = UIBarStyleBlackOpaque;
    [bgImgView addSubview:toolbar];
//
    
    /**< 毛玻璃效果   方法二:*/
//    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:kMainScreenBounds];
//    bgImgView.image = [UIImage imageNamed:@"00.jpg"];
//    bgImgView.tag = kBackGroundViewKey;
//    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
//    //[bgImgView setImageToBlur: [UIImage imageNamed:@"huoying.jpg"] blurRadius: completionBlock:nil];
//    bgImgView.userInteractionEnabled = YES;
//    [[[UIApplication sharedApplication] keyWindow] addSubview:bgImgView];
//    /*
//     毛玻璃的样式(枚举)
//     UIBlurEffectStyleExtraLight,
//     UIBlurEffectStyleLight,
//     UIBlurEffectStyleDark
//     */
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = kMainScreenBounds;
//    [bgImgView addSubview:effectView];
    
    /**< 毛玻璃效果   方法三:*/
//    UIImageView *bgImgView           = [[UIImageView alloc] initWithFrame:kMainScreenBounds];
//    bgImgView.contentMode            = UIViewContentModeScaleAspectFill;
//    // 对背景图片进行毛玻璃效果处理 参数blurRadius默认是,可指定,最后一个参数block回调可以为nil
//    [bgImgView setImageToBlur: [UIImage imageNamed:@"00.jpg"] blurRadius: completionBlock:nil];
//    bgImgView.tag                    = kBackGroundViewKey;
//    bgImgView.userInteractionEnabled = YES;
////    [self.view addSubview:bgImgView];
    
}


+ (void)removeBackGroundView
{
    NSArray *viewArray = [[[UIApplication sharedApplication] keyWindow] subviews];
    for (id obj in viewArray)
    {
        if ([[obj class] isSubclassOfClass:[UIImageView class]])
        {
            UIImageView *imageView = (UIImageView *)obj;
            
            if (imageView.tag == kBackGroundViewKey)
            {
                imageView.alpha = 0;
                [imageView removeFromSuperview];
            }
        }
        
    }
}



#pragma mark  ------   privite Method 获取APP进入后台是界面的图片

//获取到APP退到后台的屏幕截屏
+(UIImage *)screenShot
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kMainScreenWidth*screenScale, kMainScreenHeight*screenScale), YES, 0);
    //设置截屏大小
    [[[[UIApplication sharedApplication] keyWindow] layer] renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = viewImage.CGImage;
    CGRect rect = CGRectMake(0, 0, kMainScreenWidth*screenScale,kMainScreenHeight*screenScale);
    
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    return sendImage;
}


+ (UIImage *)buildImage
{
    UIImage *image = [self screenShot];
    //保存图片到照片库
    //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    return image;
}


#pragma mark  -- 图片模糊化处理    


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
