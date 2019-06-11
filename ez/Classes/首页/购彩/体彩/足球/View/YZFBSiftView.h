//
//  YZFBSiftView.h
//  ez
//
//  Created by 毛文豪 on 2019/5/10.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YZFBSiftViewDelegate <NSObject>

- (void)siftDidClickWithSelectedMatchNames:(NSArray *)selectedMatchNames;

@end

@interface YZFBSiftView : UIView

- (instancetype)initWithFrame:(CGRect)frame matchNameArray:(NSArray *)matchNameArray;

- (void)show;

- (void)hidden;

@property (nonatomic, weak) id<YZFBSiftViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
