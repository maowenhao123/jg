//
//  YZKsErbutongView.h
//  ez
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZKsBaseView.h"

@protocol KsErbutongViewDelegate <NSObject>

- (void)erbutongViewSelectedButttons:(NSMutableArray *)selectedButttons;

@end

@interface YZKsErbutongView : YZKsBaseView

@property (nonatomic, weak) id<KsErbutongViewDelegate> erbutongDelegate;

@end
