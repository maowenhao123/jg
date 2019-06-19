//
//  YZCircleCommentModel.h
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZCircleCommentModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, copy) NSString *nickName;

//自定义
@property (nonatomic,assign) BOOL isFirst;

@property (nonatomic, assign)CGRect avatarImageViewF;
@property (nonatomic, assign) CGRect nickNameLabelF;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, assign) CGRect timeLabelF;
@property (nonatomic, assign) CGRect commentLabelF;
@property (nonatomic, assign) CGFloat cellH;


@end
