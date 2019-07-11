//
//  YZUpGradeView.m
//  ez
//
//  Created by 毛文豪 on 2017/8/21.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZUpGradeView.h"

@interface YZUpGradeView ()<UIGestureRecognizerDelegate>

@property (nonatomic,weak) UIImageView * backView;
@property (nonatomic,strong) id json;

@end

@implementation YZUpGradeView

- (instancetype)initWithFrame:(CGRect)frame json:(id)json
{
    self = [super initWithFrame:frame];
    if (self) {
        self.json = json;
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    self.backgroundColor = YZColor(0, 0, 0, 0.4);
    
    if ([self.json[@"forceUpdate"] intValue] == 0) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidClick)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    
    CGFloat backViewW = 287;
    CGFloat backViewH = 300;
    UIImageView * backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backViewW, backViewH)];
    self.backView = backView;
    backView.center = self.center;
    backView.image = [UIImage imageNamed:@"up_grade_back"];
    backView.userInteractionEnabled = YES;
    [self addSubview:backView];
    
    if ([self.json[@"forceUpdate"] intValue] == 0) {
        //取消按钮
        CGFloat cancelButtonWH = 27;
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, cancelButtonWH, cancelButtonWH);
        cancelBtn.center = CGPointMake(CGRectGetMaxX(backView.frame) - 2, CGRectGetMinY(backView.frame) + 15);
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"up_grade_cancel"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
    }
    
    //标题
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = [NSString stringWithFormat:@"%@新版本更新内容", self.json[@"versionName"]];
    titleLabel.textColor = YZBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    CGSize titleLabelSize = [titleLabel.text sizeWithLabelFont:titleLabel.font];
    titleLabel.frame = CGRectMake(0, 95, backView.width, titleLabelSize.height);
    [backView addSubview:titleLabel];
    
    //内容
    UIScrollView * contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 10, backView.width, backView.height - CGRectGetMaxY(titleLabel.frame) - 10 - 37 - 20)];
    [backView addSubview:contentScrollView];
    
    UILabel * contentLabel = [[UILabel alloc]init];
    contentLabel.numberOfLines = 0;
    NSString * contentStr = [self.json[@"description"] stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    if (contentStr.length > 0) {
        NSMutableAttributedString * contentAttStr = [[NSMutableAttributedString alloc]initWithString:contentStr];
        [contentAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(0, contentAttStr.length)];
        [contentAttStr addAttribute:NSForegroundColorAttributeName value:YZDrayGrayTextColor range:NSMakeRange(0, contentAttStr.length)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3;
        [contentAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentAttStr.length)];
        contentLabel.attributedText = contentAttStr;
    }
    CGSize contentSize = [contentLabel.attributedText boundingRectWithSize:CGSizeMake(backView.width - YZMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    contentLabel.frame = CGRectMake(YZMargin, 0, contentSize.width, contentSize.height);
    [contentScrollView addSubview:contentLabel];
    contentScrollView.contentSize = CGSizeMake(contentScrollView.contentSize.width, CGRectGetMaxY(contentLabel.frame));
    
    //更新按钮
    CGFloat buttonW = 235;
    CGFloat buttonH = 40;
    CGFloat buttonX = (backView.width - buttonW) / 2;
    CGFloat buttonY = backView.height - buttonH - 13;
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"up_grade_confirm_btn_icon"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:confirmBtn];
}

- (void)tapDidClick
{
    [self removeFromSuperview];
}

- (void)confirmBtnClick
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.json[@"url"]]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint pos = [touch locationInView:self.backView.superview];
        if (CGRectContainsPoint(self.backView.frame, pos)) {
            return NO;
        }
    }
    return YES;
}

@end
