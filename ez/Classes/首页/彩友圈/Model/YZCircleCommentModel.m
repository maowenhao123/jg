//
//  YZCircleCommentModel.m
//  ez
//
//  Created by dahe on 2019/6/28.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZCircleCommentModel.h"
#import "YZDateTool.h"

@implementation YZTopicCommentReplyModel

- (CGFloat)cellH
{
    NSMutableAttributedString * commentAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", _userName, _content]];
    [commentAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:NSMakeRange(0, commentAttStr.length)];
    [commentAttStr addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:[commentAttStr.string rangeOfString:_byReplyUserName]];
    [commentAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:[commentAttStr.string rangeOfString:_content]];
    NSMutableParagraphStyle * commentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    commentParagraphStyle.lineSpacing = 5;
    [commentAttStr addAttribute:NSParagraphStyleAttributeName value:commentParagraphStyle range:NSMakeRange(0, commentAttStr.length)];
    _commentAttStr = commentAttStr;
    CGSize commentLabelSize = [commentAttStr boundingRectWithSize:CGSizeMake(screenWidth - 2 * YZMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    _commentLabelF = CGRectMake(YZMargin, 0, commentLabelSize.width, commentLabelSize.height + 2 * 9);
    return _commentLabelF.size.height;
}

@end

@implementation YZCircleCommentModel

- (CGFloat)cellH
{
    _avatarImageViewF = CGRectMake(YZMargin, 12, 36, 36);
    
    CGFloat viewX = CGRectGetMaxX(_avatarImageViewF) + 7;
    CGFloat viewW = screenWidth - YZMargin - viewX;
    
    //昵称
    CGSize nicknameLabelSize = [_userName sizeWithLabelFont:[UIFont systemFontOfSize:YZGetFontSize(28)]];
    _userNameLabelF = CGRectMake(viewX, 9 + 9, viewW, nicknameLabelSize.height);
    
    //时间
    _timeStr = [YZDateTool getTimeByTimestamp:_createTime format:@"yyyy-MM-dd HH:mm:ss"];
    CGSize timeLabelSize = [_timeStr sizeWithLabelFont:[UIFont systemFontOfSize:YZGetFontSize(24)]];
    _timeLabelF = CGRectMake(viewX, CGRectGetMaxY(_userNameLabelF) + 5, viewW, timeLabelSize.height);
    
    //评论内容
    NSMutableAttributedString * commentAttStr = [[NSMutableAttributedString alloc] initWithString:_content];
    [commentAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:NSMakeRange(0, commentAttStr.length)];
    NSMutableParagraphStyle * commentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    commentParagraphStyle.lineSpacing = 5;
    [commentAttStr addAttribute:NSParagraphStyleAttributeName value:commentParagraphStyle range:NSMakeRange(0, commentAttStr.length)];
    _commentAttStr = commentAttStr;
    CGSize commentLabelSize = [commentAttStr boundingRectWithSize:CGSizeMake(viewW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    _commentLabelF = CGRectMake(viewX, CGRectGetMaxY(_timeLabelF) + 9, commentLabelSize.width, commentLabelSize.height);
    
    //回复内容
    CGFloat lastViewMaxY = CGRectGetMaxY(_commentLabelF);
    if (_topicCommentReplys.count > 0) {
        NSMutableParagraphStyle * replyParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        replyParagraphStyle.lineSpacing = 7;
        replyParagraphStyle.headIndent = 10;
        replyParagraphStyle.tailIndent = -10;
        replyParagraphStyle.firstLineHeadIndent = 10;
        NSMutableAttributedString *replyAttStr = [[NSMutableAttributedString alloc] init];
        for (YZTopicCommentReplyModel * replyModel in _topicCommentReplys) {
            NSString *replyStr;
            if (replyModel == _topicCommentReplys.lastObject && [_replyCount intValue] <= _topicCommentReplys.count) {
                replyStr = [NSString stringWithFormat:@"%@：%@", replyModel.userName, replyModel.content];
            }else
            {
                replyStr = [NSString stringWithFormat:@"%@：%@\n", replyModel.userName, replyModel.content];
            }
            NSMutableAttributedString *replyAttStr_ = [[NSMutableAttributedString alloc] initWithString:replyStr];
            [replyAttStr_ addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:[replyAttStr_.string rangeOfString:replyModel.byReplyUserName]];
            [replyAttStr_ addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:[replyAttStr_.string rangeOfString:replyModel.content]];
            [replyAttStr appendAttributedString:replyAttStr_];
        }
        if ([_replyCount intValue] > _topicCommentReplys.count) {
           NSMutableAttributedString * replyAttStr_ = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"查看全部%@条评论", _replyCount]];
            [replyAttStr_ addAttribute:NSForegroundColorAttributeName value:YZDrayGrayTextColor range:NSMakeRange(0, replyAttStr_.length)];
            [replyAttStr appendAttributedString:replyAttStr_];
        }
        [replyAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:NSMakeRange(0, replyAttStr.length)];
        [replyAttStr addAttribute:NSParagraphStyleAttributeName value:replyParagraphStyle range:NSMakeRange(0, replyAttStr.length)];
        _replyAttStr = replyAttStr;
        CGSize replyLabelSize = [replyAttStr boundingRectWithSize:CGSizeMake(viewW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        _replyLabelF = CGRectMake(viewX, CGRectGetMaxY(_commentLabelF) + 9, viewW, replyLabelSize.height + 2 * 10);
        lastViewMaxY = CGRectGetMaxY(_replyLabelF);
    }
    
    _replyButtonF = CGRectMake(screenWidth - 70, lastViewMaxY + 5, 70, 30);
    
    _cellH = CGRectGetMaxY(_replyButtonF) + 9;
    return _cellH;
}

@end
