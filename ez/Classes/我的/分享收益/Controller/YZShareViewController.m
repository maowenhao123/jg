//
//  YZShareViewController.m
//  ez
//
//  Created by 毛文豪 on 2017/5/16.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UMSocialCore/UMSocialCore.h>
#import "YZShareViewController.h"
#import "YZShareIncomeViewController.h"
#import "YZShareView.h"
#import "UIImageView+WebCache.h"
#import "WXApi.h"

@interface YZShareViewController ()

@property (nonatomic,weak) UIScrollView * scrollView;
@property (nonatomic,weak) UIImageView *codeImageView;
@property (nonatomic,weak) UIView * line;
@property (nonatomic,weak) UILabel * reminderLabel;
@property (nonatomic,weak) UIButton *shareButton;
@property (nonatomic,weak) UIButton *incomeButton;
@property (nonatomic,strong) id json;

@end

@implementation YZShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"分享赚钱";
    self.view.backgroundColor = YZBackgroundColor;
    [self setupChilds];
    [self getData];
}

- (void)getData {
    [MBProgressHUD showMessage:@"客官请稍后" toView:self.view];
    YZUser *user = [YZUserDefaultTool user];
    NSDictionary *dict = @{
                           @"userName":user.userName
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlShare(@"/getShareFriend") params:dict success:^(id json) {
        YZLog(@"%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            self.scrollView.hidden = NO;
            self.json = json;
        }else{
            self.scrollView.hidden = YES;
        }
    }failure:^(NSError *error)
    {
        [MBProgressHUD hideHUDForView:self.view];
        self.scrollView.hidden = YES;
         YZLog(@"error = %@",error);
    }];
}
- (void)setupChilds
{
    self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithIcon:@"back_btn_flat" highIcon:@"back_btn_flat" target:self action:@selector(back)];
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH)];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    //二维码
    CGFloat codeImageViewWH = 190;
    CGFloat codeImageViewX = (screenWidth - codeImageViewWH) / 2;
    UIImageView *codeImageView = [[UIImageView alloc] init];
    self.codeImageView = codeImageView;
    codeImageView.frame = CGRectMake(codeImageViewX, 20, codeImageViewWH, codeImageViewWH);
    [scrollView addSubview:codeImageView];
    
    //分享二维码
    UILabel * shareCodeLabel = [[UILabel alloc] init];
    shareCodeLabel.text = @"分享二维码";
    shareCodeLabel.textColor = YZGrayTextColor;
    shareCodeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    CGSize shareCodeLabelSize = [shareCodeLabel.text sizeWithLabelFont:shareCodeLabel.font];
    shareCodeLabel.frame = CGRectMake((screenWidth - shareCodeLabelSize.width) / 2, CGRectGetMaxY(codeImageView.frame) + 7, shareCodeLabelSize.width, shareCodeLabelSize.height);
    [scrollView addSubview:shareCodeLabel];
    
    //分割线
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(shareCodeLabel.frame) + YZMargin, screenWidth, 1)];
    self.line = line;
    line.backgroundColor = YZWhiteLineColor;
    [scrollView addSubview:line];
    
    //温馨提示
    UILabel * reminderLabel = [[UILabel alloc] init];
    self.reminderLabel = reminderLabel;
    reminderLabel.numberOfLines = 0;
    [scrollView addSubview:reminderLabel];
    
    //按钮
    for (int i = 0; i < 2; i++) {
        YZBottomButton * button = [YZBottomButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        if (i == 0) {
            self.shareButton = button;
            [button setTitle:@"邀请好友" forState:UIControlStateNormal];
        }else
        {
            self.incomeButton = button;
            [button setTitle:@"我的收益" forState:UIControlStateNormal];
            [button setTitleColor:YZBaseColor forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];//正常
            [button setBackgroundImage:[UIImage ImageFromColor:YZColor(216, 216, 216, 1)] forState:UIControlStateHighlighted];//高亮
            button.layer.borderColor = YZBaseColor.CGColor;
            button.layer.borderWidth = 1;
        }
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        
        if (i == 1) {
            scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(button.frame) + 10);
        }
    }
}
- (void)back
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)setJson:(id)json
{
    _json = json;
    
    [self.codeImageView sd_setImageWithURL:[NSURL URLWithString:_json[@"qrCode"]]];
    NSString *reminderStr = [NSString stringWithFormat:@"分享规则\n%@",_json[@"content"]];
    reminderStr = [reminderStr stringByReplacingOccurrencesOfString:@"@" withString:@"\n"];
    NSMutableAttributedString * reminderAttStr = [[NSMutableAttributedString alloc]initWithString:reminderStr];
    [reminderAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(22)] range:NSMakeRange(0, reminderAttStr.length)];
    [reminderAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, reminderAttStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [reminderAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, reminderAttStr.length)];
    self.reminderLabel.attributedText = reminderAttStr;
    CGSize size = [self.reminderLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - YZMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.reminderLabel.frame = CGRectMake(YZMargin, CGRectGetMaxY(self.line.frame) + 7,  screenWidth - YZMargin * 2, size.height);
    
    self.shareButton.y = CGRectGetMaxY(self.reminderLabel.frame) + 20;
    self.incomeButton.y = CGRectGetMaxY(self.shareButton.frame) + 20;
    self.scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(self.incomeButton.frame) + 10);
}

- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 0) {
        [self share];
    }else if (button.tag == 1)
    {
        YZShareIncomeViewController * incomeVC = [[YZShareIncomeViewController alloc] init];
        [self.navigationController pushViewController:incomeVC animated:YES];
    }
}

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
