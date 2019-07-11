//
//  YZCircleModel.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZCircleModel.h"
#import "YZDateTool.h"

@implementation YZCircleExtModel

@end

@implementation YZCircleModel

- (CGFloat)cellH
{
    CGFloat viewX;
    CGFloat viewW;
   
    if (_circleTableViewType == CircleTableViewUser || _circleTableViewType == CircleTableViewMine) {
        NSString * timeStr = [YZDateTool getTimeByTimestamp:_createTime format:@"dd MM月"];
        NSMutableAttributedString * timeAttStr = [[NSMutableAttributedString alloc] initWithString:timeStr];
        [timeAttStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:YZGetFontSize(50)] range:NSMakeRange(0, 2)];
        [timeAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(30)] range:NSMakeRange(2, timeAttStr.length - 2)];
        [timeAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, timeAttStr.length)];
        _timeAttStr = timeAttStr;
        CGSize timeLabelSize = [timeAttStr boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        _timeLabelF = CGRectMake(YZMargin, 9 + 15, timeLabelSize.width, timeLabelSize.height);
        
        viewX = CGRectGetMaxX(_timeLabelF) + 5;
        viewW = screenWidth - YZMargin - viewX;
    }else
    {
        _avatarImageViewF = CGRectMake(YZMargin, 9 + 9, 36, 36);
        
        viewX = CGRectGetMaxX(_avatarImageViewF) + 7;
        viewW = screenWidth - YZMargin - viewX;
        
        CGSize nicknameLabelSize = [_nickname ? _nickname : _userName sizeWithLabelFont:[UIFont systemFontOfSize:YZGetFontSize(28)]];
        _nickNameLabelF = CGRectMake(viewX, 9 + 9, viewW, nicknameLabelSize.height);
        
        NSString * timeStr = [YZDateTool getTimeByTimestamp:_createTime format:@"yyyy-MM-dd HH:mm:ss"];
        NSAttributedString * timeAttStr = [[NSAttributedString alloc] initWithString:timeStr];
        _timeAttStr = timeAttStr;
        CGSize timeLabelSize = [timeAttStr boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        _timeLabelF = CGRectMake(viewX, CGRectGetMaxY(_nickNameLabelF) + 6, viewW, timeLabelSize.height);
    }
    
    if (_circleTableViewType == CircleTableViewDetail) {
        _attentionButonF = CGRectMake(screenWidth - YZMargin - 60, 9 + 9 + (36 - 26) / 2, 60, 26);
    }else
    {
        CGSize communityLabelSize = [_communityName sizeWithLabelFont:[UIFont systemFontOfSize:YZGetFontSize(26)]];
        _communityLabelF = CGRectMake(screenWidth - YZMargin - communityLabelSize.width, 9 + 9, communityLabelSize.width, 36);
    }
    
    CGFloat lastViewMaxY = CGRectGetMaxY(_timeLabelF);
    if (!YZStringIsEmpty(_content)) {
        NSMutableAttributedString * detailAttStr = [[NSMutableAttributedString alloc] initWithString:_content];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;//行间距
        [detailAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, detailAttStr.length)];
        [detailAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(0, detailAttStr.length)];
        _detailAttStr = detailAttStr;
        
        CGSize detailLabelSize = [detailAttStr boundingRectWithSize:CGSizeMake(viewW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        _detailLabelF = CGRectMake(viewX, lastViewMaxY + 9, detailLabelSize.width, detailLabelSize.height);
        lastViewMaxY = CGRectGetMaxY(_detailLabelF);
    }
    
    _lotteryMessages = [NSMutableArray array];
    if ([_type intValue] == 1) {
        NSString * schemeContent = @"方案内容：";
        for (YZTicketList * ticketModel in _extInfo.ticketList) {
            NSString * betTypeStr = [ticketModel.betType isEqualToString:@"00"] ? @"[单式]" : @"[复式]";
            NSString *numbers = ticketModel.numbers;
            numbers = [numbers stringByReplacingOccurrencesOfString:@";" withString:[NSString stringWithFormat:@"%@\n", betTypeStr]];
            NSString * schemeContent_ = [NSString stringWithFormat:@"\n%@%@\n倍数：%@倍 注数：%@注", numbers, betTypeStr, ticketModel.multiple, ticketModel.count];
            schemeContent = [NSString stringWithFormat:@"%@%@", schemeContent, schemeContent_];
        }
        NSMutableAttributedString * schemeContentAttStr = [[NSMutableAttributedString alloc] initWithString:schemeContent];
        [schemeContentAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:NSMakeRange(5, schemeContentAttStr.length - 5)];
        [schemeContentAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(0, 5)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [schemeContentAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(5, schemeContentAttStr.length - 5)];
        NSArray * lotteryMessages = @[[NSString stringWithFormat:@"宣言：%@", YZStringIsEmpty(_extInfo.description_) ? @"暂无" : _extInfo.description_],
                                      [NSString stringWithFormat:@"%@ 第%@期", [YZTool gameIdNameDict][_extInfo.gameId], _extInfo.issue],
                                      [NSString stringWithFormat:@"倍数：%@", _extInfo.multiple],
                                      [NSString stringWithFormat:@"金额：%.2f", [_extInfo.money floatValue] / 100],
                                      [NSString stringWithFormat:@"佣金：%@%%", _extInfo.commission],
                                      [NSString stringWithFormat:@"方案：%@", [YZTool getSecretStatus:[_extInfo.settings integerValue]]]];
        NSMutableArray *lotteryMessages_mu = [NSMutableArray arrayWithArray:lotteryMessages];
        if (_circleTableViewType == CircleTableViewDetail && [_extInfo.settings intValue] == 1) {
            [lotteryMessages_mu addObject:schemeContentAttStr];
        }
        CGFloat lastLabelMaxY = 3;
        _labelFs = [NSMutableArray array];
        CGFloat logoImageViewWH = 60;
        for (int i = 0; i < lotteryMessages_mu.count; i++) {
            CGSize labelSize;
            id lotteryMessage = lotteryMessages_mu[i];
            if ([lotteryMessage isKindOfClass:[NSAttributedString class]]) {
                labelSize = [lotteryMessage boundingRectWithSize:CGSizeMake(viewW - 2 * YZMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                [_lotteryMessages addObject:lotteryMessage];
            }else
            {
                NSMutableAttributedString * lotteryMessageAttStr = [[NSMutableAttributedString alloc] initWithString:lotteryMessage];
                if (i == 0) {
                    [lotteryMessageAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:NSMakeRange(0, lotteryMessageAttStr.length)];
                    labelSize = [lotteryMessageAttStr boundingRectWithSize:CGSizeMake(viewW - 2 * YZMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                }else
                {
                    [lotteryMessageAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(0, lotteryMessageAttStr.length)];
                    labelSize = [lotteryMessageAttStr boundingRectWithSize:CGSizeMake(viewW - 3 * YZMargin - logoImageViewWH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                }
                [_lotteryMessages addObject:lotteryMessageAttStr];
            }
            CGRect labelF = CGRectMake(YZMargin, lastLabelMaxY + 9, labelSize.width, labelSize.height);
            if (i == 1) {
                labelF = CGRectMake(YZMargin, lastLabelMaxY + 15, labelSize.width, labelSize.height);
            }
            [_labelFs addObject:[NSValue valueWithCGRect:labelF]];
            lastLabelMaxY = CGRectGetMaxY(labelF);
        }
        CGRect labelF1 = [_labelFs[0] CGRectValue];
        CGRect labelF5 = [_labelFs[4] CGRectValue];
        CGFloat logoMaxH = CGRectGetMaxY(labelF5) - CGRectGetMaxY(labelF1);
        if (_circleTableViewType == CircleTableViewDetail) {
            _followtButtonF = CGRectMake(YZMargin * 2, lastLabelMaxY + 9, viewW - 2 * 2 * YZMargin, 35);
            lastLabelMaxY = CGRectGetMaxY(_followtButtonF);
        }
        _lotteryViewF = CGRectMake(viewX, lastViewMaxY + 9, viewW, lastLabelMaxY + 12);
        _logoImageViewF = CGRectMake(viewW - YZMargin - logoImageViewWH, CGRectGetMaxY(labelF1) + (logoMaxH - logoImageViewWH) / 2, logoImageViewWH, logoImageViewWH);
        lastViewMaxY = CGRectGetMaxY(_lotteryViewF);
    }
    
    NSInteger imageCount = _topicAlbumList.count;//图片数量
    _imageViewFs = [NSMutableArray array];
    if (imageCount == 0) {
        _imageViewFs = [NSMutableArray array];
    }else if (imageCount == 1)
    {
        CGRect imageViewF = CGRectMake(viewX, lastViewMaxY + 9, viewW, viewW);
        [_imageViewFs addObject:[NSValue valueWithCGRect:imageViewF]];
        lastViewMaxY = CGRectGetMaxY(imageViewF);
    }else
    {
        CGFloat imageViewPadding = 5;
        CGFloat imageViewWH = (viewW - imageViewPadding * 2) / 3;
        for (int i = 0; i < imageCount; i++) {
            CGRect imageViewF = CGRectMake(viewX + (imageViewWH + imageViewPadding) * (i % 3), lastViewMaxY + 9 + (imageViewWH + imageViewPadding) * (i / 3), imageViewWH, imageViewWH);
            [_imageViewFs addObject:[NSValue valueWithCGRect:imageViewF]];
            if (i == imageCount - 1) {
              lastViewMaxY = CGRectGetMaxY(imageViewF);
            }
        }
    }
    
    if (_circleTableViewType == CircleTableViewDetail) {
        _cellH = lastViewMaxY + 12;
    }else
    {
        _cellH = lastViewMaxY + 5 + 26 + 5;
        
    }
    
    return _cellH;
}

@end
