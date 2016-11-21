//
//  WaterFallCollectionViewController.m
//  TableViewNew
//
//  Created by HZW on 16/6/24.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "WaterFallCollectionViewController.h"

@interface WaterFallCollectionViewController ()<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSArray *imageArr;  /**< 图片数组 */


@end

@implementation WaterFallCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString *headerString = @"headerCell";
static NSString *footString = @"footCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**< 随机色 */
    UIColor *arc4randomColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:arc4random()%256/255.0];
    self.view.backgroundColor = arc4randomColor;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 25);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    /**< 创建collectionVeiw */
    self.mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WMAIN, HMAIN) collectionViewLayout:flowLayout];
    self.mainCollectionView.backgroundColor = [UIColor whiteColor];
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    
    /**< 注册collectionCell */
    [self.mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    /**< 注册head */
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerString];
    /**< 注册foot */
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footString];
    
    [self.view addSubview:self.mainCollectionView];
}

#pragma mark  初始化数据源
- (NSArray *)imageArr
{
    if (!_imageArr)
    {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSInteger i=0; i<20; i++)
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",@(i)]];
            [tempArray addObject:image];
        }
        _imageArr = tempArray;
    }
    return _imageArr;
}



#pragma mark   UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    label.text = @"nihaoma";
    [cell.contentView addSubview:label];
    

//    switch (indexPath.section) {
//        case 0:
//        {
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.frame];
//            imageView.image = self.imageArr[indexPath.item];
//            [cell.contentView addSubview:imageView];
//        }
//            break;
//            
//            case 1:
//        {

//        }
//        default:
//        
//            break;
//    }
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:arc4random()%256/255.0];
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = [[UICollectionReusableView alloc]init];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerString forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor blueColor];
        
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
       
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footString forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor cyanColor];
        
    }
    return reusableView;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size;
    if (section == 0) {
      size = CGSizeMake(WMAIN, 44);
    }else if (section == 1)
    {
        size = CGSizeMake(WMAIN, 20);
    }
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if (indexPath.section == 0) {
        size = CGSizeMake(100, 100);

    }else{
        size = CGSizeMake(50, 50);

    }
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(WMAIN, 50);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
