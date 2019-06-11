//
//  YZBasketBallTableViewCell1.m
//  ez
//
//  Created by 毛文豪 on 2018/5/28.
//  Copyright © 2018年 9ge. All rights reserved.
//
#define vsLabelW 50
#define matchMessageLabelW 75
#define buttonH 60

#import "YZBasketBallTableViewCell1.h"
#import "YZFootBallMatchRate.h"
#import "YZDateTool.h"

@interface YZBasketBallTableViewCell1()

@property (nonatomic, weak) UILabel *matchMessageLabel;
@property (nonatomic, weak) UILabel *vsLabel;
@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation YZBasketBallTableViewCell1

+ (YZBasketBallTableViewCell1 *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZBasketBallTableViewCell1Id";
    YZBasketBallTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZBasketBallTableViewCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    matchMessageLabel.frame = CGRectMake(0, 0, matchMessageLabelW, 80);
    [self addSubview:matchMessageLabel];
 
    //赔率按钮
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 0.8;
        button.layer.borderColor = YZWhiteLineColor.CGColor;
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(oddInfobuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttons addObject:button];
    }
    
    //vs
    UILabel *vsLabel = [[UILabel alloc] init];
    self.vsLabel = vsLabel;
    vsLabel.backgroundColor = YZBackgroundColor;
    vsLabel.textColor = [UIColor grayColor];
    vsLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    vsLabel.textAlignment = NSTextAlignmentCenter;
    vsLabel.numberOfLines = 0;
    vsLabel.frame = CGRectMake(0, 10, vsLabelW, buttonH);
    vsLabel.centerX = matchMessageLabelW + (screenWidth - matchMessageLabelW - 10) / 2;
    vsLabel.layer.borderWidth = 0.8;
    vsLabel.layer.borderColor = YZWhiteLineColor.CGColor;
    vsLabel.hidden = YES;
    [self addSubview:vsLabel];
    
    //分割线
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, screenWidth, 9)];
    lineView.backgroundColor = YZBackgroundColor;
    [self addSubview:lineView];
}

