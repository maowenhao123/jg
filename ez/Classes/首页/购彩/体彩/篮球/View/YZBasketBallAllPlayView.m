//
//  YZBasketBallAllPlayView.m
//  ez
//
//  Created by 毛文豪 on 2018/5/22.
//  Copyright © 2018年 9ge. All rights reserved.
//
#define bigFont [UIFont systemFontOfSize:14]
#define midFont [UIFont systemFontOfSize:13]
#define littleFont [UIFont systemFontOfSize:12]
#define smallFont [UIFont systemFontOfSize:11]
#define KButtonH 42
#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height

#import "YZBasketBallAllPlayView.h"
#import "YZFootBallMatchRate.h"

@interface YZBasketBallAllPlayView()

@property (nonatomic, weak) UILabel *VsLabel;//VsLabel
@property (nonatomic, weak) UILabel *Vs1Label;//Vs1Label
@property (nonatomic, weak) UILabel *Vs2Label;//Vs2Label
@property (nonatomic, strong) NSMutableArray *btns;//按钮数组
@property (nonatomic, strong) NSMutableArray *labels;//标签数组
@property (nonatomic, strong) NSArray *foreStrArrs1;
@property (nonatomic, strong) NSArray *foreStrArrs2;
@property (nonatomic, strong) NSArray *foreStrArrs3;
@property (nonatomic, strong) NSArray *foreStrArrs4;
@property (nonatomic, strong) NSMutableArray *selMatchArr;//半场 比分 总进球 选中的玩法

@end

@implementation YZBasketBallAllPlayView

- (instancetype)initWithFrame:(CGRect)frame matchInfosModel:(YZMatchInfosStatus *)matchInfosModel onlyShowShengfen:(BOOL)onlyShowShengfen
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.matchInfosModel = matchInfosModel;
        self.onlyShowShengfen = onlyShowShengfen;
        [self setupChilds];
        [self setStatus];//设置数据
    }
    return self;
}

