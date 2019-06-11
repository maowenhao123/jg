//
//  YZFCOrderDetailStatus.h
//  ez
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZOrder.h"

@interface YZFCOrderDetailStatus : NSObject

@property (nonatomic, assign) CGFloat cellH;//cell高度
@property (nonatomic, copy) NSMutableAttributedString *betNumber;//投注号码

@property (nonatomic, strong) YZOrder *order;
@property (nonatomic, strong) YZTicketList *ticketList;

@end
