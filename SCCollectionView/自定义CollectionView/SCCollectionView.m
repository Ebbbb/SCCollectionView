//
//  SCCollectionView.m
//  SCTest
//
//  Created by sobeycloud on 16/2/2.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import "SCCollectionView.h"
#import "UICollectionViewCell+BaseConfiguration.h"
#define EmptyIdentifier @"EmptyIdentifier"
#define FooterView @"FooterView"
#define HeaderView @"HeaderView"

@interface SCCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong)NSArray *cellIdentifiers;
@property(nonatomic, strong)NSMutableArray *tempCells;
@property(nonatomic, strong)NSArray *myDataSource;
@property(nonatomic, copy)SCCollectionViewCellResponseBlock cellResponseBlock;
@property(nonatomic, copy)SCCollectionViewCellChooseBlock cellChooseBlock;

@property(nonatomic, copy)SCCollectionViewSectionHeaderBlock sectionHeaderblock;

@property(nonatomic, copy)SCCollectionViewSectionFooterBlock sectionFooterblock;

@end

@implementation SCCollectionView

- (instancetype)initWithFrame:(CGRect)frame Layout:(UICollectionViewLayout *)layout CellClassNames:(NSArray *)cellClassNames {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:EmptyIdentifier];
        _cellIdentifiers = cellClassNames;
        for (int i = 0; i < cellClassNames.count ; i++) {
            NSString *cellClassName = cellClassNames[i];
            Class cellClass = NSClassFromString(cellClassName);
            if (cellClass && [[[cellClass alloc] init] conformsToProtocol:@protocol(SCBaseCollectCellInterFace)]) {
                if ([[NSBundle mainBundle] pathForResource:_cellIdentifiers[i] ofType:@"nib"]) {
                    [self registerNib:[UINib nibWithNibName:cellClassName bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellClassName];
                }
                else {
                    [self registerClass:NSClassFromString(cellClassName) forCellWithReuseIdentifier:cellClassName];
                }
            }
            else {
                _cellIdentifiers = nil;
                break;
            }
        }
        _tempCells = [NSMutableArray array];
        for (int i = 0; i < _cellIdentifiers.count; i++) {
            Class cellClass = NSClassFromString(_cellIdentifiers[i]);
            [_tempCells addObject:[[cellClass alloc] init]];
        }
    }
    return self;
}

- (void)setInfoWithDataSource:(NSArray *)dataSource {
    if (!dataSource || dataSource.count == 0) {
        _myDataSource = nil;
    }
    else {
        if (![dataSource[0] isKindOfClass:[NSArray class]]) {
            _myDataSource = [NSArray arrayWithObject:dataSource];
        }
        else {
            _myDataSource = dataSource;
        }
    }
    [self reloadData];
}

- (void)setCellResponseBlock:(SCCollectionViewCellResponseBlock)cellResponseBlock {
    _cellResponseBlock = cellResponseBlock;
}

- (void)setCellChooseBlock:(SCCollectionViewCellChooseBlock)cellChooseBlock {
    _cellChooseBlock = cellChooseBlock;
}

- (void)setSectionHeaderBlock:(SCCollectionViewSectionHeaderBlock)sectionHeaderBlock {
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderView];
    _sectionHeaderblock = sectionHeaderBlock;
}

- (void)setSectionFooterBlock:(SCCollectionViewSectionFooterBlock)sectionFooterBlock {
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterView];
    _sectionFooterblock = sectionFooterBlock;
}

#pragma mark - UICollectionViewMethod
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _myDataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_cellIdentifiers.count > 0) {
        return [_myDataSource[section] count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if (_cellChooseBlock) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifiers[_cellChooseBlock(_myDataSource[indexPath.section][indexPath.row],indexPath)] forIndexPath:indexPath];
    }
    NSLog(@"%@",cell.child);
    if ([cell respondsToSelector:@selector(dealWithData:)]) {
        [cell.child dealWithData:_myDataSource[indexPath.section][indexPath.row]];
    }
    return cell;
}

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellChooseBlock) {
        UICollectionViewCell *tempCell = _tempCells[_cellChooseBlock(_myDataSource[indexPath.section][indexPath.row],indexPath)];
        if ([tempCell respondsToSelector:@selector(dealWithData:)]) {
            [tempCell.child dealWithData:_myDataSource[indexPath.section][indexPath.row]];
        }
        if ([tempCell respondsToSelector:@selector(getSubCellSize)]) {
            return [tempCell.child getSubCellSize];
        }
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (_sectionHeaderblock) {
            UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderView forIndexPath:indexPath];
            return _sectionHeaderblock(header, indexPath.section);
        }
    }
    
    else if (kind == UICollectionElementKindSectionFooter) {
        if (_sectionFooterblock) {
            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterView forIndexPath:indexPath];
            return _sectionFooterblock(footer, indexPath.section);
        }
    }
    return nil;
}

- (BOOL)verifyEdgeInsetsHaveNaN:(UIEdgeInsets)insets{
    NSArray *insetsArr = @[@(insets.top),@(insets.bottom),@(insets.left),@(insets.right)];
    for (int i = 0; i < insetsArr.count; i++) {
        if ([insetsArr[i] isEqualToNumber:[NSDecimalNumber notANumber]]) {
            return YES;
        }
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_cellResponseBlock) {
        _cellResponseBlock(_myDataSource[indexPath.section][indexPath.row],indexPath);
    }
}


@end
