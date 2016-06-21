//
//  SCFullImgCollectCell.h
//  AppFactory
//
//  Created by sobeycloud on 16/4/21.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionViewCell+BaseConfiguration.h"

@interface SCFullImgCollectCell : UICollectionViewCell<SCBaseCollectCellInterFace>
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic)NSDictionary *cellData;
@end
