//
//  MyFlowLayout.m
//  TableViewNew
//
//  Created by HZW on 16/6/26.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import "MyFlowLayout.h"

static NSInteger const DefaultColumncount = 3;
static float const DefaultColumnSpacing = 10;
static float const DefaultRowSpacing = 10;
static UIEdgeInsets const DefaultEdgeInsets = {10, 10, 10, 10};

@interface MyFlowLayout()

@property (nonatomic ,strong)NSMutableArray *attrArr;
@property (nonatomic, strong) NSMutableArray *MaxYArray;

- (NSInteger)columnCount;
- (CGFloat)columnSpacing;
- (CGFloat)rowSpacing;
- (UIEdgeInsets)edgeInsets;

@end

@implementation MyFlowLayout


- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(waterFlowLayouColumnCount:)]) {
        return [self.delegate waterFlowLayouColumnCount:self];
    }
    return DefaultColumncount;
}
- (CGFloat)columnSpacing
{
    if ([self.delegate respondsToSelector:@selector(waterFlowLayouColumnSpacing:)]) {
        return [self.delegate waterFlowLayouColumnSpacing:self];
    }
    return DefaultColumnSpacing;
}
- (CGFloat)rowSpacing
{
    if ([self.delegate respondsToSelector:@selector(waterFlowLayouRowSpacing:)]) {
        return [self.delegate waterFlowLayouRowSpacing:self];
    }
    return DefaultRowSpacing;
}
- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(waterFlowLayouEdgeInsets:)]) {
        return [self.delegate waterFlowLayouEdgeInsets:self];
    }
    return DefaultEdgeInsets;
}



- (NSMutableArray *)attrArr
{
    if (!_attrArr) {
        _attrArr = [NSMutableArray array];
    }
    return _attrArr;
}


- (NSMutableArray *)MaxYArray
{
    if (!_MaxYArray) {
        _MaxYArray = [NSMutableArray array];
    }
    
    return _MaxYArray;
}


- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.attrArr removeAllObjects];
    [self.MaxYArray removeAllObjects];
    
    for (NSInteger i=0; i<[self columnCount]; i++) {
        [self.MaxYArray addObject:@([self edgeInsets].top)];
    }
    
    /**< 获取item的个数 */
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i=0; i<itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.attrArr addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrArr;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger __block minHeightColumn = 0;
    NSInteger __block minHeight = [self.MaxYArray[minHeightColumn] floatValue];
    
    
    [self.MaxYArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        CGFloat columnHeight = [(NSNumber *)obj floatValue];
        
        if (minHeight > columnHeight) {
            minHeight = columnHeight;
            minHeightColumn = idx;
        }
        
    }];
    
    UIEdgeInsets tepmEdgeInsets = [self edgeInsets];
    
    CGFloat width = (CGRectGetWidth(self.collectionView.frame) - tepmEdgeInsets.left - tepmEdgeInsets.right - [self columnSpacing] * ([self columnCount] -1))/[self columnCount];
    CGFloat height = [self.delegate waterFlowLayout:self heightForItemAtIndex:indexPath.item itemWidth:width];
    
    CGFloat originX = tepmEdgeInsets.left + minHeightColumn *(width + [self columnSpacing]);
    CGFloat originY = minHeight;
    if (originY != tepmEdgeInsets.top) {
        originY += [self rowSpacing];
    }
    
    [attributes setFrame:CGRectMake(originX, originY, width, height)];
    self.MaxYArray[minHeightColumn] = @(CGRectGetMaxY(attributes.frame));

    return attributes;
}


- (CGSize)collectionViewContentSize
{
    NSInteger __block maxHeight = 0;
    
    [self.MaxYArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         CGFloat columnHeight = [(NSNumber *)obj floatValue];
         
         if (maxHeight < columnHeight) {
             maxHeight = columnHeight;
         }
         
     }];
    
    return CGSizeMake(0, maxHeight + [self edgeInsets].bottom);
}



@end
