//
//  YZGridViewFlowLayout.h
//  ez
//
//  Created by dahe on 2019/7/3.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZAddImageCollectionViewCell.h"
#import "UIView+Layout.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZGridViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,assign) BOOL panGestureRecognizerEnable;

@end

@protocol YZGridViewDataSource <UICollectionViewDataSource>

@optional

- (void)collectionView:(UICollectionView *)collectionView
       itemAtIndexPath:(NSIndexPath *)sourceIndexPath
   willMoveToIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)collectionView:(UICollectionView *)collectionView
       itemAtIndexPath:(NSIndexPath *)sourceIndexPath
    didMoveToIndexPath:(NSIndexPath *)destinationIndexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView
       itemAtIndexPath:(NSIndexPath *)sourceIndexPath
    canMoveToIndexPath:(NSIndexPath *)destinationIndexPath;

@end

@protocol YZGridViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

@optional

- (void)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
