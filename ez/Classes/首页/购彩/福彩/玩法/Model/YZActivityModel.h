//
//  YZActivityModel.h
//  ez
//
//  Created by 毛文豪 on 2018/12/25.
//  Copyright © 2018 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZActivityModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *picAddr;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *open;
@property (nonatomic, assign) long long createDate;

@end

NS_ASSUME_NONNULL_END
