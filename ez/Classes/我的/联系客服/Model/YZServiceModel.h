//
//  YZServiceModel.h
//  ez
//
//  Created by dahe on 2019/7/15.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZServiceModel : NSObject

@property (nonatomic, copy) NSString *entryId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description_;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *redirectType;
@property (nonatomic, copy) NSString *extendParams;

@end

NS_ASSUME_NONNULL_END
