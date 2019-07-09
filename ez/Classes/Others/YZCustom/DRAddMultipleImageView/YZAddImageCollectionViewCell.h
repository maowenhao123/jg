//
//  YZAddImageCollectionViewCell.h
//  ez
//
//  Created by dahe on 2019/7/3.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZAddImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) NSInteger row;

- (UIView *)snapshotView;

@end

NS_ASSUME_NONNULL_END
