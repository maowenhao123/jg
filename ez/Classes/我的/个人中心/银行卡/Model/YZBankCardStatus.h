//
//  YZBankCardStatus.h
//  ez
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZBankCardStatus : NSObject

@property (nonatomic, copy) NSString *cardId;//银行卡Id
@property (nonatomic, copy) NSString *userId;//用户ID
@property (nonatomic, copy) NSString *bank;//银行名称
@property (nonatomic, copy) NSString *accountNumber;//银行卡号
@property (nonatomic, copy) NSString *accountName;//银行卡账户名

//自定义
@property (nonatomic, assign) BOOL isSelected;//是否选中的

@end
