//
//  YZCircleModel.h
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZTicketList.h"

@interface YZCircleExtModel : NSObject

@property (nonatomic, strong) NSNumber * commission;
@property (nonatomic, copy) NSString * gameId;
@property (nonatomic, copy) NSString * gameName;
@property (nonatomic, strong) NSNumber * issue;
@property (nonatomic, copy) NSString * matchGames;
@property (nonatomic, strong) NSNumber * money;
@property (nonatomic, strong) NSNumber * multiple;
@property (nonatomic, copy) NSString * orderId;
@property (nonatomic, strong) NSNumber * settings;
@property (nonatomic, copy) NSString * unionBuyUserId;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, strong) NSArray * ticketList;

@end

@interface YZCircleModel : NSObject

@property (nonatomic, copy) NSString * communityId;
@property (nonatomic, copy) NSString * communityName;
@property (nonatomic, strong) NSNumber * concernNumber;//关注数
@property (nonatomic, strong) NSNumber * concernStatus;
@property (nonatomic, copy) NSString * content;//内容
@property (nonatomic, assign) long long createTime;//创建时间
@property (nonatomic, copy) NSString * headPortraitUrl;//用户头像
@property (nonatomic, strong) NSNumber * likeNumber;//点赞数
@property (nonatomic, strong) NSNumber * likeStatus;
@property (nonatomic, copy) NSString * nickname;//用户昵称
@property (nonatomic, copy) NSString * userName;//用户昵称
@property (nonatomic, copy) NSString * topicId;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, copy) NSString * userId;//用户id
@property (nonatomic, strong) NSArray * topicAlbumList;//图片
@property (nonatomic, strong) YZCircleExtModel *extInfo;
@property (nonatomic,assign) BOOL isDetail;
//自定义
@property (nonatomic,assign) NSInteger index;

@property (nonatomic, assign)CGRect avatarImageViewF;
@property (nonatomic, assign)CGRect nickNameLabelF;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, assign) CGRect timeLabelF;
@property (nonatomic, assign) CGRect communityLabelF;
@property (nonatomic, assign) CGRect attentionButonF;
@property (nonatomic, copy) NSMutableAttributedString * detailAttStr;
@property (nonatomic, assign)CGRect detailLabelF;
@property (nonatomic, assign)CGRect lotteryViewF;
@property (nonatomic, strong) NSArray * lotteryMessages;
@property (nonatomic, strong) NSMutableArray *labelFs;
@property (nonatomic, assign)CGRect logoImageViewF;
@property (nonatomic, strong) NSMutableArray *imageViewFs;
@property (nonatomic, assign)CGRect followtButtonF;
@property (nonatomic, assign) CGFloat cellH;

@end
