//
//  YZAddImageManage.h
//  ez
//
//  Created by dahe on 2019/7/2.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AddImageManageDelegate <NSObject>

@optional
- (void)imageManageCropImage:(UIImage *)image;

@end

@interface YZAddImageManage : NSObject

@property (nonatomic, strong) UIViewController * viewController;
@property (nonatomic,assign) BOOL isSquare;
@property (nonatomic,assign) NSInteger tag;

- (void)addImage;

@property (nonatomic, weak) id <AddImageManageDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
