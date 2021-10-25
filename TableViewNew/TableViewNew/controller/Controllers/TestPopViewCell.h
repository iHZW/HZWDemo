//
//  TestPopViewCell.h
//  TableViewNew
//
//  Created by HZW on 2018/10/29.
//  Copyright © 2018 韩志伟. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestPopViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UIView *badge;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *statusLabel;

@end

NS_ASSUME_NONNULL_END