#pragma mark - 布局视图
- (void)setupChilds
{
    //设置对阵双方
    CGFloat gap = 10;
    CGFloat vsLabelMaxW = KWidth - gap * 2;
    CGFloat VsLabelH = 35;
    CGFloat vs1LabelW = 0;
    for(int i = 0;i < 3;i++)
    {
        UILabel *VsLabel = [[UILabel alloc] init];
        VsLabel.font = bigFont;
        VsLabel.textColor = YZBlackTextColor;
        if(i == 0){//中间显示VS的label
            self.VsLabel = VsLabel;
            VsLabel.text = @"VS";
            CGSize labelSize = [VsLabel.text sizeWithFont:bigFont maxSize:CGSizeMake(vsLabelMaxW, 30)];
            vs1LabelW = (vsLabelMaxW - labelSize.width) / 2;
            CGFloat VsLabelX = gap + vs1LabelW;
            VsLabel.frame = CGRectMake(VsLabelX, 5, labelSize.width, VsLabelH);
        }else if(i == 1){//vs左边的文字
            self.Vs1Label = VsLabel;
            VsLabel.frame = CGRectMake(gap, 5, vs1LabelW, VsLabelH);
            VsLabel.textAlignment = NSTextAlignmentCenter;
            VsLabel.text = @"主队";
        }else{
            self.Vs2Label = VsLabel;
            VsLabel.textAlignment = NSTextAlignmentCenter;
            CGFloat vsLabelX = CGRectGetMaxX(self.VsLabel.frame);
            VsLabel.frame = CGRectMake(vsLabelX, 5, vs1LabelW, VsLabelH);
            VsLabel.text = @"主队";
        }
        [self addSubview:VsLabel];
    }
    
    UIView * shengfenView;
    if (self.onlyShowShengfen) {
        //胜分差
        shengfenView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.Vs1Label.frame) + 5, KWidth, KButtonH * 4)];
        [self addSubview:shengfenView];
        
        [self layoutPlayTitleLabelInView:shengfenView withTitle:@"胜\n分\n差" andBackgroundColorIsBlue:NO];
        [self layoutButtonInView:shengfenView withBtnCount:12 andTagFore:300 maxColums:3];

    }else
    {
        //胜负
        UIView * shengfuView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.Vs1Label.frame) + 5, KWidth, KButtonH)];
        [self addSubview:shengfuView];
        
        [self layoutPlayTitleLabelInView:shengfuView withTitle:@"胜\n负" andBackgroundColorIsBlue:YES];
        [self layoutButtonInView:shengfuView withBtnCount:2 andTagFore:0 maxColums:2];
        
        //让分
        UIView * rangView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shengfuView.frame) + 15, KWidth, KButtonH + 25)];
        [self addSubview:rangView];
        
        [self layoutPlayTitleLabelInView:rangView withTitle:@"让\n分" andBackgroundColorIsBlue:NO];
        [self layoutButtonInView:rangView withBtnCount:2 andTagFore:100 maxColums:2];
        [self layoutLabelInView:rangView andTagFore:1000];
        
        //大小分
        UIView * daxiaoView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(rangView.frame) + 15, KWidth, KButtonH + 25)];
        [self addSubview:daxiaoView];
        
        [self layoutPlayTitleLabelInView:daxiaoView withTitle:@"大\n小\n分" andBackgroundColorIsBlue:YES];
        [self layoutButtonInView:daxiaoView withBtnCount:2 andTagFore:200 maxColums:2];
        [self layoutLabelInView:daxiaoView andTagFore:2000];
        
        //胜分差
        shengfenView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(daxiaoView.frame) + 15, KWidth, KButtonH * 4)];
        [self addSubview:shengfenView];
        
        [self layoutPlayTitleLabelInView:shengfenView withTitle:@"胜\n分\n差" andBackgroundColorIsBlue:NO];
        [self layoutButtonInView:shengfenView withBtnCount:12 andTagFore:300 maxColums:3];
    }
    
    //底部视图
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shengfenView.frame) + 10, KWidth, 50)];
    [self addSubview:bottomView];
    
    //底部的两个按钮
    float btnW = KWidth/2 - 20;
    float btnH = 35;
    UIColor * orangeColor = YZColor(247, 81, 53, 1);
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 7.5, btnW, btnH);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:orangeColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = bigFont;
    [cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.borderWidth = 0.8;
    cancelBtn.layer.borderColor = orangeColor.CGColor;
    [bottomView addSubview:cancelBtn];
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(KWidth/2 + 10, 7.5, btnW, btnH);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = bigFont;
    [confirmBtn addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.backgroundColor = orangeColor;
    [bottomView addSubview:confirmBtn];
    
    self.height = CGRectGetMaxY(bottomView.frame) + 5;
    self.center = CGPointMake(screenWidth / 2, screenHeight / 2);
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

//左边的玩法标题
- (void)layoutPlayTitleLabelInView:(UIView *)view withTitle:(NSString *)title andBackgroundColorIsBlue:(BOOL)isBlue
{
    UIColor * backgroundColor;
    if (isBlue) {
        backgroundColor = YZColor(130, 187, 188, 1);
    }else
    {
        backgroundColor = YZColor(123, 177, 136, 1);
    }
    UILabel * feiTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 20, view.bounds.size.height)];
    feiTitleLabel.backgroundColor = backgroundColor;
    feiTitleLabel.text = title;
    feiTitleLabel.numberOfLines = 0;
    feiTitleLabel.textAlignment = NSTextAlignmentCenter;
    feiTitleLabel.textColor = [UIColor whiteColor];
    feiTitleLabel.font = littleFont;
    [view addSubview:feiTitleLabel];
}

