//
//  YZSelectBaseViewController.m
//  ez
//
//  Created by apple on 14-9-9.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#define topBtnW ((screenWidth - 3 * 5) / 2)

#import "YZSelectBaseViewController.h"
#import "YZBallBtn.h"
#import "YZSelectedBetNumberView.h"
#import "YZDateTool.h"
#import "YZKy481Math.h"

@interface YZSelectBaseViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate, YZSelectedBetNumberViewDelegate>
{
    NSInteger _remainSeconds;//本期截止倒计时剩余秒数
    NSInteger _nextOpenRemainSeconds;//下期开奖倒计时剩余秒数
}
@property (nonatomic, strong) NSDictionary *currentTermDict;//当前期的字典信息
@property (nonatomic, weak) UIView *menuBackView;
@property (nonatomic,weak) UIButton *deleteAutoSelectedBtn;
@property (nonatomic, weak) UILabel *promptLabel;

@end

@implementation YZSelectBaseViewController

#pragma mark - 视图的生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    [self setupChilds];
    //让本控制器支持摇动感应
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    self.title = [YZTool gameIdNameDict][self.gameId];
    
    _remainSeconds = 0;
    _nextOpenRemainSeconds = 0;
    [self addSetDeadlineTimer];//倒计时
    [self getCurrentTermData];//获取当前期信息，获得截止时间
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshCountdownNotification) name:RefreshCountdownNote object:nil];
    
}

- (void)RefreshCountdownNotification
{
    if (_nextOpenRemainSeconds > 0) {//倒计时运行时才刷新
        self.endTimeLabel.text = @"获取期次中...";
        _remainSeconds = 0;
        _nextOpenRemainSeconds = 0;
        [self getCurrentTermData];
        
    }
}

