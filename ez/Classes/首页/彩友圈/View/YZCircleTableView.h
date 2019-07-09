//
//  YZCircleTableView.h
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CircleNewTopic = 1,
    CircleCommunityTopic = 2,
    CircleConcernTopic = 3,
    CircleUserReleaseTopic = 4,
    CircleMineTopic = 5,
} CircleSourceType;

@protocol YZCircleTableViewDelegate <NSObject>

@optional;
- (void)circleTableViewDidScroll:(UIScrollView *)scrollView;

@end

@interface YZCircleTableView : UITableView

@property (nonatomic, weak) id<YZCircleTableViewDelegate> circleDelegate;

@property (nonatomic, assign) CircleSourceType type;

@property (nonatomic, copy) NSString * communityId;
@property (nonatomic, copy) NSString * playTypeId;
@property (nonatomic, copy) NSString * userId;

- (void)headerRefreshViewBeginRefreshing;
- (void)getData;

@end
