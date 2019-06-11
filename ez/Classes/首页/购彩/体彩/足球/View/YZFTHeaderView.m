//
//  YZFTHeaderView.m
//  ez
//
//  Created by apple on 14-11-20.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZFTHeaderView.h"

@interface YZFTHeaderView ()

@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIImageView *greenLine;

@end

@implementation YZFTHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)talbeView
{
    static NSString *ID = @"s1x5Header";
    YZFTHeaderView *header = [talbeView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if(header == nil)
    {
        header = [[YZFTHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}
//初始化子控件
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = YZColor(225, 248, 171, 1);
        //显示文字的label
        UILabel *label = [[UILabel alloc] init];
        self.label = label;
        label.textAlignment = NSTextAlignmentCenter;
        label.font= [UIFont systemFontOfSize:15];
        [self.contentView addSubview:label];

        //按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn = btn;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, screenWidth-20, 0, 0)];
        [btn setImage:[UIImage imageNamed:@"ft_header_arrow"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        //绿色分割线
        UIImageView *greenLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ft_bottomline"]];
        self.greenLine = greenLine;
        [self.contentView addSubview:greenLine];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = self.bounds;
    
    self.btn.frame = self.bounds;

    CGFloat greenLineH = 2;
    CGFloat greenLineY = headerViewH-greenLineH;
    self.greenLine.frame = CGRectMake(0, greenLineY, screenWidth, greenLineH);
}
- (void)btnClick
{
    self.sectionStatus.opened = !self.sectionStatus.opened;
    if([self.delegate respondsToSelector:@selector(headerViewDidClickWithHeader:)])
    {
        [self.delegate headerViewDidClickWithHeader:self];
    }
   
}
- (void)setSectionStatus:(YZSectionStatus *)sectionStatus
{
    _sectionStatus = sectionStatus;
    
    self.label.text = self.sectionStatus.title;

}

@end
