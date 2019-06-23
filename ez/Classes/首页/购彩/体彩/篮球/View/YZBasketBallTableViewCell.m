//
//  YZBasketBallTableViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/5/28.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZBasketBallTableViewCell.h"
#import "YZBasketBallAllPlayView.h"
#import "YZFootBallMatchRate.h"
#import "YZDateTool.h"

@interface YZBasketBallTableViewCell()<YZBasketBallAllPlayViewDelegate>

@property (nonatomic, weak) UILabel *matchMessageLabel;
@property (nonatomic, weak) UILabel *teamNameLabel;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) YZBasketBallAllPlayView *allPlayView;

@end

@implementation YZBasketBallTableViewCell

+ (YZBasketBallTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZBasketBallTableViewCellId";
    YZBasketBallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZBasketBallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
#pragma mark - 布局视图
- (void)setupChilds
{
    //比赛信息
    UILabel *matchMessageLabel = [[UILabel alloc] init];
    matchMessageLabel.numberOfLines = 0;
    self.matchMessageLabel = matchMessageLabel;
    matchMessageLabel.textColor = YZGrayTextColor;
    matchMessageLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    matchMessageLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat matchMessageLabelW = 75;
    matchMessageLabel.frame = CGRectMake(0, 0, matchMessageLabelW, 110);
    [self addSubview:matchMessageLabel];
    
    //球队名称
    UILabel *teamNameLabel = [[UILabel alloc] init];
    self.teamNameLabel = teamNameLabel;
    teamNameLabel.textColor = YZBlackTextColor;
    teamNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    teamNameLabel.textAlignment = NSTextAlignmentCenter;
    teamNameLabel.frame = CGRectMake(matchMessageLabelW, 2, screenWidth - matchMessageLabelW, 33);
    [self addSubview:teamNameLabel];
    
    CGFloat button1W = 20;
    CGFloat button3W = 45;
    CGFloat button2W = (screenWidth - matchMessageLabelW - 10 - button1W - button3W) / 2;
    CGFloat buttonH = 35;
    for (int i = 0; i < 7; i++) {
        //赔率按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        if (i == 0 || i == 3) {
            button.enabled = NO;
            button.frame = CGRectMake(matchMessageLabelW, CGRectGetMaxY(teamNameLabel.frame) +  buttonH * (i / 3), button1W, buttonH);
            button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
            [button setTitleColor:YZGrayTextColor forState:UIControlStateNormal];
            if (i == 0) {
                [button setTitle:@"胜\n负" forState:UIControlStateNormal];
            }else if (i == 3)
            {
                [button setTitle:@"让\n分" forState:UIControlStateNormal];
                button.backgroundColor = YZColor(224, 241, 201, 1);
            }
        }else if (i == 6)
        {
            button.frame = CGRectMake(matchMessageLabelW + button1W + button2W * 2, CGRectGetMaxY(teamNameLabel.frame), button3W, buttonH * 2);
            button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button setTitle:@"展开\n全部" forState:UIControlStateNormal];
            [self.buttons addObject:button];
        }else
        {
            button.frame = CGRectMake(matchMessageLabelW + button1W + button2W * (i % 3 - 1), CGRectGetMaxY(teamNameLabel.frame) + buttonH * (i / 3), button2W, buttonH);
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button setTitleColor:YZLightDrayColor forState:UIControlStateDisabled];
            button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
            [self.buttons addObject:button];
        }
        button.titleLabel.numberOfLines = 0;
        button.layer.borderWidth = 0.8;
        button.layer.borderColor = YZWhiteLineColor.CGColor;
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:YZLightDrayColor forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(oddInfobuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    //分割线
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, screenWidth, 9)];
    lineView.backgroundColor = YZBackgroundColor;
    [self addSubview:lineView];
}


