//
//  YZUnionChangeNickNameView.m
//  ez
//
//  Created by 毛文豪 on 2017/8/4.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZUnionChangeNickNameView.h"

@interface YZUnionChangeNickNameView ()<UIGestureRecognizerDelegate>

@property (nonatomic,weak) UIView * contentView;
@property (nonatomic,weak) UITextField * textField;

@end

@implementation YZUnionChangeNickNameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildViews];
    }
    return self;
}
- (void)setupChildViews
{
    self.backgroundColor = YZColor(0, 0, 0, 0.4);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidClick)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 2 * 37, 0)];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 3;
    [self addSubview:contentView];
    
    //标题
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentView.width, 40)];
    titleLabel.backgroundColor = YZBackgroundColor;
    titleLabel.text = @"设置昵称";
    titleLabel.textColor = YZBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLabel];
    
    //温馨提示
    UILabel * promptLabel = [[UILabel alloc]init];
    promptLabel.numberOfLines = 0;
    NSString * promptStr = @"您的用户名是您的手机号码，为了在发起合买时保护您的隐私，请立即设置昵称。";
    NSMutableAttributedString * promptAttStr = [[NSMutableAttributedString alloc]initWithString:promptStr];
    [promptAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(0, promptAttStr.length)];
    [promptAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, promptAttStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [promptAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, promptAttStr.length)];
    promptLabel.attributedText = promptAttStr;
    CGSize promptSize = [promptLabel.attributedText boundingRectWithSize:CGSizeMake(contentView.width - YZMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    promptLabel.frame = CGRectMake(YZMargin, CGRectGetMaxY(titleLabel.frame) + 10, promptSize.width, promptSize.height);
    [contentView addSubview:promptLabel];
    
    //输入框
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(YZMargin, CGRectGetMaxY(promptLabel.frame) + 13, contentView.width - 2 * YZMargin, 35)];
    self.textField = textField;
    textField.backgroundColor = YZColor(236, 236, 236, 1);
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    textField.textColor = YZBlackTextColor;
    textField.placeholder = @" 请输入昵称";
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 4;
    [contentView addSubview:textField];
    
    //底部按钮
    CGFloat buttonX = YZMargin;
    CGFloat buttonW = contentView.width - 2 * buttonX;
    CGFloat buttonH = 30;
    CGFloat buttonY = CGRectGetMaxY(textField.frame) + 13;
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    confirmBtn.backgroundColor = YZRedBallColor;
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"立即设置" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.layer.cornerRadius = 2;
    [contentView addSubview:confirmBtn];
    
    contentView.height = CGRectGetMaxY(confirmBtn.frame) + 13;
    contentView.center = self.center;
    
    contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
        contentView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)tapDidClick
{
    [self removeFromSuperview];
}

- (void)confirmBtnClick
{
    if (YZStringIsEmpty(self.textField.text)) {
        [MBProgressHUD showError:@"您还未输入昵称"];
        return;
    }
    
    [self removeFromSuperview];
    if([_delegate respondsToSelector:@selector(confirmBtnDidClick:)])
    {
        [_delegate confirmBtnDidClick:self.textField.text];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint pos = [touch locationInView:self.contentView.superview];
        if (CGRectContainsPoint(self.contentView.frame, pos)) {
            return NO;
        }
    }
    return YES;
}

@end

