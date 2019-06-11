//
//  YZNoNetView.m
//  ez
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZNoNetView.h"

@implementation YZNoNetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, 136, 84)];
        imageView.center = CGPointMake(screenWidth/2, imageView.center.y);
        imageView.image = [UIImage imageNamed:@"no_net"];
        [self addSubview:imageView];
        
        UILabel * label = [[UILabel alloc]init];
        label.text = @"数据加载失败";
        label.textColor = YZBlackTextColor;
        label.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        CGSize size = [label.text sizeWithLabelFont:label.font];
        label.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 15, screenWidth, size.height);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        UILabel * label1 = [[UILabel alloc]init];
        label1.text = @"请检查您的手机是否联网";
        label1.textColor = YZGrayTextColor;
        label1.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        CGSize size1 = [label1.text sizeWithLabelFont:label1.font];
        label1.frame = CGRectMake(0, CGRectGetMaxY(label.frame) + 10, screenWidth, size1.height);
        label1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label1];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, CGRectGetMaxY(label1.frame) + 30, 80, 30);
        button.center = CGPointMake(screenWidth / 2, button.center.y);
        [button setTitle:@"重新加载" forState:UIControlStateNormal];
        [button setTitleColor:YZGrayTextColor forState:UIControlStateNormal];
        [button setTitleColor:YZColor(251, 180, 44, 1) forState:UIControlStateSelected];
        [button setTitleColor:YZColor(251, 180, 44, 1) forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [button addTarget:self action:@selector(reloadNetworkDataSource:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(setButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:button];
        button.layer.cornerRadius = 30 / 2;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = YZGrayTextColor.CGColor;
        button.layer.borderWidth = 1;
    }
    return self;
}
- (void)setButtonHighlighted:(UIButton *)button
{
    button.layer.borderColor = YZColor(251, 180, 44, 1).CGColor;
}
- (void)reloadNetworkDataSource:(UIButton *)button {
    button.selected = YES;
    dispatch_time_t selectedtime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animateDuration * NSEC_PER_SEC));
    dispatch_after(selectedtime, dispatch_get_main_queue(), ^{
        button.selected = NO;
        button.layer.borderColor = YZGrayTextColor.CGColor;
    });
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadNetworkDataSource:)]) {
        [self.delegate performSelector:@selector(reloadNetworkDataSource:) withObject:button];
    }
}
@end
