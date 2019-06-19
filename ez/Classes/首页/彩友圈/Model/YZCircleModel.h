//
//  YZCircleModel.h
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZCircleModel : NSObject

@property (nonatomic, copy) NSString * userId;//用户id
@property (nonatomic, copy) NSString * userHeadImg;//用户头像
@property (nonatomic, copy) NSString * nickName;//用户昵称
@property (nonatomic, assign) long long createTime;//创建时间
@property (nonatomic, copy) NSString * content;//内容
@property (nonatomic, copy) NSString * pics;//图片
@property (nonatomic, strong) NSNumber * commentCount;//评论数
@property (nonatomic, strong) NSNumber * focusCount;//关注数
@property (nonatomic, strong) NSNumber * praiseCount;//点赞数
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, copy) NSString * id;

//自定义
@property (nonatomic,assign) NSInteger index;

@property (nonatomic, assign)CGRect avatarImageViewF;
@property (nonatomic, assign)CGRect nickNameLabelF;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, assign) CGRect timeLabelF;
@property (nonatomic, copy) NSMutableAttributedString * detailAttStr;
@property (nonatomic, assign)CGRect detailLabelF;
@property (nonatomic, strong) NSMutableArray *imageViewFs;
@property (nonatomic, assign) CGFloat cellH;

@end
