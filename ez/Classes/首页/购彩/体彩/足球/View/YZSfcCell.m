//
//  YZSfcCell.m
//  ez
//
//  Created by apple on 14-12-12.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#define bigFont [UIFont systemFontOfSize:14]
#define midFont [UIFont systemFontOfSize:13]
#define littleFont [UIFont systemFontOfSize:12]
#define matchNameLabelW 90

#import "YZSfcCell.h"

@interface YZSfcCell ()

@property (nonatomic, weak) UILabel *matchNameLabel;
@property (nonatomic, weak) UIView *verticalLine;
@property (nonatomic, weak) UILabel *vsLabel;
@property (nonatomic, strong) NSMutableArray *btns;//按钮数组

@end
@implementation YZSfcCell
+ (YZSfcCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"sfcCell";
    YZSfcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZSfcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
- (void)setupChilds
{
    //比赛名称
    UILabel *matchNameLabel = [[UILabel alloc] init];
    matchNameLabel.numberOfLines = 0;
    self.matchNameLabel = matchNameLabel;
    matchNameLabel.backgroundColor = YZColor(240, 254, 236, 1);
    matchNameLabel.font = bigFont;
    matchNameLabel.textAlignment = NSTextAlignmentCenter;
    matchNameLabel.textColor = YZBlackTextColor;
    matchNameLabel.frame = CGRectMake(0, 0, matchNameLabelW,sfcCellH);
    [self.contentView addSubview:matchNameLabel];
    
    //竖线
    UIView *verticalLine = [[UIView alloc] init];
    self.verticalLine = verticalLine;
    verticalLine.backgroundColor = [UIColor lightGrayColor];
    CGFloat verticalLineX = CGRectGetMaxX(matchNameLabel.frame);
    CGFloat verticalLineW = 2;
    verticalLine.frame = CGRectMake(verticalLineX, 0, verticalLineW, sfcCellH);
    [self.contentView addSubview:verticalLine];
    
    //VS label
    UILabel *vsLabel = [[UILabel alloc] init];
    self.vsLabel = vsLabel;
    vsLabel.textAlignment = NSTextAlignmentCenter;
    vsLabel.backgroundColor = YZColor(240, 254, 236, 1);
    vsLabel.font = bigFont;
    vsLabel.textColor = YZBlackTextColor;
    CGFloat verticalLineMaxX = CGRectGetMaxX(verticalLine.frame);
    CGFloat vsLabelX = verticalLineMaxX;
    CGFloat vsLabelW = screenWidth - verticalLineMaxX;
    CGFloat vsLabelH = 30;
    vsLabel.frame = CGRectMake(vsLabelX, 0, vsLabelW, vsLabelH);
    [self.contentView addSubview:vsLabel];

    //赔率的按钮
    int btnCount = 3;
    int maxColums = 3;//每行几个
    CGFloat btnY = CGRectGetMaxY(self.vsLabel.frame);
    CGFloat btnW = (screenWidth - verticalLineMaxX) / maxColums;
    CGFloat btnH = 40;
    for(int i = 0;i < btnCount;i++)
    {
        //赔率按钮
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        [self.btns addObject:btn];
        
        //设置属性
        btn.titleLabel.font = midFont;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        
        //设置frame
        CGFloat btnX = verticalLineMaxX + (i % maxColums) * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        [btn addTarget:self action:@selector(oddInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
    //绿色分割线
    UIImage *greenLineImage = [UIImage imageNamed:@"ft_bottomline"];
    UIImageView *greenLine = [[UIImageView alloc] initWithImage:greenLineImage];
    CGFloat greenLineH = 2;
    CGFloat greenLineY = sfcCellH - greenLineH;
    greenLine.frame = CGRectMake(0, greenLineY, screenWidth, greenLineH);
    [self.contentView addSubview:greenLine];
}

//赔率按钮点击
- (void)oddInfoBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if([self.delegate respondsToSelector:@selector(sfcCellOddsInfoBtnDidClick:withCell:)])
    {
        [self.delegate sfcCellOddsInfoBtnDidClick:btn withCell:self];
    }
}

- (void)setStatus:(YZSfcCellStatus *)status
{
    _status = status;
    
    //设置比赛名称和时间
    NSMutableAttributedString *muAttStr = [[NSMutableAttributedString alloc] init];
    NSString *number = [NSString stringWithFormat:@"%d\n",_status.number];
    NSString *matchName = [NSString stringWithFormat:@"%@\n",_status.matchName];
    [muAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:number]];//第几个比赛
    [muAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:matchName]];//比赛名称
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    UIImage *image = [UIImage imageNamed:@"timer"];
    attach.image = image;
    CGFloat scale = 1.2;
    attach.bounds = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
    NSAttributedString *attachAttStr = [NSMutableAttributedString attributedStringWithAttachment:attach];
    [muAttStr appendAttributedString:attachAttStr];//添加一个时间的图片
    NSString *endTimeStr = [NSString stringWithFormat:@" %@",_status.endTime];
    [muAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:endTimeStr]];//添加截止时间
    NSRange endTimeRange = NSMakeRange(muAttStr.length-5, 5);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [paragraphStyle setParagraphSpacing:10];
    NSDictionary *attDict = @{NSForegroundColorAttributeName : [UIColor darkGrayColor],NSFontAttributeName : midFont,NSParagraphStyleAttributeName : paragraphStyle};//时间灰黑色、中字体
    [muAttStr addAttributes:attDict range:endTimeRange];
    self.matchNameLabel.attributedText = muAttStr;
    
    [self setCommonStatus:_status];
}
- (void)setBetStatus:(YZSfcCellStatus *)betStatus
{
    _betStatus = betStatus;
    
    //更改ui
    CGFloat padding = 10;
    self.matchNameLabel.width = matchNameLabelW - 2 * padding;
    self.verticalLine.x = CGRectGetMaxX(self.matchNameLabel.frame);
    CGFloat verticalLineMaxX = CGRectGetMaxX(self.verticalLine.frame);
    self.vsLabel.x = verticalLineMaxX;
    int maxColums = 3;//每行几个
    CGFloat btnW = (screenWidth - 2 * padding - verticalLineMaxX) / maxColums;
    for(int i = 0;i < self.btns.count;i++)
    {
        UIButton *btn = self.btns[i];
        CGFloat btnX = verticalLineMaxX + (i % maxColums) * btnW;
        btn.x = btnX;
    }
    
    self.matchNameLabel.textAlignment = NSTextAlignmentLeft;
    self.matchNameLabel.text = [NSString stringWithFormat:@"%d",_betStatus.number];
    
    [self setCommonStatus:_betStatus];
}
- (void)setCommonStatus:(YZSfcCellStatus *)status
{
    //设置VS双方
    self.vsLabel.text = status.vsText;
    
    //设置三个赔率
    for(int i = 0;i < self.btns.count;i++)
    {
        UIButton *btn = self.btns[i];
        
        //设置按钮的状态
        BOOL btnState = [status.btnStateArray[i] boolValue];
        btn.selected = btnState;
        
        NSArray *firstStrArray = [[NSArray alloc] initWithObjects:@"胜",@"平",@"负", nil];
        int maxColums = 3;//每行几个
        
        NSString *fisrStr = firstStrArray[i % maxColums];
        NSString *odd = @"";
        if(status.oddsInfo.count > 1)
        {
            odd = [status.oddsInfo objectAtIndex:i];
        }
        NSString *title = [NSString stringWithFormat:@"%@%@",fisrStr,odd];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateHighlighted];
        [btn setTitle:title forState:UIControlStateSelected];
    }
}
- (NSMutableArray *)btns
{
    if(_btns == nil)
    {
        _btns = [[NSMutableArray alloc] init];
    }
    return  _btns;
}
@end
