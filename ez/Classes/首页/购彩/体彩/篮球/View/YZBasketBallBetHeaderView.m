//
//  YZBasketBallBetHeaderView.m
//  ez
//
//  Created by 毛文豪 on 2018/5/30.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZBasketBallBetHeaderView.h"

@interface YZBasketBallBetHeaderView ()

@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIButton *btn;

@end

@implementation YZBasketBallBetHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)talbeView
{
    static NSString *ID = @"YZBasketBallBetHeaderViewId";
    YZBasketBallBetHeaderView *header = [talbeView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if(header == nil)
    {
        header = [[YZBasketBallBetHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}
//初始化子控件
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        //显示文字的label
        UILabel *label = [[UILabel alloc] init];
        self.label = label;
        label.text = @"比赛";
        label.textColor = YZBlackTextColor;
        label.font= [UIFont systemFontOfSize:YZGetFontSize(28)];
        [self.contentView addSubview:label];
        
        //按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn = btn;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, screenWidth-20, 0, 0)];
        [btn setImage:[UIImage imageNamed:@"ft_header_arrow"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        //分割线
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 34, screenWidth, 1)];
        line.backgroundColor = YZWhiteLineColor;
        [self addSubview:line];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = CGRectMake(10, 0, self.width - 20 - 20, self.height);
    
    self.btn.frame = self.bounds;
}
- (void)btnClick
{
    if([self.delegate respondsToSelector:@selector(headerViewDidClickWithHeader:)])
    {
        [self.delegate headerViewDidClickWithHeader:self];
    }
    
}
- (void)setMatchInfosModel:(YZMatchInfosStatus *)matchInfosModel
{
    _matchInfosModel = matchInfosModel;
    
    //设置VS双方
    NSArray *detailInfoArray = [_matchInfosModel.detailInfo componentsSeparatedByString:@"|"];
    self.label.text = [NSString stringWithFormat:@"%@（客）VS%@（主）", detailInfoArray[1], detailInfoArray[0]];
    
}


@end
