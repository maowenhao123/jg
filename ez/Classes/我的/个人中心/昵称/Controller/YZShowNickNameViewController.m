//
//  YZShowNickNameViewController.m
//  ez
//
//  Created by 毛文豪 on 2017/8/21.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZShowNickNameViewController.h"
#import "YZNicknameViewController.h"

@interface YZShowNickNameViewController ()

@property (nonatomic,weak) UILabel * desLabel;

@end

@implementation YZShowNickNameViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    YZUser *user = [YZUserDefaultTool user];
    self.desLabel.text = user.nickName;
    CGSize desLabelSize = [self.desLabel.text sizeWithLabelFont:self.desLabel.font];
    self.desLabel.frame = CGRectMake(screenWidth - desLabelSize.width - YZMargin, 0,desLabelSize.width, YZCellH);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"用户昵称";
    [self setupChilds];
}

- (void)setupChilds
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 9, screenWidth, YZCellH)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    titleLabel.textColor = YZBlackTextColor;
    titleLabel.text = @"昵称";
    CGSize size = [titleLabel.text sizeWithLabelFont:titleLabel.font];
    titleLabel.frame = CGRectMake(YZMargin, 0, size.width, YZCellH);
    [view addSubview:titleLabel];
    
    UILabel * desLabel = [[UILabel alloc]init];
    self.desLabel = desLabel;
    desLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    desLabel.textColor = YZGrayTextColor;
    YZUser *user = [YZUserDefaultTool user];
    desLabel.text = user.nickName;
    CGSize desLabelSize = [desLabel.text sizeWithLabelFont:desLabel.font];
    desLabel.frame = CGRectMake(screenWidth - desLabelSize.width - YZMargin, 0,desLabelSize.width, YZCellH);
    [view addSubview:desLabel];

    //温馨提示
    UILabel * footerLabel = [[UILabel alloc]init];
    footerLabel.numberOfLines = 0;
    NSString * footerStr =  @"*发起或参与合买时会显示用户昵称";
    NSMutableAttributedString * footerAttStr = [[NSMutableAttributedString alloc]initWithString:footerStr];
    [footerAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(22)] range:NSMakeRange(0, footerAttStr.length)];
    [footerAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, footerAttStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [footerAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, footerAttStr.length)];
    footerLabel.attributedText = footerAttStr;
    CGSize footerLabelSize = [footerLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - YZMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    footerLabel.frame = CGRectMake(YZMargin, CGRectGetMaxY(view.frame) + 10, screenWidth - YZMargin * 2, footerLabelSize.height);
    [self.view addSubview:footerLabel];
    
    //修改按钮
    YZBottomButton * changeBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    changeBtn.y = CGRectGetMaxY(footerLabel.frame) + 30;
    [changeBtn setTitle:@"修改" forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(changeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
}

- (void)changeButtonClick
{
    YZNicknameViewController * nicknameVC = [[YZNicknameViewController alloc]init];
    nicknameVC.isChange = YES;
    [self.navigationController pushViewController:nicknameVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
