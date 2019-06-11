//
//  YZKsErtongView.h
//  ez
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZKsBaseView.h"

@protocol KsErtongViewDelegate <NSObject>

- (void)ertongViewSelectedButttons:(NSMutableArray *)selectedButttons;

@end

@interface YZKsErtongView : YZKsBaseView

@property (nonatomic, weak) id<KsErtongViewDelegate> ertongDelegate;

@end