#pragma mark - 布局子视图
- (void)setupChilds
{
    //顶部截止时间
    UILabel *endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, endTimeLabelH)];
    self.endTimeLabel = endTimeLabel;
    endTimeLabel.text = @"未能获取当前期号";
    endTimeLabel.backgroundColor = [UIColor whiteColor];
    endTimeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    endTimeLabel.textColor = YZColor(186, 186, 186, 1);
    endTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:endTimeLabel];
    
    UIView * endTimeLineView = [[UIView alloc]initWithFrame:CGRectMake(0, endTimeLabel.height - 1, screenWidth, 1)];
    endTimeLineView.backgroundColor = YZWhiteLineColor;
    [self.view addSubview:endTimeLineView];
    
    //两个按钮.
    //底部的view
    CGFloat backViewH = 36;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(endTimeLabel.frame), screenWidth, backViewH)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    self.backView = backView;
    //两个按钮
    for(int i = 0;i < 2;i++)
    {
        UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topBtn.tag = i;
        if(i==0)
        {
            topBtn.selected = YES;
            self.selectedBtn = topBtn;
            topBtn.userInteractionEnabled = NO;
            self.leftBtn = topBtn;
        }else
        {
            self.rightBtn = topBtn;
        }
        topBtn.frame = CGRectMake(5 + (topBtnW + 5) * i, 0, topBtnW, backViewH);
        topBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        topBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [topBtn setTitleColor:YZColor(134, 134, 134, 1) forState:UIControlStateNormal];
        [topBtn setTitleColor:YZBaseColor forState:UIControlStateSelected];
        [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:topBtn];
        [self.topBtns addObject:topBtn];
    }
    //底部红线
    UIView * topBtnLine = [[UIView alloc]init];
    self.topBtnLine = topBtnLine;
    topBtnLine.frame = CGRectMake(5, backViewH - 2, topBtnW, 2);
    topBtnLine.backgroundColor = YZBaseColor;
    [backView addSubview:topBtnLine];
    
    //scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delaysContentTouches = NO;
    self.scrollView = scrollView;
    scrollView.delegate = self;
    
    CGFloat autoSelectedLabelH = 20;
    CGFloat promptLabelH = 30;
    CGFloat bottomViewH = 49 + [YZTool getSafeAreaBottom];
    CGFloat scrollViewH = screenHeight - statusBarH - navBarH - CGRectGetMaxY(endTimeLabel.frame) - bottomViewH - autoSelectedLabelH - backViewH;
    if ([self.gameId isEqualToString:@"T06"]) {
        scrollViewH = screenHeight - statusBarH - navBarH - CGRectGetMaxY(endTimeLabel.frame) - bottomViewH - autoSelectedLabelH - promptLabelH;
    }
    scrollView.frame = CGRectMake(0, CGRectGetMaxY(backView.frame), screenWidth, scrollViewH);
    [self.view addSubview:scrollView];
    //设置属性
    scrollView.contentSize = CGSizeMake(screenWidth * 2, scrollViewH);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    
    //添加2个tableview
    for(int i = 0;i < 2;i++)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, scrollViewH)];
        tableView.tag = i;
        tableView.backgroundColor = YZBackgroundColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if(i == 0)
        {
            self.currentTableView = tableView;
            self.tableView1 =tableView;
        }else
        {
            self.tableView2 = tableView;
        }
        [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
        [self.tableViews addObject:tableView];
        [scrollView addSubview:tableView];
    }
    
    //底栏
    CGFloat bottomViewW = screenWidth;
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = screenHeight - bottomViewH - statusBarH - navBarH;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH)];
    self.bottomView = bottomView;
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    //删除按钮
    CGFloat buttonH = 30;
    CGFloat buttonW = 75;
    CGFloat buttonY = (bottomViewH - [YZTool getSafeAreaBottom] - buttonH) / 2;
    UIButton *deleteAutoSelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteAutoSelectedBtn = deleteAutoSelectedBtn;
    deleteAutoSelectedBtn.frame = CGRectMake(15, buttonY, buttonW, buttonH);
    [deleteAutoSelectedBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(238, 238, 238, 1) WithRect:deleteAutoSelectedBtn.bounds] forState:UIControlStateNormal];
    [deleteAutoSelectedBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(216, 216, 216, 1) WithRect:deleteAutoSelectedBtn.bounds] forState:UIControlStateHighlighted];
    [deleteAutoSelectedBtn setTitle:@"机选" forState:UIControlStateNormal];
    [deleteAutoSelectedBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    deleteAutoSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [deleteAutoSelectedBtn addTarget:self action:@selector(deleteAutoSelectedBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:deleteAutoSelectedBtn];
    deleteAutoSelectedBtn.layer.borderColor = YZColor(213, 213, 213, 1).CGColor;
    deleteAutoSelectedBtn.layer.borderWidth = 1;
    deleteAutoSelectedBtn.layer.masksToBounds = YES;
    deleteAutoSelectedBtn.layer.cornerRadius = 2;
    
    //确认按钮
    YZBottomButton *confirmBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(screenWidth - buttonW - 15, buttonY, buttonW, buttonH);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [bottomView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //注数和金额总数
    UILabel *amountLabel = [[UILabel alloc] init];
    self.amountLabel = amountLabel;
    amountLabel.textColor = YZBlackTextColor;
    amountLabel.textAlignment = NSTextAlignmentCenter;
    amountLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    CGFloat amountLabelX = CGRectGetMaxX(deleteAutoSelectedBtn.frame) + 10;
    CGFloat amountLabelW = confirmBtn.x - 10 - amountLabelX;
    CGFloat amountLabelH = 25;
    CGFloat amountLabelY = (bottomView.height - [YZTool getSafeAreaBottom] - amountLabelH) / 2;
    amountLabel.frame = CGRectMake(amountLabelX, amountLabelY, amountLabelW, amountLabelH);
    [bottomView addSubview:amountLabel];
    self.betCount = 0;
    
    //分割线
    UIView * bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    bottomLineView.backgroundColor = YZGrayLineColor;
    [bottomView addSubview:bottomLineView];
    
    CGFloat maxY = bottomView.y;
    if ([self.gameId isEqualToString:@"T06"]) {
        //下面提示的label
        UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(YZMargin, maxY - 30, screenWidth - 2 * YZMargin, promptLabelH)];
        self.promptLabel = promptLabel;
        promptLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        promptLabel.textColor = [UIColor darkGrayColor];
        promptLabel.backgroundColor = YZBackgroundColor;
        [self.view addSubview:promptLabel];
        maxY = promptLabel.y;
        
        //分割线
        UIView * promptLineView = [[UIView alloc]initWithFrame:CGRectMake(-YZMargin, 0, screenWidth, 1)];
        promptLineView.backgroundColor = YZGrayLineColor;
        [promptLabel addSubview:promptLineView];
    }
    
    //摇一摇机选
    UILabel * autoSelectedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, maxY - autoSelectedLabelH, screenWidth, autoSelectedLabelH)];
    self.autoSelectedLabel = autoSelectedLabel;
    autoSelectedLabel.backgroundColor = YZBackgroundColor;
    autoSelectedLabel.textColor = YZBlackTextColor;
    autoSelectedLabel.text = @"摇一摇机选";
    autoSelectedLabel.textAlignment = NSTextAlignmentCenter;
    autoSelectedLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [self.view addSubview:autoSelectedLabel];
}

