//
//  YZKy481ChartRenTableViewCell.m
//  ez
//
//  Created by dahe on 2019/12/2.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481ChartRenTableViewCell.h"

@interface YZKy481ChartRenTableViewCell ()

@property (nonatomic, strong) NSMutableArray *buttons;

@end


@implementation YZKy481ChartRenTableViewCell

+ (YZKy481ChartRenTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZKy481ChartRenTableViewCellId";
    YZKy481ChartRenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZKy481ChartRenTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    for(int i = 0; i < 10; i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UILabel * countLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth / 12 - 12, 0, 11, 11)];
        countLabel.hidden = YES;
        countLabel.backgroundColor = [UIColor yellowColor];
        countLabel.textColor = [UIColor redColor];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.font = [UIFont systemFontOfSize:8.0f];
        countLabel.clipsToBounds = YES;
        countLabel.layer.cornerRadius = countLabel.width / 2;
        [button addSubview:countLabel];
        
        if (i == 0) {
            button.frame = CGRectMake(0, 0, LeftLabelW2, CellH1);
            [button setTitleColor:YZChartTitleColor forState:UIControlStateNormal];
        }else if (i == 1)
        {
            button.frame = CGRectMake(LeftLabelW2, 0, LeftLabelW1, CellH1);
            [button setTitleColor:YZChartTitleColor forState:UIControlStateNormal];
        }else
        {
            button.frame = CGRectMake(LeftLabelW1 + LeftLabelW2 + CellH1 * (i - 2), 0, CellH1, CellH1);
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
    
    UIButton * button0 = self.buttons[0];
    NSString * issue = [NSString stringWithFormat:@"%@", _dataStatus.issue];
    issue = [issue substringWithRange:NSMakeRange(2, issue.length - 2)];
    [button0 setTitle:[NSString stringWithFormat:@"%@期", issue] forState:UIControlStateNormal];
    
    UIButton * button1 = self.buttons[1];
    NSString * winNumberStr = [NSString string];
    for (NSString * number in _dataStatus.winNumber) {
        winNumberStr = [NSString stringWithFormat:@"%@%@", winNumberStr, number];
    }
    [button1 setTitle:winNumberStr forState:UIControlStateNormal];
    
    [self setBallsWithBallsArray:_dataStatus.winNumber ballImageName:@"chart_blueBg"];
}

- (void)setBallsWithBallsArray:(NSArray *)ballsArray ballImageName:(NSString *)imageName
{
    for (int i = 2; i < self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        [btn setTitle:nil forState:UIControlStateNormal];
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
        UILabel * countLabel;
        for (UIView * subView in btn.subviews) {
            if ([subView isKindOfClass:[UILabel class]]) {
                countLabel = (UILabel *)subView;
                break;
            }
        }
        countLabel.hidden = YES;
    }
    
    for(NSString *str in ballsArray)
    {
        UIButton *btn;
        btn = self.buttons[[str intValue] + 1];
        [btn setTitle:[NSString stringWithFormat:@"%02d", [str intValue]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        NSMutableArray * winNumberMuArr = [NSMutableArray arrayWithArray:ballsArray];
        [winNumberMuArr removeObject:str];
        NSInteger count = ballsArray.count - winNumberMuArr.count;//从原数组删除该元素后少的元素个数就是该元素在数组中的个数
        UILabel * countLabel;
        for (UIView * subView in btn.subviews) {
            if ([subView isKindOfClass:[UILabel class]]) {
                countLabel = (UILabel *)subView;
                break;
            }
        }
        if (count > 1) {
            countLabel.hidden = NO;
            countLabel.text = [NSString stringWithFormat:@"%ld", count];
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
