//
//  YZBetSuccessViewController.m
//  ez
//
//  Created by apple on 14-9-19.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZBetSuccessViewController.h"
#import "YZPublishUnionBuyCircleViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZTabBarViewController.h"
#import "UIButton+YZ.h"
#import "YZQrCodeModel.h"
#import "YZActivityModel.h"
#import "YZDateTool.h"
#import "YZShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"

@interface YZBetSuccessViewController ()

@property (nonatomic,weak) UIScrollView * scrollView;
@property (nonatomic, weak) UIButton * lookBtn;
@property (nonatomic,weak) UIImageView *codeImageView;
@property (nonatomic,weak) UILabel * promptLabel;
@property (nonatomic,weak) UIButton * vipcnButton;
@property (nonatomic,strong) YZQrCodeModel *QrCodeModel;
@property (nonatomic,strong) NSArray * activityArray;

@end

@implementation YZBetSuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"下单成功";
    self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithIcon:@"back_btn_flat" highIcon:@"back_btn_flat" target:self action:@selector(back)];
    [self getActivityData];
    [self setupChilds];
}

#pragma mark - 请求数据
- (void)getActivityData
{
    NSDictionary *dict = @{
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlSalesManager(@"/getQuickStakeInformation") params:dict success:^(id json) {
        YZLog(@"getQuickStakeInformation:%@",json);
        if (SUCCESS) {
            self.activityArray = [YZActivityModel objectArrayWithKeyValuesArray:json[@"quickStakeInformations"]];
            [self setActivityData];
            [self getQrCodeData];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error)
     {
         YZLog(@"error = %@",error);
     }];
}

- (void)setActivityData
{
    CGFloat lastViewY = CGRectGetMaxY(self.lookBtn.frame) + 20;
    for (int i = 0; i < self.activityArray.count; i++) {
        YZActivityModel *activityModel = self.activityArray[i];
        
        UIImageView *activityImageView = [[UIImageView alloc] init];
        activityImageView.frame = CGRectMake(self.codeImageView.x, lastViewY, self.codeImageView.width, self.codeImageView.height);
        [self.scrollView addSubview:activityImageView];
        
        [activityImageView sd_setImageWithURL:[NSURL URLWithString:activityModel.picAddr]];
    }
}

- (void)getQrCodeData
{
    NSDictionary *dict = @{
                           @"type":@"CUSTOMER_SERVICE",
                           @"timestamp":[YZDateTool getNowTimeTimestamp]
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlShare(@"/getQrCode") params:dict success:^(id json) {
        YZLog(@"getQrCode:%@",json);
        if (SUCCESS) {
            self.QrCodeModel = [YZQrCodeModel objectWithKeyValues:json[@"qrCode"]];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
    }];
}

- (void)setQrCodeModel:(YZQrCodeModel *)QrCodeModel
{
    _QrCodeModel = QrCodeModel;
    
    self.codeImageView.y = CGRectGetMaxY(self.lookBtn.frame) + 20 + (self.codeImageView.height + 20) * self.activityArray.count;
    
    [self.codeImageView sd_setImageWithURL:[NSURL URLWithString:_QrCodeModel.url]];
    
    NSString * promptStr = _QrCodeModel.desc;
    if (YZStringIsEmpty(promptStr)) {
        self.vipcnButton.y = CGRectGetMaxY(self.codeImageView.frame) + 10;
    }else
    {
        NSMutableAttributedString * promptAttStr = [[NSMutableAttributedString alloc]initWithString:promptStr];
        [promptAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(0, promptAttStr.length)];
        [promptAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, promptAttStr.length)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [promptAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, promptAttStr.length)];
        self.promptLabel.attributedText = promptAttStr;
        CGSize promptSize = [self.promptLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - YZMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.promptLabel.frame = CGRectMake(YZMargin,  CGRectGetMaxY(self.codeImageView.frame) + 10, screenWidth - YZMargin * 2, promptSize.height);
        
        self.vipcnButton.y = CGRectGetMaxY(self.promptLabel.frame) + 10;
    }
    
    self.scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(self.vipcnButton.frame) + 10);
}

#pragma mark - 布局视图
- (void)setupChilds
{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH)];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"success_icon"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:YZGetFontSize(35)]];
    [button setTitle:@"下单成功，正在出票" forState:UIControlStateNormal];
    [button setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    button.frame = CGRectMake(0, screenHeight * 0.15, screenWidth, 30);
    [button setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:10];
    button.userInteractionEnabled = NO;
    [scrollView addSubview:button];
    
    UILabel * detailLabel = [[UILabel alloc] init];
    detailLabel.numberOfLines = 2;
    NSMutableAttributedString * detailAttStr = [[NSMutableAttributedString alloc]initWithString:@"出票状态显示为“出票成功”方为购买成功，请留意该订单的出票状态，祝您中奖！"];
    [detailAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(0, detailAttStr.length)];
    [detailAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(150, 150, 150, 1) range:NSMakeRange(0, detailAttStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [detailAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, detailAttStr.length)];
    detailLabel.attributedText = detailAttStr;
    CGFloat detailLabelX = 20;
    CGFloat detailLabelW = screenWidth - 2 * detailLabelX;
    CGSize detailLabelSize = [detailLabel.attributedText boundingRectWithSize:CGSizeMake(detailLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    detailLabel.frame = CGRectMake(detailLabelX, CGRectGetMaxY(button.frame) + 10, detailLabelW, detailLabelSize.height);
    [scrollView addSubview:detailLabel];
    
    UIView * lastView = detailLabel;
    
    if (self.payVcType == BetTypeStartUnionBuyBet || self.payVcType == BetTypeParticipateUnionBuyBet) {
        //合买分享
        YZBottomButton * shareButton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
        shareButton.y = CGRectGetMaxY(detailLabel.frame) + 50;
        shareButton.height = 55;
        NSMutableAttributedString * shareAttStr = [[NSMutableAttributedString alloc] initWithString:@"邀请好友来跟单\n（邀请用户跟单还可以分享收益）"];
        [shareAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, shareAttStr.length)];
        [shareAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(30)] range:NSMakeRange(0, 7)];
        [shareAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(7, shareAttStr.length - 7)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [shareAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, shareAttStr.length)];
        [shareButton setAttributedTitle:shareAttStr forState:UIControlStateNormal];
        shareButton.titleLabel.numberOfLines = 0;
        [shareButton addTarget:self action:@selector(shareButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:shareButton];
        
        //合买晒单
        YZBottomButton * publishCircleBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
        publishCircleBtn.y = CGRectGetMaxY(shareButton.frame) + 20;
        [publishCircleBtn setTitle:@"合买晒单" forState:UIControlStateNormal];
        [publishCircleBtn addTarget:self action:@selector(publishCircleBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:publishCircleBtn];
        
        lastView = publishCircleBtn;
    }
    
    //继续投注
    YZBottomButton * againBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    againBtn.y = CGRectGetMaxY(lastView.frame) + 20;
    [againBtn setTitle:@"继续投注" forState:UIControlStateNormal];
    [againBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:againBtn];
    
    //查看投注记录
    YZBottomButton * lookBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.lookBtn = lookBtn;
    lookBtn.y = CGRectGetMaxY(againBtn.frame) + 20;
    [lookBtn setTitle:@"查看投注记录" forState:UIControlStateNormal];
    [lookBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    [lookBtn setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:lookBtn.bounds] forState:UIControlStateNormal];
    [lookBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(216, 216, 216, 1) WithRect:lookBtn.bounds] forState:UIControlStateHighlighted];
    lookBtn.layer.borderWidth = 1;
    lookBtn.layer.borderColor = YZColor(213, 213, 213, 1).CGColor;
    [lookBtn addTarget:self action:@selector(lookBetRecord) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:lookBtn];
    
    //二维码
    CGFloat imageViewWH = 190;
    CGFloat imageViewX = (screenWidth - imageViewWH) / 2;
    UIImageView *codeImageView = [[UIImageView alloc] init];
    self.codeImageView = codeImageView;
    codeImageView.frame = CGRectMake(imageViewX, CGRectGetMaxY(codeImageView.frame) + 20, imageViewWH, imageViewWH);
    [scrollView addSubview:codeImageView];
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    codeImageView.userInteractionEnabled = YES;
    [codeImageView addGestureRecognizer:longPress];
    
    UILabel * promptLabel = [[UILabel alloc] init];
    self.promptLabel = promptLabel;
    promptLabel.numberOfLines = 0;
    [scrollView addSubview:promptLabel];
    
    UIButton * vipcnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.vipcnButton = vipcnButton;
    vipcnButton.frame = CGRectMake((screenWidth - 80) / 2, CGRectGetMaxY(lookBtn.frame) + 10, 80, 30);
    [vipcnButton setTitle:@"复制公共号" forState:UIControlStateNormal];
    [vipcnButton setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    vipcnButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    vipcnButton.layer.masksToBounds = YES;
    vipcnButton.layer.cornerRadius = 3;
    vipcnButton.layer.borderWidth = 1;
    vipcnButton.layer.borderColor = YZGrayTextColor.CGColor;
    [vipcnButton addTarget:self action:@selector(vipcnButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:vipcnButton];
    
    scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(vipcnButton.frame) + 10);
}

- (void)publishCircleBtnDidClick
{
    YZPublishUnionBuyCircleViewController * publishCircleVC = [[YZPublishUnionBuyCircleViewController alloc] init];
    publishCircleVC.unionbuyModel = self.unionbuyModel;
    [self.navigationController pushViewController:publishCircleVC animated:YES];
}

- (void)back
{
    if (self.isDismissVC) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)longPress
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"保存图片？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self saveImage];
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)saveImage
{
    UIImage *image = self.codeImageView.image; // 取得图片
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [MBProgressHUD showSuccess:@"保存成功"];
        [self performSelector:@selector(guideWeChat) withObject:self afterDelay:1.0f];
    }else
    {
        [MBProgressHUD showError:@"保存图片失败"];
    }
}

- (void)guideWeChat
{
    YZLoadHtmlFileController * updataActivityVC = [[YZLoadHtmlFileController alloc] initWithWeb:[NSString stringWithFormat:@"%@%@", baseH5Url, @"/zhongcai/html/wx-saoma.html"]];
    [self.navigationController pushViewController:updataActivityVC animated:YES];
}

- (void)vipcnButtonDidClick
{
    if (YZStringIsEmpty(self.QrCodeModel.weixin)) {
        return;
    }
    
    //复制账号
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    NSString *string = self.QrCodeModel.weixin;
    [pab setString:string];
    [MBProgressHUD showSuccess:@"复制成功"];
    [self performSelector:@selector(skipWeixin) withObject:self afterDelay:1.0f];
}

- (void)skipWeixin
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
}