//布局赔率按钮
- (void)layoutButtonInView:(UIView *)view withBtnCount:(int)count andTagFore:(int)tagFore maxColums:(int)maxColums
{
    float leftPadding = 20 + 10;
    float rightPadding = 10;
    float btnW = (KWidth - leftPadding - rightPadding)/maxColums;
    float btnH = KButtonH;
    NSMutableArray * btnArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnX = leftPadding + (i % maxColums) * btnW;
        CGFloat btnY = (i / maxColums) * btnH;
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        button.tag = tagFore + i;
        button.titleLabel.numberOfLines = 0;
        [button setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.titleLabel.font = bigFont;
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(oddInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.layer.borderWidth = 0.8;
        button.layer.borderColor = YZWhiteLineColor.CGColor;
        
        [btnArray addObject:button];
        [view addSubview:button];
    }
    [self.btns addObject:btnArray];
}

- (void)layoutLabelInView:(UIView *)view andTagFore:(int)tagFore
{
    UILabel *label = [[UILabel alloc] init];
    label.font = midFont;
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(10 + 20, view.height - 25, KWidth - 20 - 10 - 10, 25);
    label.textColor = [UIColor grayColor];
    label.layer.borderWidth = 0.8;
    label.layer.borderColor = YZWhiteLineColor.CGColor;
    [view addSubview:label];
    [self.labels addObject:label];
}

#pragma mark - 设置数据
- (void)setStatus
{
    //设置VS双方
    NSArray *detailInfoArray = [self.matchInfosModel.detailInfo componentsSeparatedByString:@"|"];
    self.Vs1Label.text = [NSString stringWithFormat:@"%@(客)", detailInfoArray[1]];
    self.Vs2Label.text = [NSString stringWithFormat:@"%@(主)", detailInfoArray[0]];
    
    if (self.onlyShowShengfen) {
        NSString * oddsInfoStr = self.matchInfosModel.oddsMap.CN03.oddsInfo;
        NSArray * oddInfos = [oddsInfoStr componentsSeparatedByString:@"|"];
        NSMutableArray *allOddsInfo = [NSMutableArray array];
        [self addOddsInfoToArray1:allOddsInfo fromArray2:oddInfos number:12];//总进球有八个按钮
        
        NSArray * selMatchArray = self.matchInfosModel.selMatchArr[3];
        NSMutableArray * btns = self.btns.firstObject;
        for (int j = 0; j < allOddsInfo.count; j++) {
            UIButton * button = btns[j];
            NSString * foreStr = self.foreStrArrs4[j];
            NSString * oddInfoStr = nil;
            if (j > 5) {
                oddInfoStr = allOddsInfo[j - 6];
            }else
            {
                oddInfoStr = allOddsInfo[j + 6];
            }
            if ([oddInfoStr floatValue] == 0 || (self.matchInfosModel.oddsMap.CN03.single == 0 && self.matchInfosModel.playTypeTag == 8)) {
                oddInfoStr = @"----";
            }
            NSString * btnStr = [NSString stringWithFormat:@"%@\n%@",foreStr,oddInfoStr];
            [self setButton:button withBtnStr:btnStr andBigNumber:foreStr.length andselBtnTitles:selMatchArray andForeStr:foreStr];
        }
    }else
    {
        for (int i = 0; i < self.labels.count; i++) {
            UILabel * label = self.labels[i];
            if (i == 0) {
                NSString *concedePoints = [NSString stringWithFormat:@"%@", self.matchInfosModel.oddsMap.CN01.concedePoints];
                NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] init];
                if ([concedePoints floatValue] >= 0) {
                    attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"让分胜负(主队+%@)", concedePoints]];
                    [attStr addAttribute:NSForegroundColorAttributeName value:YZMDRedColor range:[attStr.string rangeOfString:concedePoints]];
                }else
                {
                    attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"让分胜负(主队%@)", concedePoints]];
                    [attStr addAttribute:NSForegroundColorAttributeName value:YZMDGreenColor range:[attStr.string rangeOfString:concedePoints]];
                }
                label.attributedText = attStr;
            }else
            {
                NSString * yuzongfen = [NSString stringWithFormat:@"%@", self.matchInfosModel.oddsMap.CN04.concedePoints];
                label.text = [NSString stringWithFormat:@"预设总分(%@)", yuzongfen];
            }
        }
        
        //设置赔率数据
        for (int i = 0; i < 4; i++) {
            NSArray * btns = self.btns[i];
            if (i == 0) {//胜负
                NSString * oddsInfoStr = self.matchInfosModel.oddsMap.CN02.oddsInfo;
                NSArray * oddInfos = [oddsInfoStr componentsSeparatedByString:@"|"];
                if (self.matchInfosModel.oddsMap.CN02.single == 0 && self.matchInfosModel.playTypeTag == 9) {
                    oddInfos = [NSArray array];
                }
                NSMutableArray *allOddsInfo = [NSMutableArray array];
                [self addOddsInfoToArray1:allOddsInfo fromArray2:oddInfos number:2];
                NSArray * selMatchArray = self.matchInfosModel.selMatchArr[0];
                //倒序
                NSArray * allOddsInfos = [[allOddsInfo reverseObjectEnumerator] allObjects];
                for (int j = 0; j < allOddsInfos.count; j++) {
                    UIButton * button = btns[j];
                    NSString * foreStr = self.foreStrArrs1[j];
                    NSString * oddInfoStr = allOddsInfos[j];
                    if ([oddInfoStr floatValue] == 0) {
                        oddInfoStr = @"----";
                    }
                    NSString * btnStr = [NSString stringWithFormat:@"%@\n%@",foreStr,oddInfoStr];
                    [self setButton:button withBtnStr:btnStr andBigNumber:foreStr.length andselBtnTitles:selMatchArray andForeStr:foreStr];
                }
            }else if (i == 1)//让分
            {
                NSString * oddsInfoStr = self.matchInfosModel.oddsMap.CN01.oddsInfo;
                NSArray * oddInfos = [oddsInfoStr componentsSeparatedByString:@"|"];
                if (self.matchInfosModel.oddsMap.CN01.single == 0 && self.matchInfosModel.playTypeTag == 9) {
                    oddInfos = [NSArray array];
                }
                NSMutableArray *allOddsInfo = [NSMutableArray array];
                [self addOddsInfoToArray1:allOddsInfo fromArray2:oddInfos number:2];
                NSArray * selMatchArray = self.matchInfosModel.selMatchArr[1];
                //倒序
                NSArray * allOddsInfos = [[allOddsInfo reverseObjectEnumerator] allObjects];
                for (int j = 0; j < allOddsInfos.count; j++) {
                    UIButton * button = btns[j];
                    NSString * foreStr = self.foreStrArrs2[j];
                    NSString * oddInfoStr = allOddsInfo[j];
                    if ([oddInfoStr floatValue] == 0) {
                        oddInfoStr = @"----";
                    }
                    NSString * btnStr = [NSString stringWithFormat:@"%@\n%@",foreStr,oddInfoStr];
                    [self setButton:button withBtnStr:btnStr andBigNumber:foreStr.length andselBtnTitles:selMatchArray andForeStr:foreStr];
                }
            }else if (i == 2)//大小分
            {
                NSString * oddsInfoStr = self.matchInfosModel.oddsMap.CN04.oddsInfo;
                NSArray * oddInfos = [oddsInfoStr componentsSeparatedByString:@"|"];
                if (self.matchInfosModel.oddsMap.CN04.single == 0 && self.matchInfosModel.playTypeTag == 9) {
                    oddInfos = [NSArray array];
                }
                NSMutableArray *allOddsInfo = [NSMutableArray array];
                [self addOddsInfoToArray1:allOddsInfo fromArray2:oddInfos number:2];
                NSArray * selMatchArray = self.matchInfosModel.selMatchArr[2];
                for (int j = 0; j < allOddsInfo.count; j++) {
                    UIButton * button = btns[j];
                    NSString * foreStr = self.foreStrArrs3[j];
                    NSString * oddInfoStr = allOddsInfo[j];
                    if ([oddInfoStr floatValue] == 0) {
                        oddInfoStr = @"----";
                    }
                    NSString * btnStr = [NSString stringWithFormat:@"%@\n%@",foreStr,oddInfoStr];
                    [self setButton:button withBtnStr:btnStr andBigNumber:foreStr.length andselBtnTitles:selMatchArray andForeStr:foreStr];
                }
            }else if (i == 3)//胜分差
            {
                NSString * oddsInfoStr = self.matchInfosModel.oddsMap.CN03.oddsInfo;
                NSArray * oddInfos = [oddsInfoStr componentsSeparatedByString:@"|"];
                if (self.matchInfosModel.oddsMap.CN03.single == 0 && self.matchInfosModel.playTypeTag == 9) {
                    oddInfos = [NSArray array];
                }
                NSMutableArray *allOddsInfo = [NSMutableArray array];
                [self addOddsInfoToArray1:allOddsInfo fromArray2:oddInfos number:12];//总进球有八个按钮
                
                NSArray * selMatchArray = self.matchInfosModel.selMatchArr[3];
                for (int j = 0; j < allOddsInfo.count; j++) {
                    UIButton * button = btns[j];
                    NSString * foreStr =self.foreStrArrs4[j];
                    NSString * oddInfoStr = @"";
                    if (j > 5) {
                        oddInfoStr = allOddsInfo[j - 6];
                    }else
                    {
                        oddInfoStr = allOddsInfo[j + 6];
                    }
                    if ([oddInfoStr floatValue] == 0) {
                        oddInfoStr = @"----";
                    }
                    NSString * btnStr = [NSString stringWithFormat:@"%@\n%@",foreStr,oddInfoStr];
                    [self setButton:button withBtnStr:btnStr andBigNumber:foreStr.length andselBtnTitles:selMatchArray andForeStr:foreStr];
                }
            }
        }
    }
}

