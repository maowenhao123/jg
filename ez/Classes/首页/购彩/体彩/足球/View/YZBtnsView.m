//
//  YZBtnsView.m
//  ez
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#define btnH 40
#import "YZBtnsView.h"
#import "YZFootBallMatchRate.h"

@interface YZBtnsView ()
@property (nonatomic, strong) NSArray *foreStrArr1;
@property (nonatomic, strong) NSArray *foreStrArr2;
@end
@implementation YZBtnsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
    }
    return self;
}
- (void)setRates:(NSArray *)rates
{
    _rates = rates;//放footBallMatchRate对象

    int maxColumns = 3;
    CGFloat padding = 2;
    CGFloat btnW = (btnsViewW - 2 * padding) / 3;
    
    for(int i = 0 ;i < _rates.count;i++)
    {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        btn.titleLabel.numberOfLines = 0;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        UIImage *image = [UIImage resizedImageWithName:@"fb_btnImageWithDelete" left:0.5 top:0.5];
        UIImage *hiImage= [UIImage resizedImageWithName:@"fb_btnImageWithDelete_pressed" left:0.5 top:0.5];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:hiImage forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(oddInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
     
        YZFootBallMatchRate *rate = _rates[i];
        if(![rate.value isEqualToString:@""] && rate.value.length != 0)//标题不为空
        {
            btn.hidden = NO;
            [self setBtnTitle:btn withMatchRate:rate];
            
            //设置frame
            int col = i % maxColumns;
            int row = i / maxColumns;
            CGFloat btnX = col * (btnW + padding);
            CGFloat btnY = row * (btnH + padding);
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        }else
        {
            btn.hidden = YES;
        }

    }
}
- (void)setBtnTitle:(UIButton *)btn withMatchRate:(YZFootBallMatchRate *)rate
{
    NSString *tempTitle = @"";
    if ([rate.CNType isEqualToString:@"CN03"] || [rate.CNType isEqualToString:@"CN04"]) {
        tempTitle = [NSString stringWithFormat:@"%@\n%@",rate.info ,rate.value];
        NSMutableAttributedString * btnAttStr = [[NSMutableAttributedString alloc]initWithString:tempTitle];
        //换行后依旧居中对齐
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *attDict = @{NSParagraphStyleAttributeName : paragraphStyle};
        [btnAttStr addAttributes:attDict range:NSMakeRange(0, btnAttStr.length)];
        [btn setAttributedTitle:btnAttStr forState:UIControlStateNormal];
    }else if ([rate.CNType isEqualToString:@"CN01"])
    {
        tempTitle = [NSString stringWithFormat:@"让球%@%@",rate.info ,rate.value];
        [btn setTitle:tempTitle forState:UIControlStateNormal];
    }else
    {
       tempTitle = [NSString stringWithFormat:@"%@%@",rate.info ,rate.value];
       [btn setTitle:tempTitle forState:UIControlStateNormal];
    }
}
//赔率按钮点击
- (void)oddInfoBtnClick:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(btnsViewDidClickOddInfoBtn:inBtnsView:)])
    {
        [self.delegate btnsViewDidClickOddInfoBtn:btn inBtnsView:self];
    }
}
//初始化
- (void)setStatus:(YZFbBetCellStatus *)status
{
    _status = status;
}
- (NSString *)getStringFromFloatString:(NSString *)floatString
{
    NSString* str;
    float num = [floatString floatValue];
    if (fmodf(num, 1)==0)
    {
        str = [NSString stringWithFormat:@"%.0f",num];
    } else if (fmodf(num * 10, 1)==0)
    {
        str = [NSString stringWithFormat:@"%.1f",num];
    }else if (fmodf(num * 100, 1)==0)
    {
        str = [NSString stringWithFormat:@"%.2f",num];
    }else if (fmodf(num * 1000, 1)==0)
    {
        str = [NSString stringWithFormat:@"%.3f",num];
    }else if (fmodf(num * 10000, 1)==0)
    {
        str = [NSString stringWithFormat:@"%.4f",num];
    }else
    {
        str = [NSString stringWithFormat:@"%.5f",num];
    }
    return str;
}
@end
