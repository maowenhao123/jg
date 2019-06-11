//
//  YZFBAllPlayView.m
//  ez
//
//  Created by apple on 16/5/18.
//  Copyright (c) 2016年 9ge. All rights reserved.
//
#define bigFont [UIFont systemFontOfSize:14]
#define midFont [UIFont systemFontOfSize:13]
#define littleFont [UIFont systemFontOfSize:12]
#define smallFont [UIFont systemFontOfSize:11]
#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height

#import "YZFBAllPlayView.h"
#import "YZFootBallMatchRate.h"

@interface YZFBAllPlayView()

@property (nonatomic, weak) UIScrollView *playScrollView;//所有玩法的视图
@property (nonatomic, weak) UILabel *VsLabel;//VsLabel
@property (nonatomic, weak) UILabel *Vs1Label;//Vs1Label
@property (nonatomic, weak) UILabel *Vs2Label;//Vs2Label
@property (nonatomic, strong) NSMutableArray *allPlayArray;//所有玩法的数据
@property (nonatomic, strong) NSMutableArray *btns;//按钮数组
@property (nonatomic, strong) NSArray *foreStrArr1;
@property (nonatomic, strong) NSArray *foreStrArr2;
@property (nonatomic, strong) NSArray *foreStrArr3;
@property (nonatomic, strong) NSArray *foreStrArr4;
@property (nonatomic, strong) NSArray *foreStrArr5;
@property (nonatomic, strong) NSMutableArray *selMatchArr;//半场 比分 总进球 选中的玩法


@end

