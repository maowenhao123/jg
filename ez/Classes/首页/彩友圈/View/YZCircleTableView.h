//
//  YZCircleTableView.h
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZCircleTableViewDelegate <NSObject>

@optional;
- (void)circleTableViewDidScroll:(UIScrollView *)scrollView;

@end

@interface YZCircleTableView : UITableView

@property (nonatomic, weak) id<YZCircleTableViewDelegate> circleDelegate;


@end
