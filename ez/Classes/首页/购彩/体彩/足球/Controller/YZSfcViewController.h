//
//  YZSfcViewController.h
//  ez
//
//  Created by apple on 14-12-12.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZFootBallBaseViewController.h"

@interface YZSfcViewController : YZFootBallBaseViewController
{
    NSMutableArray *_termIds;//期数的数组
    NSArray *_minMatchCounts;//最少要求选择的比赛场次数
    int _betCount;
    int _selectedTermIdBtnTag;//选中期数按钮的tag
    int _selectedMatchCount;//已选比赛场次
}
@property (nonatomic, strong) NSMutableArray *statusArray;
- (void)setBottomMidLabelText;
- (NSMutableArray *)getBetStatus;

@end
