//
//  YZVoucherGuideView.m
//  ez
//
//  Created by 毛文豪 on 2017/6/15.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZVoucherGuideView.h"
#import "YZVoucherViewController.h"
#import "YZMoneyDetailViewController.h"
#import "YZLoadHtmlFileController.h"
#import "UIButton+WebCache.h"

@interface YZVoucherGuideView ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) YZGuideModel *guideModel;
@property (nonatomic,weak) UIView *backView;
@property (nonatomic,weak) UIImageView * imageView;

@end

@implementation YZVoucherGuideView

- (instancetype)initWithFrame:(CGRect)frame guideModel:(YZGuideModel *)guideModel
{
    self = [super initWithFrame:frame];
    if (self) {
        self.guideModel = guideModel;
        [self setupChildViews];
    }
    return self;
}
- (void)setupChildViews
{
    //背景
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = YZColor(0, 0, 0, 0.5);
    [self addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
    tap.delegate = self;
    [backView addGestureRecognizer:tap];
    
    //视图
    CGFloat imageView1W = 38;
    CGFloat imageView1H = 44;
    
    CGFloat imageView2W = 248;
    CGFloat imageView2H = 294;
    
    CGFloat imageView1Y = (self.height -imageView1H - imageView2H) / 2;
    UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake((screenWidth - imageView1W) / 2, imageView1Y, imageView1W, imageView1H);
    deleteButton.adjustsImageWhenHighlighted = NO;
    [deleteButton setImage:[UIImage imageNamed:@"voucher_guide1"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
  
    UIButton * goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goButton.frame = CGRectMake((screenWidth - imageView2W) / 2, CGRectGetMaxY(deleteButton.frame), imageView2W, imageView2H);
    [goButton sd_setImageWithURL:[NSURL URLWithString:self.guideModel.url] forState:UIControlStateNormal];
    goButton.adjustsImageWhenHighlighted = NO;
    [goButton addTarget:self action:@selector(gotoVoucher) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:goButton];
}
- (void)gotoVoucher
{
    [self removeFromSuperview];
    
    if ([self.guideModel.type isEqualToString:@"coupon"]) {
        YZVoucherViewController * voucherVC = [[YZVoucherViewController alloc] init];
        [self.owerViewController pushViewController:voucherVC animated:YES];
    }else if ([self.guideModel.type isEqualToString:@"hit"])
    {
        YZMoneyDetailViewController * moneyDetailVC = [[YZMoneyDetailViewController alloc] init];
        [self.owerViewController pushViewController:moneyDetailVC animated:YES];
    }else if ([self.guideModel.type isEqualToString:@"web"])
    {
        YZLoadHtmlFileController * updataActivityVC = [[YZLoadHtmlFileController alloc] initWithWeb:self.guideModel.htmlUrl];
        [self.owerViewController pushViewController:updataActivityVC animated:YES];
    }else if ([self.guideModel.type isEqualToString:@"ticket"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshRecordNote object:@(0)];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint pos = [touch locationInView:self.imageView.superview];
        if (CGRectContainsPoint(self.imageView.frame, pos)) {
            return NO;
        }
    }
    return YES;
}

@end