#pragma mark - 赔率按钮点击
- (void)oddInfobuttonClick:(UIButton *)button
{
    if (button.tag == 6) {
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        self.backView = backView;
        backView.backgroundColor = YZColor(0, 0, 0, 0.4);
        [KEY_WINDOW addSubview:backView];
        
        YZBasketBallAllPlayView * allPlayView = [[YZBasketBallAllPlayView alloc]initWithFrame:CGRectMake(20, statusBarH, screenWidth - 40, screenHeight - statusBarH) matchInfosModel:_matchInfosModel onlyShowShengfen:NO];
        self.allPlayView = allPlayView;
        allPlayView.delegate = self;
        [backView addSubview:allPlayView];
        allPlayView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:animateDuration animations:^{
            allPlayView.transform = CGAffineTransformMakeScale(1, 1);
        }];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBackView)];
        tap.delegate = self;
        [backView addGestureRecognizer:tap];
    }else
    {
        button.selected = !button.selected;
        
        int concedePoints = [_matchInfosModel.concedePoints intValue];
        if (button.tag == 1 || button.tag == 2) {
            //读取
            YZFootBallMatchRate * rate = [[YZFootBallMatchRate alloc]init];
            NSArray * oddInfo = [_matchInfosModel.oddsMap.CN02.oddsInfo componentsSeparatedByString:@"|"];
            //倒序
            NSArray * oddInfos = [[oddInfo reverseObjectEnumerator] allObjects];
            rate.CNType = @"CN02";
            rate.value = oddInfos[button.tag - 1];
            rate.concedePoints = concedePoints;
            rate.info = @[@"客胜", @"主胜"][button.tag - 1];
            NSMutableArray * selMatchArr = _matchInfosModel.selMatchArr[0];
            //修改
            if (button.selected) {
                [selMatchArr addObject:rate];
            }else
            {
                YZFootBallMatchRate * removeRate = [[YZFootBallMatchRate alloc]init];
                for (YZFootBallMatchRate * selRate in selMatchArr) {
                    if ([selRate.info isEqualToString:rate.info]) {
                        removeRate = selRate;
                    }
                }
                [selMatchArr removeObject:removeRate];
            }
            //储存
            _matchInfosModel.selMatchArr[0] = [self orderArray:selMatchArr byPlayType:1];
        }else if (button.tag == 4 || button.tag == 5)
        {
            //读取
            YZFootBallMatchRate * rate = [[YZFootBallMatchRate alloc]init];
            NSArray * oddInfo = [_matchInfosModel.oddsMap.CN01.oddsInfo componentsSeparatedByString:@"|"];
            //倒序
            NSArray * oddInfos = [[oddInfo reverseObjectEnumerator] allObjects];
            rate.CNType = @"CN01";
            rate.value = oddInfos[button.tag - 4];
            rate.concedePoints = concedePoints;
            rate.info = @[@"让分客胜", @"让分主胜"][button.tag - 4];
            NSMutableArray * selMatchArr = _matchInfosModel.selMatchArr[1];
            //修改
            if (button.selected) {
                [selMatchArr addObject:rate];
            }else
            {
                YZFootBallMatchRate * removeRate = [[YZFootBallMatchRate alloc]init];
                for (YZFootBallMatchRate * selRate in selMatchArr) {
                    if ([selRate.info isEqualToString:rate.info]) {
                        removeRate = selRate;
                    }
                }
                [selMatchArr removeObject:removeRate];
            }
            //储存
            _matchInfosModel.selMatchArr[1] = [self orderArray:selMatchArr byPlayType:2];
        }
        
        self.matchInfosModel = _matchInfosModel;
        //代理
        if ([_delegate respondsToSelector:@selector(reloadBottomMidLabelText)]) {
            [_delegate reloadBottomMidLabelText];
        }
    }
}

- (void)removeBackView
{
    [self.backView removeFromSuperview];
}

- (void)upDateByMatchInfosModel:(YZMatchInfosStatus *)matchInfosModel
{
    self.matchInfosModel = matchInfosModel;
    //刷新底部的比赛数信息
    if ([_delegate respondsToSelector:@selector(reloadBottomMidLabelText)]) {
        [_delegate reloadBottomMidLabelText];
    }
}

