//
//  ViewController.m
//  SCCollectionView
//
//  Created by sobeycloud on 16/6/20.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import "ViewController.h"
#import "SCCollectionViewLayout.h"
#import "SCCollectionView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.view.backgroundColor = [UIColor whiteColor];
    SCCollectionViewLayout *flowLayout = [[SCCollectionViewLayout alloc] init];
    flowLayout.cellEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.lineSpacing = 10;
    flowLayout.interitemSpacing = 10;
    flowLayout.headerSize = CGSizeMake(screenWidth, 40);
    flowLayout.footerSize = CGSizeMake(screenWidth, 40);
    SCCollectionView *collectionView = [[SCCollectionView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, screenHeight) Layout:flowLayout CellClassNames:@[@"SCFullImgCollectCell"]];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    [collectionView setCellChooseBlock:^int(NSDictionary *data, NSIndexPath *indexPath) {
        return 0;
    }];
    [flowLayout setDynamicSetCelllineSpacing:^CGFloat(NSIndexPath *indexPath) {
        return indexPath.section * 20 + 10;
    }];
    [flowLayout setDynamicSetHeaderlineSpacing:^CGFloat(NSInteger section) {
        return section * 10;
    }];
    [flowLayout setDynamicSetFooterlineSpacing:^CGFloat(NSInteger section) {
        return section * 10 + 10;
    }];
    [flowLayout setDynamicSetHeaderSize:^CGSize(NSInteger section) {
        if (section == 0) {
            return CGSizeMake(screenWidth, 40);
        }
        return CGSizeMake(screenWidth, 10);
    }];
    [flowLayout setDynamicSetFooterSize:^CGSize(NSInteger section) {
        if (section == 0) {
            return CGSizeMake(screenWidth, 60);
        }
        return CGSizeMake(screenWidth, 125);
    }];
    [collectionView setSectionHeaderBlock:^UICollectionReusableView *(UICollectionReusableView *header, NSInteger section) {
        header.backgroundColor = [UIColor redColor];
        return header;
    }];
    [collectionView setSectionFooterBlock:^UICollectionReusableView *(UICollectionReusableView *footer, NSInteger section) {
        footer.backgroundColor = [UIColor orangeColor];
        return footer;
    }];
    [collectionView setInfoWithDataSource:@[@[@{@"title":@"cell",@"size":@"0"},@{@"title":@"cell",@"size":@"1"},@{@"title":@"cell",@"size":@"2"},@{@"title":@"cell",@"size":@"3"},@{@"title":@"cell",@"size":@"4"}],@[@{@"title":@"cell",@"size":@"0"},@{@"title":@"cell",@"size":@"1"},@{@"title":@"cell",@"size":@"2"},@{@"title":@"cell",@"size":@"3"},@{@"title":@"cell",@"size":@"4"}]]];
    [collectionView setCellResponseBlock:^(NSDictionary *data, NSIndexPath *indexPath) {
        NSLog(@"section %ld row %ld",indexPath.section,indexPath.row);
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
