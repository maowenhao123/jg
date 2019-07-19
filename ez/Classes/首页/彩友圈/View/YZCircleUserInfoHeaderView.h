//
//  YZCircleUserInfoHeaderView.h
//  ez
//
//  Created by dahe on 2019/6/27.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZCircleUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZCircleUserInfoHeaderView : UIView

@property (nonatomic, assign) BOOL canChooseAvatar;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, strong) YZCircleUserInfoModel *userInfoModel;

@end

NS_ASSUME_NONNULL_END
