//
//  YZSegementCollectionViewCell.h
//  ez
//
//  Created by dahe on 2019/6/21.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZSegementCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isCurrentItem;
@property (nonatomic, copy) NSString * text;

- (UIView *)snapshotView;

@end

NS_ASSUME_NONNULL_END
