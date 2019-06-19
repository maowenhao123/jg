//
//  YZCircleModel.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZCircleModel.h"

@implementation YZCircleModel

- (CGFloat)cellH
{
    _avatarImageViewF = CGRectMake(YZMargin, 9 + 9, 36, 36);
    
    CGFloat viewX = CGRectGetMaxX(_avatarImageViewF) + 7;
    CGFloat viewW = screenWidth - YZMargin - viewX;
    
    CGSize titleLabelSize = [_nickName sizeWithLabelFont:[UIFont systemFontOfSize:YZGetFontSize(28)]];
    _nickNameLabelF = CGRectMake(viewX, 9 + 9, viewW, titleLabelSize.height);
    
    _timeStr = [NSString stringWithFormat:@"%lld", _createTime];
    CGSize timeLabelSize = [_timeStr sizeWithLabelFont:[UIFont systemFontOfSize:YZGetFontSize(24)]];
    _timeLabelF = CGRectMake(viewX, CGRectGetMaxY(_nickNameLabelF) + 3, viewW, timeLabelSize.height);
    
    NSMutableAttributedString * detailAttStr = [[NSMutableAttributedString alloc] initWithString:_content];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;//行间距
    [detailAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, detailAttStr.length)];
    [detailAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(0, detailAttStr.length)];
    _detailAttStr = detailAttStr;
    
    CGSize detailLabelSize = [detailAttStr boundingRectWithSize:CGSizeMake(viewW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    _detailLabelF = CGRectMake(viewX, CGRectGetMaxY(_avatarImageViewF) + 9, detailLabelSize.width, detailLabelSize.height);
    
    CGFloat lastViewMaxY = CGRectGetMaxY(_detailLabelF);
    NSArray * imageUrls = [_pics componentsSeparatedByString:@"|"];
    NSInteger imageCount = self.imageCount;//图片数量
    _imageViewFs = [NSMutableArray array];
    if (imageCount == 0) {
        _imageViewFs = [NSMutableArray array];
    }else if (imageCount == 1)
    {
//        NSString * imageUrl = imageUrls[0];
//        if (YZStringIsEmpty(imageUrl)) {
//            _imageViewFs = [NSMutableArray array];
//        }else
//        {
            CGRect imageViewF = CGRectMake(viewX, lastViewMaxY + 9, viewW, viewW);
            [_imageViewFs addObject:[NSValue valueWithCGRect:imageViewF]];
            lastViewMaxY = CGRectGetMaxY(imageViewF);
//        }
    }else
    {
        CGFloat imageViewPadding = 5;
        CGFloat imageViewWH = (viewW - imageViewPadding * 2) / 3;
        imageCount = imageCount > 3 ? 3 : imageCount;
        for (int i = 0; i < imageCount; i++) {
            CGRect imageViewF = CGRectMake(viewX + (imageViewWH + imageViewPadding) * i, CGRectGetMaxY(_detailLabelF) + 9, imageViewWH, imageViewWH);
            [_imageViewFs addObject:[NSValue valueWithCGRect:imageViewF]];
            lastViewMaxY = CGRectGetMaxY(imageViewF);
        }
    }
    
    _cellH = lastViewMaxY + 26 + 5;
    
    return _cellH;
}


@end
