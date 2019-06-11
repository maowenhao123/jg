//
//  YZNoticeStatus.h
//  ez
//
//  Created by apple on 16/12/29.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZNoticeStatus : NSObject

@property (nonatomic, copy) NSString *noticeId;//主键id
@property (nonatomic, copy) NSString *message;//消息	
@property (nonatomic, copy) NSString *gameId;//彩种

@end
