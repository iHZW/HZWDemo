//
//  PASBaseTableView.h
//  TableViewNew
//
//  Created by HZW on 2017/10/13.
//  Copyright © 2017年 韩志伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface PASBaseTableView : UITableView

@property (nonatomic, copy) MJRefreshComponentRefreshingBlock freshBlock;

@property (nonatomic, copy) MJRefreshComponentRefreshingBlock moreBlock;

/**
 *  加载刷新视图
 *
 * freshBlock 下拉时调用
 */
- (void)loadFreshView:(MJRefreshComponentRefreshingBlock)freshBlock;

/**
 *  加载更多视图
 *
 *  moreBlock 上拉时回调
 */
- (void)loadMoreView:(MJRefreshComponentRefreshingBlock)moreBlock;


/**
 开始刷新动画
 */
- (void)startHeaderRefreshing;

/**
 *  结束刷新动画
 */
- (void)endHeaderRefreshing;

/**
 *  结束加载更多动画
 *
 *  @param isHidden 是否隐藏加载更多
 */
- (void)endFooterRefreshingWithHidden:(BOOL)isHidden;

@end
