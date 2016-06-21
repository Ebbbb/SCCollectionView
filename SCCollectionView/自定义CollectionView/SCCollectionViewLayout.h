//
//  SCCollectionViewLayout.h
//  SCCollectionViewLayoutDemo
//
//  Created by sobeycloud on 16/6/16.
//  Copyright © 2016年 vince. All rights reserved.
//


/*
 READ ME
 
 - (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
    以上的UICollectionViewDelegateFlowLayout的回调函数 将失效;
 */



#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class SCCollectionViewLayout;
typedef CGFloat (^DynamicSetCelllineSpacing)(NSIndexPath * indexPath);
typedef CGFloat (^DynamicSetHeaderlineSpacing)(NSInteger section);
typedef CGFloat (^DynamicSetFooterlineSpacing)(NSInteger section);
typedef CGSize (^DynamicSetHeaderSize)(NSInteger section);
typedef CGSize (^DynamicSetFooterSize)(NSInteger section);

extern NSString *const SCCollectionElementKindSectionHeader;
extern NSString *const SCCollectionElementKindSectionFooter;

@interface SCCollectionViewLayout : UICollectionViewLayout

@property(nonatomic,assign)CGSize cellItemSize;//默认为:CGSizeMake(80, 80)
@property(nonatomic,assign)CGSize headerSize;
@property(nonatomic,assign)CGSize footerSize;


//cell 间距设置
//**当cell width大于collectionviewwidth时，(_cellEdgeInsets)的左右边距参数将不再起作用
@property(nonatomic,assign)UIEdgeInsets cellEdgeInsets;
@property(nonatomic,assign)CGFloat lineSpacing;//上下间距
@property(nonatomic,assign)CGFloat interitemSpacing;//cell之间的间距
//支持动态设置cell上间距
- (void)setDynamicSetCelllineSpacing:(DynamicSetCelllineSpacing)dynamicSetCelllineSpacing;
//动态设置header 上间距离
- (void)setDynamicSetHeaderlineSpacing:(DynamicSetHeaderlineSpacing)dynamicSetHeaderlineSpacing;
//动态设置footer 上间距离
- (void)setDynamicSetFooterlineSpacing:(DynamicSetFooterlineSpacing)dynamicSetFooterlineSpacing;
//动态设置header size
- (void)setDynamicSetHeaderSize:(DynamicSetHeaderSize)dynamicSetHeaderSize;
//动态设置footer size
- (void)setDynamicSetFooterSize:(DynamicSetFooterSize)dynamicSetFooterSize;
@end
