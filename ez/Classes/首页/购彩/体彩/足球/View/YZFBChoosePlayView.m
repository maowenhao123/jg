//
//  YZFBChoosePlayView.m
//  ez
//
//  Created by apple on 16/5/18.
//  Copyright (c) 2016年 9ge. All rights reserved.
//
#define bigFont [UIFont systemFontOfSize:14]
#define midFont [UIFont systemFontOfSize:13]
#define littleFont [UIFont systemFontOfSize:12]
#define smallFont [UIFont systemFontOfSize:12]
#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height
#import "YZFBChoosePlayView.h"
#import "YZFootBallMatchRate.h"

@interface YZFBChoosePlayView()

@property (nonatomic, weak) UILabel *VsLabel;//VsLabel
@property (nonatomic, weak) UILabel *Vs1Label;//Vs1Label
@property (nonatomic, weak) UILabel *Vs2Label;//Vs2Label
@property (nonatomic, strong) NSMutableArray *btns;//按钮数组
@property (nonatomic, strong) NSArray *foreStrArr1;
@property (nonatomic, strong) NSArray *foreStrArr2;
@property (nonatomic, strong) NSArray *foreStrArr3;
@property (nonatomic, strong) NSMutableArray *selRateArr;//被选中的赔率数组

@end

@implementation YZFBChoosePlayView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame playType:(int)playType
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.playType = playType;
        [self setupChilds];
    }
    return self;
}
- (void)setPlayType:(int)playType
{
    _playType = playType;
}
- (void)setMatchInfos:(YZMatchInfosStatus *)matchInfos
{
    _matchInfos = matchInfos;
    [self setStatus];//设置数据
}
- (NSArray *)foreStrArr1
{
    if(_foreStrArr1 == nil)
    {
        _foreStrArr1 = [NSArray arrayWithObjects:@"胜胜",@"胜平",@"胜负",@"平胜",@"平平",@"平负",@"负胜",@"负平",@"负负",nil];
    }
    return  _foreStrArr1;
}
- (NSArray *)foreStrArr2
{
    if(_foreStrArr2 == nil)
    {
        _foreStrArr2 = [NSArray arrayWithObjects:@"1:0",@"2:0",@"2:1",@"3:0",@"3:1",@"3:2",@"4:0",@"4:1",@"4:2",@"5:0",@"5:1",@"5:2",@"胜其他",@"0:0",@"1:1",@"2:2",@"3:3",@"平其他",@"0:1",@"0:2",@"1:2",@"0:3",@"1:3",@"2:3",@"0:4",@"1:4",@"2:4",@"0:5",@"1:5",@"2:5",@"负其他",nil];
    }
    return  _foreStrArr2;
}
- (NSArray *)foreStrArr3
{
    if(_foreStrArr3 == nil)
    {
        _foreStrArr3 = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7+",nil];
    }
    return  _foreStrArr3;
}
- (NSMutableArray *)btns
{
    if(_btns == nil)
    {
        _btns = [[NSMutableArray alloc] init];
    }
    return  _btns;
}
- (NSMutableArray *)selRateArr
{
    if (_selRateArr == nil) {
        _selRateArr = [NSMutableArray array];
        int playTypeIndex;
        int playType = _matchInfos.playTypeTag;
        if (playType <= 7) {
            playTypeIndex = playType - 1;
        }else
        {
            playTypeIndex = playType - 1 - 6;
        }
        NSMutableArray * array = _matchInfos.selMatchArr[playTypeIndex];
        for (id object in array) {
            [_selRateArr addObject:object];
        }
    }
    return _selRateArr;
}
#pragma mark - 布局视图
- (void)setupChilds
{
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
            VsLabel.frame = CGRectMake(gap,5, vs1LabelW, VsLabelH);
            VsLabel.textAlignment = NSTextAlignmentCenter;
        }else{
            self.Vs2Label = VsLabel;
            VsLabel.textAlignment = NSTextAlignmentCenter;
            CGFloat vsLabelX = CGRectGetMaxX(self.VsLabel.frame);
            VsLabel.frame = CGRectMake(vsLabelX, 5, vs1LabelW, VsLabelH);
        }
        [self addSubview:VsLabel];
    }
    
    //底部的两个按钮
    float btnW = KWidth/2 - 20;
    float btnH = 30;
    UIColor * orangeColor = YZColor(247, 81, 53, 1);
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, KHeight - btnH -10, btnW, btnH);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:orangeColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = bigFont;
    [cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.borderWidth = 0.8;
    cancelBtn.layer.borderColor = orangeColor.CGColor;
    [self addSubview:cancelBtn];
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(KWidth/2 + 10, KHeight - btnH -10, btnW, btnH);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = bigFont;
    [confirmBtn addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.backgroundColor = orangeColor;
    [self addSubview:confirmBtn];

}
- (void)layoutBanquanchang
{
    float padding = 10;
    float linePadding = 5;
    int btnCount = 9;
    int maxColums = 3;//每行几个
    float btnW = (KWidth - padding * 2)/maxColums;
    float btnH = 40;
    for (int i = 0; i < btnCount; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnX = 10 + (i % maxColums) * btnW;
        CGFloat btnY = 40 + linePadding + (i / maxColums) * (btnH + linePadding);
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        button.tag = i;
        
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(oddInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        
        [self.btns addObject:button];
        [self addSubview:button];
    }
}
- (void)layoutBifen
{
    float padding = 10;
    float linePadding = 5;
    int btnCount = 31;
    int maxColums = 5;//每行几个
    float btnW = (KWidth - padding * 2)/maxColums;
    float btnH = 30;
    for (int i = 0; i < btnCount; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnX;
        CGFloat btnY;
        if (i < 13) {
            btnX = 10 + (i % maxColums) * btnW;
            btnY = 40 + linePadding + (i / maxColums) * (btnH + linePadding);
        }else if (i >= 13 && i <= 17)//13到17加宽上下的间隔
        {
            btnX = 10 + ((i - 13)  % maxColums) * btnW;
            btnY = 40 + 3 * linePadding + ((i + 2)  / maxColums) * (btnH + linePadding);
        }else
        {
            btnX = 10 + ((i - 18)  % maxColums) * btnW;
            btnY = 40 + 6 * linePadding + ((i + 2) / maxColums) * (btnH + linePadding);
        }
        if (i == 12) {//12和30变为3倍宽
            btnW = 3 * btnW;
        }else if (i == 30)
        {
            btnW = 3 * btnW;
        }
        else
        {
            btnW = (KWidth - padding * 2)/maxColums;
        }

        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        button.tag = i;
        
        button.titleLabel.numberOfLines = 0;//换行
        
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(oddInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        [self.btns addObject:button];
        [self addSubview:button];
    }
}
- (void)layoutZongjinqiu
{
    float padding = 10;
    float linePadding = 5;
    int btnCount = 8;
    int maxColums = 3;//每行几个
    float btnW = (KWidth - padding * 2)/maxColums;
    float btnH = 40;
    for (int i = 0; i < btnCount; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnX = 10 + (i % maxColums) * btnW;
        CGFloat btnY = 40 + linePadding + (i / maxColums) * (btnH + linePadding);
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        button.tag = i;
        
        button.titleLabel.numberOfLines = 0;//换行
        
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(oddInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        
        [self.btns addObject:button];
        [self addSubview:button];
    }
}
#pragma mark - 按钮点击
//赔率按钮点击
- (void)oddInfoBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
    NSArray * foreStrArr = [NSArray array];
    NSString * oddsInfoStr;
    NSString * CNType;
    if (_matchInfos.playTypeTag == 4 || _matchInfos.playTypeTag == 10) {
        foreStrArr = self.foreStrArr1;
        oddsInfoStr = _matchInfos.oddsMap.CN05.oddsInfo;
        CNType = @"CN05";
    }else if (_matchInfos.playTypeTag == 5 || _matchInfos.playTypeTag == 11)
    {
        foreStrArr = self.foreStrArr2;
        oddsInfoStr = _matchInfos.oddsMap.CN03.oddsInfo;
        CNType = @"CN03";
    }else if (_matchInfos.playTypeTag == 6 || _matchInfos.playTypeTag == 12)
    {
        foreStrArr = self.foreStrArr3;
        oddsInfoStr = _matchInfos.oddsMap.CN04.oddsInfo;
        CNType = @"CN04";
    }
    NSArray * oddInfos = [oddsInfoStr componentsSeparatedByString:@"|"];
    YZFootBallMatchRate * rate = [[YZFootBallMatchRate alloc]init];
    rate.info = foreStrArr[button.tag];
    rate.value = oddInfos[button.tag];
    rate.CNType = CNType;
    signed int concedePoints = [_matchInfos.concedePoints intValue];//让球数
    rate.concedePoints = concedePoints;
    if (button.selected) {
        [self.selRateArr addObject:rate];
    }else
    {
        YZFootBallMatchRate * removeRate = [[YZFootBallMatchRate alloc]init];
        for (YZFootBallMatchRate * selRate in self.selRateArr) {
            if ([selRate.info isEqualToString:rate.info]) {
                removeRate = selRate;
            }
        }
        [self.selRateArr removeObject:removeRate];
    }
    //排序
    [self orderArray];
}
- (void)cancelButtonClick:(UIButton *)button
{
    [self.superview removeFromSuperview];
}
- (void)confirmButtonClick:(UIButton *)button
{
    [self.superview removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(selRateSet:)]) {
        [_delegate selRateSet:self.selRateArr];
    }
}
#pragma mark - 设置数据
- (void)setStatus
{
    //设置VS双方
    NSArray *detailInfoArray = [_matchInfos.detailInfo componentsSeparatedByString:@"|"];
    NSString *Vs1LabelText = [self getSubStringOfString:detailInfoArray[0] limitedLength:5];;
    self.Vs1Label.text = Vs1LabelText;
    //vs2
    NSString *vs2Text = [self getSubStringOfString:detailInfoArray[1] limitedLength:5];
    self.Vs2Label.text = vs2Text;
    if (_matchInfos.playTypeTag == 4 || _matchInfos.playTypeTag == 10) {
        NSString * oddsInfoStr = _matchInfos.oddsMap.CN05.oddsInfo;
        NSArray * oddInfos = [oddsInfoStr componentsSeparatedByString:@"|"];
        [self layoutBanquanchang];
        NSMutableArray *allOddsInfo = [NSMutableArray array];
        [self addOddsInfoToArray1:allOddsInfo fromArray2:oddInfos number:9];//半全场有九个
        for (int i = 0; i < self.btns.count; i++) {
            NSString * foreStr = self.foreStrArr1[i];
            UIButton * button = self.btns[i];
            NSString * btnStr;
            if ([allOddsInfo[i] floatValue] == 0) {
                button.selected = NO;
                button.enabled = NO;
                btnStr = [NSString stringWithFormat:@"%@----",foreStr];
            }else
            {
                btnStr = [NSString stringWithFormat:@"%@%@",foreStr,allOddsInfo[i]];
            }
            NSMutableAttributedString * btnAttStr = [[NSMutableAttributedString alloc]initWithString:btnStr];
            //字体属性
            NSInteger bigNum = foreStr.length;//要变大字的个数
            [btnAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, bigNum)];
            [btnAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(bigNum, btnStr.length - bigNum)];
            [btnAttStr addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(0, bigNum)];
            [btnAttStr addAttribute:NSFontAttributeName value:littleFont range:NSMakeRange(bigNum, btnStr.length - bigNum)];

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
            //判断是否被选中
            button.selected = NO;//默认不被选中
            int playTypeIndex;
            int playType = _matchInfos.playTypeTag;
            if (playType <= 7) {
                playTypeIndex = playType - 1;
            }else
            {
                playTypeIndex = playType - 1 - 6;
            }
            for (YZFootBallMatchRate * rate in _matchInfos.selMatchArr[playTypeIndex]) {
                if ([foreStr isEqualToString:rate.info]) {
                    button.selected = YES;
                }
            }
        }
    }else if (_matchInfos.playTypeTag == 5 || _matchInfos.playTypeTag == 11)//比分
    {
        NSString * oddsInfoStr = _matchInfos.oddsMap.CN03.oddsInfo;
        NSArray * oddInfos = [oddsInfoStr componentsSeparatedByString:@"|"];
        [self layoutBifen];
        NSMutableArray *allOddsInfo = [NSMutableArray array];
        [self addOddsInfoToArray1:allOddsInfo fromArray2:oddInfos number:31];//比分有三十一个按钮
        for (int i = 0; i < self.btns.count; i++) {
            UIButton * button = self.btns[i];
            NSString * foreStr = self.foreStrArr2[i];
            NSString * btnStr;
            if ([allOddsInfo[i] floatValue] == 0) {
                button.selected = NO;
                button.enabled = NO;
                btnStr = [NSString stringWithFormat:@"%@\n----",foreStr];
            }else
            {
                btnStr = [NSString stringWithFormat:@"%@\n%@",foreStr,allOddsInfo[i]];
            }
            NSMutableAttributedString * btnAttStr = [[NSMutableAttributedString alloc]initWithString:btnStr];
            //换行后依旧居中对齐
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            NSDictionary *attDict = @{NSParagraphStyleAttributeName : paragraphStyle};
            [btnAttStr addAttributes:attDict range:NSMakeRange(0, btnAttStr.length)];
            //字体属性
            NSInteger bigNum = foreStr.length;//要变大字的个数
            [btnAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, bigNum)];
            [btnAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(bigNum, btnStr.length - bigNum)];
            [btnAttStr addAttribute:NSFontAttributeName value:midFont range:NSMakeRange(0, bigNum)];
            [btnAttStr addAttribute:NSFontAttributeName value:smallFont range:NSMakeRange(bigNum, btnStr.length - bigNum)];
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
            //判断是否被选中
            button.selected = NO;//默认不被选中
            int playTypeIndex;
            int playType = _matchInfos.playTypeTag;
            if (playType <= 7) {
                playTypeIndex = playType - 1;
            }else
            {
                playTypeIndex = playType - 1 - 6;
            }
            for (YZFootBallMatchRate * rate in _matchInfos.selMatchArr[playTypeIndex]) {
                if ([foreStr isEqualToString:rate.info]) {
                    button.selected = YES;
                }
            }
        }
    }else if (_matchInfos.playTypeTag == 6 || _matchInfos.playTypeTag == 12)//总进球
    {
        NSString * oddsInfoStr = _matchInfos.oddsMap.CN04.oddsInfo;
        NSArray * oddInfos = [oddsInfoStr componentsSeparatedByString:@"|"];
        [self layoutZongjinqiu];
        NSMutableArray *allOddsInfo = [NSMutableArray array];
        [self addOddsInfoToArray1:allOddsInfo fromArray2:oddInfos number:8];//总进球有八个按钮
        for (int i = 0; i < self.btns.count; i++) {
            UIButton * button = self.btns[i];
            NSString * foreStr = self.foreStrArr3[i];
            NSString * btnStr;
            if ([allOddsInfo[i] floatValue] == 0) {
                button.selected = NO;
                button.enabled = NO;
                btnStr = [NSString stringWithFormat:@"%@\n----",foreStr];
            }else
            {
                btnStr = [NSString stringWithFormat:@"%@\n%@",foreStr,allOddsInfo[i]];
            }
            NSMutableAttributedString * btnAttStr = [[NSMutableAttributedString alloc]initWithString:btnStr];
            //换行后依旧居中对齐
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            NSDictionary *attDict = @{NSParagraphStyleAttributeName : paragraphStyle};
            [btnAttStr addAttributes:attDict range:NSMakeRange(0, btnAttStr.length)];
            //字体属性
            NSInteger bigNum = foreStr.length;//要变大字的个数
            [btnAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, bigNum)];
            [btnAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(bigNum, btnStr.length - bigNum)];
            [btnAttStr addAttribute:NSFontAttributeName value:midFont range:NSMakeRange(0, bigNum)];
            [btnAttStr addAttribute:NSFontAttributeName value:smallFont range:NSMakeRange(bigNum, btnStr.length - bigNum)];
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
            //判断是否被选中
            button.selected = NO;//默认不被选中
            int playTypeIndex;
            int playType = _matchInfos.playTypeTag;
            if (playType <= 7) {
                playTypeIndex = playType - 1;
            }else
            {
                playTypeIndex = playType - 1 - 6;
            }
            for (YZFootBallMatchRate * rate in _matchInfos.selMatchArr[playTypeIndex]) {
                if ([foreStr isEqualToString:rate.info]) {
                    button.selected = YES;
                }
            }
        }
    }
}
//排序
- (void)orderArray
{
    NSMutableArray * orderArray = [NSMutableArray array];
    NSArray * foreArr = [NSArray array];
    if (self.playType == 4 || self.playType == 10) {
        foreArr = self.foreStrArr1;
    }else if (self.playType == 5 || self.playType == 11)
    {
        foreArr = self.foreStrArr2;
    }else if (self.playType == 6 || self.playType == 12)
    {
        foreArr = self.foreStrArr3;
    }
    for (NSString * foreStr in foreArr) {
        for (YZFootBallMatchRate * rate in self.selRateArr) {
            if ([foreStr isEqualToString:rate.info]) {
                [orderArray addObject:rate];
            }
        }
    }
    self.selRateArr = orderArray;
}
- (NSString *)getSubStringOfString:(NSString *)string limitedLength:(NSInteger)limitedLength
{
    if(string.length <= limitedLength) return string;
    
    return [string substringToIndex:limitedLength];
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