#pragma mark - 赔率按钮点击
- (void)oddInfobuttonClick:(UIButton *)button
{
    button.selected = !button.selected;
    
    int concedePoints = [_matchInfosModel.concedePoints intValue];
    if (_matchInfosModel.playTypeTag == 0 || _matchInfosModel.playTypeTag == 5) {//胜负
        //读取
        YZFootBallMatchRate * rate = [[YZFootBallMatchRate alloc]init];
        NSArray * oddInfo = [_matchInfosModel.oddsMap.CN02.oddsInfo componentsSeparatedByString:@"|"];
        //倒序
        NSArray * oddInfos = [[oddInfo reverseObjectEnumerator] allObjects];
        rate.CNType = @"CN02";
        rate.value = oddInfos[button.tag];
        rate.concedePoints = concedePoints;
        rate.info = @[@"客胜", @"主胜"][button.tag];
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
    }else if (_matchInfosModel.playTypeTag == 2 || _matchInfosModel.playTypeTag == 7) {//让分胜负
        //读取
        YZFootBallMatchRate * rate = [[YZFootBallMatchRate alloc]init];
        NSArray * oddInfo = [_matchInfosModel.oddsMap.CN01.oddsInfo componentsSeparatedByString:@"|"];
        //倒序
        NSArray * oddInfos = [[oddInfo reverseObjectEnumerator] allObjects];
        rate.CNType = @"CN01";
        rate.value = oddInfos[button.tag];
        rate.concedePoints = concedePoints;
        rate.info = @[@"让分客胜", @"让分主胜"][button.tag];
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
    }else if (_matchInfosModel.playTypeTag == 1 || _matchInfosModel.playTypeTag == 6) {//大小分
        //读取
        YZFootBallMatchRate * rate = [[YZFootBallMatchRate alloc]init];
        NSArray * oddsInfos = [_matchInfosModel.oddsMap.CN04.oddsInfo componentsSeparatedByString:@"|"];
        rate.CNType = @"CN04";
        rate.value = oddsInfos[button.tag];
        rate.concedePoints = concedePoints;
        rate.info = @[@"大分", @"小分"][button.tag];
        NSMutableArray * selMatchArr = _matchInfosModel.selMatchArr[2];
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
        _matchInfosModel.selMatchArr[2] = [self orderArray:selMatchArr byPlayType:3];
    }
    
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
    paragraphStyle.lineSpacing = 3;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [matchMessageAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, matchMessageAttStr.length)];
    self.matchMessageLabel.attributedText = matchMessageAttStr;
    
    //设置赔率
    NSArray *detailInfoArray = [_matchInfosModel.detailInfo componentsSeparatedByString:@"|"];
    if (_matchInfosModel.playTypeTag == 0 || _matchInfosModel.playTypeTag == 5) {//胜负
        self.vsLabel.hidden = YES;
        CGFloat buttonW = (screenWidth - matchMessageLabelW - 10) / 2;
        for (UIButton * button in self.buttons) {
            button.selected = NO;
            NSInteger index = [self.buttons indexOfObject:button];
            button.frame = CGRectMake(matchMessageLabelW + buttonW * index, 10, buttonW, buttonH);
            NSArray *CN02OddsInfo = [_matchInfosModel.oddsMap.CN02.oddsInfo componentsSeparatedByString:@"|"];
            //如果当前不支持单关
            if (_matchInfosModel.oddsMap.CN02.single == 0 && (_matchInfosModel.playTypeTag == 5))
                {
                CN02OddsInfo = [NSArray array];
            }
            NSMutableArray *allOddsInfo = [NSMutableArray array];
            [self addOddsInfoToArray1:allOddsInfo fromArray2:CN02OddsInfo];
            
            NSString * teamStr = [NSString string];
            NSString * rateStr = [NSString string];
            if (index == 0) {
                teamStr = [NSString stringWithFormat:@"%@(客)", detailInfoArray[1]];
                rateStr = [NSString stringWithFormat:@"客胜%@", allOddsInfo[1]];
            }else
            {
                teamStr = [NSString stringWithFormat:@"%@(主)", detailInfoArray[0]];
                rateStr = [NSString stringWithFormat:@"主胜%@", allOddsInfo[0]];
            }
            if([rateStr rangeOfString:@"----"].location != NSNotFound)//没有赔率，按钮失效显示
            {
                button.selected = NO;
                button.enabled = NO;
            }else
            {
                button.enabled = YES;
            }
            NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", teamStr, rateStr]];
            [attStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:[attStr.string rangeOfString:teamStr]];
            [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[attStr.string rangeOfString:rateStr]];
            [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:[attStr.string rangeOfString:teamStr]];
            [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:[attStr.string rangeOfString:rateStr]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
            [button setAttributedTitle:attStr forState:UIControlStateNormal];
            
            NSMutableAttributedString *attStr_sel = [attStr mutableCopy];
            [attStr_sel addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStr_sel.string.length)];
            [button setAttributedTitle:attStr_sel forState:UIControlStateSelected];
            [button setAttributedTitle:attStr_sel forState:UIControlStateHighlighted];
            
            NSMutableAttributedString *attStr_dis = [attStr mutableCopy];
            [attStr_dis addAttribute:NSForegroundColorAttributeName value:YZLightDrayColor range:NSMakeRange(0, attStr_dis.string.length)];
            [button setAttributedTitle:attStr_dis forState:UIControlStateDisabled];
        }
    }else if (_matchInfosModel.playTypeTag == 2 || _matchInfosModel.playTypeTag == 7) {//让分胜负
        self.vsLabel.hidden = YES;
        CGFloat buttonW = (screenWidth - matchMessageLabelW - 10) / 2;
        for (UIButton * button in self.buttons) {
            button.selected = NO;
            NSInteger index = [self.buttons indexOfObject:button];
            button.frame = CGRectMake(matchMessageLabelW + buttonW * index, 10, buttonW, buttonH);
            NSArray *CN01OddsInfo = [_matchInfosModel.oddsMap.CN01.oddsInfo componentsSeparatedByString:@"|"];
            //如果当前不支持单关
            if (_matchInfosModel.oddsMap.CN01.single == 0 && (_matchInfosModel.playTypeTag == 7))
            {
                CN01OddsInfo = [NSArray array];
            }
            NSMutableArray *allOddsInfo = [NSMutableArray array];
            [self addOddsInfoToArray1:allOddsInfo fromArray2:CN01OddsInfo];
            
            NSString * teamStr = [NSString string];
            NSString * rateStr = [NSString string];
            if (index == 0) {
                teamStr = [NSString stringWithFormat:@"%@(客)", detailInfoArray[1]];
                rateStr = [NSString stringWithFormat:@"客胜%@", allOddsInfo[1]];
            }else
            {
                teamStr = [NSString stringWithFormat:@"%@(主)", detailInfoArray[0]];
                rateStr = [NSString stringWithFormat:@"主胜%@", allOddsInfo[0]];
            }
            if([rateStr rangeOfString:@"----"].location != NSNotFound)//没有赔率，按钮失效显示
            {
                button.selected = NO;
                button.enabled = NO;
            }else
            {
                button.enabled = YES;
            }
            NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] init];
            if (index == 1) {
                float concedePoints = [_matchInfosModel.concedePoints floatValue];
                NSString *concedePointsStr;
                if (concedePoints >= 0) {
                    concedePointsStr = [NSString stringWithFormat:@"+%@", [YZTool formatFloat:concedePoints]];
                }else
                {
                    concedePointsStr = [NSString stringWithFormat:@"%@", [YZTool formatFloat:concedePoints]];
                }
                attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@(%@)\n%@", teamStr, concedePointsStr, rateStr]];
                if (concedePoints >= 0) {
                    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:[attStr.string rangeOfString:concedePointsStr]];
                }else
                {
                    [attStr addAttribute:NSForegroundColorAttributeName value:YZMDGreenColor range:[attStr.string rangeOfString:concedePointsStr]];
                }
            }else
            {
                attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", teamStr, rateStr]];
            }
            [attStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:[attStr.string rangeOfString:teamStr]];
            [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[attStr.string rangeOfString:rateStr]];
            [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:[attStr.string rangeOfString:teamStr]];
            [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:[attStr.string rangeOfString:rateStr]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
            [button setAttributedTitle:attStr forState:UIControlStateNormal];
            
            NSMutableAttributedString *attStr_sel = [attStr mutableCopy];
            [attStr_sel addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStr_sel.string.length)];
            [button setAttributedTitle:attStr_sel forState:UIControlStateSelected];
            [button setAttributedTitle:attStr_sel forState:UIControlStateHighlighted];
            
            NSMutableAttributedString *attStr_dis = [attStr mutableCopy];
            [attStr_dis addAttribute:NSForegroundColorAttributeName value:YZLightDrayColor range:NSMakeRange(0, attStr_dis.string.length)];
            [button setAttributedTitle:attStr_dis forState:UIControlStateDisabled];
        }
    }else if (_matchInfosModel.playTypeTag == 1 || _matchInfosModel.playTypeTag == 6) {//大小分
        self.vsLabel.hidden = NO;
        NSString * yuzongfen = [NSString stringWithFormat:@"%@", self.matchInfosModel.oddsMap.CN04.concedePoints];
        self.vsLabel.text = [NSString stringWithFormat:@"VS\n%@", yuzongfen];
        CGFloat buttonW = (screenWidth - matchMessageLabelW - 10 - vsLabelW) / 2;
        for (UIButton * button in self.buttons) {
            button.selected = NO;
            NSInteger index = [self.buttons indexOfObject:button];
            button.frame = CGRectMake(matchMessageLabelW + (buttonW + vsLabelW) * index, 10, buttonW, buttonH);
            NSArray *CN04OddsInfo = [_matchInfosModel.oddsMap.CN04.oddsInfo componentsSeparatedByString:@"|"];
            //如果当前不支持单关
            if (_matchInfosModel.oddsMap.CN04.single == 0 && (_matchInfosModel.playTypeTag == 6))
            {
                CN04OddsInfo = [NSArray array];
            }
            NSMutableArray *allOddsInfo = [NSMutableArray array];
            [self addOddsInfoToArray1:allOddsInfo fromArray2:CN04OddsInfo];
            
            NSString * teamStr = [NSString string];
            NSString * rateStr = [NSString string];
            if (index == 0) {
                teamStr = [NSString stringWithFormat:@"%@(客)", detailInfoArray[1]];
                rateStr = [NSString stringWithFormat:@"客胜%@", allOddsInfo[0]];
            }else
            {
                teamStr = [NSString stringWithFormat:@"%@(主)", detailInfoArray[0]];
                rateStr = [NSString stringWithFormat:@"主胜%@", allOddsInfo[1]];
            }
            if([rateStr rangeOfString:@"----"].location != NSNotFound)//没有赔率，按钮失效显示
            {
                button.selected = NO;
                button.enabled = NO;
            }else
            {
                button.enabled = YES;
            }
            NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", teamStr, rateStr]];
            [attStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:[attStr.string rangeOfString:teamStr]];
            [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[attStr.string rangeOfString:rateStr]];
            [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:[attStr.string rangeOfString:teamStr]];
            [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:[attStr.string rangeOfString:rateStr]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
            [button setAttributedTitle:attStr forState:UIControlStateNormal];
            
            NSMutableAttributedString *attStr_sel = [attStr mutableCopy];
            [attStr_sel addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStr_sel.string.length)];
            [button setAttributedTitle:attStr_sel forState:UIControlStateSelected];
            [button setAttributedTitle:attStr_sel forState:UIControlStateHighlighted];
            
            NSMutableAttributedString *attStr_dis = [attStr mutableCopy];
            [attStr_dis addAttribute:NSForegroundColorAttributeName value:YZLightDrayColor range:NSMakeRange(0, attStr_dis.string.length)];
            [button setAttributedTitle:attStr_dis forState:UIControlStateDisabled];
        }
    }
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
    }else if (playType == 2)
    {
        foreArr = @[@"让分客胜", @"让分主胜"];
    }else if (playType == 3)
    {
        foreArr = @[@"大分", @"小分"];
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
