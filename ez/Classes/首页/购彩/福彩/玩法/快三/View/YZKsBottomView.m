//
//  YZKsBottomView.m
//  ez
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 9ge. All rights reserved.
//

#define KWidth self.bounds.size.width
#define KHeight 49
#define KRedColor YZColor(226, 118, 39, 1)
#define KGrayColor YZColor(159, 159, 159, 1)
#import "YZKsBottomView.h"

@interface YZKsBottomView ()

@property (nonatomic, weak) UILabel *amountLabel;

@end

@implementation YZKsBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZColor(40, 40, 40, 1);
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWidth, 2)];
    line.backgroundColor = YZColor(226, 118, 39, 1);
    [self addSubview:line];
    
    //删除按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat deleteBtnY = CGRectGetMaxY(line.frame);
    CGFloat deleteBtnW = 75;
    CGFloat deleteBtnH = KHeight - deleteBtnY;
    deleteBtn.frame  = CGRectMake(0, deleteBtnY, deleteBtnW, deleteBtnH);
    [deleteBtn setImage:[UIImage imageNamed:@"ks_lajitong"] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(83, 83, 83, 1) WithRect:deleteBtn.bounds] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(29, 29, 29, 1) WithRect:deleteBtn.bounds] forState:UIControlStateHighlighted];
    [deleteBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(29, 29, 29, 1) WithRect:deleteBtn.bounds] forState:UIControlStateSelected];
    [self addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //确认按钮
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat confirmBtnH = 30;
    CGFloat confirmBtnW = 75;
    confirmBtn.frame = CGRectMake(screenWidth - confirmBtnW - 15, (KHeight - confirmBtnH) / 2, confirmBtnW, confirmBtnH);
    [confirmBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(226, 118, 39, 1) WithRect:deleteBtn.bounds] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(166, 82, 28, 1) WithRect:deleteBtn.bounds] forState:UIControlStateHighlighted];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.layer.cornerRadius = 2;

    //注数和金额总数
    UILabel *amountLabel = [[UILabel alloc] init];
    self.amountLabel = amountLabel;
    amountLabel.backgroundColor = [UIColor clearColor];
    amountLabel.textColor = KGrayColor;
    NSString *str = [NSString stringWithFormat:@"共0注，0元"];
    NSRange range1 = [str rangeOfString:@"共"];
    NSRange range2 = [str rangeOfString:@"注"];
    NSRange range3 = [str rangeOfString:@"元"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:KRedColor range:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:KRedColor range:NSMakeRange(range2.location + 2, range3.location - range2.location - 2)];
    amountLabel.attributedText = attStr;
    amountLabel.font = [UIFont systemFontOfSize:14];
    CGFloat amountLabelX = CGRectGetMaxX(deleteBtn.frame) + 5;
    CGFloat amountLabelW = KWidth - deleteBtnW - confirmBtnW - 10;
    CGFloat amountLabelH = 25;
    amountLabel.frame = CGRectMake(amountLabelX, deleteBtnY, amountLabelW, amountLabelH);
    amountLabel.center = CGPointMake(amountLabel.center.x, deleteBtnH / 2);
    [self addSubview:amountLabel];
}
- (void)deleteBtnClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(bottomViewDeleteBtnClick)]) {
        [_delegate bottomViewDeleteBtnClick];
    }
}
- (void)confirmBtnClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(bottomViewConfirmBtnClick)]) {
        [_delegate bottomViewConfirmBtnClick];
    }
}
- (void)setBetCount:(int)betCount
{
    NSString *temp = [NSString stringWithFormat:@"共%d注，%d元",betCount,betCount*2];
    
    NSRange range1 = [temp rangeOfString:@"共"];
    NSRange range2 = [temp rangeOfString:@"注"];
    NSRange range3 = [temp rangeOfString:@"元"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temp];
    [attStr addAttribute:NSForegroundColorAttributeName value:KRedColor range:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:KRedColor range:NSMakeRange(range2.location + 2, range3.location - range2.location - 2)];
    self.amountLabel.attributedText = attStr;
}

@end
