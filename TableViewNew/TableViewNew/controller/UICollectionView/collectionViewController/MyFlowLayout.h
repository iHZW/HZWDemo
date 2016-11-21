//
//  MyFlowLayout.h
//  TableViewNew
//
//  Created by HZW on 16/6/26.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyFlowLayout;
@protocol WaterFallLayoutDelegate <NSObject>

@required

- (CGFloat)waterFlowLayout:(MyFlowLayout *)layout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (NSInteger)waterFlowLayouColumnCount:(MyFlowLayout *)layout;
- (CGFloat)waterFlowLayouColumnSpacing:(MyFlowLayout *)layout;
- (CGFloat)waterFlowLayouRowSpacing:(MyFlowLayout *)layout;
- (UIEdgeInsets)waterFlowLayouEdgeInsets:(MyFlowLayout *)layout;

@end

@interface MyFlowLayout : UICollectionViewFlowLayout

@property ( nonatomic ,assign) id<WaterFallLayoutDelegate>delegate;


@end
