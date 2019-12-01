//
//  YZKsHistoryTableView.h
//  ez
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KsHistoryViewDelegate <NSObject>

- (void)historyViewRecentStatus:(NSArray *)recentStatus;

@end

@interface YZKsHistoryTableView : UITableView

@property (nonatomic, weak) id<KsHistoryViewDelegate> historyDelegate;

@end
