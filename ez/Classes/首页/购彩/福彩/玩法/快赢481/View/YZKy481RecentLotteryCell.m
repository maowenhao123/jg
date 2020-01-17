//
//  YZKy481RecentLotteryCell.m
//  ez
//
//  Created by dahe on 2019/11/6.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481RecentLotteryCell.h"

@interface YZKy481RecentLotteryCell ()

@property (nonatomic, strong) NSMutableArray *btns;

@end

@implementation YZKy481RecentLotteryCell

+ (YZKy481RecentLotteryCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZKy481RecentLotteryCellId";
    YZKy481RecentLotteryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZKy481RecentLotteryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    int btnCount = 12;
    for(int i = 0; i < btnCount;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i == 0 || i == 1)
        {
            [btn setTitleColor:YZChartTitleColor forState:UIControlStateNormal];
        }else
        {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            UILabel * countLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth / 12 - 12, 0, 11, 11)];
            countLabel.hidden = YES;
            countLabel.backgroundColor = [UIColor yellowColor];
            countLabel.textColor = [UIColor redColor];
            countLabel.textAlignment = NSTextAlignmentCenter;
            countLabel.font = [UIFont systemFontOfSize:8.0f];
            countLabel.clipsToBounds = YES;
            countLabel.layer.cornerRadius = countLabel.width / 2;
            [btn addSubview:countLabel];
        }
        btn.userInteractionEnabled = NO;
        btn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 0.25;
        [self.contentView addSubview:btn];
        
        [self.btns addObject:btn];
        
    }
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    CGFloat historyCellH = screenWidth / 12;
    if (_cellTag == KhistoryCellTagWanNeng) {
        historyCellH = screenWidth / 14;
    }
    CGFloat btnX = 0;
    for (int i = 0; i < self.btns.count; i++) {
        UIButton *btn =  self.btns[i];
        btn.hidden = NO;
        if (_cellTag == KhistoryCellTag283 && i >= 6) {
            btn.hidden = YES;
        }else if (_cellTag != KhistoryCellTagWanNeng && i > 9)
        {
            btn.hidden = YES;
        }else if (_cellTag == KhistoryCellTag283 && i < 6)
        {
            btn.frame = CGRectMake(btnX, 0, historyCellH * 2, historyCellH);
        }else
        {
            if (i == 0 || i == 1) {
                btn.frame = CGRectMake(btnX, 0, historyCellH * 2, historyCellH);
            }else
            {
                btn.frame = CGRectMake(btnX, 0, historyCellH, historyCellH);
            }
        }
        btnX = CGRectGetMaxX(btn.frame);
    }
    
    if (_index == 0) {
        UIButton *btn0 = self.btns[0];
        [btn0 setTitle:@"期" forState:UIControlStateNormal];
        
        UIButton *btn1 = self.btns[1];
        if (_cellTag == KhistoryCellTagZongHe || _cellTag == KhistoryCellTagWanNeng || _cellTag == KhistoryCellTag283) {
            [btn1 setTitle:@"奖号" forState:UIControlStateNormal];
        }else if (_cellTag == KhistoryCellTagZu)
        {
            [btn1 setTitle:@"类型" forState:UIControlStateNormal];
        }else
        {
            [btn1 setTitle:@"012" forState:UIControlStateNormal];
        }
        
        for (int i = 2; i < self.btns.count; i++) {
            UIButton *btn =  self.btns[i];
            if (!btn.hidden) {
                if (_cellTag == KhistoryCellTagWanNeng) {
                    [btn setTitle:[NSString stringWithFormat:@"%d", i - 2] forState:UIControlStateNormal];
                }else if (_cellTag == KhistoryCellTag283) {
                    NSArray * btnTitles = @[@"前三", @"形态", @"后三", @"形态"];
                    [btn setTitle:btnTitles[i - 2] forState:UIControlStateNormal];
                }else
                {
                    [btn setTitle:[NSString stringWithFormat:@"%02d", i - 1] forState:UIControlStateNormal];
                }
            }
            [btn setTitleColor:YZChartTitleColor forState:UIControlStateNormal];
            [btn setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
}

- (void)setStatus:(YZRecentLotteryStatus *)status
{
    _status = status;
    
    //设置期数
    NSString *termId = nil;
    if(_status.termId)
    {
        termId = [status.termId substringFromIndex:6];
    }else
    {
        termId = @"";
    }
    UIButton *btn0 =  self.btns[0];
    [btn0 setTitle:[NSString stringWithFormat:@"%@期", termId] forState:UIControlStateNormal];
    
    //奖号
    UIButton *btn1 =  self.btns[1];
    NSArray *ballArray = [_status.winNumber componentsSeparatedByString:@","];
    if (_cellTag == KhistoryCellTagZongHe || _cellTag == KhistoryCellTagWanNeng || _cellTag == KhistoryCellTag283) {
        NSString * winNumber = [_status.winNumber stringByReplacingOccurrencesOfString:@"," withString:@""];
        [btn1 setTitle:winNumber forState:UIControlStateNormal];
    }else if (_cellTag == KhistoryCellTagZu)
    {
        NSSet *ballSet = [NSSet setWithArray:ballArray];
        if (ballSet.count == 2) {
            NSString * firstCharacter = [NSString stringWithFormat:@"%@", ballArray.firstObject];
            NSInteger sameCount = 0;
            for (NSString * number in ballArray) {
                if ([number integerValue] == [firstCharacter integerValue]) {//相同的个数
                    sameCount ++;
                }
            }
            if (sameCount == 2) {
                [btn1 setTitle:@"组6" forState:UIControlStateNormal];
            }else
            {
                [btn1 setTitle:@"组4" forState:UIControlStateNormal];
            }
        }else if (ballSet.count == 3)
        {
            [btn1 setTitle:@"组12" forState:UIControlStateNormal];
        }else if (ballSet.count == 4)
        {
            [btn1 setTitle:@"组24" forState:UIControlStateNormal];
        }
    }else
    {
        NSArray *subArr = [NSArray array];
        if(_cellTag == KhistoryCellTagZiyou)
        {
            subArr = [ballArray subarrayWithRange:NSMakeRange(0, 1)];
        }else if(_cellTag == KhistoryCellTagYang)
        {
            subArr = [ballArray subarrayWithRange:NSMakeRange(1, 1)];
        }else if(_cellTag == KhistoryCellTagWa)
        {
            subArr = [ballArray subarrayWithRange:NSMakeRange(2, 1)];
        }else if(_cellTag == KhistoryCellTagDie)
        {
            subArr = [ballArray subarrayWithRange:NSMakeRange(3, 1)];
        }
        if (!YZArrayIsEmpty(subArr)) {
            int number = [subArr.firstObject intValue];
            if (number == 0 || number == 3 || number == 6 || number == 9) {
                [btn1 setTitle:@"0" forState:UIControlStateNormal];
            }else if (number == 1 || number == 4 || number == 7) {
                [btn1 setTitle:@"1" forState:UIControlStateNormal];
            }else if (number == 2 || number == 5 || number == 8) {
                [btn1 setTitle:@"2" forState:UIControlStateNormal];
            }
        }
    }
    
    //设置号码球
    if (_cellTag == KhistoryCellTagZongHe || _cellTag == KhistoryCellTagZu) {
        [self setBallsWithBallsArray:ballArray ballImageName:@"redBg"];
    }else if(_cellTag == KhistoryCellTagZiyou)
    {
        NSArray *subArr = [ballArray subarrayWithRange:NSMakeRange(0, 1)];
        [self setBallsWithBallsArray:subArr ballImageName:@"greenBg"];
    }else if(_cellTag == KhistoryCellTagYang)
    {
        NSArray *subArr = [ballArray subarrayWithRange:NSMakeRange(1, 1)];
        [self setBallsWithBallsArray:subArr ballImageName:@"blueBg"];
    }else if(_cellTag == KhistoryCellTagWa)
    {
        NSArray *subArr = [ballArray subarrayWithRange:NSMakeRange(2, 1)];
        [self setBallsWithBallsArray:subArr ballImageName:@"blueBg"];
    }else if(_cellTag == KhistoryCellTagDie)
    {
        NSArray *subArr = [ballArray subarrayWithRange:NSMakeRange(3, 1)];
        [self setBallsWithBallsArray:subArr ballImageName:@"blueBg"];
    }else if(_cellTag == KhistoryCellTagWanNeng)
    {
        NSMutableSet * sumSet = [NSMutableSet set];
        for (int i = 0; i < ballArray.count; i++) {
            int number1 = [ballArray[i] intValue];
            for (int j = i + 1; j < ballArray.count; j++) {
                int number2 = [ballArray[j] intValue];
                NSString * number = [NSString stringWithFormat:@"%d", number1 + number2];
                if (number.length > 1) {
                    number = [number substringWithRange:NSMakeRange(1, 1)];
                }
                [sumSet addObject:number];
            }
        }
        NSMutableArray * subArr = [NSMutableArray array];
        for (NSString * number in sumSet) {
            [subArr addObject:number];
        }
        [self setBallsWithBallsArray:subArr ballImageName:@"redBg"];
    }else if (_cellTag == KhistoryCellTag283)
    {
        NSString * winNumber = [_status.winNumber stringByReplacingOccurrencesOfString:@"," withString:@""];
        for (int i = 2; i < self.btns.count; i++) {
            UIButton *btn = self.btns[i];
            [btn setTitleColor:YZChartTitleColor forState:UIControlStateNormal];
            [btn setTitle:nil forState:UIControlStateNormal];
            [btn setBackgroundImage:nil forState:UIControlStateNormal];
            if (i == 2) {
                [btn setTitle:[winNumber substringWithRange:NSMakeRange(0, 3)] forState:UIControlStateNormal];
            }else if (i == 3)
            {
                NSArray *ballArray = [_status.winNumber componentsSeparatedByString:@","];
                [btn setTitle:[self get283SanBuChongTextWithWinNumberArray:[ballArray subarrayWithRange:NSMakeRange(0, 3)]] forState:UIControlStateNormal];
            }else if (i == 4)
            {
                [btn setTitle:[winNumber substringWithRange:NSMakeRange(1, 3)] forState:UIControlStateNormal];
            }else if (i == 5)
            {
                NSArray *ballArray = [_status.winNumber componentsSeparatedByString:@","];
                [btn setTitle:[self get283SanBuChongTextWithWinNumberArray:[ballArray subarrayWithRange:NSMakeRange(1, 3)]] forState:UIControlStateNormal];
            }
            UILabel * countLabel;
            for (UIView * subView in btn.subviews) {
                if ([subView isKindOfClass:[UILabel class]]) {
                    countLabel = (UILabel *)subView;
                    break;
                }
            }
            countLabel.hidden = YES;
        }
    }
}

- (void)setBallsWithBallsArray:(NSArray *)ballsArray ballImageName:(NSString *)imageName
{
    for (int i = 2; i < self.btns.count; i++) {
        UIButton *btn = self.btns[i];
        [btn setTitle:nil forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
        if(_cellTag == KhistoryCellTagWanNeng){
            btn = self.btns[[str intValue] + 2];
            [btn setTitle:[NSString stringWithFormat:@"%d", [str intValue]] forState:UIControlStateNormal];
        }else
        {
            btn = self.btns[[str intValue] + 1];
            [btn setTitle:[NSString stringWithFormat:@"%02d", [str intValue]] forState:UIControlStateNormal];
        }
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
        if (_cellTag == KhistoryCellTagZongHe || _cellTag == KhistoryCellTagZu) {
            if (count > 1) {
                countLabel.hidden = NO;
                countLabel.text = [NSString stringWithFormat:@"%ld", count];
            }
        }
    }
}

- (NSString *)get283SanBuChongTextWithWinNumberArray:(NSArray *)winNumberArray
{
    NSSet *subWinNumberSet = [NSSet setWithArray:winNumberArray];
    NSInteger sameCount = winNumberArray.count - subWinNumberSet.count;
    int max = 0;
    int min = 0;
    for (int i = 0; i < winNumberArray.count; i++) {
        int winNumberInt = [winNumberArray[i] intValue];
        if (i == 0) {
            min = winNumberInt;
        }
        if (winNumberInt < min) {
            min = winNumberInt;
        }
        if (winNumberInt > max) {
            max = winNumberInt;
        }
    }
    if (sameCount == 0)
    {
        if (max - min == 2 && max != [winNumberArray[1] intValue] && min != [winNumberArray[1] intValue]) {
            return @"拖拉机";
        }else
        {
            return @"三不重";
        }
    }else if (sameCount == 1)
    {
        return @"二带一";
    }else if (sameCount == 3)
    {
        return @"豹子";
    }
    return @"";
}

- (NSMutableArray *)btns
{
    if(_btns == nil)
    {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

@end
