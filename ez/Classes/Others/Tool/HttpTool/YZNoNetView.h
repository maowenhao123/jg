//
//  YZNoNetView.h
//  ez
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZNoNetViewDelegate  <NSObject>

- (void)reloadNetworkDataSource:(id)sender;

@end

@interface YZNoNetView : UIView

/**
 *  由代理控制器去执行刷新网络
 */
@property (nonatomic, strong) id<YZNoNetViewDelegate>delegate;

@end
