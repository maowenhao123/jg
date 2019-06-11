//
//  YZKsSantongView.h
//  ez
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZKsBaseView.h"

@protocol KsSantongViewDelegate <NSObject>

- (void)santongViewSelectedButttons:(NSMutableArray *)selectedButttons;

@end

@interface YZKsSantongView : YZKsBaseView

@property (nonatomic, weak) id<KsSantongViewDelegate> santongDelegate;

@end
