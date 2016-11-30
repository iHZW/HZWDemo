//
//  FlashTagView.h
//  TableViewNew
//
//  Created by HZW on 16/11/28.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlashTagView : UIView

@property (nonatomic, strong)NSString *flashImageName; /**< 闪烁图片的名字 */

/**< 开始闪烁 */
- (void)startFlashTagView;

@end