//设置button状态
- (void)setButton:(UIButton *)button withBtnStr:(NSString *)btnStr andBigNumber:(NSInteger)bigNum andselBtnTitles:(NSArray *)selMatchArr andForeStr:(NSString *)foreStr
{
    NSMutableAttributedString * btnAttStr = [[NSMutableAttributedString alloc]initWithString:btnStr];
    //字体属性
    [btnAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, bigNum)];
    [btnAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(bigNum, btnStr.length - bigNum)];
    [btnAttStr addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(0, bigNum)];
    [btnAttStr addAttribute:NSFontAttributeName value:littleFont range:NSMakeRange(bigNum, btnStr.length - bigNum)];
    //换行后依旧居中对齐
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attDict = @{NSParagraphStyleAttributeName : paragraphStyle};
    [btnAttStr addAttributes:attDict range:NSMakeRange(0, btnAttStr.length)];
    [button setAttributedTitle:btnAttStr forState:UIControlStateNormal];
    //选中状态下的字体为白色
    NSMutableAttributedString * attStr_white = [[NSMutableAttributedString alloc]initWithAttributedString:btnAttStr];
    [attStr_white addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, btnAttStr.length)];
    [button setAttributedTitle:attStr_white forState:UIControlStateSelected];
    [button setAttributedTitle:attStr_white forState:UIControlStateHighlighted];
    //Disabled状态下的字体为灰色
    NSMutableAttributedString * attStr_gray = [[NSMutableAttributedString alloc]initWithAttributedString:btnAttStr];
    [attStr_gray addAttribute:NSForegroundColorAttributeName value:YZLightDrayColor range:NSMakeRange(0, btnAttStr.length)];
    [button setAttributedTitle:attStr_gray forState:UIControlStateDisabled];
    if([btnStr rangeOfString:@"----"].location != NSNotFound)//没有赔率，按钮失效显示
    {
        button.selected = NO;
        button.enabled = NO;
    }else
    {
        button.enabled = YES;
    }
    //是否选中
    button.selected = NO;
    //是否选中
    for (YZFootBallMatchRate * rate in selMatchArr) {
        if ([rate.info isEqualToString:foreStr]) {
            button.selected = YES;
        }
    }
}

