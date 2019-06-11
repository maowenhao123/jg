//
//  YZSchemeDetailTableViewCell.m
//  ez
//
//  Created by apple on 16/10/8.
//  Copyright © 2016年 9ge. All rights reserved.
//
#import "YZSchemeDetailTableViewCell.h"

@interface YZSchemeDetailTableViewCell ()

@property (nonatomic, strong) NSMutableArray *labels;

@end

@implementation YZSchemeDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SchemeDetailTableViewCell";
    YZSchemeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell)
    {
        cell = [[YZSchemeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40 - 1, screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [self addSubview:line];
    
    //四个label
    NSArray * labelWs = @[@0.15,@0.3,@0.25,@0.3];
    UILabel * lastLabel;
    for (int i = 0; i < 4; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastLabel.frame), 1, [labelWs[i] floatValue] * screenWidth, 40 - 1)];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = YZBlackTextColor;
        [self addSubview:label];
        if (i == 0) {
            self.noLabel = label;
        }
        [self.labels addObject:label];
        lastLabel = label;
    }
    //小三角
    UIImageView * downTriangle = [[UIImageView alloc]init];
    downTriangle.frame = CGRectMake(screenWidth - 7, 40 - 7, 7, 7);
    downTriangle.image = [UIImage imageNamed:@"scheme_down_triangle"];
    [self addSubview:downTriangle];
}
- (void)setStatus:(YZOrder *)status
{
    _status = status;
    for (UILabel * label in self.labels) {
        NSInteger index = [self.labels indexOfObject:label];
        if (index == 1) {
            label.text = [NSString stringWithFormat:@"%@",status.termId];
        }else if (index == 2)//状态
        {
            label.text = status.statusDesc;
        }else if (index == 3)//中奖信息
        {
            float bonus = [status.bonus intValue] / 100.0;
            NSString *isHitStr = nil;
            if(bonus > 0)
            {
                label.textColor = YZRedTextColor;
                isHitStr = [NSString stringWithFormat:@"中奖：%.2f元",bonus];
            }else if ([status.status intValue] == 3)//出票成功的代码
            {
                label.textColor = YZBlackTextColor;
                isHitStr = status.ishitDesc;
            }
            label.text = isHitStr;
        }
    }
}
#pragma mark - 初始化
- (NSMutableArray *)labels
{
    if (_labels == nil) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}


@end
