//
//  YZSelectBallCell.m
//  ez
//
//  Created by apple on 14-9-9.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#define iconTitleW 44

#import "YZSelectBallCell.h"

@interface YZSelectBallCell ()

@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UILabel *leftLabel;
@property (nonatomic, weak) UIView * lineView;

@end

@implementation YZSelectBallCell

+(YZSelectBallCell *)cellWithTableView:(UITableView *)tableView andIndexpath:(NSIndexPath *)indexPath
{
    //cell不重用
    NSString *ID = [NSString stringWithFormat:@"ball%ld%ld",(long)indexPath.section,(long)indexPath.row];
    YZSelectBallCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZSelectBallCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = YZBackgroundColor;
    }
    return  cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self setupChilds];
        
    }
    return self;
}
- (void)setupChilds
{
    //文字
    UILabel *label = [[UILabel alloc] init];
    self.label = label;
    label.textColor = YZBlackTextColor;
    label.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [self addSubview:label];
    
    //backView,用于装2个按钮
    UIView *btnBackView = [[UIView alloc] init];
    CGFloat btnBackViewW = 85;
    CGFloat btnBackViewH = 40;
    CGFloat btnBackViewX = screenWidth - btnBackViewW - 10;
    CGFloat btnBackViewY = 0;
    btnBackView.frame = CGRectMake(btnBackViewX, btnBackViewY, btnBackViewW, btnBackViewH);
    
    //右边的机选和机选数按钮
    CGFloat btnH = 21;
    CGFloat btnY = (btnBackViewH - btnH) / 2;
    for(int i = 0;i< 2;i++)
    {
        CGFloat btnW;
        CGFloat btnX;
        YZLotteryButton *btn = [YZLotteryButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(20)];
        if(i == 0)//机选按钮
        {
            btnW = 60;
            btnX = 0;
            self.randomBtn = btn;
            [btn addTarget:self action:@selector(randomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            self.randomBtn = btn;
        }else//机选数按钮
        {
            btnW = 30;
            btnX = 60;
            self.randomCountBtn = btn;
            btn.owner = self;
            [btn addTarget:self action:@selector(randomCountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btnBackView insertSubview:btn aboveSubview:btnBackView];
    }
    [self addSubview:btnBackView];
    
    //显示个十百位的图片
    UIImageView * icon = [[UIImageView alloc]init];
    self.icon = icon;
    icon.hidden = YES;
    [self addSubview:icon];
    
    //显示左边标题
    UILabel *leftLabel = [[UILabel alloc] init];
    self.leftLabel = leftLabel;
    leftLabel.textColor = YZBlackTextColor;
    leftLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    leftLabel.hidden = YES;
    [self addSubview:leftLabel];
    
    //分割线
    UIView * lineView = [[UIView alloc]init];
    self.lineView = lineView;
    lineView.backgroundColor = YZGrayLineColor;
    [self addSubview:lineView];
}

- (void)setStatus:(YZSelectBallCellStatus *)status
{
    _status = status;
    
    //右边的机选和机选数按钮
    if(_status.RandomCount)//有随机数才显示两个随机按钮
    {
        //机选按钮
        NSString *image = [NSString stringWithFormat:@"left%@Btn_flat",_status.isRed ? @"Red":@"Blue"];
        [self.randomBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [self.randomBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed",image]] forState:UIControlStateHighlighted];
        [self.randomBtn setTitle:_status.isRed ? @"机选红球":@"机选蓝球" forState:UIControlStateNormal];
        if([[_status.title string] rangeOfString:@"区"].location != NSNotFound)//title是前区,就改标题
        {
            [self.randomBtn setTitle:_status.isRed ? @"机选前区":@"机选后区" forState:UIControlStateNormal];
        }
        [self.randomBtn addTarget:self action:@selector(randomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //机选数按钮
        NSString *image1 = [NSString stringWithFormat:@"right%@Btn_flat",_status.isRed?@"Red":@"Blue"];
        [self.randomCountBtn setImage:[UIImage imageNamed:image1] forState:UIControlStateNormal];
        [self.randomCountBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed",image1]] forState:UIControlStateHighlighted];
        [self.randomCountBtn setTitle:[NSString stringWithFormat:@"%d",_status.RandomCount] forState:UIControlStateNormal];
        self.randomCountBtn.range = _status.randomCountRange;
        [self.randomCountBtn addTarget:self action:@selector(randomCountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //icon文字
    if(!YZStringIsEmpty(_status.icon))
    {
        self.icon.hidden = NO;
        self.icon.image = [UIImage imageNamed:_status.icon];
        CGFloat iconY = 1;
        if(_status.title)
        {
            iconY = 40;
        }
        CGFloat iconW = 35;
        CGFloat iconH = 16;
        self.icon.frame = CGRectMake(0, iconY, iconW, iconH);
    }else
    {
        self.icon.image = nil;
        self.icon.hidden = YES;
    }
    
    //号码球
    int maxColumns = 7;//一行显示几个
    if (!YZStringIsEmpty(_status.icon)) {
        maxColumns = 6;
    }
    if (!YZStringIsEmpty(_status.leftTitle)) {
        maxColumns = 8;
    }
    CGFloat leftPadding = 0;
    if (!YZStringIsEmpty(_status.leftTitle)) {
        leftPadding = 20;
    }
    if(_status.ballReuse == NO)//不循环利用球，则删除
    {
        for(YZBallBtn *ball in self.ballsArray)
        {
            [ball removeFromSuperview];
        }
        [self.ballsArray removeAllObjects];
    }

    CGFloat padding = 0;//球与球的边距
    CGFloat btnW = 36;
    CGFloat btnH = 36;
    if(self.ballsArray.count != _status.ballsCount)//如果相等说明已经创建，则不用再创建
    {
        NSMutableArray *ballsArray = [[NSMutableArray alloc] init];
        for(int i = 0;i < _status.ballsCount;i++)
        {
            YZBallBtn *btn = [YZBallBtn button];
            btn.owner = self;
            btn.delegate = self.delegate;
            NSString *image = [NSString stringWithFormat:@"%@Ball_flat",_status.isRed ? @"red":@"blue"];
            btn.selImageName = image;
            btn.ballTextColor = _status.isRed ? YZRedBallColor : YZBlueBallColor;
            if(_status.startNumber)//有值
            {
                btn.tag = i + [_status.startNumber intValue];
                [btn setTitle:[NSString stringWithFormat:@"%ld",(long)btn.tag] forState:UIControlStateNormal];
            }else
            {
                btn.tag = i + 1;
                [btn setTitle:[NSString stringWithFormat:@"%02ld",(long)btn.tag] forState:UIControlStateNormal];
            }
            [btn setTitleColor:btn.ballTextColor forState:UIControlStateNormal];
            CGFloat btnX = 0;
            if (!YZStringIsEmpty(_status.icon))
            {
                padding = (screenWidth - leftPadding - maxColumns * btnW - iconTitleW) / (maxColumns + 1);
                btnX = padding + leftPadding + iconTitleW + (i % maxColumns) * (btnW + padding);
            }else
            {
                padding = (screenWidth - leftPadding - maxColumns * btnW ) / (maxColumns + 1);
                btnX = padding + leftPadding + (i % maxColumns) * (btnW + padding);
                self.icon.frame = CGRectZero;
            }
            CGFloat btnY = 0;
            //
            if(_status.title)
            {
                if (!YZStringIsEmpty(_status.icon) && !_status.RandomCount) {
                    btnY = 40 + padding + (i / maxColumns) * (btnH + padding);
                }else if (!YZStringIsEmpty(_status.leftTitle))
                {
                    btnY = 60 + 5 + (i / maxColumns) * (btnH + padding);
                }else
                {
                    btnY = 30 + padding + (i / maxColumns) * (btnH + padding);
                }
            }else
            {
                if (!YZStringIsEmpty(_status.leftTitle))
                {
                    btnY = 30 + 5 + (i / maxColumns) * (btnH + padding);
                }else
                {
                    btnY = padding + (i / maxColumns) * (btnH + padding);
                }
            }
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            [self addSubview:btn];
            [ballsArray addObject:btn];
        }
        self.ballsArray = ballsArray;
    }
    
    //title文字的frame
    if(_status.title)
    {
       self.label.hidden = NO;
       self.label.attributedText = _status.title;
       self.label.frame = CGRectMake(YZMargin, 10, screenWidth - 2 * YZMargin, 20);
    }else
    {
       self.label.attributedText = nil;
       self.label.hidden = YES;
    }
    
     //左边文字
    if(!YZStringIsEmpty(_status.leftTitle))
    {
      self.leftLabel.hidden = NO;
      self.leftLabel.text = _status.leftTitle;
      CGFloat leftLabelW = 50;
      CGFloat leftLabelH = 20;
        if(_status.title)
        {
           self.leftLabel.frame = CGRectMake(YZMargin, CGRectGetMaxY(self.label.frame) + 10, leftLabelW, leftLabelH);
        }else
        {
           self.leftLabel.frame = CGRectMake(YZMargin, 10, leftLabelW, leftLabelH);
        }
    }else
    {
      self.leftLabel.text = @"";
      self.leftLabel.hidden = YES;
    }
    
    if(!YZStringIsEmpty(_status.title) && !YZStringIsEmpty(_status.icon) && !_status.RandomCount)
    {
        self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.label.frame) + 10, screenWidth, 1);
    }else
    {
        self.lineView.frame = CGRectMake(0, 0, screenWidth, 1);
    }
    if (self.index == 0 && YZStringIsEmpty(_status.icon)) {
        self.lineView.hidden = YES;
    }else
    {
        self.lineView.hidden = NO;
    }

}
//随机选球
- (void)randomBtnClick:(YZLotteryButton *)btn
{
    //先清空已选按钮
    [self clearChooseBalls:self.ballsArray];
    
    //通知代理点击了机选按钮,清空已选按钮数组
    if([self.delegate respondsToSelector:@selector(randomBtnDidClick:)])
    {
        [self.delegate randomBtnDidClick:btn];
    }
    
    //随机选球
    int count = (int)self.ballsArray.count;
    NSMutableSet *btnsSet = [NSMutableSet set];
    while (btnsSet.count < self.status.RandomCount) {
        int random = arc4random() % count;
        [btnsSet addObject:[self.ballsArray objectAtIndex:random]];
    }
    for(YZBallBtn *btn in btnsSet)
    {
        [btn ballClick:btn];
    }
    
}

//按钮变回原来颜色
- (void)clearChooseBalls:(NSArray *)ballsArray
{
    for(int i = 0;i < ballsArray.count;i++)
    {
        YZBallBtn *ballBtn = ballsArray[i];
        if(ballBtn.isSelected)
        {
            [ballBtn ballChangeToWhite];
        }
    }
}

- (void)randomCountBtnClick:(YZLotteryButton *)btn
{
    if([self.delegate respondsToSelector:@selector(randomCountBtnDidClick:)])
    {
        [self.delegate randomCountBtnDidClick:btn];
    }
}

@end
