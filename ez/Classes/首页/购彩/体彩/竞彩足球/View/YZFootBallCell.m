//
//  YZFootBallCell.m
//  ez
//
//  Created by apple on 14-11-20.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#define bigFont [UIFont systemFontOfSize:14]
#define midFont [UIFont systemFontOfSize:13]
#define littleFont [UIFont systemFontOfSize:12]
#import "YZFootBallCell.h"
#import "YZSelectBallCell.h"
#import "YZFBChoosePlayView.h"
#import "YZFBAllPlayView.h"
#import "YZFootBallMatchRate.h"
#import "YZFBMatchDetailCellView.h"

@interface YZFootBallCell ()<YZFBChoosePlayViewDelegate,YZFBAllPlayViewDelegate,YZFBMatchDetailCellViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, weak) UILabel *matchNameLabel;//比赛名称
@property (nonatomic, weak) UIButton *openButton;//展开按钮
@property (nonatomic, weak) UIImageView *openImageView;//展开图片
@property (nonatomic, weak) UIView *verticalLine;//灰色竖线
@property (nonatomic, weak) UILabel *feiLabel;//非让label
@property (nonatomic, weak) UILabel *rangLabel;//让球Label
@property (nonatomic, weak) UILabel *VsLabel;//VsLabel
@property (nonatomic, strong) NSMutableArray *btns;//按钮数组
@property (nonatomic, weak) UIButton *allPlayTypeBtn;//全部玩法按钮
@property (nonatomic, weak) UIButton *choosePlayBtn;//半全场 比分 总进球的button
@property (nonatomic, weak) UIImageView *greenLine;
@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) YZFBMatchDetailCellView *matchDetailCellView;//比赛详细信息视图
@property (nonatomic, weak) YZFBChoosePlayView *choosePlayView;
@property (nonatomic, weak) YZFBAllPlayView *allPlayView;

