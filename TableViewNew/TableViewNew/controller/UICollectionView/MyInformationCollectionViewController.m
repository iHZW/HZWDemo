//
//  MyInformationCollectionViewController.m
//  TableViewNew
//
//  Created by HZW on 16/6/23.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "MyInformationCollectionViewController.h"
#import "PASMyInfoMationCollectionViewCell.h"

#define dimof(a)                    (sizeof(a)/sizeof(a[0]))


@interface MyInformationCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) UICollectionView *mainCollectionView;


@end

@implementation MyInformationCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString *MyInformationHeaderId = @"headerCell";
static NSString *MyInformationFootId = @"footCell";


static NSString *myInformationCenterCellIdentifiers[] =
{
    @"MyInformationOneCell",
    @"MyInformationTwoCell"
};

//static NSString *myInfomationItemCell[] =
//{
//  
//    
//};


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**< flowlayout */
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
//    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.view.backgroundColor = [UIColor whiteColor];
   
    /**< 创建UICollectionView */
    self.mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WMAIN, HMAIN) collectionViewLayout:flowLayout];
    self.mainCollectionView.showsVerticalScrollIndicator = YES;
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    
    /**< 随机色 */
    UIColor *armColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:arc4random()%256/255.0];
    self.mainCollectionView.backgroundColor = armColor;
    [self.view addSubview:self.mainCollectionView];
    
    /**< 注册复用cell */
    // Register cell classes
    for (NSInteger i=0; i<dimof(myInformationCenterCellIdentifiers); i++)
    {
        NSString *className = myInformationCenterCellIdentifiers[i];
        [self.mainCollectionView registerClass:NSClassFromString(className) forCellWithReuseIdentifier:className];
    }
    
    /**< 注册头  尾 */
    
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MyInformationHeaderId];
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MyInformationFootId];
    
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

#pragma mark -- UICollectionView  dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = @[@2,@4];
    return [array[section] integerValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *itemCell = nil;
    NSString *idStringId = myInformationCenterCellIdentifiers[indexPath.section];
    itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:idStringId forIndexPath:indexPath];
    
    switch (indexPath.section)
    {
        case 0:
        {
            MyInformationOneCell *tempCell = (MyInformationOneCell *)itemCell;
            tempCell.titleLabel.text = [NSString stringWithFormat:@"第%ld名",indexPath.item];
            tempCell.nameLabel.text = [NSString stringWithFormat:@"我是大%ld",indexPath.item];
        }
            break;
            
        case 1:
        {
            MyInformationTwoCell *tempCell = (MyInformationTwoCell *)itemCell;
            tempCell.ageLabel.text  = [NSString stringWithFormat:@"我今年%ld岁",indexPath.item];
            tempCell.nameLabel.text = [NSString stringWithFormat:@"我是%ld小",indexPath.item];
        }
            break;
            
        default:
            break;
    }
    itemCell.backgroundColor = [UIColor yellowColor];
    
    return itemCell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeMake(WMAIN/4, 60);
    switch (indexPath.section) {
        case 0:
           itemSize = CGSizeMake(WMAIN/2, 120);
            break;
        default:
            break;
    }
    return itemSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(WMAIN, 44);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(WMAIN, 44);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    switch (section) {
        case 0:
            insets = UIEdgeInsetsMake(5, 5, 5, 5);
            break;
            
        default:
            break;
    }
    return insets;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = [[UICollectionReusableView alloc]init];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MyInformationHeaderId forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor redColor];
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MyInformationFootId forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor blueColor];
    }
    
    return reusableView;
}



#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
