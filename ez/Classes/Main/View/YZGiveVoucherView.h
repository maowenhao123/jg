//
//  YZGiveVoucherView.h
//  ez
//
//  Created by 孔琪琪 on 2018/3/28.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGiveVoucherModel.h"

@interface YZGiveVoucherView : UIView

- (instancetype)initWithFrame:(CGRect)frame giveVoucherModel:(YZGiveVoucherModel *)giveVoucherModel;

@property (nonatomic, strong) UINavigationController *owerViewController;

@end
