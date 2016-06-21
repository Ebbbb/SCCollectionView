//
//  SCCollectionViewLayout.m
//  SCCollectionViewLayoutDemo
//
//  Created by sobeycloud on 16/6/16.
//  Copyright © 2016年 vince. All rights reserved.
//





#import "SCCollectionViewLayout.h"



@interface SCCollectionViewLayout(){
    float contentSizeHeight;
}
@property(nonatomic,copy)DynamicSetCelllineSpacing dynamicSetCelllineSpacing;//支持动态设置cell上间距
@property(nonatomic,copy)DynamicSetHeaderlineSpacing dynamicSetHeaderlineSpacing;//动态设置header 上间距离
@property(nonatomic,copy)DynamicSetFooterlineSpacing dynamicSetFooterlineSpacing;//动态设置footer 上间距离
@property(nonatomic,copy)DynamicSetHeaderSize dynamicSetHeaderSize;//动态设置header size
@property(nonatomic,copy)DynamicSetFooterSize dynamicSetFooterSize;//动态设置footer size

@property(nonatomic,weak)UICollectionViewLayoutAttributes * tempAttributes;
@property(nonatomic,strong)NSMutableArray *layoutAttributesArray;
@property(nonatomic,readonly)id<UICollectionViewDelegateFlowLayout> delegate;
@property(nonatomic,readonly)CGFloat collectionViewWidth;

@property(nonatomic,strong)NSArray * sectionItemsCountArray;


@end
@implementation SCCollectionViewLayout
-(void)awakeFromNib{
    self.cellEdgeInsets = UIEdgeInsetsZero;
    self.cellItemSize = CGSizeMake(80, 80);
    self.headerSize = CGSizeZero;
    self.footerSize = CGSizeZero;
 
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellEdgeInsets = UIEdgeInsetsZero;
        self.cellItemSize = CGSizeMake(80, 80);
        self.headerSize = CGSizeZero;
        self.footerSize = CGSizeZero;

    }
    return self;
}

- (void)setDynamicSetCelllineSpacing:(DynamicSetCelllineSpacing)dynamicSetCelllineSpacing {
    _dynamicSetCelllineSpacing = dynamicSetCelllineSpacing;
}

- (void)setDynamicSetHeaderlineSpacing:(DynamicSetHeaderlineSpacing)dynamicSetHeaderlineSpacing {
    _dynamicSetHeaderlineSpacing = dynamicSetHeaderlineSpacing;
}

- (void)setDynamicSetFooterlineSpacing:(DynamicSetFooterlineSpacing)dynamicSetFooterlineSpacing {
    _dynamicSetFooterlineSpacing = dynamicSetFooterlineSpacing;
}

- (void)setDynamicSetHeaderSize:(DynamicSetHeaderSize)dynamicSetHeaderSize {
    _dynamicSetHeaderSize = dynamicSetHeaderSize;
}

- (void)setDynamicSetFooterSize:(DynamicSetFooterSize)dynamicSetFooterSize {
    _dynamicSetFooterSize = dynamicSetFooterSize;
}

//函数执行优先级 0
-(void)prepareLayout{
    [super prepareLayout];

    contentSizeHeight = 0;
    self.tempAttributes = nil;
    self.layoutAttributesArray = [NSMutableArray array];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    NSMutableArray * sectionInfoArray = [NSMutableArray arrayWithCapacity:sectionCount];
    for (int i=0; i<sectionCount; i++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        [sectionInfoArray addObject:@(itemCount)];
    }
    self.sectionItemsCountArray = sectionInfoArray;
    
    
    
}
//函数执行优先级 1
-(CGSize)collectionViewContentSize{

    return CGSizeMake(self.collectionViewWidth, contentSizeHeight);
}
-(CGFloat)collectionViewWidth{
    return CGRectGetWidth(self.collectionView.bounds);
}
//函数执行优先级 2
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
   
    if (_layoutAttributesArray.count>0) {
        return _layoutAttributesArray;
    }
 
    for (NSInteger section=0; section<self.sectionItemsCountArray.count; section++) {
        
        NSInteger total = [self.collectionView numberOfItemsInSection:section];
        
   
        NSIndexPath * path = nil;
     
        UICollectionViewLayoutAttributes * headAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        if (headAttributes) {
            [_layoutAttributesArray addObject:headAttributes];
            self.tempAttributes = headAttributes;
        }
        
        for (NSInteger i =0; i<total; i++) {
            
            path = [NSIndexPath indexPathForItem:i inSection:section];
            UICollectionViewLayoutAttributes * attributes =[self layoutAttributesForItemAtIndexPath:path];
            [_layoutAttributesArray addObject:attributes];
            self.tempAttributes = attributes;
            
            CGFloat bHeight =(CGRectGetMaxY(attributes.frame)+_cellEdgeInsets.bottom);
            contentSizeHeight = contentSizeHeight>bHeight?contentSizeHeight:bHeight;
        }
        UICollectionViewLayoutAttributes * footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
       
        if (footerAttributes) {
            [_layoutAttributesArray addObject:footerAttributes];
            self.tempAttributes = footerAttributes;
            
            CGFloat bHeight =(CGRectGetMaxY(footerAttributes.frame));
            contentSizeHeight = contentSizeHeight>bHeight?contentSizeHeight:bHeight;
        }
        
        path = nil;
        
    }
  
    return _layoutAttributesArray;
}

