//
//  YZKsSanbutongView.h
//  ez
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZKsBaseView.h"

@protocol KsSanbutongViewDelegate <NSObject>

- (void)sanbutongViewSelectedButttons:(NSMutableArray *)selectedButttons;

@end

@interface YZKsSanbutongView : YZKsBaseView

@property (nonatomic, weak) id<KsSanbutongViewDelegate> sanbutongDelegate;

@end
