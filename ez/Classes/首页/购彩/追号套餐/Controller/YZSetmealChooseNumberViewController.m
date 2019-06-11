//
//  YZSetmealChooseNumberViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/7/12.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZSetmealChooseNumberViewController.h"
#import "YZChooseNumberView.h"

@interface YZSetmealChooseNumberViewController ()

@property (nonatomic, weak) UIScrollView * scrollView;
@property (nonatomic, weak) YZChooseNumberView *chooseNumberView;
@property (nonatomic, weak) UIButton * confirmButton;

@end

@implementation YZSetmealChooseNumberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(253, 239, 226, 1);
    if (self.chooseNumberType == ChooseNumberByBirthday) {
        self.title = @"生日选号";
    }else if (self.chooseNumberType == ChooseNumberByPhone)
    {
        self.title = @"电话选号";
    }else if (self.chooseNumberType == ChooseNumberByLuckyNumber)
    {
        self.title = @"幸运数字选号";
    }
    [self setupChilds];
    [self.chooseNumberView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    self.chooseNumberView.bgImageView.frame = self.chooseNumberView.bounds;
    self.confirmButton.y = CGRectGetMaxY(self.chooseNumberView.frame) + 30;
    self.scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(self.confirmButton.frame) + 20);
}

#pragma mark - 创建视图
- (void)setupChilds
{
    //scrollView
    CGFloat bottomImageViewH = 75;
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - navBarH - statusBarH - bottomImageViewH)];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    //选择号码
    YZChooseNumberView *chooseNumberView = [[YZChooseNumberView alloc] initWithFrame:CGRectMake(10, 15, screenWidth - 20, 0) chooseNumberType:self.chooseNumberType];
    self.chooseNumberView = chooseNumberView;
    chooseNumberView.gameId = self.gameId;
    [scrollView addSubview:self.chooseNumberView];
    
    //确定
    YZBottomButton * confirmButton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton = confirmButton;
    confirmButton.y = CGRectGetMaxY(self.chooseNumberView.frame) + 30;
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:confirmButton];
    
    scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(confirmButton.frame) + 20);
    
    //底部图片
    CGFloat bottomImageViewW = screenWidth / 375 * 360;
    UIImageView * bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth - bottomImageViewW) / 2, screenHeight - statusBarH - navBarH - 75, bottomImageViewW, bottomImageViewH)];
    if (self.chooseNumberType == ChooseNumberByBirthday) {
        bottomImageView.image = [UIImage imageNamed:@"choose_number_birthday_bottom"];
    }else if (self.chooseNumberType == ChooseNumberByPhone)
    {
        bottomImageView.image = [UIImage imageNamed:@"choose_number_phone_bottom"];
    }else if (self.chooseNumberType == ChooseNumberByLuckyNumber)
    {
        bottomImageView.image = [UIImage imageNamed:@"choose_number_number_bottom"];
    }
    [self.view addSubview:bottomImageView];
}

- (void)confirmButtonDidClick
{
    if (YZArrayIsEmpty(self.chooseNumberView.numberBallStatus)) {
        [MBProgressHUD showError:@"请生成投注号码"];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(getNumberBallStatus:)]) {
        [_delegate getNumberBallStatus:self.chooseNumberView.numberBallStatus];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - dealloc
- (void)dealloc
{
    [self.chooseNumberView removeObserver:self forKeyPath:@"frame"];
}

@end
