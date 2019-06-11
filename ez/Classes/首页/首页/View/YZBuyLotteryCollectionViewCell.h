//
//  YZBuyLotteryCollectionViewCell.h
//  ez
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZBuyLotteryCellStatus.h"

@interface YZBuyLotteryCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) YZBuyLotteryCellStatus * status;
@property (nonatomic, weak) UIView *line2;//右分割线

@end
