//
//  YZSfcBetViewController.h
//  ez
//
//  Created by apple on 14-12-12.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"
#import "YZChooseVoucherViewController.h"

@interface YZSfcBetViewController : YZBaseViewController
{
    NSString *_playType;
    int _playTypeTag;
    NSInteger _selectedMatchCount;//已选比赛场次
}
- (instancetype)initWithPlayTypeTag:(int)playTypeTag statusArray:(NSMutableArray *)statusArray;
@property (nonatomic, copy) NSString *gameId;//游戏id
@property (nonatomic, copy) NSString *termId;
@property (nonatomic, copy) NSString *playType;
@property (nonatomic, strong) NSMutableArray *statusArray;//数据源
@property (nonatomic, assign) int betCount;//注数
@property (nonatomic, assign) float amountMoney;//金额
@property (nonatomic, weak) UITextField *multipleTextField;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic,weak) UIButton *unionBuyBtn;
- (void)setAmountLabelText;
@end