#pragma mark - 子类重写
- (void)deleteAutoSelectedBtnDidClick:(UIButton *)button
{
    if ([button.currentTitle isEqualToString:@"清空"]) {
        [self deleteBtnClick];
    }else if ([button.currentTitle isEqualToString:@"机选"])
    {
        [self autoSelectedBtnClick];
    }
}
- (void)confirmBtnClick:(UIButton *)btn
{
    //子类重写
}
- (void)deleteBtnClick
{
    //子类重写
}
- (void)autoSelectedBtnClick
{
    YZSelectedBetNumberView * selectedBetNumberView = [[YZSelectedBetNumberView alloc] initWithFrame:KEY_WINDOW.bounds];
    selectedBetNumberView.delegate = self;
    [KEY_WINDOW addSubview:selectedBetNumberView];
}
- (void)selectedBetNumberViewSelectedNumber:(NSInteger)number
{
    [self autoSelectedBetWithNumber:number];
}
- (void)autoSelectedBetWithNumber:(NSInteger)number
{
    
}
//清空号码球数组，让所有已选号码球变回原来颜色
- (void)clearSelBalls:(NSMutableArray *)array
{
    for(int i = 0;i < array.count;i++)
    {
        YZBallBtn *ballBtn = array[i];
        if(ballBtn.isSelected)
        {
            [ballBtn ballChangeToWhite];
        }
    }
    [array removeAllObjects];
}
//设置注数
- (void)setBetCount:(int)betCount
{
    _betCount = betCount;
    
    [self setDeleteAutoSelectedBtnTitle];
    
    NSString *temp = [NSString stringWithFormat:@"共%d注，%d元", betCount, betCount*2];
    
    NSRange range1 = [temp rangeOfString:@"共"];
    NSRange range2 = [temp rangeOfString:@"注"];
    NSRange range3 = [temp rangeOfString:@"元"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temp];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedBallColor range:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedBallColor range:NSMakeRange(range2.location + 2, range3.location - range2.location - 2)];
    
    self.amountLabel.attributedText = attStr;
    
    if ([self.gameId isEqualToString:@"T06"])
    {
        [self setPromptLabelText];
    }
}

- (void)setDeleteAutoSelectedBtnTitle
{
    if (_betCount == 0 && self.autoSelectedLabel.hidden == NO) {//当前为选号并且支持随机选号
        [self.deleteAutoSelectedBtn setTitle:@"机选" forState:UIControlStateNormal];
    }else
    {
        [self.deleteAutoSelectedBtn setTitle:@"清空" forState:UIControlStateNormal];
    }
}

#pragma mark - 设置下面提示label的文字
- (void)setPromptLabelText
{
    NSRange prize = [YZKy481Math getKy481Prize_putongWithTag:(int)self.selectedPlayTypeBtnTag selectCount:(int)self.selectcount betCount:self.betCount];
    
    int minPrize = (int)prize.location;
    int maxPrize = (int)prize.length;
    int minProfit = minPrize - self.betCount * 2;
    int maxProfit = maxPrize - self.betCount * 2;
    NSString *text = [NSString stringWithFormat:@"若中奖：奖金%d至%d元，盈利%d至%d元",minPrize,maxPrize,minProfit,maxProfit];
    if (minPrize == maxPrize) {
        text = [NSString stringWithFormat:@"若中奖：奖金%d元，盈利%d元",minPrize,minProfit];
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZBaseColor range:NSMakeRange(0, attStr.length)];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\D*"  options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray *result = [regex matchesInString:attStr.string options:0 range:NSMakeRange(0, attStr.length)];
    for (NSTextCheckingResult *resultCheck in result) {
        if (resultCheck.range.length > 0) {
            [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:resultCheck.range];
        }
    }
    self.promptLabel.attributedText = attStr;
}

#pragma mark - tableView的滚动
- (void)topBtnClick:(UIButton *)btn
{
    //滚动到指定页码
    [self.scrollView setContentOffset:CGPointMake(btn.tag * screenWidth, 0) animated:YES];
}
- (void)changeBtnState:(UIButton *)btn
{
    self.selectedBtn.selected = NO;
    self.selectedBtn.userInteractionEnabled = YES;
    btn.userInteractionEnabled = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    self.currentTableView = self.tableViews[btn.tag];//当前的tableview
    [self currentTableViewDidChange];
    //红线动画
    [UIView animateWithDuration:animateDuration
                     animations:^{
                         self.topBtnLine.center = CGPointMake(btn.center.x, self.topBtnLine.center.y);
                     }];
}
- (void)currentTableViewDidChange
{
    //子类重写该方法
}
#pragma mark - UIScrollViewDelegate代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(![scrollView isKindOfClass:[UITableView class]])
    {
        // 1.取出水平方向上滚动的距离
        CGFloat offsetX = scrollView.contentOffset.x;
        
        // 2.求出页码
        double pageDouble = offsetX / (screenWidth * 2);
        self.pageInt = (int)(pageDouble + 0.5);
        [self changeBtnState:self.topBtns[self.pageInt]];
    }
}