#pragma mark - 按钮点击
//赔率按钮点击
- (void)oddInfoBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
    
    NSMutableArray * selMatchArr = [NSMutableArray array];
    YZFootBallMatchRate * rate = [[YZFootBallMatchRate alloc]init];
    if (button.tag < 100) {//胜负
        selMatchArr = self.selMatchArr[0];
        NSArray * oddInfo = [ self.matchInfosModel.oddsMap.CN02.oddsInfo componentsSeparatedByString:@"|"];
        //倒序
        NSArray * oddInfos = [[oddInfo reverseObjectEnumerator] allObjects];
        rate.info = self.foreStrArrs1[button.tag];
        rate.value = oddInfos[button.tag];
        rate.CNType = @"CN02";
    }else if (button.tag >= 100 && button.tag < 200)//让分
    {
        selMatchArr = self.selMatchArr[1];
        NSArray * oddInfo = [ self.matchInfosModel.oddsMap.CN01.oddsInfo componentsSeparatedByString:@"|"];
        //倒序
        NSArray * oddInfos = [[oddInfo reverseObjectEnumerator] allObjects];
        rate.info = self.foreStrArrs2[button.tag - 100];
        rate.value = oddInfos[button.tag - 100];
        rate.CNType = @"CN01";
    }else if (button.tag >= 200 && button.tag < 300)//大小分
    {
        selMatchArr = self.selMatchArr[2];
        NSArray * oddInfos = [ self.matchInfosModel.oddsMap.CN04.oddsInfo componentsSeparatedByString:@"|"];
        rate.info = self.foreStrArrs3[button.tag - 200];
        rate.value = oddInfos[button.tag - 200];
        rate.CNType = @"CN04";
    }else if (button.tag >= 300 && button.tag < 400)//胜分差
    {
        selMatchArr = self.selMatchArr[3];
        NSArray * oddInfos = [ self.matchInfosModel.oddsMap.CN03.oddsInfo componentsSeparatedByString:@"|"];
        rate.info = self.foreStrArrs4[button.tag - 300];
        if (button.tag > 305) {
            rate.value = oddInfos[button.tag - 300 - 6];
        }else
        {
            rate.value = oddInfos[button.tag - 300 + 6];
        }
        rate.CNType = @"CN03";
    }
    signed int concedePoints = [self.matchInfosModel.concedePoints intValue];//让球数
    rate.concedePoints = concedePoints;
    //修改
    if (selMatchArr == nil || selMatchArr.count == 0) {
        selMatchArr = [NSMutableArray array];
    }
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
    if (button.tag < 100) {
        self.selMatchArr[0] = [self orderArray:selMatchArr byPlayType:1];
    }else if (button.tag >= 100 && button.tag < 200)
    {
        self.selMatchArr[1] = [self orderArray:selMatchArr byPlayType:2];
    }else if (button.tag >= 200 && button.tag < 300)
    {
        self.selMatchArr[2] = [self orderArray:selMatchArr byPlayType:3];
    }else if (button.tag >= 300 && button.tag < 400)
    {
        self.selMatchArr[3] = [self orderArray:selMatchArr byPlayType:4];
    }
}

