//
//  UICollectionViewCell+BaseConfiguration.h
//  AppFactory
//
//  Created by sobeycloud on 16/4/18.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCBaseCollectCellInterFace <NSObject>

@required
- (void)dealWithData:(NSDictionary *)dict;
- (CGSize)getSubCellSize;
@end

@interface UICollectionViewCell (BaseConfiguration)
@property(nonatomic, weak)UICollectionViewCell<SCBaseCollectCellInterFace> *child;
@end
