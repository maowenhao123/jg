//
//  YZCircleCommentListView.h
//  ez
//
//  Created by dahe on 2019/6/28.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZCircleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZCircleCommentListView : UIView

- (instancetype)initWithTopicId:(NSString *)topicId commentId:(NSString *)commentId;

- (void)show;

@property (nonatomic, strong) YZCircleModel *circleModel;

@end

NS_ASSUME_NONNULL_END
