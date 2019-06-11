//
//  YZChooseNumberView.m
//  ez
//
//  Created by 毛文豪 on 2018/7/12.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZChooseNumberView.h"
#import "YZChooseBirthdayView.h"
#import "YZChoosePhoneView.h"
#import "YZChooseLuckyNumberView.h"
#import "YZWinNumberBall.h"

@interface YZChooseNumberView ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) YZChooseBirthdayView *chooseBirthdayView;
@property (nonatomic, weak) YZChoosePhoneView *choosePhoneView;
@property (nonatomic, weak) YZChooseLuckyNumberView *chooseLuckyNumberView;
@property (nonatomic, weak) UIView *numberView;
@property (nonatomic, strong) NSMutableArray *numberBalls;
@property (nonatomic, strong) NSArray *matchArray;
@property (nonatomic, assign) ChooseNumberType chooseNumberType;

@end

@implementation YZChooseNumberView

- (instancetype)initWithFrame:(CGRect)frame chooseNumberType:(ChooseNumberType)chooseNumberType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.chooseNumberType = chooseNumberType;
        [self setupChilds];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (self.chooseNumberType == ChooseNumberByBirthday) {
        self.numberView.y = CGRectGetMaxY(self.chooseBirthdayView.frame);
    }else if (self.chooseNumberType == ChooseNumberByPhone)
    {
        self.numberView.y = CGRectGetMaxY(self.choosePhoneView.frame);
    }else if (self.chooseNumberType == ChooseNumberByLuckyNumber)
    {
        self.numberView.y = CGRectGetMaxY(self.chooseLuckyNumberView.frame);
    }
    self.height = CGRectGetMaxY(self.numberView.frame);
}


