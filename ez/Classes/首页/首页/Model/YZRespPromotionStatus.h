//
//  YZRespPromotionStatus.h
//  ez
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZRespPromotionStatus : NSObject

@property (nonatomic, copy) NSString *respAdvId;//id
@property (nonatomic, copy) NSString *picAddr;//图片url
@property (nonatomic, copy) NSString *showAddr;//详情html
@property (nonatomic, assign) long startDate;//开始时间
@property (nonatomic, assign) long endDate;//结束时间
@property (nonatomic, copy) NSString *remark;//备注
@property (nonatomic, copy) NSString *title;//标题

@end