#pragma mark - 获取当前期信息
- (void)getCurrentTermData
{
    if(_nextOpenRemainSeconds > 0) return;
    NSDictionary *dict = @{
                           @"cmd":@(8026),
                           @"gameId":self.gameId
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"%@",json);
        if (SUCCESS) {
            self.currentTermDict = json;
            NSArray *termList = json[@"game"][@"termList"];
            if(termList.count)//当前期次正在销售
            {
                if([self.gameId isEqualToString:@"T05"] || [self.gameId isEqualToString:@"T61"] || [self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T63"] || [self.gameId isEqualToString:@"T64"])
                {
                    NSString *currentTermId = [json[@"game"][@"termList"] lastObject][@"termId"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:TermIdChangedNote object:currentTermId];
                }
                NSString * endTime = [json[@"game"][@"termList"] lastObject][@"endTime"];
                NSString * nextOpenTime = [json[@"game"][@"termList"] lastObject][@"nextOpenTime"];
                NSString * sysTime = json[@"sysTime"];
                //彩种截止时间
                NSDateComponents *deltaDate = [YZDateTool getDeltaDateFromDateString:sysTime fromFormat:@"yyyy-MM-dd HH:mm:ss" toDateString:endTime ToFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDateComponents *nextOpenDeltaDate = [YZDateTool getDeltaDateFromDateString:sysTime fromFormat:@"yyyy-MM-dd HH:mm:ss" toDateString:nextOpenTime ToFormat:@"yyyy-MM-dd HH:mm:ss"];
                _remainSeconds = deltaDate.day * 24 * 60 * 60 + deltaDate.hour * 60 * 60 + deltaDate.minute * 60 + deltaDate.second;
                _nextOpenRemainSeconds = nextOpenDeltaDate.day * 24 * 60 * 60 + nextOpenDeltaDate.hour * 60 * 60 + nextOpenDeltaDate.minute * 60 + nextOpenDeltaDate.second;
            }else
            {
                self.endTimeLabel.text = @"当前期已截止销售";
            }
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"getCurrentTermData - error = %@",error);
    }];
}
- (void)addSetDeadlineTimer
{
    if(self.getCurrentTermDataTimer == nil)//空才创建
    {
        self.getCurrentTermDataTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(setDeadlineTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.getCurrentTermDataTimer forMode:NSRunLoopCommonModes];
        [self.getCurrentTermDataTimer fire];
    }
}
#pragma  mark - 设置时间label
- (void)setDeadlineTime
{
    if(_nextOpenRemainSeconds <= 0 && _remainSeconds <= 0 && ([self.gameId isEqualToString:@"T05"] || [self.gameId isEqualToString:@"T61"] || [self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T63"] || [self.gameId isEqualToString:@"T64"]))
    {
        [self getCurrentTermData];//重新获取所有彩种信息
        return;
    }
    _remainSeconds--;
    _nextOpenRemainSeconds--;
    NSDictionary *json = self.currentTermDict;
    NSString *termId = [json[@"game"][@"termList"] lastObject][@"termId"];
    NSString * nextTermId = [json[@"game"][@"termList"] lastObject][@"nextTermId"];
    //如果是11选5就截取期数，除去时间
    if([self.gameId isEqualToString:@"T05"] || [self.gameId isEqualToString:@"T61"] || [self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T63"] || [self.gameId isEqualToString:@"T64"])//是11选5
    {
        termId = [termId substringFromIndex:6];
        nextTermId = [nextTermId substringFromIndex:6];
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
    NSDateComponents *deltaDate = [YZDateTool getDateComponentsBySeconds:_remainSeconds];
    NSDateComponents *nextOpenDeltaDate = [YZDateTool getDateComponentsBySeconds:_nextOpenRemainSeconds];
    if(_remainSeconds > 0)//当前期正在销售
    {
        NSString * deltaTime;
        if(deltaDate.day > 0)//相差超过一天，就显示天、小时
        {
            deltaTime = [NSString stringWithFormat:@"%ld天%ld小时", (long)deltaDate.day, (long)deltaDate.hour];
        }else if (deltaDate.hour > 0)//相差超过一小时，就显示小时、分
        {
            deltaTime = [NSString stringWithFormat:@"%ld小时%ld分", (long)deltaDate.hour, (long)deltaDate.minute];
        }else if(deltaDate.minute > 0 || deltaDate.second > 0)//相差超过一分钟或者一秒钟，就显示分、秒
        {
            deltaTime = [NSString stringWithFormat:@"%ld分%ld秒", (long)deltaDate.minute, (long)deltaDate.second];
        }
        attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距%@期截止:%@",termId,deltaTime]];
    }else if (_remainSeconds <= 0 && _nextOpenRemainSeconds > 0)//当前期已截止销售,下期还未开始
    {
        NSString * deltaTime;
        if(nextOpenDeltaDate.day > 0)//相差超过一天，就显示天、小时
        {
            deltaTime = [NSString stringWithFormat:@"%ld天%ld小时", (long)nextOpenDeltaDate.day, (long)nextOpenDeltaDate.hour];
        }else if (nextOpenDeltaDate.hour > 0)//相差超过一小时，就显示小时、分
        {
            deltaTime = [NSString stringWithFormat:@"%ld小时%ld分", (long)nextOpenDeltaDate.hour, (long)nextOpenDeltaDate.minute];
        }else if(nextOpenDeltaDate.minute > 0 || nextOpenDeltaDate.second > 0)//相差超过一分钟或者一秒钟，就显示分、秒
        {
            deltaTime = [NSString stringWithFormat:@"%ld分%ld秒", (long)nextOpenDeltaDate.minute, (long)nextOpenDeltaDate.second];
        }
        attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距%@期开始:%@",nextTermId,deltaTime]];
    }else//为0的时候，重新刷新数据
    {
        attStr = [[NSMutableAttributedString alloc]initWithString:@"获取新期次中..."];
        _nextOpenRemainSeconds = 0;
    }
    NSRange qiRange = [[attStr string] rangeOfString:@":"];
    NSRange tianRange = [[attStr string] rangeOfString:@"天"];
    NSRange shiRange = [[attStr string] rangeOfString:@"小时"];
    NSRange fenRange = [[attStr string] rangeOfString:@"分"];
    NSRange miaoRange = [[attStr string] rangeOfString:@"秒"];
    if(tianRange.location != NSNotFound)//天、小时
    {
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(qiRange.location+1, tianRange.location-qiRange.location-1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(tianRange.location+1, shiRange.location-tianRange.location-1)];
    }else if (shiRange.location != NSNotFound)//小时、分
    {
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(qiRange.location+1, shiRange.location-qiRange.location-1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(shiRange.location+2, fenRange.location-shiRange.location-2)];
    }else if (fenRange.location != NSNotFound)//分、秒
    {
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(qiRange.location+1, fenRange.location-qiRange.location-1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(fenRange.location+1, miaoRange.location-fenRange.location-1)];
    }
    self.endTimeLabel.attributedText = attStr;
}
#pragma mark - 多手势识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//冒泡排序球数组
- (NSMutableArray *)sortBallsArray:(NSMutableArray *)mutableArray
{
    if(mutableArray.count == 1) return mutableArray;
    for(int i = 0;i < mutableArray.count;i++)
    {
        for(int j = i + 1;j <mutableArray.count;j++)
        {
            YZBallBtn *ballBtn1 = mutableArray[i];
            YZBallBtn *ballBtn2= mutableArray[j];
            if(ballBtn1.tag > ballBtn2.tag)
            {
                [mutableArray replaceObjectAtIndex:i withObject:ballBtn2];
                [mutableArray replaceObjectAtIndex:j withObject:ballBtn1];
            }
        }
    }
    return mutableArray;
}

#pragma mark - 初始化
- (NSMutableArray *)topBtns
{
    if (_topBtns == nil) {
        _topBtns = [NSMutableArray array];
    }
    return _topBtns;
}

- (NSMutableArray *)tableViews
{
    if(_tableViews == nil)
    {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

#pragma  mark - 销毁对象
- (void)dealloc
{
    [self removeSetDeadlineTimer];
    if(self.menuBackView)
    {
        [self.menuBackView removeFromSuperview];
    }
}
- (void)removeSetDeadlineTimer
{
    [self.getCurrentTermDataTimer invalidate];
    self.getCurrentTermDataTimer = nil;
}

@end
