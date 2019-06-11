//
//  YZSchemeSetmealTableViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/7/11.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZSchemeSetmealTableViewCell.h"

@interface YZSchemeSetmealTableViewCell ()

@property (nonatomic, weak) UIView * customContentView;
@property (nonatomic, weak) UILabel * nameLabel;
@property (nonatomic, weak) UILabel * moneyLabel;
@property (nonatomic, weak) UILabel *unhitReturnMoneyDescLabel;
@property (nonatomic, weak) UILabel *hitRatioLabel;
@property (nonatomic, weak) UILabel *termCountLabel;

@end

@implementation YZSchemeSetmealTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SchemeSetmealTableViewCellId";
    YZSchemeSetmealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZSchemeSetmealTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    //分割线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 9)];
    lineView.backgroundColor = YZBackgroundColor;
    [self addSubview:lineView];
    
    //内容
    UIView * customContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 9, screenWidth, 100)];
    self.customContentView = customContentView;
    customContentView.backgroundColor = [UIColor whiteColor];
    customContentView.layer.borderWidth = 0.5;
    customContentView.layer.borderColor = YZWhiteLineColor.CGColor;
    [self addSubview:customContentView];
    
    CGFloat leftViewW = 150;
    //名字
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, leftViewW, 20)];
    self.nameLabel = nameLabel;
    nameLabel.textColor = YZBlackTextColor;
    nameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [customContentView addSubview:nameLabel];
    
    //金额
    UILabel * moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame), leftViewW, 30)];
    self.moneyLabel = moneyLabel;
    moneyLabel.textColor = YZRedTextColor;
    moneyLabel.font = [UIFont systemFontOfSize:YZGetFontSize(34)];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [customContentView addSubview:moneyLabel];
    
    //金额描述
    UILabel * unhitReturnMoneyDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyLabel.frame), leftViewW, 20)];
    self.unhitReturnMoneyDescLabel = unhitReturnMoneyDescLabel;
    unhitReturnMoneyDescLabel.textColor = YZRedTextColor;
    unhitReturnMoneyDescLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    unhitReturnMoneyDescLabel.textAlignment = NSTextAlignmentCenter;
    [customContentView addSubview:unhitReturnMoneyDescLabel];
    
    //中奖率
    UILabel * hitRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 20 - 105, 10, 40, 40)];
    self.hitRatioLabel = hitRatioLabel;
    hitRatioLabel.numberOfLines = 0;
    [customContentView addSubview:hitRatioLabel];
    
    //分割线
    UIView * line = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 20 - 60, 13, 1, 30)];
    line.backgroundColor = YZWhiteLineColor;
    [customContentView addSubview:line];
    
    //中奖率
    UILabel * termCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 20 - 53, 10, 60, 40)];
    self.termCountLabel = termCountLabel;
    termCountLabel.numberOfLines = 0;
    [customContentView addSubview:termCountLabel];
    
    //投注按钮
    YZBottomButton * buyButton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    buyButton.frame = CGRectMake(screenWidth - 100 - 20, 53, 100, 35);
    [buyButton setTitle:@"立刻购买" forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buyButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [customContentView addSubview:buyButton];
}

- (void)buyButtonDidClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(schemeSetmealTableViewCellBuyDidClickCell:)]) {
        [_delegate schemeSetmealTableViewCellBuyDidClickCell:self];
    }
}

- (void)setSchemeSetmealInfoModel:(YZSchemeSetmealInfoModel *)schemeSetmealInfoModel
{
    _schemeSetmealInfoModel = schemeSetmealInfoModel;
    
    self.nameLabel.text = _schemeSetmealInfoModel.name;
    
    NSString * money = [NSString stringWithFormat:@"%.2f", [_schemeSetmealInfoModel.money floatValue] / 100];
    NSString * moneyStr = [NSString stringWithFormat:@"%@%@", money, _schemeSetmealInfoModel.moneyDesc];
    NSMutableAttributedString * moneyAttStr = [[NSMutableAttributedString alloc]initWithString:moneyStr];
    [moneyAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(36)] range:[moneyAttStr.string rangeOfString:money]];
    [moneyAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:[moneyAttStr.string rangeOfString:_schemeSetmealInfoModel.moneyDesc]];
    self.moneyLabel.attributedText = moneyAttStr;
    
    self.unhitReturnMoneyDescLabel.text = _schemeSetmealInfoModel.unhitReturnMoneyDesc;
    
    NSString * hitRatioStr = [NSString stringWithFormat:@"%@%%\n中奖率", _schemeSetmealInfoModel.hitRatio];
    NSMutableAttributedString * hitRatioAttStr = [[NSMutableAttributedString alloc]initWithString:hitRatioStr];
    [hitRatioAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(0, hitRatioAttStr.length - 3)];
    [hitRatioAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, hitRatioAttStr.length - 3)];
    [hitRatioAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(22)] range:NSMakeRange(hitRatioAttStr.length - 3, 3)];
    [hitRatioAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(hitRatioAttStr.length - 3, 3)];
    NSMutableParagraphStyle *hitRatioParagraph = [[NSMutableParagraphStyle alloc] init];
    hitRatioParagraph.lineSpacing = 3;
    hitRatioParagraph.alignment = NSTextAlignmentRight;
    [hitRatioAttStr addAttribute:NSParagraphStyleAttributeName value:hitRatioParagraph range:NSMakeRange(0, hitRatioAttStr.length)];
    self.hitRatioLabel.attributedText = hitRatioAttStr;
    
    NSString * termCountStr = [NSString stringWithFormat:@"%@期\n追号期数", _schemeSetmealInfoModel.termCount];
    NSMutableAttributedString * termCountAttStr = [[NSMutableAttributedString alloc]initWithString:termCountStr];
    [termCountAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(0, termCountAttStr.length - 4)];
    [termCountAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, termCountAttStr.length - 4)];
    [termCountAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(22)] range:NSMakeRange(termCountAttStr.length - 4, 4)];
    [termCountAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(termCountAttStr.length - 4, 4)];
    NSMutableParagraphStyle *termCountParagraph = [[NSMutableParagraphStyle alloc] init];
    termCountParagraph.lineSpacing = 3;
    termCountParagraph.alignment = NSTextAlignmentLeft;
    [termCountAttStr addAttribute:NSParagraphStyleAttributeName value:termCountParagraph range:NSMakeRange(0, termCountAttStr.length)];
    self.termCountLabel.attributedText = termCountAttStr;
}

@end