- (void)cancelButtonClick:(UIButton *)button
{
    [self.superview removeFromSuperview];
}

- (void)confirmButtonClick:(UIButton *)button
{
    self.matchInfosModel.selMatchArr = self.selMatchArr;
    if ([_delegate respondsToSelector:@selector(upDateByMatchInfosModel:)]) {
        [_delegate upDateByMatchInfosModel:self.matchInfosModel];
    }
    [self.superview removeFromSuperview];
}

#pragma mark - 初始化
- (NSMutableArray *)selMatchArr
{
    if (_selMatchArr == nil) {
        _selMatchArr = [NSMutableArray array];
        for (NSMutableArray * array in _matchInfosModel.selMatchArr) {
            NSMutableArray * array_ = [NSMutableArray array];
            for (id object in array) {
                [array_ addObject:object];
            }
            [_selMatchArr addObject:array_];
        }
    }
    return _selMatchArr;
}
- (NSMutableArray *)btns
{
    if(_btns == nil)
    {
        _btns = [[NSMutableArray alloc] init];
    }
    return  _btns;
}

- (NSMutableArray *)labels
{
    if(_labels == nil)
    {
        _labels = [[NSMutableArray alloc] init];
    }
    return  _labels;
}

- (NSArray *)foreStrArrs1
{
    if(_foreStrArrs1 == nil)
    {
        _foreStrArrs1 = @[@"客胜", @"主胜"];
    }
    return  _foreStrArrs1;
}

- (NSArray *)foreStrArrs2
{
    if(_foreStrArrs2 == nil)
    {
        _foreStrArrs2 = @[@"让分客胜", @"让分主胜"];
    }
    return  _foreStrArrs2;
}

- (NSArray *)foreStrArrs3
{
    if(_foreStrArrs3 == nil)
    {
        _foreStrArrs3 = @[@"大分", @"小分"];
    }
    return  _foreStrArrs3;
}

- (NSArray *)foreStrArrs4
{
    if(_foreStrArrs4 == nil)
    {
        _foreStrArrs4 = @[@"客胜1-5", @"客胜6-10", @"客胜11-15", @"客胜16-20", @"客胜21-25", @"客胜26+", @"主胜1-5", @"主胜6-10", @"主胜11-15", @"主胜16-20", @"主胜21-25", @"主胜26+"];
    }
    return  _foreStrArrs4;
}

#pragma mark - 工具
- (NSMutableArray *)orderArray:(NSMutableArray *)array byPlayType:(int)playType
{
    NSMutableArray * orderArray = [NSMutableArray array];
    NSArray * foreArr = [NSArray array];
    if (playType == 1) {
        foreArr = self.foreStrArrs1;
    }else if (playType == 2)
    {
        foreArr = self.foreStrArrs2;
    }else if (playType == 3) {
        foreArr = self.foreStrArrs3;
    }else if (playType == 4)
    {
        foreArr = self.foreStrArrs4;
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


- (void)addOddsInfoToArray1:(NSMutableArray *)array1 fromArray2:(NSArray *)array2 number:(int) number
{
    if(!array2 || array2.count != number)
    {
        NSMutableArray * array2_mu = [NSMutableArray array];
        for (int i = 0; i < number; i++) {
            [array2_mu addObject:@"----"];
        }
        [array1 addObjectsFromArray:array2_mu];
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

@end