@implementation YZFBAllPlayView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame matchInfos:(YZMatchInfosStatus *)matchInfos
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _matchInfos = matchInfos;
        [self setupChilds];
        [self setStatus];//设置数据
    }
    return self;
}
- (NSMutableArray *)allPlayArray
{
    if (_allPlayArray == nil) {
        _allPlayArray = [NSMutableArray array];
    }
    return _allPlayArray;
}
- (NSMutableArray *)btns
{
    if(_btns == nil)
    {
        _btns = [[NSMutableArray alloc] init];
    }
    return  _btns;
}
- (NSArray *)foreStrArr1
{
    if(_foreStrArr1 == nil)
    {
        _foreStrArr1 = [NSArray arrayWithObjects:@"胜",@"平",@"负", nil];
    }
    return  _foreStrArr1;
}
- (NSArray *)foreStrArr3
{
    if(_foreStrArr3 == nil)
    {
        _foreStrArr3 = [NSArray arrayWithObjects:@"胜胜",@"胜平",@"胜负",@"平胜",@"平平",@"平负",@"负胜",@"负平",@"负负",nil];
    }
    return  _foreStrArr3;
}
- (NSArray *)foreStrArr4
{
    if(_foreStrArr4 == nil)
    {
        _foreStrArr4 = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7+",nil];
    }
    return  _foreStrArr4;
}
- (NSArray *)foreStrArr5
{
    if(_foreStrArr5 == nil)
    {
        _foreStrArr5 = [NSArray arrayWithObjects:@"1:0",@"2:0",@"2:1",@"3:0",@"3:1",@"3:2",@"4:0",@"4:1",@"4:2",@"5:0",@"5:1",@"5:2",@"胜其他",@"0:0",@"1:1",@"2:2",@"3:3",@"平其他",@"0:1",@"0:2",@"1:2",@"0:3",@"1:3",@"2:3",@"0:4",@"1:4",@"2:4",@"0:5",@"1:5",@"2:5",@"负其他",nil];
    }
    return  _foreStrArr5;
}
- (NSMutableArray *)selMatchArr
{
    if (_selMatchArr == nil) {
        _selMatchArr = [NSMutableArray array];
        for (NSMutableArray * array in _matchInfos.selMatchArr) {
             NSMutableArray * array_ = [NSMutableArray array];
            for (id object in array) {
                [array_ addObject:object];
            }
            [_selMatchArr addObject:array_];
        }
    }
    return _selMatchArr;
}
#pragma mark - 布局视图
- (void)setupChilds
{
    UIScrollView * playScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KWidth, KHeight - 50)];
    self.playScrollView = playScrollView;
    playScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:playScrollView];
    
    //设置对阵双方
    CGFloat gap = 10;
    CGFloat vsLabelMaxW = KWidth - gap * 2;
    CGFloat VsLabelH = 30;
    CGFloat vs1LabelW = 0;
    for(int i = 0;i < 3;i++)
    {
        UILabel *VsLabel = [[UILabel alloc] init];
        VsLabel.font = midFont;
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
        }else{
            self.Vs2Label = VsLabel;
            VsLabel.textAlignment = NSTextAlignmentCenter;
            CGFloat vsLabelX = CGRectGetMaxX(self.VsLabel.frame);
            VsLabel.frame = CGRectMake(vsLabelX, 5, vs1LabelW, VsLabelH);
        }
        [playScrollView addSubview:VsLabel];
    }
    
    //非让
    UIView * feirangView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.Vs1Label.frame) + 5, screenWidth, 40)];
    [playScrollView addSubview:feirangView];
    
    [self layoutPlayTitleLabelInView:feirangView withTitle:@"非\n让" andBackgroundColorIsYellow:YES];
    [self layoutBigButtonInView:feirangView withBtnCount:3 andTagFore:0];
    
    //让球
    UIView * rangView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(feirangView.frame) + 5, screenWidth, 40)];
    [playScrollView addSubview:rangView];
    
    [self layoutPlayTitleLabelInView:rangView withTitle:@"让\n球" andBackgroundColorIsYellow:NO];
    [self layoutBigButtonInView:rangView withBtnCount:3 andTagFore:100];

    //半全场
    UIView * banquanchangView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(rangView.frame) + 15, screenWidth, 130)];
    [playScrollView addSubview:banquanchangView];
    
    [self layoutPlayTitleLabelInView:banquanchangView withTitle:@"半\n全\n场" andBackgroundColorIsYellow:YES];
    [self layoutBigButtonInView:banquanchangView withBtnCount:9 andTagFore:200];
    
    //总进球数
    UIView * zongjinqiuView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(banquanchangView.frame) + 15, screenWidth, 130)];
    [playScrollView addSubview:zongjinqiuView];
    
    [self layoutPlayTitleLabelInView:zongjinqiuView withTitle:@"总\n进\n球\n数" andBackgroundColorIsYellow:NO];
    [self layoutBigButtonInView:zongjinqiuView withBtnCount:8 andTagFore:300];
    
    //比分
    UIView * bifenView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(zongjinqiuView.frame) + 15, screenWidth, 260)];
    [playScrollView addSubview:bifenView];
    
    [self layoutPlayTitleLabelInView:bifenView withTitle:@"比\n分" andBackgroundColorIsYellow:YES];
    [self layoutSmallButtonInView:bifenView];

    playScrollView.contentSize = CGSizeMake(KWidth, bifenView.origin.y + bifenView.bounds.size.height + 10);
    //底部视图
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(playScrollView.frame), KWidth, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
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
}
//左边的玩法标题
- (void)layoutPlayTitleLabelInView:(UIView *)view withTitle:(NSString *)title andBackgroundColorIsYellow:(BOOL)isYellow
{
    UIColor * backgroundColor;
    if (isYellow) {
        backgroundColor = YZColor(231, 128, 28, 1);
    }else
    {
        backgroundColor = YZColor(97, 180, 59, 1);
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
//布局赔率按钮(非让 让球 半全场 总进球数)
- (void)layoutBigButtonInView:(UIView *)view withBtnCount:(int)count andTagFore:(int)tagFore
{
    float leftPadding = 20 + 10;
    float rightPadding = 10;
    float linePadding = 5;
    int maxColums = 3;//每行几个
    float btnW = (KWidth - leftPadding - rightPadding)/maxColums;
    float btnH = 40;
    NSMutableArray * btnArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnX = leftPadding + (i % maxColums) * btnW;
        CGFloat btnY = (i / maxColums) * (btnH + linePadding);
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        button.tag = tagFore + i;
        button.titleLabel.numberOfLines = 0;
        
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(oddInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        
        [btnArray addObject:button];
        [view addSubview:button];
    }
    [self.btns addObject:btnArray];
}
//布局赔率按钮(比分)
- (void)layoutSmallButtonInView:(UIView *)view
{
    float leftPadding = 20 + 10;//离左边边框的距离
    float rightPadding = 10;//距离右边边框的距离
    float linePadding = 5;//没行的间距
    int btnCount = 31;//一个几个按钮
    int maxColums = 5;//每行几个
    float btnW = (KWidth - leftPadding - rightPadding)/maxColums;
    float btnH = 30;
    NSMutableArray * btnArray = [NSMutableArray array];
    for (int i = 0; i < btnCount; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnX;
        CGFloat btnY;
        if (i < 13) {
            btnX = leftPadding + (i % maxColums) * btnW;
            btnY = (i / maxColums) * (btnH + linePadding);
        }else if (i >= 13 && i <= 17)//13到17加宽上下的间隔
        {
            btnX = leftPadding + ((i - 13)  % maxColums) * btnW;
            btnY = 2 * linePadding + ((i + 2)  / maxColums) * (btnH + linePadding);
        }else
        {
            btnX = leftPadding + ((i - 18)  % maxColums) * btnW;
            btnY = 4 * linePadding + ((i + 2) / maxColums) * (btnH + linePadding);
        }
        if (i == 12) {//12和30变为3倍宽
            btnW = 3 * btnW;
        }else if (i == 30)
        {
            btnW = 3 * btnW;
        }
        else
        {
            btnW = (KWidth - leftPadding - rightPadding)/maxColums;
        }
        
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        button.tag = 400 + i;
        
        button.titleLabel.numberOfLines = 0;//换行
        
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(oddInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        
         button.titleLabel.numberOfLines = 0;
        
        [btnArray addObject:button];
        [view addSubview:button];
    }
    [self.btns addObject:btnArray];
}
#pragma mark - 设置数据
- (void)setStatus
{
    //设置VS双方
    signed int concedePoints = [_matchInfos.concedePoints intValue];
    NSArray *detailInfoArray = [_matchInfos.detailInfo componentsSeparatedByString:@"|"];
    NSString *Vs1LabelText = [self getSubStringOfString:detailInfoArray[0] limitedLength:5];
    if (concedePoints > 0) {
        self.Vs1Label.text = [NSString stringWithFormat:@"%@(+%d)",Vs1LabelText,concedePoints];
    }else
    {
       self.Vs1Label.text = [NSString stringWithFormat:@"%@(%d)",Vs1LabelText,concedePoints];
    }
    //vs2
    NSString *vs2Text = [self getSubStringOfString:detailInfoArray[1] limitedLength:5];
    self.Vs2Label.text = vs2Text;
    //设置赔率数据
    for (int i = 0; i < 5; i++) {
        NSArray * btns = self.btns[i];
        if (i == 0) {//非让
            NSString * oddsInfoStr = _matchInfos.oddsMap.CN02.oddsInfo;
            NSArray * oddInfos = [oddsInfoStr componentsSeparatedByString:@"|"];
            if (_matchInfos.oddsMap.CN02.single == 0 && _matchInfos.playTypeTag == 7) {
                oddInfos = [NSArray array];
            }
            NSMutableArray *allOddsInfo = [NSMutableArray array];
            [self addOddsInfoToArray1:allOddsInfo fromArray2:oddInfos number:3];
            NSArray * selMatchArray = _matchInfos.selMatchArr[0];
            for (int j = 0; j < btns.count; j++) {
                UIButton * button = btns[j];
                NSString * foreStr = self.foreStrArr1[j];
                NSString * btnStr = [NSString stringWithFormat:@"%@%@",foreStr,allOddsInfo[j]];
                [self setButton:button withBtnStr:btnStr andBigNumber:foreStr.length andselBtnTitles:selMatchArray andForeStr:foreStr];
            }
        }else if (i == 1)//让
        {
            NSString * oddsInfoStr = _matchInfos.oddsMap.CN01.oddsInfo;
            NSArray * oddInfos = [oddsInfoStr componentsSeparatedByString:@"|"];
            if (_matchInfos.oddsMap.CN01.single == 0 && _matchInfos.playTypeTag == 7) {
                oddInfos = [NSArray array];
            }
            NSMutableArray *allOddsInfo = [NSMutableArray array];
            [self addOddsInfoToArray1:allOddsInfo fromArray2:oddInfos number:3];
            NSArray * selMatchArray = _matchInfos.selMatchArr[1];
            for (int j = 0; j < btns.count; j++) {
                UIButton * button = btns[j];
                NSString * foreStr = self.foreStrArr1[j];
                NSString * btnStr = [NSString stringWithFormat:@"%@%@",foreStr,allOddsInfo[j]];
                [self setButton:button withBtnStr:btnStr andBigNumber:foreStr.length andselBtnTitles:selMatchArray andForeStr:foreStr];
            }
        }else if (i == 2)//半场
        {
            NSString * oddsInfoStr = _matchInfos.oddsMap.CN05.oddsInfo;
            NSArray * oddInfos = [oddsInfoStr componentsSeparatedByString:@"|"];
            NSMutableArray *allOddsInfo = [NSMutableArray array];
            [self addOddsInfoToArray1:allOddsInfo fromArray2:oddInfos number:9];//半全场有九个
            NSArray * selMatchArray = _matchInfos.selMatchArr[3];
            for (int j = 0; j < btns.count; j++) {
                UIButton * button = btns[j];
                NSString * foreStr = self.foreStrArr3[j];
                NSString * oddInfoStr = allOddsInfo[j];
                if ([oddInfoStr floatValue] == 0 || (_matchInfos.oddsMap.CN05.single == 0 && _matchInfos.playTypeTag == 7)) {
                    oddInfoStr = @"----";
                }
                NSString * btnStr = [NSString stringWithFormat:@"%@\n%@",foreStr,oddInfoStr];                [self setButton:button withBtnStr:btnStr andBigNumber:foreStr.length andselBtnTitles:selMatchArray andForeStr:foreStr];
            }
        }else if (i == 3)//总进球
        {
            NSString * oddsInfoStr = _matchInfos.oddsMap.CN04.oddsInfo;
            NSArray * oddInfos = [oddsInfoStr componentsSeparatedByString:@"|"];
            NSMutableArray *allOddsInfo = [NSMutableArray array];
            [self addOddsInfoToArray1:allOddsInfo fromArray2:oddInfos number:8];//总进球有八个按钮
            
            NSArray * selMatchArray = _matchInfos.selMatchArr[5];
            for (int j = 0; j < btns.count; j++) {
                UIButton * button = btns[j];
                NSString * foreStr = self.foreStrArr4[j];
                NSString * oddInfoStr = allOddsInfo[j];
                if ([oddInfoStr floatValue] == 0 || (_matchInfos.oddsMap.CN04.single == 0 && _matchInfos.playTypeTag == 7)) {
                    oddInfoStr = @"----";
                }
                NSString * btnStr = [NSString stringWithFormat:@"%@\n%@",foreStr,oddInfoStr];
                [self setButton:button withBtnStr:btnStr andBigNumber:foreStr.length andselBtnTitles:selMatchArray andForeStr:foreStr];
            }
        }else if (i == 4)//比分
        {
            NSArray * selMatchArray = _matchInfos.selMatchArr[4];
            NSString * oddsInfoStr = _matchInfos.oddsMap.CN03.oddsInfo;
            NSArray * oddInfos = [oddsInfoStr componentsSeparatedByString:@"|"];
            NSMutableArray *allOddsInfo = [NSMutableArray array];
            [self addOddsInfoToArray1:allOddsInfo fromArray2:oddInfos number:31];//比分有三十一个按钮
            
            for (int j = 0; j < btns.count; j++) {
                UIButton * button = btns[j];
                NSString * foreStr = self.foreStrArr5[j];
                NSString * oddInfoStr = allOddsInfo[j];
                if ([oddInfoStr floatValue] == 0 || (_matchInfos.oddsMap.CN03.single == 0 && _matchInfos.playTypeTag == 7)) {
                    oddInfoStr = @"----";
                }
                NSString * btnStr = [NSString stringWithFormat:@"%@\n%@",foreStr,oddInfoStr];
                [self setButton:button withBtnStr:btnStr andBigNumber:foreStr.length andselBtnTitles:selMatchArray andForeStr:foreStr];
            }
        }
    }
}
//设置button状态
- (void)setButton:(UIButton *)button withBtnStr:(NSString *)btnStr andBigNumber:(NSInteger)bigNum andselBtnTitles:(NSArray *)selMatchArr andForeStr:(NSString *)foreStr
{
    NSMutableAttributedString * btnAttStr = [[NSMutableAttributedString alloc]initWithString:btnStr];
    //字体属性
    [btnAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, bigNum)];
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
    if (button.tag < 100) {
        selMatchArr = self.selMatchArr[0];
        NSArray * oddInfos = [ _matchInfos.oddsMap.CN02.oddsInfo componentsSeparatedByString:@"|"];
        rate.info = self.foreStrArr1[button.tag];
        rate.value = oddInfos[button.tag];
        rate.CNType = @"CN02";
    }else if (button.tag >= 100 && button.tag < 200)
    {
        selMatchArr = self.selMatchArr[1];
        NSArray * oddInfos = [ _matchInfos.oddsMap.CN01.oddsInfo componentsSeparatedByString:@"|"];
        rate.info = self.foreStrArr1[button.tag - 100];
        rate.value = oddInfos[button.tag - 100];
        rate.CNType = @"CN01";
    }else if (button.tag >= 200 && button.tag < 300)
    {
        selMatchArr = self.selMatchArr[3];
        NSArray * oddInfos = [ _matchInfos.oddsMap.CN05.oddsInfo componentsSeparatedByString:@"|"];
        rate.info = self.foreStrArr3[button.tag - 200];
        rate.value = oddInfos[button.tag - 200];
        rate.CNType = @"CN05";
    }else if (button.tag >= 300 && button.tag < 400)
    {
        selMatchArr = self.selMatchArr[5];
        NSArray * oddInfos = [ _matchInfos.oddsMap.CN04.oddsInfo componentsSeparatedByString:@"|"];
        rate.info = self.foreStrArr4[button.tag - 300];
        rate.value = oddInfos[button.tag - 300];
        rate.CNType = @"CN04";
        
    }else if (button.tag >= 400 && button.tag < 500)
    {
        selMatchArr = self.selMatchArr[4];
        NSArray * oddInfos = [ _matchInfos.oddsMap.CN03.oddsInfo componentsSeparatedByString:@"|"];
        rate.info = self.foreStrArr5[button.tag - 400];
        rate.value = oddInfos[button.tag - 400];
        rate.CNType = @"CN03";
    }
    signed int concedePoints = [_matchInfos.concedePoints intValue];//让球数
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
        self.selMatchArr[3] = [self orderArray:selMatchArr byPlayType:3];
    }else if (button.tag >= 300 && button.tag < 400)
    {
        self.selMatchArr[5] = [self orderArray:selMatchArr byPlayType:5];
    }else if (button.tag >= 400 && button.tag < 500)
    {
        self.selMatchArr[4] = [self orderArray:selMatchArr byPlayType:4];
    }
}
- (void)cancelButtonClick:(UIButton *)button
{
    [self.superview removeFromSuperview];
}
- (void)confirmButtonClick:(UIButton *)button
{
    _matchInfos.selMatchArr = self.selMatchArr;
    if ([_delegate respondsToSelector:@selector(upDateByMatchInfos:)]) {
        [_delegate upDateByMatchInfos:_matchInfos];
    }
    [self.superview removeFromSuperview];
}
#pragma mark - 工具
- (NSMutableArray *)orderArray:(NSMutableArray *)array byPlayType:(int)playType
{
    NSMutableArray * orderArray = [NSMutableArray array];
    NSArray * foreArr = [NSArray array];
    if (playType == 1 || playType == 2) {
        foreArr = self.foreStrArr1;
    }else if (playType == 3) {
        foreArr = self.foreStrArr3;
    }else if (playType == 4)
    {
        foreArr = self.foreStrArr5;
    }else if (playType == 5)
    {
        foreArr = self.foreStrArr4;
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
- (NSString *)getSubStringOfString:(NSString *)string limitedLength:(NSInteger)limitedLength
{
    if(string.length <= limitedLength) return string;
    
    return [string substringToIndex:limitedLength];
}

@end
