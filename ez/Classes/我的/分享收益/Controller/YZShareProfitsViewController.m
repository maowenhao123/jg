//
//  YZShareProfitsViewController.m
//  ez
//
//  Created by dahe on 2019/7/10.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UMSocialCore/UMSocialCore.h>
#import "YZShareProfitsViewController.h"
#import "YZShareIncomeViewController.h"
#import "YZInitiateUnionBuyViewController.h"
#import "YZUnionBuyViewController.h"
#import "YZOrderViewController.h"
#import "YZShareView.h"
#import "UIImageView+WebCache.h"
#import "WXApi.h"
#import "Masonry.h"

@interface YZShareProfitsViewController ()

@property (nonatomic,weak) UIScrollView * scrollView;
@property (nonatomic,weak) UILabel * ruleLabel;
@property (nonatomic,weak) UIImageView *codeImageView;
@property (nonatomic,strong) id json;

@end

@implementation YZShareProfitsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"分享赚钱";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChilds];
    [self getData];
}

#pragma mark - 请求数据
- (void)getData
{
    waitingView
    YZUser *user = [YZUserDefaultTool user];
    NSDictionary *dict = @{
                           @"userName":user.userName
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlShare(@"/getShareFriend") params:dict success:^(id json) {
        YZLog(@"%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            self.json = json;
            [self setDataWithJson:json];
        }else
        {
            ShowErrorView
        }
    }failure:^(NSError *error)
    {
         [MBProgressHUD hideHUDForView:self.view];
         YZLog(@"error = %@",error);
    }];
}

- (void)setDataWithJson:(NSDictionary *)json
{
    NSString *rule = json[@"rule"];
    rule = [rule stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n"];
    rule = [rule stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    rule = [rule substringToIndex:rule.length - 1];
    NSAttributedString * attStr = [self getAttributedStringWithBlackText:rule blueText:@"" alignment:NSTextAlignmentLeft];
    
    CGSize labelSize = [attStr boundingRectWithSize:CGSizeMake(screenWidth - YZMargin * 4, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    [self.ruleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(labelSize.height);
    }];
    
    self.ruleLabel.attributedText = attStr;
    
    [self.codeImageView sd_setImageWithURL:[NSURL URLWithString:json[@"qrCode"]]];
}

#pragma mark - 布局视图
- (void)setupChilds
{
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-YZMargin - 40 - [YZTool getSafeAreaBottom]);
    }];
    
    //分享规则
    UILabel * ruleLabel = [[UILabel alloc] init];
    self.ruleLabel = ruleLabel;
    ruleLabel.numberOfLines = 0;
    ruleLabel.layer.borderColor = YZGrayLineColor.CGColor;
    ruleLabel.layer.borderWidth = 1.5;
    ruleLabel.layer.masksToBounds = YES;
    ruleLabel.layer.cornerRadius = 4;
    [scrollView addSubview:ruleLabel];
    
    [ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).with.offset(YZMargin + 20);
        make.left.equalTo(scrollView).with.offset(YZMargin);
        make.width.mas_equalTo(screenWidth - 2 * YZMargin);
        make.height.mas_equalTo(100);
    }];
    
    [self getButtonByText:@"分享规则" action:nil width:150 topView:nil];
    
    //邀请方式1
    UIView * titleView1 = [self getTitleViewByText:@"邀请方式1" topView:ruleLabel];
    
    UILabel * hintLabel1 = [self getLabelWithAttStr:[self getAttributedStringWithBlackText:@"点击下方按钮邀请好友\n好友只能通过您发送的链接注册方可获得收益" blueText:@"" alignment:NSTextAlignmentCenter] topView:titleView1];
   
    UIButton * inviteButton = [self getButtonByText:@"邀请好友" action:@selector(share) width:150 topView:hintLabel1];
    
    //邀请方式2
    UIView * titleView2 = [self getTitleViewByText:@"邀请方式2" topView:inviteButton];
    
    UILabel * hintLabel2 = [self getLabelWithAttStr:[self getAttributedStringWithBlackText:@"好友面对面的情况下\n好友通过扫一扫 扫描下方二维码即可" blueText:@"" alignment:NSTextAlignmentCenter] topView:titleView2];
    
    //二维码
    CGFloat codeImageViewWH = 190;
    UIImageView *codeImageView = [[UIImageView alloc] init];
    self.codeImageView = codeImageView;
    [scrollView addSubview:codeImageView];
    
    [codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintLabel2.mas_bottom).with.offset(YZMargin);
        make.centerX.equalTo(scrollView);
        make.width.mas_equalTo(codeImageViewWH);
        make.height.mas_equalTo(codeImageViewWH);
    }];
    
    //邀请方式3
    UIView * titleView3 = [self getTitleViewByText:@"邀请方式3" topView:codeImageView];
    
    UILabel * hintLabel3 = [self getLabelWithAttStr:[self getAttributedStringWithBlackText:@"通过邀请好友参与合买跟单，如好友是新注册用户\n则您可享受该好友购买金额的分享收益" blueText:@"" alignment:NSTextAlignmentCenter] topView:titleView3];

    UILabel * hintLabel31 = [self getLabelWithAttStr:[self getAttributedStringWithBlackText:@"1、您可分享自己发起的合买" blueText:@"合买下单完成后您可点击【邀请好友跟单您也可查看自己的合买订单详情，点击下方【邀请好友跟单】" alignment:NSTextAlignmentLeft] topView:hintLabel3];
    
    [hintLabel31 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintLabel3.mas_bottom).with.offset(0);
    }];

    UILabel * hintLabel32 = [self getLabelWithAttStr:[self getAttributedStringWithBlackText:@"2、您还可转发别人发起的合买" blueText:@"打开别人的合买订单详情并点击右上角【合买分享】分享给好友" alignment:NSTextAlignmentLeft] topView:hintLabel31];

    [hintLabel32 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintLabel31.mas_bottom).with.offset(0);
    }];

    NSArray * buttonTitles = @[@"发起合买", @"去分享我的合买订单", @"去分享别人的合买订单"];
    UIView * lastView = hintLabel32;
    for (NSString * buttonTitle in buttonTitles) {
        UIButton * button = [self getButtonByText:buttonTitle action:@selector(skipButtonDidClick:) width:screenWidth * 0.6 topView:lastView];
        button.tag = [buttonTitles indexOfObject:buttonTitle];
        lastView = button;
    }
    
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scrollView).with.offset(-YZMargin);
    }];
    
    UIButton * myProfitsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myProfitsButton.backgroundColor = YZBaseColor;
    myProfitsButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [myProfitsButton setTitle:@"我的收益" forState:UIControlStateNormal];
    [myProfitsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [myProfitsButton addTarget:self action:@selector(goMyProfits) forControlEvents:UIControlEventTouchUpInside];
    myProfitsButton.layer.masksToBounds = YES;
    myProfitsButton.layer.cornerRadius = 3;
    [self.view addSubview:myProfitsButton];
    
    [myProfitsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(YZMargin);
        make.right.equalTo(self.view).with.offset(-YZMargin);
        make.bottom.equalTo(self.view).with.offset(-[YZTool getSafeAreaBottom]);
        make.height.mas_equalTo(40);
    }];
}

