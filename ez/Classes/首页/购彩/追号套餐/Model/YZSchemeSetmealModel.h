//
//  YZSchemeSetmealModel.h
//  ez
//
//  Created by 毛文豪 on 2018/7/11.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZSchemeSetmealInfoModel : NSObject

@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, strong) NSNumber *hitRatio;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) NSNumber *money;
@property (nonatomic, copy) NSString *moneyDesc;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *order;
@property (nonatomic, strong) NSNumber *termCount;
@property (nonatomic, strong) NSNumber *unhitReturnMoney;
@property (nonatomic, copy) NSString *unhitReturnMoneyDesc;

@end

@interface YZSchemeSetmealTypeModel : NSObject

@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, copy) NSString *name;

@end

@interface YZSchemeSetmealModel : NSObject

@property (nonatomic, strong) NSArray *infos;
@property (nonatomic, strong) YZSchemeSetmealTypeModel *type;

@end
