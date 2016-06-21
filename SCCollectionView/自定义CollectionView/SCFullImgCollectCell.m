//
//  SCFullImgCollectCell.m
//  AppFactory
//
//  Created by sobeycloud on 16/4/21.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import "SCFullImgCollectCell.h"

@implementation SCFullImgCollectCell

- (void)dealWithData:(NSDictionary *)dict {
    
    if ([dict objectForKey:@"icon"]) {
        self.icon.image = [UIImage imageNamed:dict[@"icon"]];
    }
    _cellData = dict;
}

- (CGSize)getSubCellSize {
    NSInteger size = [[_cellData objectForKey:@"size"] integerValue];
    return CGSizeMake(100 + 20 * size, 100);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor blueColor];
    // Initialization code
}

@end
