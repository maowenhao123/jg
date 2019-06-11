//
//  YZThirdPartyBindingViewController.h
//  ez
//
//  Created by apple on 16/12/15.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"
#import "YZThirdPartyStatus.h"

@interface YZThirdPartyBindingViewController : YZBaseViewController

@property (nonatomic, strong) NSNumber *type;;//第三方登陆平台类型
@property (nonatomic, copy) NSString *param;//json格式
@property (nonatomic, copy) NSString *imei;//注册imei.
@property (nonatomic, strong) YZThirdPartyStatus *thirdPartyStatus;

@end