#pragma mark - 查看投注记录按钮
- (void)lookBetRecord
{
    if (self.payVcType == BetTypeStartUnionBuyBet || self.payVcType == BetTypeParticipateUnionBuyBet) {
        [self toAccountWithRecordIndex:AccountRecordTypeMyUnionBuy];
    }else if (self.termCount > 1) {//追号
        [self toAccountWithRecordIndex:AccountRecordTypeMyScheme];
    }else
    {
        [self toAccountWithRecordIndex:AccountRecordTypeMyBet];
    }
}
- (void)toAccountWithRecordIndex:(AccountRecordType)accountRecordType
{
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        });
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshRecordNote object:@(accountRecordType)];
        });
    }];
    [op2 addDependency:op1];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue waitUntilAllOperationsAreFinished];
    [queue addOperation:op1];
    [queue addOperation:op2];
}

#pragma mark - 分享
- (void)shareButtonDidClick
{
    YZShareView * shareView = [[YZShareView alloc]init];
    [shareView show];
    shareView.block = ^(UMSocialPlatformType platformType){//选择平台
        [self shareToPlatformType:platformType];
    };
}

- (void)shareToPlatformType:(UMSocialPlatformType)platformType
{
    NSString * title = self.unionbuyModel.title ? self.unionbuyModel.title : @"无";
    NSString * descr = self.unionbuyModel.desc ? self.unionbuyModel.desc : @"无";
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
#if JG
    UIImage * image = [UIImage imageNamed:@"logo"];
#elif ZC
    UIImage * image = [UIImage imageNamed:@"logo1"];
#elif CS
    UIImage * image = [UIImage imageNamed:@"logo1"];
#endif
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:image];
    YZUser *user = [YZUserDefaultTool user];
    NSString * nickName = user.nickName;
        shareObject.webpageUrl = [NSString stringWithFormat:@"%@/unionbuydetail?unionBuyPlanId=%@&userName=%@", shareBaseUrl, self.unionbuyModel.unionBuyPlanId, nickName];
    messageObject.shareObject = shareObject;//调用分享接口
#if JG
    [WXApi registerApp:WXAppIdOld withDescription:@"九歌彩票"];
#elif ZC
    [WXApi registerApp:WXAppIdOld withDescription:@"中彩啦"];
#elif CS
    [WXApi registerApp:WXAppIdOld withDescription:@"财多多"];
#endif
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
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
#pragma mark - 初始化
- (NSArray *)activityArray
{
    if (_activityArray == nil) {
        _activityArray = [NSArray array];
    }
    return _activityArray;
}

@end