#pragma mark - 设置数据
- (void)setMatchInfosModel:(YZMatchInfosStatus *)matchInfosModel
{
    _matchInfosModel = matchInfosModel;
    
    //比赛信息
    NSString *macthNum = [_matchInfosModel.code substringFromIndex:9];
    NSString * week = [YZDateTool getWeekFromDateString:_matchInfosModel.endTime format:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * timeDate = [YZDateTool getDateFromDateString:_matchInfosModel.endTime format:@"yyyy-MM-dd HH:mm:ss"];
    NSString * time = [YZDateTool getDateStringFromDate:timeDate format:@"HH:mm"];
    NSMutableAttributedString *matchMessageAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"篮球\n%@%@\n%@截至", week, macthNum, time]];
    [matchMessageAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(30)] range:NSMakeRange(0, 2)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [matchMessageAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, matchMessageAttStr.length)];
    self.matchMessageLabel.attributedText = matchMessageAttStr;
    
    //设置VS双方
    NSArray *detailInfoArray = [_matchInfosModel.detailInfo componentsSeparatedByString:@"|"];
    self.teamNameLabel.text = [NSString stringWithFormat:@"%@（客）VS%@（主）", detailInfoArray[1], detailInfoArray[0]];
    
    //设置赔率
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton * button = self.buttons[i];
        //非让和让球后面的赔率
        NSArray *CN02OddsInfo = [_matchInfosModel.oddsMap.CN02.oddsInfo componentsSeparatedByString:@"|"];
        NSArray *CN01OddsInfo = [_matchInfosModel.oddsMap.CN01.oddsInfo componentsSeparatedByString:@"|"];
        //如果当前不支持单关
        if (_matchInfosModel.oddsMap.CN01.single == 0 && (_matchInfosModel.playTypeTag == 9))
        {
            CN01OddsInfo = [NSArray array];
        }
        NSMutableArray *allOddsInfo1 = [NSMutableArray array];
        [self addOddsInfoToArray1:allOddsInfo1 fromArray2:CN01OddsInfo];
        
        if (_matchInfosModel.oddsMap.CN02.single == 0 && (_matchInfosModel.playTypeTag == 9))
        {
            CN02OddsInfo = [NSArray array];
        }
        NSMutableArray *allOddsInfo2 = [NSMutableArray array];
        [self addOddsInfoToArray1:allOddsInfo2 fromArray2:CN02OddsInfo];
        
        if (i == 0) {
            [button setTitle:[NSString stringWithFormat:@"客胜%@", allOddsInfo2[1]] forState:UIControlStateNormal];
            if([button.currentTitle rangeOfString:@"----"].location != NSNotFound)//没有赔率，按钮失效显示
            {
                button.selected = NO;
                button.enabled = NO;
            }else
            {
                button.enabled = YES;
            }
        }else if (i == 1)
        {
            [button setTitle:[NSString stringWithFormat:@"主胜%@", allOddsInfo2[0]] forState:UIControlStateNormal];
            if([button.currentTitle rangeOfString:@"----"].location != NSNotFound)//没有赔率，按钮失效显示
            {
                button.selected = NO;
                button.enabled = NO;
            }else
            {
                button.enabled = YES;
            }
        }else if (i == 2)
        {
            [button setTitle:[NSString stringWithFormat:@"让分客胜%@", allOddsInfo1[1]] forState:UIControlStateNormal];
            if([button.currentTitle rangeOfString:@"----"].location != NSNotFound)//没有赔率，按钮失效显示
            {
                button.selected = NO;
                button.enabled = NO;
            }else
            {
                button.enabled = YES;
            }
        }else if (i == 3)
        {
            float concedePoints = [_matchInfosModel.concedePoints floatValue];
            NSString *concedePointsStr;
            if (concedePoints >= 0) {
                concedePointsStr = [NSString stringWithFormat:@"+%@", [YZTool formatFloat:concedePoints]];
            }else
            {
                concedePointsStr = [NSString stringWithFormat:@"%@", [YZTool formatFloat:concedePoints]];
            }
            NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"让分主胜(%@)%@", concedePointsStr, allOddsInfo1[0]]];
            if([attStr.string rangeOfString:@"----"].location != NSNotFound)//没有赔率，按钮失效显示
            {
                button.selected = NO;
                button.enabled = NO;
            }else
            {
                button.enabled = YES;
            }
            
            [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, attStr.string.length)];
            if (concedePoints >= 0) {
                [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:[attStr.string rangeOfString:concedePointsStr]];
            }else
            {
                [attStr addAttribute:NSForegroundColorAttributeName value:YZMDGreenColor range:[attStr.string rangeOfString:concedePointsStr]];
            }
            [button setAttributedTitle:attStr forState:UIControlStateNormal];
            
            NSMutableAttributedString *attStr_sel = [attStr mutableCopy];
            [attStr_sel addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStr_sel.string.length)];
            [button setAttributedTitle:attStr_sel forState:UIControlStateSelected];
            [button setAttributedTitle:attStr_sel forState:UIControlStateHighlighted];
            
            NSMutableAttributedString *attStr_dis = [attStr mutableCopy];
            [attStr_dis addAttribute:NSForegroundColorAttributeName value:YZLightDrayColor range:NSMakeRange(0, attStr_dis.string.length)];
            [button setAttributedTitle:attStr_dis forState:UIControlStateDisabled];
        }
        
        //判断是否是选中状态
        button.selected = NO;
        NSMutableArray * selMatchArr = [NSMutableArray array];
        if (i < 2) {
            selMatchArr = _matchInfosModel.selMatchArr[0];
        }else
        {
            selMatchArr = _matchInfosModel.selMatchArr[1];
        }
        for (YZFootBallMatchRate * rate in selMatchArr) {
            if (rate.info != nil && rate.info.length != 0) {
                NSString * info = rate.info;
                //如果找到了就为选中状态
                if ([button.titleLabel.text rangeOfString:info].location != NSNotFound) {
                    button.selected = YES;
                }
            }
        }
    }
    
    //展开全部
    int numberSelMatch = _matchInfosModel.numberSelMatch;
    UIButton * allButton = self.buttons.lastObject;
    if (numberSelMatch > 0) {
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已选\n%d项", numberSelMatch]];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, attStr.string.length)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:[attStr.string rangeOfString:[NSString stringWithFormat:@"%d", numberSelMatch]]];
        [allButton setAttributedTitle:attStr forState:UIControlStateNormal];
        [allButton setBackgroundImage:[UIImage ImageFromColor:YZColor(238, 253, 255, 1) WithRect:allButton.bounds] forState:UIControlStateNormal];
        [allButton setBackgroundImage:[UIImage ImageFromColor:YZColor(238, 253, 255, 1) WithRect:allButton.bounds] forState:UIControlStateSelected];
    }else
    {
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:@"展开\n全部"];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, attStr.string.length)];
        [allButton setAttributedTitle:attStr forState:UIControlStateNormal];
        [allButton setBackgroundImage:[UIImage resizedImageWithName:@""] forState:UIControlStateNormal];
        [allButton setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [allButton setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
    }
}

