//
//  YZSetmealShowNumberViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/7/12.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZSetmealShowNumberViewController.h"
#import "YZWinNumberBallStatus.h"
#import "YZBallBtn.h"

@interface YZSetmealShowNumberViewController ()<YZBallBtnDelegate>

@property (nonatomic, weak) UIScrollView * scrollView;
@property (nonatomic, strong) NSMutableArray *ballsArray;
@property (nonatomic, strong) NSMutableArray *selRedBalls;
@property (nonatomic, strong) NSMutableArray *selBlueBalls;

@end

@implementation YZSetmealShowNumberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"选号(单式)";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清空选择" style:UIBarButtonItemStylePlain target:self action:@selector(clearSelBallsBarDidClick)];
    [self setupChilds];
}

- (void)clearSelBallsBarDidClick
{
    for (YZBallBtn *numberBtn in self.ballsArray) {
        [numberBtn ballChangeToWhite];
    }
}

#pragma mark - 创建视图
- (void)setupChilds
{
    //scrollView
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - navBarH - statusBarH)];
    self.scrollView = scrollView;
    scrollView.backgroundColor =YZBackgroundColor;
    [self.view addSubview:scrollView];
    
    //号码球
    UIView * numberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0)];
    numberView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:numberView];
    UIView * lastView = numberView;
    
    UILabel * numberTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, screenWidth - 30, 15)];
    numberTitleLabel.text = @"自选号码";
    numberTitleLabel.textColor = YZBlackTextColor;
    numberTitleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    numberTitleLabel.textAlignment = NSTextAlignmentLeft;
    [numberView addSubview:numberTitleLabel];
    
    int redCount = 0;
    int blueCount = 0;
    if ([self.gameId isEqualToString:@"F01"]) {
        redCount = 33;
        blueCount = 16;
    }else if ([self.gameId isEqualToString:@"T01"]) {
        redCount = 35;
        blueCount = 12;
    }
    
    NSMutableArray * selectedRedNumbers = [NSMutableArray array];
    NSMutableArray * selectedBlueNumbers = [NSMutableArray array];
    for (YZWinNumberBallStatus * ballStatus in self.numberArray) {
        if (ballStatus.type == 1) {
            [selectedRedNumbers addObject:ballStatus.number];
        }else if (ballStatus.type == 2)
        {
            [selectedBlueNumbers addObject:ballStatus.number];
        }
    }
    CGFloat numberBtnWH = 35;
    CGFloat numberBtnPadding = (screenWidth - 7 * numberBtnWH) / 8;//球与球的边距
    for(int i = 0; i < redCount + blueCount; i++)
    {
        YZBallBtn *numberBtn = [YZBallBtn button];
        numberBtn.delegate = self;
        int index = i;
        if (i < redCount) {
            numberBtn.selImageName = @"redBall_flat";
            numberBtn.ballTextColor = YZRedBallColor;
            [numberBtn setTitle:[NSString stringWithFormat:@"%02d", i + 1] forState:UIControlStateNormal];
            [numberBtn setTitleColor:numberBtn.ballTextColor forState:UIControlStateNormal];
            if ([selectedRedNumbers containsObject:numberBtn.currentTitle]) {
                [numberBtn ballChangeToRed];
            }
        }else
        {
            numberBtn.isBlue = YES;
            numberBtn.selImageName =  @"blueBall_flat";
            numberBtn.ballTextColor = YZBlueBallColor;
            [numberBtn setTitleColor:numberBtn.ballTextColor forState:UIControlStateNormal];
            [numberBtn setTitle:[NSString stringWithFormat:@"%02d", i + 1 - redCount] forState:UIControlStateNormal];
            if ([selectedBlueNumbers containsObject:numberBtn.currentTitle]) {
                [numberBtn ballChangeBlue];
            }
            if (redCount % 7 != 0) {
                index = i + (7 - redCount % 7);
            }
        }
        numberBtn.frame = CGRectMake(numberBtnPadding + (numberBtnPadding + numberBtnWH) * (index % 7), CGRectGetMaxY(numberTitleLabel.frame) + 10 + (numberBtnPadding + numberBtnWH) * (index / 7), numberBtnWH, numberBtnWH);
        [numberView addSubview:numberBtn];
        [self.ballsArray addObject:numberBtn];
        
        lastView = numberBtn;
    }
    numberView.height = CGRectGetMaxY(lastView.frame) + numberBtnPadding;
    lastView = numberView;
    
    //确定
    YZBottomButton * confirmButton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    confirmButton.y = CGRectGetMaxY(lastView.frame) + 40;
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:confirmButton];
    
    scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(confirmButton.frame) + 20);
}

- (void)ballDidClick:(YZBallBtn *)btn
{
    if (btn.isBlue) {
        if (btn.selected) {
            [self.selBlueBalls removeObject:btn];
        }else
        {
            [self.selBlueBalls addObject:btn];
        }
    }else
    {
        if (btn.selected) {
            [self.selRedBalls removeObject:btn];
        }else
        {
            [self.selRedBalls addObject:btn];
        }
    }
}

- (void)confirmButtonDidClick
{
    int redCount = 0;
    int blueCount = 0;
    NSMutableArray * numberBallStatus = [NSMutableArray array];
    for (YZBallBtn *numberBtn in self.ballsArray) {
        if (numberBtn.selected) {
            YZWinNumberBallStatus * ballStatus = [[YZWinNumberBallStatus alloc]init];
            if (numberBtn.isBlue) {
                ballStatus.type = 2;
                blueCount++;
            }else
            {
                ballStatus.type = 1;
                redCount++;
            }
            ballStatus.number = [NSString stringWithFormat:@"%@", numberBtn.currentTitle];
            [numberBallStatus addObject:ballStatus];
        }
    }
    
    if ([self.gameId isEqualToString:@"F01"]) {
        if (redCount != 6 || blueCount != 1) {
            [MBProgressHUD showError:@"请选择6个红球，1个蓝球"];
            return;
        }
    }
    if ([self.gameId isEqualToString:@"T01"]) {
        if (redCount != 5 || blueCount != 2) {
            [MBProgressHUD showError:@"请选择5个红球，2个蓝球"];
            return;
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(getNumberBallStatus:numberArray:)]) {
        [_delegate getNumberBallStatus:numberBallStatus numberArray:self.numberArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化
- (NSMutableArray *)ballsArray
{
    if(_ballsArray == nil)
    {
        _ballsArray = [NSMutableArray array];
    }
    return _ballsArray;
}
- (NSMutableArray *)selRedBalls
{
    if(_selRedBalls == nil)
    {
        _selRedBalls = [NSMutableArray array];
    }
    return _selRedBalls;
}
- (NSMutableArray *)selBlueBalls
{
    if(_selBlueBalls == nil)
    {
        _selBlueBalls = [NSMutableArray array];
    }
    return _selBlueBalls;
}

@end
