//
//  YZKy481DanView.m
//  ez
//
//  Created by dahe on 2019/11/5.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481DanView.h"
#import "YZBallBtn.h"

@interface YZKy481DanView ()<YZBallBtnDelegate>

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *ballButtons;
@property (nonatomic, strong) NSMutableArray *danBallButtons;

@end

@implementation YZKy481DanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZBackgroundColor;
        [self setupSonChilds];
    }
    return self;
}

#pragma mark - 布局子视图
- (void)setupSonChilds
{
    //标题文字
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YZMargin, 10, screenWidth - 2 * YZMargin, 20)];
    self.titleLabel = titleLabel;
    titleLabel.textColor = YZBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [self addSubview:titleLabel];
    
    //选号
    UILabel *xuanTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YZMargin, CGRectGetMaxY(titleLabel.frame) + 10, 50, 30)];
    xuanTitleLabel.text = @"选号";
    xuanTitleLabel.textColor = YZBlackTextColor;
    xuanTitleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [self addSubview:xuanTitleLabel];
    
    CGFloat ballWH = 35;
    CGFloat ballPadding = (screenWidth - 2 * YZMargin - 8 * ballWH) / 7;
    CGFloat danBallWH = 30;
    CGFloat danBallPadding = (screenWidth - 2 * YZMargin - 8 * danBallWH) / 7;
    for (int i = 1; i < 9; i++) {
        YZBallBtn *btn = [YZBallBtn button];
        btn.frame = CGRectMake(YZMargin + (ballWH + ballPadding) * (i - 1), CGRectGetMaxY(xuanTitleLabel.frame) + 10, ballWH, ballWH);
        btn.tag = 10 + i;
        btn.owner = self;
        btn.delegate = self;
        [btn setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        NSString *image = @"redBall_flat";
        btn.selImageName = image;
        btn.ballTextColor = YZRedBallColor;
        [btn setTitleColor:btn.ballTextColor forState:UIControlStateNormal];
        [self addSubview:btn];
        [self.ballButtons addObject:btn];
        
        UIButton * ballButton = [UIButton buttonWithType:UIButtonTypeCustom];
        ballButton.tag = i;
        ballButton.frame = CGRectMake(YZMargin + (danBallWH + danBallPadding) * (i - 1), CGRectGetMaxY(btn.frame) + 15, danBallWH, danBallWH);
        ballButton.centerX = btn.centerX;
        [ballButton setTitle:@"胆" forState:UIControlStateNormal];
        [ballButton setTitleColor:YZDrayGrayTextColor forState:UIControlStateNormal];
        [ballButton setTitleColor:YZDrayGrayTextColor forState:UIControlStateHighlighted];
        [ballButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [ballButton setBackgroundImage:[UIImage ImageFromColor:YZBackgroundColor] forState:UIControlStateNormal];
        [ballButton setBackgroundImage:[UIImage ImageFromColor:YZBackgroundColor] forState:UIControlStateHighlighted];
        [ballButton setBackgroundImage:[UIImage ImageFromColor:RGBACOLOR(248, 148, 75, 1)] forState:UIControlStateSelected];
        ballButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(34)];
        ballButton.layer.masksToBounds = YES;
        ballButton.layer.cornerRadius = danBallWH / 2;
        ballButton.layer.borderWidth = 1;
        ballButton.layer.borderColor = YZGrayTextColor.CGColor;
        [ballButton addTarget:self action:@selector(danBallButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ballButton];
        
        [self.danBallButtons addObject:ballButton];
    }
}

- (void)ballDidClick:(YZBallBtn *)button
{
    YZBallBtn * otherButton = [self viewWithTag:button.tag - 10];
    if (button.selected && otherButton.selected) {
        otherButton.selected = NO;
        otherButton.layer.borderWidth = 1;
    }
}

- (void)danBallButtonDidClick:(UIButton *)button
{
    YZBallBtn * otherButton = [self viewWithTag:button.tag + 10];
    if (!otherButton.selected) {
        return;
    }
    
    BOOL haveSelected = NO;
    for (UIButton * danButton in self.danBallButtons) {
        if (danButton.selected && danButton != button) {
            haveSelected = YES;
            break;
        }
    }
    if (haveSelected) {
        [MBProgressHUD showError:@"最多能选择1个胆"];
        return;
    }
    
    if (button.selected) {
        button.layer.borderWidth = 1;
    }else
    {
        button.layer.borderWidth = 0;
    }
    button.selected = !button.selected;
}


- (void)setStatus:(YZSelectBallCellStatus *)status
{
    _status = status;
    
    self.titleLabel.attributedText = _status.title;
}

#pragma mark - 初始化
- (NSMutableArray *)ballButtons
{
    if (_ballButtons == nil) {
        _ballButtons = [NSMutableArray array];
    }
    return _ballButtons;
}

- (NSMutableArray *)danBallButtons
{
    if (_danBallButtons == nil) {
        _danBallButtons = [NSMutableArray array];
    }
    return _danBallButtons;
}


@end