#pragma mark - 手势协议
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.allPlayView) {
            CGPoint pos = [touch locationInView:self.allPlayView.superview];
            if (CGRectContainsPoint(self.allPlayView.frame, pos)) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - 初始化
- (NSMutableArray *)buttons
{
    if(_buttons == nil)
    {
        _buttons = [[NSMutableArray alloc] init];
    }
    return  _buttons;
}

#pragma mark - 工具
- (void)addOddsInfoToArray1:(NSMutableArray *)array1 fromArray2:(NSArray *)array2
{
    if(!array2 || array2.count == 0)//空
    {
        [array1 addObjectsFromArray:[NSArray arrayWithObjects:@"----", @"----",@"----", nil]];
    }else
    {
        for (id object in array2) {
            if ([object floatValue] == 0) {
                [array1 addObject:@"----"];
            }else
            {
                [array1 addObject:object];
            }
        }
    }
}

- (NSMutableArray *)orderArray:(NSMutableArray *)array byPlayType:(int)playType
{
    NSMutableArray * orderArray = [NSMutableArray array];
    NSArray *foreArr = [NSArray array];
    if (playType == 1) {
        foreArr = @[@"客胜", @"主胜"];
    }else
    {
        foreArr = @[@"让分客胜", @"让分主胜"];
    }
    for (NSString * foreStr in foreArr) {
        for (YZFootBallMatchRate * rate in array) {
            if ([foreStr isEqualToString:rate.info]) {
                [orderArray addObject:rate];
            }
        }
    }
    return orderArray;
}

@end
