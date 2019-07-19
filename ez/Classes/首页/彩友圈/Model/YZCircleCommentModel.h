//
//  YZCircleCommentModel.h
//  ez
//
//  Created by dahe on 2019/6/28.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZTopicCommentReplyModel : NSObject

@property (nonatomic, copy) NSString *byReplyUserId;
@property (nonatomic, copy) NSString *byReplyUserName;
@property (nonatomic, copy) NSString *byReplyUserHeadPortraitUrl;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, copy) NSString *headPortraitUrl;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *topicCommentId;
@property (nonatomic, copy) NSString *topicCommentReplyId;
@property (nonatomic, copy) NSString *topicId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSAttributedString *commentAttStr;
@property (nonatomic, assign) CGRect commentLabelF;
@property (nonatomic, assign) CGFloat cellH;

@end

@interface YZCircleCommentModel : NSObject

@property (nonatomic, copy) NSString *byCommentUserId;
@property (nonatomic, copy) NSString *byCommentUserName;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, copy) NSString *headPortraitUrl;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *topicId;
@property (nonatomic, strong) NSNumber *replyCount;
@property (nonatomic, strong) NSArray *topicCommentReplys;
@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) CGRect avatarImageViewF;
@property (nonatomic, assign) CGRect userNameLabelF;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, assign) CGRect timeLabelF;
@property (nonatomic, copy) NSAttributedString *commentAttStr;
@property (nonatomic, assign) CGRect commentLabelF;
@property (nonatomic, copy) NSAttributedString *replyAttStr;
@property (nonatomic, assign) CGRect replyLabelF;
@property (nonatomic, assign) CGRect replyButtonF;
@property (nonatomic, assign) CGFloat cellH;

@end

NS_ASSUME_NONNULL_END
