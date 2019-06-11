//
//  YZScjqCell.m
//  ez
//
//  Created by apple on 14-12-15.
//  Copyright (c) 2014年 9ge. All rights reserved.
//  四场进球的cell
#define bigFont [UIFont systemFontOfSize:14]
#define midFont [UIFont systemFontOfSize:13]
#define littleFont [UIFont systemFontOfSize:12]
#define matchNameLabelW 80
#define maxColums 4  //每行几个

#import "YZScjqCell.h"

@interface YZScjqCell ()
@property (nonatomic, weak) UILabel *matchNameLabel;
@property (nonatomic, weak) UIView *verticalLine;
@property (nonatomic, weak) UILabel *vsLabel;
@property (nonatomic, strong) NSMutableArray *btns;//按钮数组
@end
@implementation YZScjqCell
+ (YZScjqCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"scjqCell";
    YZScjqCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZScjqCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = YZColor(240, 254, 236, 1);
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupChilds];
    }
    return  self;
}
- (void)setupChilds
{
    //比赛名称
    UILabel *matchNameLabel = [[UILabel alloc] init];
    matchNameLabel.numberOfLines = 0;
    matchNameLabel.backgroundColor = [UIColor clearColor];
    self.matchNameLabel = matchNameLabel;
    matchNameLabel.font = bigFont;
    matchNameLabel.textAlignment = NSTextAlignmentCenter;
    matchNameLabel.textColor = YZBlackTextColor;
    matchNameLabel.frame = CGRectMake(0, 0, matchNameLabelW,scjqCellH);
    [self.contentView addSubview:matchNameLabel];
    
    //竖线
    UIView *verticalLine = [[UIView alloc] init];
    self.verticalLine = verticalLine;
    verticalLine.backgroundColor = [UIColor lightGrayColor];
    CGFloat verticalLineX = CGRectGetMaxX(matchNameLabel.frame);
    CGFloat verticalLineW = 2;
    verticalLine.frame = CGRectMake(verticalLineX, 0, verticalLineW, scjqCellH);
    [self.contentView addSubview:verticalLine];
    
    //VS label
    UILabel *vsLabel = [[UILabel alloc] init];
    self.vsLabel = vsLabel;
    vsLabel.backgroundColor = [UIColor clearColor];
    vsLabel.textAlignment = NSTextAlignmentCenter;
    vsLabel.numberOfLines = 0;
    vsLabel.font = bigFont;
    vsLabel.textColor = YZBlackTextColor;
    CGFloat verticalLineMaxX = CGRectGetMaxX(verticalLine.frame);
    CGFloat vsLabelX = verticalLineMaxX;
    vsLabel.frame = CGRectMake(vsLabelX, 0, matchNameLabelW, scjqCellH);
    [self.contentView addSubview:vsLabel];
    
    CGFloat greenLineH = 2;
    //八个按钮
    int btnCount = 8;
    CGFloat topRightPadding = 5;
    CGFloat btnPadding = 2;
    CGFloat vsLabelMaxX = CGRectGetMaxX(vsLabel.frame);
    CGFloat btnW = (screenWidth - vsLabelMaxX - topRightPadding - (maxColums - 1) * btnPadding) / maxColums;
    CGFloat btnH = (scjqCellH - greenLineH - 4 * topRightPadding) / 2;
    for(int i = 0;i < btnCount;i++)
    {
        //赔率按钮
        UIButton *btn = [[UIButton alloc] init];
        int titleInt = (i % maxColums);
        [btn setTitle:[NSString stringWithFormat:@"%d",(i % maxColums)] forState:UIControlStateNormal];
        if(titleInt == 3)
        {
            [btn setTitle:@"3+" forState:UIControlStateNormal];
        }
        btn.tag = i;
        [self.btns addObject:btn];
        
        //设置属性
        btn.titleLabel.font = midFont;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        
        //设置frame
        CGFloat btnX = vsLabelMaxX + (i % maxColums) * (btnW + btnPadding);
        CGFloat btnY = topRightPadding + (i / maxColums) * (btnH + 2 * topRightPadding);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        [btn addTarget:self action:@selector(oddInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
    //绿色分割线
    UIImage *greenLineImage = [UIImage imageNamed:@"ft_bottomline"];
    UIImageView *greenLine = [[UIImageView alloc] initWithImage:greenLineImage];
    CGFloat greenLineY = scjqCellH - greenLineH;
    greenLine.frame = CGRectMake(0, greenLineY, screenWidth, greenLineH);
    [self.contentView addSubview:greenLine];
}
- (void)setStatus:(YZScjqCellStatus *)status
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
    paragraphStyle.lineSpacing = 10;
    paragraphStyle.paragraphSpacing = 10;
    NSDictionary *attDict = @{NSForegroundColorAttributeName : [UIColor darkGrayColor],NSFontAttributeName : midFont,NSParagraphStyleAttributeName : paragraphStyle};//时间灰黑色、中字体
    [muAttStr addAttributes:attDict range:endTimeRange];
    self.matchNameLabel.attributedText = muAttStr;
    
    [self setCommonStatus:_status];
}
- (void)setBetStatus:(YZScjqCellStatus *)betStatus
{
    _betStatus = betStatus;
    
    //更改ui
    CGFloat padding = 10;
    self.matchNameLabel.width = 2 * matchNameLabelW / 3;
    self.verticalLine.x = CGRectGetMaxX(self.matchNameLabel.frame);
    CGFloat verticalLineMaxX = CGRectGetMaxX(self.verticalLine.frame);
    self.vsLabel.x = verticalLineMaxX;
    CGFloat btnPadding = 2;
    CGFloat vsLabelMaxX = CGRectGetMaxX(self.vsLabel.frame);
    CGFloat btnW = (screenWidth - 2 * padding - vsLabelMaxX - (maxColums - 1) * btnPadding) / maxColums;
    for(int i = 0;i < self.btns.count;i++)
    {
        UIButton *btn = self.btns[i];
        CGFloat btnX = vsLabelMaxX + (i % maxColums) * (btnW + btnPadding);
        btn.x = btnX;
    }
    
    self.matchNameLabel.textAlignment = NSTextAlignmentLeft;
    self.matchNameLabel.text = [NSString stringWithFormat:@"%d",_betStatus.number];
    
    [self setCommonStatus:_betStatus];
}
- (void)setCommonStatus:(YZScjqCellStatus *)status
{
    //设置VS双方
    self.vsLabel.text = status.vsText;
    
    //设置8个赔率
    
    for(int i = 0;i < self.btns.count;i++)
    {
        UIButton *btn = self.btns[i];
        
        //设置按钮的状态
        BOOL btnState = [status.btnStateArray[i / maxColums][i % maxColums] boolValue];//第几行，第几个按钮
        btn.selected = btnState;
    }
}
//赔率按钮点击
- (void)oddInfoBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if([self.delegate respondsToSelector:@selector(scjqCellOddsInfoBtnDidClick:withCell:)])
    {
        [self.delegate scjqCellOddsInfoBtnDidClick:btn withCell:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