//按钮
- (UIButton *)getButtonByText:(NSString *)text action:(SEL)action width:(CGFloat)width topView:(UIView *)topView
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = YZBaseColor;
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 20;
    [self.scrollView addSubview:button];
    
    if (topView) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).with.offset(YZMargin);
            make.centerX.equalTo(self.scrollView);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(40);
        }];
    }else
    {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView).with.offset(20);
            make.centerX.equalTo(self.scrollView);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(40);
        }];
    }
    return button;
}

//标题视图
- (UIView *)getTitleViewByText:(NSString *)text topView:(UIView *)topView
{
    UIView *titleView = [[UIView alloc] init];
    [self.scrollView addSubview:titleView];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = text;
    titleLabel.textColor = YZBlackTextColor;
    titleLabel.font = [UIFont boldSystemFontOfSize:YZGetFontSize(32)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    
    CGSize titleLabelSize = [titleLabel.text sizeWithLabelFont:titleLabel.font];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView).with.offset(0);
        make.centerX.equalTo(self.scrollView.mas_centerX);
        make.width.mas_equalTo(titleLabelSize.width + 20);
        make.height.mas_equalTo(40);
    }];
    
    for (int i = 0; i < 2; i++) {
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = YZGrayLineColor;
        [titleView addSubview:line];
        
        if (i == 0) {
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(titleView.mas_left).with.offset(YZMargin);
                make.right.equalTo(titleLabel.mas_left).with.offset(-YZMargin);
                make.centerY.equalTo(titleLabel.mas_centerY);
                make.height.mas_equalTo(1);
            }];
        }else
        {
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(titleLabel.mas_right).with.offset(YZMargin);
                make.right.equalTo(titleView.mas_right).with.offset(-YZMargin);
                make.centerY.equalTo(titleLabel.mas_centerY);
                make.height.mas_equalTo(1);
            }];
        }
    }
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).with.offset(YZMargin);
        make.left.equalTo(self.scrollView).with.offset(0);
        make.width.mas_equalTo(screenWidth);
        make.height.mas_equalTo(40);
    }];
    
    return titleView;
}

