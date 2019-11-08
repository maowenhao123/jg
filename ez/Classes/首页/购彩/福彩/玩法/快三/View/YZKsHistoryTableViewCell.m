//
//  YZKsHistoryTableViewCell.m
//  ez
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZKsHistoryTableViewCell.h"
#import "YZksHistoryWinNumberView.h"

#define cellH 25

@interface YZKsHistoryTableViewCell ()

@property (nonatomic, weak) UILabel *termIdLabel;
@property (nonatomic, weak) UILabel *codeLabel;
@property (nonatomic, strong) NSMutableArray *winNumberViews;
@property (nonatomic, weak) UILabel *typeLabel;

@end

@implementation YZKsHistoryTableViewCell

+ (YZKsHistoryTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"KsHistoryTableViewCell";
    YZKsHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZKsHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    CGFloat termLabelW = (screenWidth - 6 * cellH) * 2 / 8;
    CGFloat codeLabelW = (screenWidth - 6 * cellH) * 3 / 8;
    CGFloat typeLabelW = (screenWidth - 6 * cellH) * 3 / 8;
    
    UILabel * termLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, termLabelW, cellH)];
    self.termIdLabel = termLabel;
    termLabel.font = [UIFont systemFontOfSize:13];
    termLabel.textAlignment = NSTextAlignmentCenter;
    termLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    termLabel.layer.borderWidth = 0.25;
    [self addSubview:termLabel];
    
    UILabel * codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(termLabel.frame), 0, codeLabelW, cellH)];
    self.codeLabel = codeLabel;
    codeLabel.font = [UIFont systemFontOfSize:13];
    codeLabel.textAlignment = NSTextAlignmentCenter;
    codeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    codeLabel.layer.borderWidth = 0.25;
    [self addSubview:codeLabel];
    
    for (int i = 1; i < 7; i++) {
        YZksHistoryWinNumberView * winNumberView = [[YZksHistoryWinNumberView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(codeLabel.frame) + (i - 1) * cellH, 0, cellH, cellH)];
        winNumberView.tag = i;
        winNumberView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        winNumberView.layer.borderWidth = 0.25;
        [self addSubview:winNumberView];
        [self.winNumberViews addObject:winNumberView];
    }
    
    UILabel * typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - typeLabelW, 0, typeLabelW, cellH)];
    self.typeLabel = typeLabel;
    typeLabel.font = [UIFont systemFontOfSize:13];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    typeLabel.layer.borderWidth = 0.25;
    [self addSubview:typeLabel];
}

- (void)setStatus:(YZRecentLotteryStatus *)status
{
    self.termIdLabel.text = [NSString stringWithFormat:@"%@期",[status.termId substringFromIndex:status.termId.length - 2]];
    NSArray * winNumbers = [status.winNumber componentsSeparatedByString:@","];
    winNumbers = [self sortArray:[NSMutableArray arrayWithArray:winNumbers]];
    self.codeLabel.text = [winNumbers componentsJoinedByString:@" "];
    NSInteger max = 0;
    NSInteger sum = 0;
    for (NSString * winNumber in winNumbers) {
        YZksHistoryWinNumberView * winNumberView = [self viewWithTag:[winNumber intValue]];
        winNumberView.winNumber = winNumber;
        NSMutableArray * winNumberMuArr = [NSMutableArray arrayWithArray:winNumbers];
        [winNumberMuArr removeObject:winNumber];
        NSInteger count = winNumbers.count - winNumberMuArr.count;//从原数组删除该元素后少的元素个数就是该元素在数组中的个数
        if (count > 1) {
            winNumberView.count = [NSString stringWithFormat:@"%ld",(long)count];
        }
        max = max > count ? max : count;
        sum += [winNumber integerValue];
    }
    int KsSelectedPlayTypeBtnTag = [YZUserDefaultTool getIntForKey:@"KsSelectedPlayTypeBtnTag"];
    if (KsSelectedPlayTypeBtnTag == 0) {
        self.typeLabel.text = [NSString stringWithFormat:@"%ld",(long)sum];
    }else
    {
        if (max == 1) {
            self.typeLabel.text = @"三不同";
        }else if (max == 2)
        {
            self.typeLabel.text = @"二   同";
        }else if (max == 3)
        {
            self.typeLabel.text = @"三   同";
        }
    }
}

- (NSMutableArray *)sortArray:(NSMutableArray *)array
{
    if(array.count == 1) return array;
    for(int i = 0;i < array.count;i++)
    {
        for(int j = i + 1;j <array.count;j++)
        {
            int number1 = [array[i] intValue];
            int number2 = [array[j] intValue];
            if(number1 > number2)
            {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return array;
}

- (NSMutableArray *)winNumberViews
{
    if (_winNumberViews == nil) {
        _winNumberViews = [NSMutableArray array];
    }
    return _winNumberViews;
}


@end
