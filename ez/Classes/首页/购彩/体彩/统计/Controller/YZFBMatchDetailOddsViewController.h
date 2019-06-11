//
//  YZFBMatchDetailOddsViewController.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"
#import "YZOddsCellStatus.h"

@interface YZFBMatchDetailOddsViewController : YZBaseViewController

@property (nonatomic, strong) NSArray *oddsCells;
@property (nonatomic, copy) NSString *companyId;//公司Id
@property (nonatomic, assign) NSInteger selectedIndex;//选中的
@property (nonatomic, copy) NSString *roundNum;//赛事ID
@property (nonatomic, assign) NSInteger oddsType;//赔率类型 0.欧赔 1.亚盘 2.大小盘

@end
