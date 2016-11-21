//
//  IndexTopItem.m
//  TableViewNew
//
//  Created by HZW on 16/8/29.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "IndexTopItem.h"

@interface IndexTopItem()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollerView;

@property (nonatomic, assign) CGFloat mainWidth;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation IndexTopItem

- (instancetype)initWithFrame:(CGRect)frame  dataArray:(NSMutableArray *)dataArray
{
    if (self = [super initWithFrame:frame])
    {
        NSInteger index = [dataArray count];
        self.mainScrollerView = [[UIScrollView alloc]initWithFrame:frame];
        [self addSubview:self.mainScrollerView];
        
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
        self.pageControl.numberOfPages = 2;
        [self addSubview:self.pageControl];
        
        self.mainWidth = frame.size.width;
        self.mainScrollerView.delegate = self;
        self.mainScrollerView.pagingEnabled = YES;
        self.mainScrollerView.showsHorizontalScrollIndicator = NO;
        self.mainScrollerView.bounces = NO;
        
        self.currentPage = 0;
        self.pageControl.currentPage = 0;
        
        for (NSInteger i=0; i<[dataArray count]+1; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.mainWidth, 0, frame.size.width, frame.size.height)];
            NSString *imageName = [NSString stringWithFormat:@"%@.jpg",@(i)];
            if (i > 1) {
                imageName = [NSString stringWithFormat:@"0.jpg"];
            }
            imageView.image = [UIImage imageNamed:imageName];
            imageView.userInteractionEnabled = YES;
            imageView.backgroundColor = [UIColor blueColor];
            [self.mainScrollerView addSubview:imageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [self addGestureRecognizer:tap];
            
        }
        
        self.mainScrollerView.contentSize = CGSizeMake(self.mainWidth*(dataArray.count+1), frame.size.height);
    }
    return self;
}


- (void)tapAction:(UITapGestureRecognizer *)sender
{
    
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.mainScrollerView)
    {
        self.currentPage = self.mainScrollerView.contentOffset.x/self.mainWidth;
        if (self.currentPage == 0) {
            self.mainScrollerView.contentOffset = CGPointMake(self.mainWidth*2, 0);
//            self.currentPage = 1;
        }else if(self.currentPage == 2)
        {
            self.mainScrollerView.contentOffset = CGPointMake(self.mainWidth*0, 0);
            self.currentPage = 0;
        }
        self.pageControl.currentPage = self.currentPage;
    }
}










@end
