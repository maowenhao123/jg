//
//  YZBasketBallHeaderView.m
//  ez
//
//  Created by 毛文豪 on 2018/5/22.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZBasketBallHeaderView.h"

@interface YZBasketBallHeaderView ()

@property (nonatomic, weak) UILabel *label;

@end

@implementation YZBasketBallHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)talbeView
{
    static NSString *ID = @"YZBasketBallHeaderViewId";
    YZBasketBallHeaderView *header = [talbeView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if(header == nil)
    {
        header = [[YZBasketBallHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}
//初始化子控件
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        //显示文字的label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenWidth - 20 - 20, self.height)];
        self.label = label;
        label.text = @"比赛";
        label.textColor = YZBlackTextColor;
        label.font= [UIFont systemFontOfSize:YZGetFontSize(30)];
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
    
    self.label.height = self.height;
    
    self.btn.frame = self.bounds;
}
- (void)btnClick
{
    self.sectionModel.opened = !self.sectionModel.opened;
    if([self.delegate respondsToSelector:@selector(headerViewDidClickWithHeader:)])
    {
        [self.delegate headerViewDidClickWithHeader:self];
    }

}
- (void)setSectionModel:(YZSectionStatus *)sectionModel
{
    _sectionModel = sectionModel;

    self.label.text = _sectionModel.title;

}

@end
