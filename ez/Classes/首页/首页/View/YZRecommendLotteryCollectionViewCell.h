//
//  YZRecommendLotteryCollectionViewCell.h
//  ez
//
//  Created by 毛文豪 on 2018/1/10.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZQuickStakeGameModel.h"
#import "YZUnionBuyStatus.h"

@interface YZRecommendLotteryCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) YZQuickStakeGameModel *gameModel;
@property (nonatomic, strong) YZUnionBuyStatus *unionBuyStatus;

@end
