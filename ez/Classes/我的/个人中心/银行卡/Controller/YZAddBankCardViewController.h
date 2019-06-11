//
//  YZAddBankCardViewController.h
//  ez
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"

@protocol YZAddBankCardDelegate <NSObject>

- (void)addBankSuccess;//添加银行卡成功，返回上一页吗刷新数据

@end

@interface YZAddBankCardViewController : YZBaseViewController

@property (nonatomic, weak) id<YZAddBankCardDelegate> delegate;

@end
