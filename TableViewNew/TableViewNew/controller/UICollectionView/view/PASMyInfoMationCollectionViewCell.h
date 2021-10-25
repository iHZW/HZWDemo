//
//  PASMyInfoMationCollectionViewCell.h
//  TableViewNew
//
//  Created by HZW on 16/6/23.
//  Copyright © 2016年 韩志伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PASMyInfoMationCollectionViewCell : UICollectionViewCell

@end



@interface MyInformationOneCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;

- (NSArray *)configWith:(NSDictionary *)dic;

@end


@interface MyInformationTwoCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *nameLabel;


@end


@interface ThreeCellId : UICollectionViewCell



@end


@interface FourCellId : UICollectionViewCell



@end


@interface FiveCellId : UICollectionViewCell



@end