//说明
- (UILabel *)getLabelWithAttStr:(NSAttributedString *)attStr topView:(UIView *)topView
{
    UILabel * label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    label.attributedText = attStr;
    label.numberOfLines = 0;
    [self.scrollView addSubview:label];
    
    CGSize labelSize = [label.attributedText boundingRectWithSize:CGSizeMake(screenWidth - 2 * YZMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).with.offset(YZMargin);
        make.left.equalTo(self.scrollView).with.offset(0);
        make.width.mas_equalTo(screenWidth);
        make.height.mas_equalTo(labelSize.height + 5);
    }];
    
    return label;
}

//富文本
- (NSMutableAttributedString *)getAttributedStringWithBlackText:(NSString *)blackText blueText:(NSString *)blueText alignment:(NSTextAlignment)alignment
{
    NSString * string = blackText;
    if (!YZStringIsEmpty(blueText)) {
        string = [NSString stringWithFormat:@"%@\n%@", blackText, blueText];
    }
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc]initWithString:string];
    [attString addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:[attString.string rangeOfString:blackText]];
    [attString addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:[attString.string rangeOfString:blueText]];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:NSMakeRange(0, attString.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment = alignment;
    paragraphStyle.firstLineHeadIndent = YZMargin;
    paragraphStyle.headIndent = YZMargin;
    paragraphStyle.tailIndent = -YZMargin;
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attString.length)];
    return attString;
}

#pragma mark - 跳转页面
- (void)skipButtonDidClick:(UIButton *)button
{
     if (button.tag == 0) {
        YZInitiateUnionBuyViewController *initiateUnionBuyVC = [[YZInitiateUnionBuyViewController alloc] init];
        [self.navigationController pushViewController:initiateUnionBuyVC animated:YES];
    }else if (button.tag == 1)
    {
        NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
        }];
        NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshRecordNote object:@(3)];
            });
        }];
        [op2 addDependency:op1];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue waitUntilAllOperationsAreFinished];
        [queue addOperation:op1];
        [queue addOperation:op2];
    }else if (button.tag == 2)
    {
        YZUnionBuyViewController *unionBuyVC = [[YZUnionBuyViewController alloc] init];
        [self.navigationController pushViewController:unionBuyVC animated:YES];
    }
}

- (void)goMyProfits
{
    YZShareIncomeViewController * incomeVC = [[YZShareIncomeViewController alloc] init];
    [self.navigationController pushViewController:incomeVC animated:YES];
}
#pragma mark - 分享
- (void)share
{
    YZShareView * shareView = [[YZShareView alloc]init];
    [shareView show];
    shareView.block = ^(UMSocialPlatformType platformType){//选择平台
        [self shareImageToPlatformType:platformType];
    };
}

//分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
#if JG
    UIImage *thumImage = [UIImage imageNamed:@"logo"];
#elif ZC
    UIImage *thumImage = [UIImage imageNamed:@"logo1"];
#elif CS
    UIImage *thumImage = [UIImage imageNamed:@"logo1"];
#elif RR
    UIImage *thumImage = [UIImage imageNamed:@"logo1"];
#endif
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.json[@"seoTitle"] descr:self.json[@"seoDesc"] thumImage:thumImage];
    shareObject.webpageUrl = self.json[@"url"];
    messageObject.shareObject = shareObject;
#if JG
    [WXApi registerApp:WXAppIdOld withDescription:@"九歌彩票"];
#elif ZC
    [WXApi registerApp:WXAppIdOld withDescription:@"中彩啦"];
#elif CS
    [WXApi registerApp:WXAppIdOld withDescription:@"财多多"];
#elif RR
    [WXApi registerApp:WXAppIdOld withDescription:@"人人彩"];
#endif
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSInteger errorCode = error.code;
            if (errorCode == 2003) {
                [MBProgressHUD showError:@"分享失败"];
            }else if (errorCode == 2008)
            {
                [MBProgressHUD showError:@"应用未安装"];
            }else if (errorCode == 2010)
            {
                [MBProgressHUD showError:@"网络异常"];
            }
        }
    }];
}

@end
