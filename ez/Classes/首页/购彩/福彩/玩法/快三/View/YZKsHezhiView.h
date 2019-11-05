//
//  YZKsHezhiView.h
//  ez
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZKsBaseView.h"

@protocol KsHezhiViewDelegate <NSObject>

- (void)hezhiViewSelectedButttons:(NSMutableArray *)selectedButttons;

@end

@interface YZKsHezhiView : YZKsBaseView

@property (nonatomic, weak) id<KsHezhiViewDelegate> hezhiDelegate;

@end
