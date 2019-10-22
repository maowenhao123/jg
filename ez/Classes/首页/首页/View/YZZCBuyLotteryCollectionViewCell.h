//
//  YZZCBuyLotteryCollectionViewCell.h
//  ez
//
//  Created by 毛文豪 on 2017/9/26.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZBuyLotteryCellStatus.h"

@interface YZZCBuyLotteryCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) YZBuyLotteryCellStatus * status;
@property (nonatomic, weak) UIView *line1;//下分割线
@property (nonatomic, weak) UIView *line2;//右分割线
@property (nonatomic, assign) NSInteger index;

@end