@end
@implementation YZFootBallCell
+ (YZFootBallCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"footBallCell";
    YZFootBallCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZFootBallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    //比赛名称
    UILabel *matchNameLabel = [[UILabel alloc] init];
    matchNameLabel.numberOfLines = 0;
    self.matchNameLabel = matchNameLabel;
    matchNameLabel.backgroundColor = YZColor(240, 254, 236, 1);
    [matchNameLabel setTextColor:[UIColor blackColor]];
    matchNameLabel.font = bigFont;
    matchNameLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat matchNameLabelW = 70;
    matchNameLabel.frame = CGRectMake(0, 0, matchNameLabelW,FbCellH0);
    [self.contentView addSubview:matchNameLabel];
    
    //展开按钮
    UIButton * openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openButton = openButton;
    openButton.frame = matchNameLabel.bounds;
    [openButton addTarget:self action:@selector(openButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:openButton];
    
    UIImageView *openImageView = [[UIImageView alloc] init];
    self.openImageView = openImageView;
    openImageView.image = [UIImage imageNamed:@"fb_show_detail_down"];
    [self.contentView addSubview:openImageView];
    
    //竖线
    UIView *verticalLine = [[UIView alloc] init];
    self.verticalLine = verticalLine;
    verticalLine.backgroundColor = [UIColor lightGrayColor];
    CGFloat verticalLineX = CGRectGetMaxX(matchNameLabel.frame);
    CGFloat verticalLineW = 1;
    verticalLine.frame = CGRectMake(verticalLineX, 0, verticalLineW, FbCellH0);
    [self.contentView addSubview:verticalLine];
    
    //VS label
    CGFloat verticalLineMaxX = CGRectGetMaxX(verticalLine.frame);
    CGFloat vsLabelMaxW = screenWidth - verticalLineMaxX;
    CGFloat VsLabelH = 30;
    CGFloat vs1LabelW = 0;
    for(int i = 0;i < 3;i++)
    {
        UILabel *VsLabel = [[UILabel alloc] init];
        VsLabel.backgroundColor = YZColor(240, 254, 236, 1);
        VsLabel.font = bigFont;
        if(i == 0){//中间显示VS的label
            self.VsLabel = VsLabel;
            VsLabel.text = @"VS";
            CGSize labelSize = [VsLabel.text sizeWithLabelFont:VsLabel.font];
            vs1LabelW = (vsLabelMaxW - labelSize.width) / 2;
            CGFloat VsLabelX = verticalLineMaxX + vs1LabelW;
            VsLabel.frame = CGRectMake(VsLabelX, 0, labelSize.width, VsLabelH);
        }else if(i == 1){//vs左边的文字
            self.Vs1Label = VsLabel;
            VsLabel.frame = CGRectMake(verticalLineMaxX, 0, vs1LabelW, VsLabelH);
        }else{
            self.Vs2Label = VsLabel;
            VsLabel.textAlignment = NSTextAlignmentRight;
            CGFloat vsLabelX = CGRectGetMaxX(self.VsLabel.frame);
            VsLabel.frame = CGRectMake(vsLabelX - 0.5, 0, vs1LabelW + 0.5, VsLabelH);
        }
        [self.contentView addSubview:VsLabel];
    }
    
    //全部玩法按钮
    UIButton *allPlayTypeBtn = [[UIButton alloc] init];
    self.allPlayTypeBtn = allPlayTypeBtn;
    allPlayTypeBtn.titleLabel.font = bigFont;
    allPlayTypeBtn.layer.borderWidth = 0.5;
    allPlayTypeBtn.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
    allPlayTypeBtn.titleLabel.numberOfLines = 0;
    [allPlayTypeBtn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
    [allPlayTypeBtn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
    [allPlayTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allPlayTypeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [allPlayTypeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [allPlayTypeBtn setTitleColor:YZLightDrayColor forState:UIControlStateDisabled];
    [allPlayTypeBtn setTitle:@"全部\n玩法" forState:UIControlStateNormal];
    CGFloat allPlayTypeBtnW = 40;
    CGFloat allPlayTypeBtnX = screenWidth - allPlayTypeBtnW;
    CGFloat allPlayTypeBtnH = FbCellH0 - CGRectGetMaxY(self.Vs1Label.frame);
    allPlayTypeBtn.frame = CGRectMake(allPlayTypeBtnX, CGRectGetMaxY(self.Vs1Label.frame), allPlayTypeBtnW, allPlayTypeBtnH);
    [allPlayTypeBtn addTarget:self action:@selector(allPlayTypeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:allPlayTypeBtn];
    
    //非让和让球
    CGFloat labelW = 20;
    CGFloat labelH = 40;
    CGFloat labelX = verticalLineMaxX;
    //显示“非让和让球”文字
    for(int j = 0;j < 2;j++ )
    {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        if(j == 0)
        {
            label.text = @"非\n让";
            self.feiLabel = label;
            label.backgroundColor = YZColor(231, 128, 28, 1);
        }else if(j == 1)
        {
            label.text = @"让\n球";
            self.rangLabel = label;
            label.backgroundColor = YZColor(97, 180, 59, 1);
        }
        label.font = littleFont;
        CGFloat labelY = CGRectGetMaxY(self.Vs1Label.frame) + j * labelH;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        [self.contentView addSubview:label];
    }
    
    //非让和让球后面的按钮
    int btnCount = 6;
    for(int i = 0;i < btnCount;i++)
    {
        //赔率按钮
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        [self.btns addObject:btn];
        btn.titleLabel.font = midFont;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:YZLightDrayColor forState:UIControlStateDisabled];
        
        [btn addTarget:self action:@selector(oddInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
    //选择玩法按钮 半场 比分 总进球
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.choosePlayBtn = btn;
    btn.frame = CGRectMake(CGRectGetMaxX(verticalLine.frame), CGRectGetMaxY(self.Vs1Label.frame), screenWidth - CGRectGetMaxX(verticalLine.frame), FbCellH1 - CGRectGetMaxY(self.Vs1Label.frame));
    btn.titleLabel.font = midFont;
    btn.titleLabel.numberOfLines = 0;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
    [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setTitleColor:YZLightDrayColor forState:UIControlStateDisabled];
    
    [btn addTarget:self action:@selector(choosePlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];

    //绿色分割线
    UIImage *greenLineImage = [UIImage imageNamed:@"ft_bottomline"];
    UIImageView *greenLine = [[UIImageView alloc] initWithImage:greenLineImage];
    self.greenLine = greenLine;
    [self.contentView addSubview:greenLine];
    
    //比赛详细信息视图
    YZFBMatchDetailCellView *matchDetailCellView = [[YZFBMatchDetailCellView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(matchNameLabel.frame), screenWidth, FbMatchDetailH)];
    self.matchDetailCellView = matchDetailCellView;
    matchDetailCellView.hidden = YES;
    matchDetailCellView.delegate = self;
    [self addSubview:matchDetailCellView];
}
#pragma mark - 设置数据
- (void)setMatchInfos:(YZMatchInfosStatus *)matchInfos
{
    _matchInfos = matchInfos;

    [self setStatus];//设置数据
    
    [self setFrame];//设置frame

}
- (void)setFrame
{
    CGFloat cellH;
    BOOL isHighCell;//是否是高的cell
    if(_matchInfos.playTypeTag == 0)//混合过关,高是FbCellH0
    {
        cellH = FbCellH0;
        isHighCell = YES;
        self.allPlayTypeBtn.hidden = NO;
    }else if (_matchInfos.playTypeTag == 7)//单关
    {
        cellH = FbCellH0;
        isHighCell = YES;
        self.allPlayTypeBtn.hidden = NO;
    }else//其他FbCellH1
    {
        cellH = FbCellH1;
        isHighCell = NO;
        self.allPlayTypeBtn.hidden = YES;
    }
    
    //比赛名称的frame
    self.matchNameLabel.height = cellH;
    //比赛详细信息
    self.matchDetailCellView.y = CGRectGetMaxY(self.matchNameLabel.frame);
    //灰色竖线
    self.verticalLine.height = cellH;
    
    //非让和让球的label
    CGFloat labelW = 20;
    if(isHighCell)
    {
        self.feiLabel.width = labelW;
        self.rangLabel.width = labelW;
    }else
    {
        self.feiLabel.width = 0;
        self.rangLabel.width = 0;
    }
    
    if (_matchInfos.playTypeTag < 4 || _matchInfos.playTypeTag == 7 || _matchInfos.playTypeTag == 8 || _matchInfos.playTypeTag == 9) {
        for (UIButton * button in self.btns) {
            button.hidden = NO;
        }
        self.choosePlayBtn.hidden = YES;
    }else
    {
        for (UIButton * button in self.btns) {
            button.hidden = YES;
        }
        self.choosePlayBtn.hidden = NO;
    }
    
    //非让和让球后面的按钮
    if(_matchInfos.playTypeTag == 0 || _matchInfos.playTypeTag == 7)//混合过关
    {
        [self showBtns:self.btns hideBtns:nil];
    }else if(_matchInfos.playTypeTag == 1 || _matchInfos.playTypeTag == 8)//胜平负
    {
        //显示上面三个按钮,隐藏下面三个按钮
        NSArray *showBtns = [self.btns subarrayWithRange:NSMakeRange(0, 3)];
        NSArray *hideBtns = [self.btns subarrayWithRange:NSMakeRange(3, 3)];
        [self showBtns:showBtns hideBtns:hideBtns];
    }else if(_matchInfos.playTypeTag == 2 || _matchInfos.playTypeTag == 9)//让球胜平负
    {
        //显示下面三个按钮,隐藏上面三个按钮
        NSArray *showBtns = [self.btns subarrayWithRange:NSMakeRange(3, 3)];
        NSArray *hideBtns = [self.btns subarrayWithRange:NSMakeRange(0, 3)];
        [self showBtns:showBtns hideBtns:hideBtns];
    }else if (_matchInfos.playTypeTag == 3)//二选一
    {
        int concedePoints = [_matchInfos.concedePoints intValue];
        NSMutableArray *showBtns = [NSMutableArray array];
        NSMutableArray *hideBtns = [NSMutableArray array];
        //只显示两个按钮
        if (concedePoints > 0) {
            showBtns = [NSMutableArray arrayWithObjects:self.btns[3],self.btns[2],nil];
            hideBtns = [NSMutableArray arrayWithObjects:self.btns[0],self.btns[1],self.btns[4],self.btns[5],nil];
        }else
        {
            showBtns = [NSMutableArray arrayWithObjects:self.btns[0],self.btns[5],nil];
            hideBtns = [NSMutableArray arrayWithObjects:self.btns[1],self.btns[2],self.btns[3],self.btns[4],nil];
        }
        [self showBtns:showBtns hideBtns:hideBtns];
    }
    //绿线的高度
    CGFloat greenLineH = 2;
    CGFloat greenLineY = cellH - greenLineH;
    self.greenLine.frame = CGRectMake(0, greenLineY, screenWidth, greenLineH);
    
    if (_matchInfos.playTypeTag == 0 || _matchInfos.playTypeTag == 7) {
        self.openImageView.frame = CGRectMake(0, self.matchNameLabel.height - 15, 14, 8);
    }else
    {
        self.openImageView.frame = CGRectMake(0, self.matchNameLabel.height - 13, 14, 8);
    }
    self.openImageView.centerX = self.matchNameLabel.centerX;
}

- (void)setStatus
{
    if (_matchInfos.open) {//展开按钮
        self.openImageView.image = [UIImage imageNamed:@"fb_show_detail_up"];
        self.matchDetailCellView.hidden = NO;
    }else
    {
        self.openImageView.image = [UIImage imageNamed:@"fb_show_detail_down"];
        self.matchDetailCellView.hidden = YES;
    }

    NSArray *detailInfoArray = [_matchInfos.detailInfo componentsSeparatedByString:@"|"];
    //设置比赛名称和时间
    NSMutableAttributedString *muAttStr = [[NSMutableAttributedString alloc] init];
    NSString *macthNum = [_matchInfos.code substringFromIndex:9];
    [muAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",macthNum]]];//显示第几个比赛
    
    [muAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",detailInfoArray[2]]]];//比赛名称
    NSString *endTime = [_matchInfos.endTime substringWithRange:NSMakeRange(11, 5)];
    NSString *endTimeStr = [NSString stringWithFormat:@" %@",endTime];
    [muAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:endTimeStr]];//添加截止时间
    NSRange endTimeRange = NSMakeRange(muAttStr.length-5, 5);
    
    NSDictionary *attDict = @{NSForegroundColorAttributeName : [UIColor darkGrayColor],NSFontAttributeName : midFont};//时间灰黑色、中字体  ,NSParagraphStyleAttributeName : paragraphStyle
    [muAttStr addAttributes:attDict range:endTimeRange];
    self.matchNameLabel.attributedText = muAttStr;
    
    //设置VS双方
    signed int concedePoints = [_matchInfos.concedePoints intValue];
    NSString *Vs1LabelText = [self getSubStringOfString:detailInfoArray[0] limitedLength:5];;
    NSString *allStr = Vs1LabelText;
    if(_matchInfos.playTypeTag == 0 || _matchInfos.playTypeTag == 2 || _matchInfos.playTypeTag == 3)//是混合，让球，二选一就显示绿色的加减数
    {
        NSString *points;
        if(concedePoints > 0)
        {
            points =[NSString stringWithFormat:@"(+%d)",concedePoints];
        }else
        {
            points =[NSString stringWithFormat:@"(%d)",concedePoints];
        }
        allStr = [NSString stringWithFormat:@"%@%@",Vs1LabelText,points];
    }
    NSMutableAttributedString *Vs1LabelMuAttStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    [Vs1LabelMuAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(97, 180, 59, 1) range:NSMakeRange(Vs1LabelText.length, allStr.length-Vs1LabelText.length)];
    [Vs1LabelMuAttStr insertAttributedString:[[NSAttributedString alloc] initWithString:@"  "] atIndex:0];
    
    self.Vs1Label.attributedText = Vs1LabelMuAttStr;
    //vs2
    NSString *vs2Text = [self getSubStringOfString:detailInfoArray[1] limitedLength:5];
    NSMutableAttributedString *Vs2LabelMuAttStr = [[NSMutableAttributedString alloc] initWithString:vs2Text];
    [Vs2LabelMuAttStr insertAttributedString:[[NSAttributedString alloc] initWithString:@"空"] atIndex:vs2Text.length];
    [Vs2LabelMuAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(Vs2LabelMuAttStr.length-1, 1)];
    self.Vs2Label.attributedText = Vs2LabelMuAttStr;
    
    //全部玩法
    if (_matchInfos.playTypeTag == 7) {
        self.allPlayTypeBtn.enabled = ![_matchInfos isCloseAllSingle];
    }else
    {
        self.allPlayTypeBtn.enabled = YES;
    }
    
    self.allPlayTypeBtn.selected = [_matchInfos isHaveSelected1];
    //非让和让球后面的赔率
    NSArray *CN02OddsInfo = [_matchInfos.oddsMap.CN02.oddsInfo componentsSeparatedByString:@"|"];
    NSArray *CN01OddsInfo = [_matchInfos.oddsMap.CN01.oddsInfo componentsSeparatedByString:@"|"];
    //如果当前不支持单关
    if (_matchInfos.oddsMap.CN01.single == 0 && (_matchInfos.playTypeTag == 7 || _matchInfos.playTypeTag == 9)) {
        CN01OddsInfo = [NSArray array];
    }
    if (_matchInfos.oddsMap.CN02.single == 0 && (_matchInfos.playTypeTag == 7 || _matchInfos.playTypeTag == 8)) {
        CN02OddsInfo = [NSArray array];
    }
    NSMutableArray *allOddsInfo = [NSMutableArray array];
    [self addOddsInfoToArray1:allOddsInfo fromArray2:CN02OddsInfo];
    [self addOddsInfoToArray1:allOddsInfo fromArray2:CN01OddsInfo];
    if (_matchInfos.playTypeTag < 3 || _matchInfos.playTypeTag == 7 || _matchInfos.playTypeTag == 8 || _matchInfos.playTypeTag == 9) {
        //按钮的状态数组
        for(int i = 0;i < self.btns.count;i++)
        {
            UIButton *btn = self.btns[i];
            
            NSArray *firstStrArray = [[NSArray alloc] initWithObjects:@"胜",@"平",@"负", nil];
            int maxColums = 3;//每行几个
            if([allOddsInfo[i] isEqualToString:@"----"])//没有赔率，按钮失效显示
            {
                btn.selected = NO;
                btn.enabled = NO;
            }else
            {
                btn.enabled = YES;
            }
            NSString *fisrStr = firstStrArray[i % maxColums];
            NSString *title = [NSString stringWithFormat:@"%@%@",fisrStr,allOddsInfo[i]];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitle:title forState:UIControlStateHighlighted];
            [btn setTitle:title forState:UIControlStateSelected];
            //判断是否是选中状态
            btn.selected = NO;
            NSMutableArray * selMatchArr = [NSMutableArray array];
            if (i < 3) {
                selMatchArr = _matchInfos.selMatchArr[0];
            }else
            {
                selMatchArr = _matchInfos.selMatchArr[1];
            }
            for (YZFootBallMatchRate * rate in selMatchArr) {
                if (rate.info != nil && rate.info.length != 0) {
                    NSString * info = rate.info;
                    //如果找到了就为选中状态
                    if ([btn.titleLabel.text rangeOfString:info].location != NSNotFound) {
                        btn.selected = YES;
                    }
                }
            }
        }
    }else if (_matchInfos.playTypeTag == 3)
    {
        for(int i = 0;i < self.btns.count;i++)
        {
            UIButton *btn = self.btns[i];
            
            NSString * fisrStr = @"";
            if (i == 0) {
                fisrStr = @"主胜";
            }else if (i == 2)
            {
                fisrStr = @"主败";
            }else if (i == 3)
            {
                fisrStr = @"主不败";
            }else if (i == 5)
            {
                fisrStr = @"主不胜";
            }
            
            NSString *title = [NSString stringWithFormat:@"%@%@",fisrStr,allOddsInfo[i]];
            
            if([title rangeOfString:@"----"].location != NSNotFound)//没有赔率，按钮失效显示
            {
                btn.selected = NO;
                btn.enabled = NO;
            }else
            {
                btn.enabled = YES;
            }
            
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitle:title forState:UIControlStateHighlighted];
            [btn setTitle:title forState:UIControlStateSelected];
            
            //判断是否是选中状态
            btn.selected = NO;
            NSMutableArray * selMatchArr = selMatchArr = _matchInfos.selMatchArr[2];
            for (YZFootBallMatchRate * rate in selMatchArr) {
                if (rate.info != nil && rate.info.length != 0) {
                    NSString * info = rate.info;
                    //如果找到了就为选中状态
                    if ([btn.titleLabel.text rangeOfString:info].location != NSNotFound) {
                        btn.selected = YES;
                    }
                }
            }
        }
    }else if (_matchInfos.playTypeTag == 4 || _matchInfos.playTypeTag == 5 || _matchInfos.playTypeTag == 6 || _matchInfos.playTypeTag == 10 || _matchInfos.playTypeTag == 11 || _matchInfos.playTypeTag == 12)
    {
        NSMutableArray * selPlayArray = [NSMutableArray array];
        if (_matchInfos.playTypeTag == 4 || _matchInfos.playTypeTag == 5 || _matchInfos.playTypeTag == 6) {
            selPlayArray = _matchInfos.selMatchArr[_matchInfos.playTypeTag - 1];
        }else
        {
            selPlayArray = _matchInfos.selMatchArr[_matchInfos.playTypeTag - 1 - 6];
        }
        
        if (selPlayArray.count == 0) {//为空则
            self.choosePlayBtn.enabled = YES;
            if (_matchInfos.playTypeTag == 4 || _matchInfos.playTypeTag == 10) {
                [self.choosePlayBtn setTitle:@"点击选择半全场" forState:UIControlStateNormal];
                if (_matchInfos.playTypeTag == 10 && !_matchInfos.oddsMap.CN05.single) {
                    self.choosePlayBtn.enabled = NO;
                }
            }else if (_matchInfos.playTypeTag == 5 || _matchInfos.playTypeTag == 11)
            {
                [self.choosePlayBtn setTitle:@"点击选择比分" forState:UIControlStateNormal];
                if (_matchInfos.playTypeTag == 11 && !_matchInfos.oddsMap.CN03.single) {
                    self.choosePlayBtn.enabled = NO;
                }
            }else if (_matchInfos.playTypeTag == 6 || _matchInfos.playTypeTag == 12)
            {
                [self.choosePlayBtn setTitle:@"点击选择总进球数" forState:UIControlStateNormal];
                if (_matchInfos.playTypeTag == 12 && !_matchInfos.oddsMap.CN04.single) {
                    self.choosePlayBtn.enabled = NO;
                }
            }
            self.choosePlayBtn.selected = NO;
        }else
        {
            NSMutableString *selPlayRateStr = [NSMutableString string];
            for (YZFootBallMatchRate * rate in selPlayArray) {
                [selPlayRateStr appendFormat:@"%@,",rate.info];
            }
            [selPlayRateStr deleteCharactersInRange:NSMakeRange(selPlayRateStr.length-1, 1)];//去掉最后一个逗号;
            [self.choosePlayBtn setTitle:selPlayRateStr forState:UIControlStateSelected];
            self.choosePlayBtn.selected = YES;
        }
    }
}
- (void)setMatchDetailStatus:(YZFBMatchDetailStatus *)matchDetailStatus
{
    _matchDetailStatus = matchDetailStatus;
    self.matchDetailCellView.matchDetailStatus = matchDetailStatus;
}
#pragma mark - 赔率按钮点击
- (void)oddInfoBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    signed int concedePoints = [_matchInfos.concedePoints intValue];//让球数
    //储存
    if (_matchInfos.playTypeTag < 3 || _matchInfos.playTypeTag == 7 || _matchInfos.playTypeTag == 8 || _matchInfos.playTypeTag == 9) {//让球和非让球
        if (btn.tag < 3) {//非让
            //读取
            YZFootBallMatchRate * rate = [[YZFootBallMatchRate alloc]init];
            NSArray * oddsInfos = [_matchInfos.oddsMap.CN02.oddsInfo componentsSeparatedByString:@"|"];
            rate.CNType = @"CN02";
            rate.value = oddsInfos[btn.tag];
            rate.concedePoints = concedePoints;
            NSArray *firstStrArray = [[NSArray alloc] initWithObjects:@"胜",@"平",@"负", nil];
            rate.info = firstStrArray[btn.tag];
            NSMutableArray * selMatchArr = _matchInfos.selMatchArr[0];
            //修改
            if (btn.selected) {
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
            _matchInfos.selMatchArr[0] = [self orderArray:selMatchArr byPlayType:1];
        }else
        {
            //读取
            YZFootBallMatchRate * rate = [[YZFootBallMatchRate alloc]init];
            NSArray * oddsInfos = [_matchInfos.oddsMap.CN01.oddsInfo componentsSeparatedByString:@"|"];
            rate.CNType = @"CN01";
            rate.value = oddsInfos[btn.tag - 3];
            rate.concedePoints = concedePoints;
            NSArray *firstStrArray = [[NSArray alloc] initWithObjects:@"胜",@"平",@"负", nil];
            rate.info = firstStrArray[btn.tag - 3];
            NSMutableArray * selMatchArr = _matchInfos.selMatchArr[1];
            //修改
            if (btn.selected) {
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
            _matchInfos.selMatchArr[1] = [self orderArray:selMatchArr byPlayType:2];
        }
    }else if (_matchInfos.playTypeTag == 3)//二选一
    {
        NSArray *CN02OddsInfo = [_matchInfos.oddsMap.CN02.oddsInfo componentsSeparatedByString:@"|"];
        NSArray *CN01OddsInfo = [_matchInfos.oddsMap.CN01.oddsInfo componentsSeparatedByString:@"|"];
        NSMutableArray *allOddsInfo = [NSMutableArray array];
        [self addOddsInfoToArray1:allOddsInfo fromArray2:CN02OddsInfo];
        [self addOddsInfoToArray1:allOddsInfo fromArray2:CN01OddsInfo];
        NSString * fisrStr = @"";
        if (btn.tag == 0) {
            fisrStr = @"主胜";
        }else if (btn.tag == 2)
        {
            fisrStr = @"主败";
        }else if (btn.tag == 3)
        {
            fisrStr = @"主不败";
        }else if (btn.tag == 5)
        {
            fisrStr = @"主不胜";
        }
        YZFootBallMatchRate * rate = [[YZFootBallMatchRate alloc]init];
        rate.value = allOddsInfo[btn.tag];
        rate.info = fisrStr;
        rate.CNType = @"CN06";
        rate.concedePoints = concedePoints;
        NSMutableArray * selMatchArr = _matchInfos.selMatchArr[2];
        //修改
        if (btn.selected) {
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
        _matchInfos.selMatchArr[2] = [self orderArray:selMatchArr byPlayType:3];
    }
    //全部玩法
    //    self.allPlayTypeBtn.selected = [_matchInfos isHaveSelected];
    //代理
    if ([_delegate respondsToSelector:@selector(reloadBottomMidLabelText)]) {
        [_delegate reloadBottomMidLabelText];
    }
}
- (NSMutableArray *)orderArray:(NSMutableArray *)array byPlayType:(int)playType
{
    NSMutableArray * orderArray = [NSMutableArray array];
    NSArray *foreArr = [NSArray array];
    if (playType == 1 || playType == 2) {
        foreArr = [[NSArray alloc] initWithObjects:@"胜",@"平",@"负", nil];
    }else
    {
        foreArr = [[NSArray alloc] initWithObjects:@"主胜",@"主败",@"主不败", @"主不胜",nil];
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

#pragma mark - 展开按钮点击
- (void)openButtonDidClick:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(footBallCellOpenBtnDidClick:withCell:)])
    {
        [self.delegate footBallCellOpenBtnDidClick:btn withCell:self];
    }
}
#pragma mark - YZFBMatchDetailCellViewDelegate
- (void)showDetailBtnDidClick
{
    if([_delegate respondsToSelector:@selector(showDetailBtnDidClickWithCell:)])
    {
        [_delegate showDetailBtnDidClickWithCell:self];
    }
}
#pragma mark - 全部按钮点击
- (void)allPlayTypeBtnClick
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.backView = backView;
    backView.backgroundColor = YZColor(0, 0, 0, 0.4);
    [KEY_WINDOW addSubview:backView];
    
    YZFBAllPlayView * allPlayView = [[YZFBAllPlayView alloc]initWithFrame:CGRectMake(20, statusBarH, screenWidth - 40, screenHeight - statusBarH - [YZTool getSafeAreaBottom]) matchInfos:_matchInfos];
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
}
#pragma mark - YZFBAllPlayViewDelegate
- (void)upDateByMatchInfos:(YZMatchInfosStatus *)matchInfos
{
    _matchInfos = matchInfos;
    //刷新底部的比赛数信息
    if ([_delegate respondsToSelector:@selector(reloadBottomMidLabelText)]) {
        [_delegate reloadBottomMidLabelText];
    }
    [self setStatus];
}
#pragma mark - 半全场 比分 总进球选择玩法
- (void)choosePlayBtnClick:(UIButton *)button
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.backView = backView;
    backView.backgroundColor = YZColor(0, 0, 0, 0.4);
    [KEY_WINDOW addSubview:backView];
    
    //不同玩法的view大小不一样
    CGRect rect;
    if (_matchInfos.playTypeTag == 4 || _matchInfos.playTypeTag == 6 || _matchInfos.playTypeTag == 10 || _matchInfos.playTypeTag == 12) {
        rect = CGRectMake(20, 100, screenWidth - 40, 235);
    }else {
        rect = CGRectMake(20, 100, screenWidth - 40, 370);
    }
    YZFBChoosePlayView * choosePlayView = [[YZFBChoosePlayView alloc]initWithFrame:rect playType:_matchInfos.playTypeTag];
    choosePlayView.delegate = self;
    choosePlayView.center = KEY_WINDOW.center;
    self.choosePlayView = choosePlayView;
    choosePlayView.matchInfos = _matchInfos;
    [backView addSubview:choosePlayView];
    
    choosePlayView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
        choosePlayView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBackView)];
    tap.delegate = self;
    [backView addGestureRecognizer:tap];
}
- (void)removeBackView
{
    [self.backView removeFromSuperview];
}
#pragma mark - YZFBChoosePlayViewDelegate
- (void)selRateSet:(NSMutableArray *)rateArr
{
    int playTypeIndex;
    int playType = _matchInfos.playTypeTag;
    if (playType <= 7) {
        playTypeIndex = playType - 1;
    }else
    {
        playTypeIndex = playType - 1 - 6;
    }
    _matchInfos.selMatchArr[playTypeIndex] = rateArr;
    if (rateArr.count != 0) {//有被选中的
        NSMutableString *selPlayRateStr = [NSMutableString string];
        for (YZFootBallMatchRate * rate in rateArr) {
            [selPlayRateStr appendFormat:@"%@,",rate.info];
        }
        [selPlayRateStr deleteCharactersInRange:NSMakeRange(selPlayRateStr.length-1, 1)];//去掉最后一个逗号;
        [self.choosePlayBtn setTitle:selPlayRateStr forState:UIControlStateSelected];
        self.choosePlayBtn.selected = YES;
    }else
    {
        if (_matchInfos.playTypeTag == 4 || _matchInfos.playTypeTag == 10) {
            [self.choosePlayBtn setTitle:@"点击选择半全场" forState:UIControlStateNormal];
        }else if (_matchInfos.playTypeTag == 5 || _matchInfos.playTypeTag == 11)
        {
            [self.choosePlayBtn setTitle:@"点击选择比分" forState:UIControlStateNormal];
        }else if (_matchInfos.playTypeTag == 6 || _matchInfos.playTypeTag == 12)
        {
            [self.choosePlayBtn setTitle:@"点击选择总进球数" forState:UIControlStateNormal];
        }
        self.choosePlayBtn.selected = NO;
    }
    //刷新底部的比赛数信息
    if ([_delegate respondsToSelector:@selector(reloadBottomMidLabelText)]) {
        [_delegate reloadBottomMidLabelText];
    }
}
#pragma mark - 手势协议
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.choosePlayView) {
            CGPoint pos = [touch locationInView:self.choosePlayView.superview];
            if (CGRectContainsPoint(self.choosePlayView.frame, pos)) {
                return NO;
            }
        }
        if (self.allPlayView) {
            CGPoint pos = [touch locationInView:self.allPlayView.superview];
            if (CGRectContainsPoint(self.allPlayView.frame, pos)) {
                return NO;
            }
        }
    }
    return YES;
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
- (void)addBtnStatesToArray1:(NSMutableArray *)array1 fromArray2:(NSMutableArray *)array2
{
    if(!array2)//空
    {
        [array1 addObjectsFromArray:[NSArray arrayWithObjects:@(0), @(0), @(0), nil]];
    }else
    {
        [array1 addObjectsFromArray:array2];
    }
}
//显示和隐藏按钮
- (void)showBtns:(NSArray *)showBtns hideBtns:(NSArray *)hideBtns
{
    //显示按钮
    int maxColums = 0;//每行几个
    if (showBtns.count == 1) {//半全场 比分 总进球只显示一个按钮
        maxColums = 1;
    }else if (showBtns.count == 2)//二选一只显示两个按钮
    {
        maxColums = 2;
    }else
    {
        maxColums = 3;
    }
    CGFloat feiLabelMaxX = CGRectGetMaxX(self.feiLabel.frame);
    CGFloat btnW;
    if (_matchInfos.playTypeTag == 0 || _matchInfos.playTypeTag == 7) {//给全部玩法留空间
        btnW = (screenWidth - feiLabelMaxX - 40) / maxColums;
    }else
    {
        btnW = (screenWidth - feiLabelMaxX) / maxColums;
    }
    CGFloat btnH = 40;
    if (showBtns.count == 3) {
        btnH = 60;
    }
    for(int i = 0;i < showBtns.count;i++)
    {
        UIButton *btn = showBtns[i];
        btn.hidden = NO;
        CGFloat btnX = feiLabelMaxX + (i % maxColums) * btnW;
        CGFloat btnY = CGRectGetMaxY(self.Vs1Label.frame) + (i / maxColums) * btnH;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    //隐藏按钮
    if(!hideBtns || hideBtns.count == 0) return;
    for(int i = 0;i < hideBtns.count;i++)
    {
        UIButton *btn = hideBtns[i];
        btn.frame = CGRectZero;//不用hidden
        btn.hidden = YES;
    }
}
- (NSString *)getSubStringOfString:(NSString *)string limitedLength:(NSInteger)limitedLength
{
    if(string.length <= limitedLength) return string;
    
    return [string substringToIndex:limitedLength];
}
#pragma mark - 初始化
- (NSMutableArray *)btns
{
    if(_btns == nil)
    {
        _btns = [[NSMutableArray alloc] init];
    }
    return  _btns;
}

@end
