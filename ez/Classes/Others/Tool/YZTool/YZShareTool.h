//
//  YZShareTool.h
//  ez
//
//  Created by dahe on 2020/9/4.
//  Copyright © 2020 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZShareTool : NSObject

+ (void)UMShareWithTitle:(NSString *)title content:(NSString *)content webpageUrl:(NSString *)webpageUrl thumImage:(id)thumImage;

@end

NS_ASSUME_NONNULL_END