#pragma mark - 创建视图
- (void)setupChilds
{
    //背景图片
    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.bgImageView = bgImageView;
    bgImageView.userInteractionEnabled = YES;
    [self addSubview:bgImageView];
    
    //标题
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, self.width, 30)];
    self.titleLabel = titleLabel;
    titleLabel.textColor = RGBACOLOR(196, 165, 134, 1);
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(36)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    if (self.chooseNumberType == ChooseNumberByBirthday) {
        titleLabel.text = @"您的生日";
        bgImageView.image = [[UIImage imageNamed:@"choose_number_birthday_bg"] stretchableImageWithLeftCapWidth:self.width / 2 topCapHeight:200];
    }else if (self.chooseNumberType == ChooseNumberByPhone)
    {
        titleLabel.text = @"您的电话号码";
        bgImageView.image = [[UIImage imageNamed:@"choose_number_phone_bg"] stretchableImageWithLeftCapWidth:self.width / 2 topCapHeight:200];
    }else if (self.chooseNumberType == ChooseNumberByLuckyNumber)
    {
        titleLabel.text = @"您的幸运数字";
        bgImageView.image = [[UIImage imageNamed:@"choose_number_number_bg"] stretchableImageWithLeftCapWidth:self.width / 2 topCapHeight:200];
    }
    
    CGFloat maxY = 50;
    //选号视图
    if (self.chooseNumberType == ChooseNumberByBirthday) {
        YZChooseBirthdayView *chooseBirthdayView = [[YZChooseBirthdayView alloc] initWithFrame:CGRectMake(0, 50, self.width, 0)];
        self.chooseBirthdayView = chooseBirthdayView;
        [self addSubview:chooseBirthdayView];
        [self.chooseBirthdayView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        maxY = CGRectGetMaxY(self.chooseBirthdayView.frame);
    }else if (self.chooseNumberType == ChooseNumberByPhone)
    {
        YZChoosePhoneView *choosePhoneView = [[YZChoosePhoneView alloc] initWithFrame:CGRectMake(0, 50, self.width, 0)];
        self.choosePhoneView = choosePhoneView;
        [self addSubview:choosePhoneView];
        [self.choosePhoneView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        maxY = CGRectGetMaxY(self.choosePhoneView.frame);
    }else if (self.chooseNumberType == ChooseNumberByLuckyNumber)
    {
        YZChooseLuckyNumberView *chooseLuckyNumberView = [[YZChooseLuckyNumberView alloc] initWithFrame:CGRectMake(0, 50, self.width, 0)];
        self.chooseLuckyNumberView = chooseLuckyNumberView;
        [self addSubview:chooseLuckyNumberView];
        [self.chooseLuckyNumberView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        maxY = CGRectGetMaxY(self.chooseLuckyNumberView.frame);
    }
    
    //选号视图
    UIView * numberView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, self.width, 0)];
    self.numberView = numberView;
    [self addSubview:numberView];
    
    //生成幸运号码
    UIButton * createNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat createNumberButtonW = 160;
    CGFloat createNumberButtonH = 40;
    createNumberButton.adjustsImageWhenHighlighted = NO;
    createNumberButton.frame = CGRectMake((self.width - createNumberButtonW) / 2, 0, createNumberButtonW, createNumberButtonH);
    [createNumberButton setBackgroundImage:[UIImage imageNamed:@"choose_number_btn_icon"] forState:UIControlStateNormal];
    [createNumberButton setTitle:@"生成幸运号码" forState:UIControlStateNormal];
    [createNumberButton setTitleEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
    [createNumberButton setTitleColor:RGBACOLOR(196, 165, 134, 1) forState:UIControlStateNormal];
    createNumberButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [createNumberButton addTarget:self action:@selector(createNumberButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [numberView addSubview:createNumberButton];
    
    //号码球
    CGFloat ballPadding = 5;
    CGFloat ballWH = (self.width - ballPadding * 6 - 15 * 2) / 7;
    for (int i = 0; i < 7; i++) {
        YZWinNumberBall *ball = [[YZWinNumberBall alloc] initWithFrame:CGRectMake(15 + (ballPadding + ballWH) * i, CGRectGetMaxY(createNumberButton.frame) + 20, ballWH, ballWH)];
        ball.numberLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [numberView addSubview:ball];
        [self.numberBalls addObject:ball];
    }
    numberView.height = CGRectGetMaxY(createNumberButton.frame) + 25 + ballWH + 35;
    self.height = CGRectGetMaxY(numberView.frame);
    self.bgImageView.frame = self.bounds;
}

- (void)createNumberButtonDidClick
{
    [self endEditing:YES];
    
    if (self.chooseNumberType == ChooseNumberByBirthday) {
        for (NSDateComponents *dateComponents in self.chooseBirthdayView.dataArray) {
            if (dateComponents.year == 0 || dateComponents.month == 0 || dateComponents.day == 0) {
                [MBProgressHUD showError:@"请补全生日信息"];
                return;
            }
        }
        self.numberBallStatus = [self getNumberBallStatusByBirthday];
    }else if (self.chooseNumberType == ChooseNumberByPhone)
    {
        for (NSString *phone in self.choosePhoneView.dataArray) {
            if (phone.length != 11) {
                [MBProgressHUD showError:@"请补全电话信息"];
                return;
            }
        }
        self.numberBallStatus = [self getNumberBallStatusByPhone];
    }else if (self.chooseNumberType == ChooseNumberByLuckyNumber)
    {
        if (YZStringIsEmpty(self.chooseLuckyNumberView.numberTF.text)) {
            [MBProgressHUD showError:@"请补全幸运数字信息"];
            return;
        }
        self.numberBallStatus = [self getNumberBallStatusByLuckyNumber];
    }
    if (self.numberBallStatus.count == self.numberBalls.count) {
        for (int i = 0; i < 7; i++) {
            YZWinNumberBall *ball = self.numberBalls[i];
            YZWinNumberBallStatus * ballStatus = self.numberBallStatus[i];
            ball.status = ballStatus;
        }
    }
    
}
#pragma mark - 生成号码球信息
- (NSMutableArray *)getNumberBallStatusByBirthday
{
    NSMutableArray * numbers = [NSMutableArray array];
    for (NSDateComponents *dateComponents in self.chooseBirthdayView.dataArray) {
        [numbers addObject:[NSString stringWithFormat:@"%02ld", dateComponents.year]];
        [numbers addObject:[NSString stringWithFormat:@"%02ld", dateComponents.month]];
        [numbers addObject:[NSString stringWithFormat:@"%02ld", dateComponents.day]];
    }
    return [self getNumberBallStatusByNumbers:numbers chooseNumberType:ChooseNumberByPhone];
}

- (NSMutableArray *)getNumberBallStatusByPhone
{
    NSMutableArray * numbers = [NSMutableArray array];
    for (NSString *phone in self.choosePhoneView.dataArray) {
        [numbers addObject:phone];
    }
    return [self getNumberBallStatusByNumbers:numbers chooseNumberType:ChooseNumberByPhone];
}

- (NSMutableArray *)getNumberBallStatusByLuckyNumber
{
    NSMutableArray * numbers = [NSMutableArray array];
    NSString * numberStr = self.chooseLuckyNumberView.numberTF.text;
    if (numberStr.length == 1) {//一位数
        [numbers addObject:numberStr];
        return [self getNumberBallStatusByNumbers:numbers chooseNumberType:ChooseNumberByLuckyNumber];
    }else if (numberStr.length == 2)//两位数
    {
        [numbers addObject:numberStr];
        NSString * number1 = [numberStr substringWithRange:NSMakeRange(0, 1)];
        [numbers addObject:number1];
        NSString * number2 = [numberStr substringWithRange:NSMakeRange(1, 1)];
        [numbers addObject:number2];
        NSString * number3 = [NSString stringWithFormat:@"%d", [self getNewNumberByNumbers:numbers]];
        [numbers addObject:number3];
        return [self getNumberBallStatusByNumbers:numbers chooseNumberType:ChooseNumberByLuckyNumber];
    }
    return nil;
}

- (NSMutableArray *)getNumberBallStatusByNumbers:(NSMutableArray *)numbers chooseNumberType:(ChooseNumberType)chooseNumberType
{
    int redCount = 0;
    int blueCount = 0;
    if ([self.gameId isEqualToString:@"F01"]) {
        redCount = 6;
        blueCount = 1;
    }else if ([self.gameId isEqualToString:@"T01"]) {
        redCount = 5;
        blueCount = 2;
    }
    
    BOOL contains = NO;
    //红球
    NSMutableSet *redSet = [NSMutableSet set];
    NSMutableSet *selRedSet = [NSMutableSet set];
    int count = 0;
    while (!contains) {
        if (count >= 100) {
            [MBProgressHUD showError:@"未能生成号码球，请重新输入内容"];
            return nil;
        }
        count++;
        redSet = [NSMutableSet set];
        while (redSet.count < redCount) {
            int number = [self getRandomRedBallNumber];
            [redSet addObject:@(number)];
            //是否包含要选中的数字
            if (numbers.count > 1 && chooseNumberType == ChooseNumberByLuckyNumber) {
                if ([numbers containsObject:[NSString stringWithFormat:@"%d", number]]) {
                    [selRedSet addObject:@(number)];
                    contains = YES;
                }
            }else
            {
                for (NSString * numberStr in numbers) {
                    if ([[NSString stringWithFormat:@"%02d", number] rangeOfString:numberStr].location != NSNotFound || [numberStr rangeOfString:[NSString stringWithFormat:@"%02d", number]].location != NSNotFound) {
                        [selRedSet addObject:@(number)];
                        contains = YES;
                    }
                }
            }
        }
    }
    
    NSMutableArray * array1 = [NSMutableArray array];
    for (NSNumber * number in redSet) {
        YZWinNumberBallStatus * ballStatus = [[YZWinNumberBallStatus alloc]init];
        ballStatus.number = [NSString stringWithFormat:@"%02d",[number intValue]];
        ballStatus.type = 1;
        ballStatus.isRecommendLottery = ![selRedSet containsObject:number];
        [array1 addObject:ballStatus];
    }
    //对红球数组排序
    NSMutableArray *sortArray1 = [self sortBallsArray:array1];
    //蓝球
    NSMutableSet *blueSet = [NSMutableSet set];
    while (blueSet.count < blueCount) {
        [blueSet addObject:@([self getRandomBlueBallNumber])];
    }
    NSMutableArray * array2 = [NSMutableArray array];
    for (NSNumber * number in blueSet) {
        YZWinNumberBallStatus * ballStatus = [[YZWinNumberBallStatus alloc]init];
        ballStatus.number = [NSString stringWithFormat:@"%02d",[number intValue]];
        ballStatus.type = 2;
        ballStatus.isRecommendLottery = YES;
        [array2 addObject:ballStatus];
    }
    //对蓝球数组排序
    NSMutableArray *sortArray2 = [self sortBallsArray:array2];
    //合并数组
    NSMutableArray * array = [NSMutableArray arrayWithArray:sortArray1];
    [array addObjectsFromArray:sortArray2];
    return array;
}

#pragma mark - 工具
- (int)getNewNumberByNumbers:(NSArray *)numbers
{
    int number1 = [numbers[arc4random() % numbers.count] intValue];
    int number2 = [numbers[arc4random() % numbers.count] intValue];
    NSString * match = self.matchArray[arc4random() % self.matchArray.count];
    if ([match isEqualToString:@"+"])
    {
        return number1 + number2;
    }else if ([match isEqualToString:@"-"])
    {
        return number2 - number1;
    }else if ([match isEqualToString:@"*"])
    {
        return number1 * number2;
    }else if ([match isEqualToString:@"/"])
    {
        if (number1 != 0) {
            if (number2 % number1 == 0) {
                return number2 / number1;
            }
        }
    }
    return 0;
}

- (int)getRandomRedBallNumber
{
    if ([self.gameId isEqualToString:@"F01"]) {
        return arc4random() % 33 + 1;
    }else
    {
        return arc4random() % 35 + 1;
    }
}
- (int)getRandomBlueBallNumber
{
    if ([self.gameId isEqualToString:@"F01"]) {
        return arc4random() % 16 + 1;
    }else
    {
        return arc4random() % 12 + 1;
    }
}
//冒泡排序球数组
- (NSMutableArray *)sortBallsArray:(NSMutableArray *)mutableArray
{
    if(mutableArray.count == 1) return mutableArray;
    for(int i = 0;i < mutableArray.count;i++)
    {
        for(int j = i + 1;j <mutableArray.count;j++)
        {
            YZWinNumberBallStatus * ballStatus1 = mutableArray[i];
            YZWinNumberBallStatus * ballStatus2 = mutableArray[j];
            int number1 = [ballStatus1.number intValue];
            int number2 = [ballStatus2.number intValue];
            if(number1 > number2)
            {
                [mutableArray replaceObjectAtIndex:i withObject:ballStatus2];
                [mutableArray replaceObjectAtIndex:j withObject:ballStatus1];
            }
        }
    }
    return mutableArray;
}

#pragma mark - 初始化
- (NSMutableArray *)numberBalls
{
    if(_numberBalls == nil)
    {
        _numberBalls = [NSMutableArray array];
    }
    return _numberBalls;
}
- (NSArray *)matchArray
{
    if (_matchArray == nil) {
        _matchArray = @[@"+", @"-", @"*", @"/"];
    }
    return _matchArray;
}

@end