//section header or footer 位置
-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
  
        CGSize s = CGSizeZero;
        CGFloat y =CGRectGetMaxY(self.tempAttributes.frame);
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            s = _dynamicSetHeaderSize?_dynamicSetHeaderSize(indexPath.section):_headerSize;
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
                s = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section];
                
            }
            
            y+=_dynamicSetHeaderlineSpacing?_dynamicSetHeaderlineSpacing(indexPath.section):0;
            

            
        }else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]){
            s = _dynamicSetFooterSize?_dynamicSetFooterSize(indexPath.section):_footerSize;
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
                s = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:indexPath.section];
            }
            y+=_dynamicSetFooterlineSpacing?_dynamicSetFooterlineSpacing(indexPath.section):0;
      
        }
    
    UICollectionViewLayoutAttributes * attributes = nil;
    if (s.width>0&&s.height>0) {
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        CGRect r;
        r.size = s;
        r.origin.x = 0;
        r.origin.y = y;
        
        attributes.frame = r;
    }
   
    return attributes;
}

//cell位置
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize s = _cellItemSize;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
       s = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect r ;
    r.size = s;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    if (s.width>=self.collectionViewWidth) {//当cell width大于collectionviewwidth时，(_cellEdgeInsets)的左右边距参数将不再使用
        s.width = self.collectionViewWidth;
        x = 0;
        if (self.tempAttributes) {
            y = (_dynamicSetCelllineSpacing?_dynamicSetCelllineSpacing(indexPath):_lineSpacing)+CGRectGetMaxY(self.tempAttributes.frame);
        }else{
            y = _cellEdgeInsets.top;
        }
       
    }else{
    
        x = _cellEdgeInsets.left;
        y = _cellEdgeInsets.top;
        if (r.size.width>(self.collectionViewWidth-_cellEdgeInsets.right-_cellEdgeInsets.left)) {
            r.size.width = self.collectionViewWidth-_cellEdgeInsets.right-_cellEdgeInsets.left;
        }
    
        if (self.tempAttributes) {
            CGRect tempFrame = self.tempAttributes.frame;
        
            if (self.tempAttributes.representedElementCategory == UICollectionElementCategorySupplementaryView||indexPath.item == 0) {
         
                x = _cellEdgeInsets.left;
                y = CGRectGetMaxY(tempFrame)+(_dynamicSetCelllineSpacing?_dynamicSetCelllineSpacing(indexPath):_lineSpacing);
            
            }else{
        
                CGFloat maxX = CGRectGetMaxX(tempFrame)+_interitemSpacing;
                x = maxX;
                y = tempFrame.origin.y;
        
                if (maxX+r.size.width>(self.collectionViewWidth-_cellEdgeInsets.right)) {
                    x = _cellEdgeInsets.left;
                    y = CGRectGetMaxY(tempFrame)+(_dynamicSetCelllineSpacing?_dynamicSetCelllineSpacing(indexPath):_lineSpacing);
                }
            
            }
        }
    
    }
    r.origin = CGPointMake(x, y);
    attributes.frame = r;

    
    return attributes;
}


#pragma mark -----
-(id<UICollectionViewDelegateFlowLayout>)delegate{
    return (id <UICollectionViewDelegateFlowLayout> )self.collectionView.delegate;

}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
 
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}
@end
