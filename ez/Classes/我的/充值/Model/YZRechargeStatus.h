//
//  YZRechargeStatus.h
//  ez
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZRechargeStatus : NSObject

@property (nonatomic, copy) NSString *pId;//主键id
@property (nonatomic, copy) NSString *paymentId;//支付方式ID
@property (nonatomic, copy) NSString *clientId;//支付方式在客户端的ID
@property (nonatomic,copy) NSString *name;
@property (nonatomic, assign) int seqNo;//序号
@property (nonatomic, assign) long createDate;//创建时间
@property (nonatomic, assign) int status;//状态 2:启用 4:禁用
@property (nonatomic, copy) NSString *detailUrl;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *intro;//说明

@property (nonatomic, copy) NSString *imageName;//图片名称
@property (nonatomic, copy) NSString *title;//充值标题

@end
