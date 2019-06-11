//
//  YZInformationModel.h
//  ez
//
//  Created by 毛文豪 on 2019/3/27.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZInformationModel : NSObject

@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *game;
@property (nonatomic, strong) NSNumber *browseTimes;
@property (nonatomic, copy) NSString *detailUrl;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *imgPath;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, assign) long long publishTime;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
