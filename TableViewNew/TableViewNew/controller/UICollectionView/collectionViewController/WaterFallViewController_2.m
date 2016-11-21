//
//  WaterFallViewController_2.m
//  TableViewNew
//
//  Created by HZW on 16/6/26.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "WaterFallViewController_2.h"
#import "MyFlowLayout.h"



static NSString *MyWaterFallCellId = @"myWaterFallCell";

@interface WaterFallViewController_2 ()<UICollectionViewDataSource,
UICollectionViewDelegate,
WaterFallLayoutDelegate>

@property (nonatomic ,strong) UICollectionView *mainCollectionView;


@end

@implementation WaterFallViewController_2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    MyFlowLayout *flowLayou = [[MyFlowLayout alloc]init];
    flowLayou.delegate = self;
    
    self.mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WMAIN, HMAIN) collectionViewLayout:flowLayou];
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    [self.mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MyWaterFallCellId];
    self.mainCollectionView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.mainCollectionView];
    
}





#pragma mark    UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyWaterFallCellId forIndexPath:indexPath];

    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }

    UILabel *label = [[UILabel alloc]init];
    [cell.contentView addSubview:label];
    label.text = [NSString stringWithFormat:@"第%ld个",indexPath.item];
    [label sizeToFit];
//    label.adjustsFontSizeToFitWidth = YES;

    cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:arc4random()%256/255.0];
    
    return cell;
}


#pragma mark  --WaterFlowLayoutDelegate

- (CGFloat)waterFlowLayout:(MyFlowLayout *)layout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth
{
    return  100 + arc4random_uniform(150);
}

- (NSInteger)waterFlowLayouColumnCount:(MyFlowLayout *)layout
{
    return 3;
}

- (CGFloat)waterFlowLayouRowSpacing:(MyFlowLayout *)layout
{
    return 5;
}

- (CGFloat)waterFlowLayouColumnSpacing:(MyFlowLayout *)layout
{
    return 5;
}

- (UIEdgeInsets)waterFlowLayouEdgeInsets:(MyFlowLayout *)layout
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
