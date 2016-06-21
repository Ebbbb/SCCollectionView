//
//  UICollectionViewCell+BaseConfiguration.m
//  AppFactory
//
//  Created by sobeycloud on 16/4/18.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import "UICollectionViewCell+BaseConfiguration.h"
#import <objc/runtime.h>

static void *childKey = &childKey;

@implementation UICollectionViewCell (BaseConfiguration)

- (void)setChild:(UICollectionViewCell<SCBaseCollectCellInterFace> *)child {
}

- (UICollectionViewCell<SCBaseCollectCellInterFace> *)child {
    if ([self conformsToProtocol:@protocol(SCBaseCollectCellInterFace)]) {
        return self;
    }
    return nil;
}

@end
