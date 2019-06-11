//
//  YZCircleCommentModel.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZCircleCommentModel.h"

@implementation YZCircleCommentModel

- (CGFloat)cellH
{
    _avatarImageViewF = CGRectMake(YZMargin, 9, 36, 36);
    
    CGSize nickNameLabelSize = [_nickName sizeWithLabelFont:[UIFont systemFontOfSize:YZGetFontSize(26)]];
    _nickNameLabelF = CGRectMake(CGRectGetMaxX(_avatarImageViewF) + 5, 9, nickNameLabelSize.width, 36);
    
    _timeStr = @"123";
    CGSize timeLabelSize = [_timeStr sizeWithLabelFont:[UIFont systemFontOfSize:YZGetFontSize(22)]];
    _timeLabelF = CGRectMake(screenWidth - YZMargin - timeLabelSize.width, 9, timeLabelSize.width, 36);
    
    CGSize commentLabelSize = [_content sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(24)] maxSize:CGSizeMake(screenWidth - _nickNameLabelF.origin.x - YZMargin, MAXFLOAT)];
    _commentLabelF = CGRectMake(_nickNameLabelF.origin.x, CGRectGetMaxY(_nickNameLabelF), commentLabelSize.width, commentLabelSize.height);
    
    _cellH = CGRectGetMaxY(_commentLabelF) + 6;
    return _cellH;
}


@end
