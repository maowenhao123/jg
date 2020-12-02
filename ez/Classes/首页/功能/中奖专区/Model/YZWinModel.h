//
//  YZWinModel.h
//  ezTests
//
//  Created by dahe on 2020/5/18.
//  Copyright © 2020 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZWinModel : NSObject

@property (nonatomic, copy) NSString * describe;
@property (nonatomic, copy) NSString * gameId;
@property (nonatomic, copy) NSString * hitDate;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * userHeadImage;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, assign) float money;//金额

@end

NS_ASSUME_NONNULL_END
