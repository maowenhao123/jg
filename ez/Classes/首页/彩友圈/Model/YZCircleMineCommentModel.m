//
//  YZCircleMineCommentModel.m
//  ez
//
//  Created by dahe on 2019/6/28.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZCircleMineCommentModel.h"
#import "YZDateTool.h"

@implementation YZCircleMineCommentModel

- (CGFloat)cellH
{
    _avatarImageViewF = CGRectMake(YZMargin, 12, 36, 36);
    
    CGFloat viewX = CGRectGetMaxX(_avatarImageViewF) + 7;
    CGFloat viewW = screenWidth - YZMargin - viewX;
    
    //昵称
    NSMutableAttributedString * userNameAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 回复了您", _userName]];
    [userNameAttStr addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:[userNameAttStr.string rangeOfString:_userName]];
    [userNameAttStr addAttribute:NSForegroundColorAttributeName value:YZDrayGrayTextColor range:[userNameAttStr.string rangeOfString:@"回复了您"]];
    [userNameAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:NSMakeRange(0, userNameAttStr.length)];
    _userNameAttStr = userNameAttStr;
    
    CGSize userNameLabelSize = [userNameAttStr boundingRectWithSize:CGSizeMake(viewW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    _userNameLabelF = CGRectMake(viewX, 12, viewW, userNameLabelSize.height);
    
    //时间
    _timeStr = [YZDateTool getTimeByTimestamp:_createTime format:@"yyyy-MM-dd HH:mm:ss"];
    CGSize timeLabelSize = [_timeStr sizeWithLabelFont:[UIFont systemFontOfSize:YZGetFontSize(24)]];
    _timeLabelF = CGRectMake(viewX, CGRectGetMaxY(_userNameLabelF) + 5, viewW, timeLabelSize.height);
    
    //评论内容
    NSMutableAttributedString * commentAttStr = [[NSMutableAttributedString alloc] initWithString:_content];
    [commentAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(0, commentAttStr.length)];
    NSMutableParagraphStyle * commentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    commentParagraphStyle.lineSpacing = 5;
    [commentAttStr addAttribute:NSParagraphStyleAttributeName value:commentParagraphStyle range:NSMakeRange(0, commentAttStr.length)];
    _commentAttStr = commentAttStr;
    CGSize commentLabelSize = [commentAttStr boundingRectWithSize:CGSizeMake(viewW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    _commentLabelF = CGRectMake(viewX, CGRectGetMaxY(_timeLabelF) + 7, commentLabelSize.width, commentLabelSize.height);
    
    //我的评论
    NSMutableAttributedString * myCommentAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我：%@", _myMessage]];
    [myCommentAttStr addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:[myCommentAttStr.string rangeOfString:@"我："]];
    [myCommentAttStr addAttribute:NSForegroundColorAttributeName value:YZDrayGrayTextColor range:[myCommentAttStr.string rangeOfString:_myMessage]];
    [myCommentAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(0, myCommentAttStr.length)];
    NSMutableParagraphStyle * myCommentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    myCommentParagraphStyle.lineSpacing = 5;
    myCommentParagraphStyle.headIndent = 7;
    myCommentParagraphStyle.tailIndent = -7;
    myCommentParagraphStyle.firstLineHeadIndent = 7;
    [myCommentAttStr addAttribute:NSParagraphStyleAttributeName value:myCommentParagraphStyle range:NSMakeRange(0, myCommentAttStr.length)];
    _myCommentAttStr = myCommentAttStr;
    
    CGSize myCommentLabelSize = [myCommentAttStr boundingRectWithSize:CGSizeMake(viewW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    _myCommentLabelF = CGRectMake(viewX, CGRectGetMaxY(_commentLabelF) + 7, viewW, myCommentLabelSize.height + 2 * 7);
    
    //原文
    NSMutableAttributedString * titleAttStr = [[NSMutableAttributedString alloc] initWithString:_title];
    [titleAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(0, titleAttStr.length)];
    [titleAttStr addAttribute:NSParagraphStyleAttributeName value:myCommentParagraphStyle range:NSMakeRange(0, titleAttStr.length)];
    _titleAttStr = titleAttStr;
    
    CGSize titleLabelSize = [titleAttStr boundingRectWithSize:CGSizeMake(screenWidth - 2 * YZMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    _titleLabelF = CGRectMake(YZMargin, CGRectGetMaxY(_myCommentLabelF) + 12, screenWidth - 2 * YZMargin, titleLabelSize.height + 2 * 7);
    
    _cellH = CGRectGetMaxY(_titleLabelF) + 12;
    return _cellH;
}

@end
