//
//  YZEditSegementView.h
//  ez
//
//  Created by dahe on 2019/6/20.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YZEditSegementViewDelegate <NSObject>

- (void)editSegementDidCompleteWithBtnTitles:(NSMutableArray *)btnTitles currentText:(NSString *)currentText;
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath;

@end

@interface YZEditSegementView : UIView

- (instancetype)initWithBtnTitles:(NSMutableArray *)btnTitles currentText:(NSString *)currentText;

- (void)show;

@property (nonatomic, weak) id<YZEditSegementViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
