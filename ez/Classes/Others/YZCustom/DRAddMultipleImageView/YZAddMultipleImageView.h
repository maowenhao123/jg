//
//  YZAddMultipleImageView.h
//  ez
//
//  Created by dahe on 2019/7/3.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZAddImageCollectionViewCell.h"

@protocol AddMultipleImageViewDelegate <NSObject>

@optional
- (void)viewHeightchange;

@end

@interface YZAddMultipleImageView : UIView

@property (nonatomic,weak) UICollectionView *collectionView;

@property (nonatomic, weak) UILabel * titleLabel;

@property (nonatomic, strong) NSMutableArray * images;

@property (nonatomic, assign) int maxImageCount;

- (void)setImagesWithImageUrlStrs:(NSArray *)imageUrlStrs;

- (CGFloat)getViewHeight;

@property (nonatomic, assign) id <AddMultipleImageViewDelegate> delegate;

@end
