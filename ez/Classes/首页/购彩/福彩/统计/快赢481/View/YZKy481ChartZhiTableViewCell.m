//
//  YZKy481ChartZhiTableViewCell.m
//  ez
//
//  Created by 毛文豪 on 2019/12/2.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481ChartZhiTableViewCell.h"

@interface YZKy481ChartZhiTableViewCell ()

@property (nonatomic, strong) NSMutableArray *buttons;

@end


@implementation YZKy481ChartZhiTableViewCell

+ (YZKy481ChartZhiTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZKy481ChartZhiTableViewCellId";
    YZKy481ChartZhiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZKy481ChartZhiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  cell;
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
    NSArray * labelTexts = @[@"形态", @"和值", @"跨度", @"奇偶比", @"大小比"];
    CGFloat labelW = (screenWidth - LeftLabelW1 - LeftLabelW2) / labelTexts.count;
    for(int i = 0; i < 2 + labelTexts.count; i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            button.frame = CGRectMake(0, 0, LeftLabelW2, CellH2);
            [button setTitleColor:YZChartTitleColor forState:UIControlStateNormal];
        }else if (i == 1)
        {
            button.frame = CGRectMake(LeftLabelW2, 0, LeftLabelW1, CellH2);
            [button setTitleColor:YZChartTitleColor forState:UIControlStateNormal];
        }else
        {
            button.frame = CGRectMake(LeftLabelW1 + LeftLabelW2 + labelW * (i - 2), 0, labelW, CellH2);
            [button setTitleColor:YZChartLightGrayColor forState:UIControlStateNormal];
        }
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 0.25;
        [self.contentView addSubview:button];
        [self.buttons addObject:button];
    }
}

- (void)setDataStatus:(YZChartDataStatus *)dataStatus
{
    _dataStatus = dataStatus;
    
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton * button = self.buttons[i];
        if (i == 0) {
            NSString * issue = [NSString stringWithFormat:@"%@", _dataStatus.issue];
            issue = [issue substringWithRange:NSMakeRange(2, issue.length - 2)];
            [button setTitle:[NSString stringWithFormat:@"%@期", issue] forState:UIControlStateNormal];
        }else if (i == 1)
        {
            NSString * winNumberStr = [NSString string];//获奖号码
            for (NSString * number in _dataStatus.winNumber) {
                winNumberStr = [NSString stringWithFormat:@"%@%@", winNumberStr, number];
            }
            [button setTitle:winNumberStr forState:UIControlStateNormal];
        }else if (i == 2)
        {
            NSSet *winNumberSet = [NSSet setWithArray:_dataStatus.winNumber];
            if (winNumberSet.count == 2) {
                NSString * firstCharacter = [NSString stringWithFormat:@"%@", _dataStatus.winNumber.firstObject];
                NSInteger sameCount = 0;
                for (NSString * number in _dataStatus.winNumber) {
                    if ([number integerValue] == [firstCharacter integerValue]) {//相同的个数
                        sameCount ++;
                    }
                }
                if (sameCount == 2) {
                    [button setTitle:@"组6" forState:UIControlStateNormal];
                }else
                {
                    [button setTitle:@"组4" forState:UIControlStateNormal];
                }
            }else if (winNumberSet.count == 3)
            {
                [button setTitle:@"组12" forState:UIControlStateNormal];
            }else if (winNumberSet.count == 4)
            {
                [button setTitle:@"组24" forState:UIControlStateNormal];
            }
        }else if (i == 3)
        {
            NSArray * hezhi = _dataStatus.missNumber[@"hezhi"];
            [button setTitle:[NSString stringWithFormat:@"%@", hezhi.firstObject] forState:UIControlStateNormal];
        }else if (i == 4)
        {
            NSArray * kuadu = _dataStatus.missNumber[@"kuadu"];
            [button setTitle:[NSString stringWithFormat:@"%@", kuadu.firstObject] forState:UIControlStateNormal];
        }else if (i == 5)
        {
            NSInteger jishuCount = 0;
            for (NSString * number in _dataStatus.winNumber) {
                if ([number integerValue] % 2 != 0) {//奇数
                    jishuCount ++;
                }
            }
            NSInteger oushuCount = _dataStatus.winNumber.count - jishuCount;
            [button setTitle:[NSString stringWithFormat:@"%ld:%ld", jishuCount, oushuCount] forState:UIControlStateNormal];
        }else if (i == 6)
        {
            NSInteger dashuCount = 0;
            for (NSString * number in _dataStatus.winNumber) {
                if ([number integerValue] > 4) {//大数
                    dashuCount ++;
                }
            }
            NSInteger xiaoshuCount = _dataStatus.winNumber.count - dashuCount;
            [button setTitle:[NSString stringWithFormat:@"%ld:%ld", dashuCount, xiaoshuCount] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 初始化
- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}


@end
