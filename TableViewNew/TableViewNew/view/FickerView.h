//
//  FickerView.h
//  TableViewNew
//
//  Created by HZW on 16/11/23.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FickerView : UIView

@property (nonatomic, strong) NSString *imageName; /**< 图片名称 */

/**< 开始闪烁 */
- (void)startFlashing;

@end
