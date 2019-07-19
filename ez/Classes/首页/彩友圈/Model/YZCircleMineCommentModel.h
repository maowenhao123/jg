//
//  YZCircleMineCommentModel.h
//  ez
//
//  Created by dahe on 2019/6/28.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZCircleMineCommentModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *headPortraitUrl;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, copy) NSString *myMessage;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *topicId;

//自定义
@property (nonatomic,assign) BOOL isFirst;

@property (nonatomic, assign) CGRect avatarImageViewF;
@property (nonatomic, assign) CGRect userNameLabelF;
@property (nonatomic, copy) NSAttributedString *userNameAttStr;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, assign) CGRect timeLabelF;
@property (nonatomic, copy) NSAttributedString *commentAttStr;
@property (nonatomic, assign) CGRect commentLabelF;
@property (nonatomic, copy) NSAttributedString *myCommentAttStr;
@property (nonatomic, assign) CGRect myCommentLabelF;
@property (nonatomic, copy) NSAttributedString *titleAttStr;
@property (nonatomic, assign) CGRect titleLabelF;
@property (nonatomic, assign) CGFloat cellH;

@end

NS_ASSUME_NONNULL_END
