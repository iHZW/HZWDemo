//
//  MyLabel.h
//  TableViewNew
//
//  Created by HZW on 2018/1/22.
//  Copyright © 2018年 韩志伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , VerticalAlignment)
{
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
};

@interface MyLabel : UILabel

@property (nonatomic, assign) VerticalAlignment verticalAlignment;

@end
