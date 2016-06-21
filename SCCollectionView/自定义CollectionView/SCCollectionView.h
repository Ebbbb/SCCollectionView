//
//  SCCollectionView.h
//  SCTest
//
//  Created by sobeycloud on 16/2/2.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SCCollectionViewCellResponseBlock)(NSDictionary *data,NSIndexPath *indexPath);

typedef int(^SCCollectionViewCellChooseBlock)(NSDictionary *data,NSIndexPath *indexPath);

typedef UICollectionReusableView*(^SCCollectionViewSectionFooterBlock)(UICollectionReusableView *footer, NSInteger section);

typedef UICollectionReusableView*(^SCCollectionViewSectionHeaderBlock)(UICollectionReusableView *header, NSInteger section);

@interface SCCollectionView : UICollectionView

//初始化方法。
- (instancetype)initWithFrame:(CGRect)frame Layout:(UICollectionViewLayout *)layout CellClassNames:(NSArray *)cellClassNames;

//数据加载方法。
- (void)setInfoWithDataSource:(NSArray *)dataSource;

//cell选择反馈方法。
- (void)setCellResponseBlock:(SCCollectionViewCellResponseBlock)cellResponseBlock;

//cell选择方法。
//请将此方法的执行，放在数据加载之前（在tableView初始化行高会用到此方法）。
- (void)setCellChooseBlock:(SCCollectionViewCellChooseBlock)cellChooseBlock;

//设置sectionheader
- (void)setSectionHeaderBlock:(SCCollectionViewSectionHeaderBlock)sectionHeaderBlock;

//设置sectionfooter
- (void)setSectionFooterBlock:(SCCollectionViewSectionFooterBlock)sectionFooterBlock;
@end
