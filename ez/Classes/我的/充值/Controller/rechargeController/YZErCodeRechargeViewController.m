//
//  YZErCodeRechargeViewController.m
//  ez
//
//  Created by dahe on 2019/11/11.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZErCodeRechargeViewController.h"
#import "YZErCodeRechargeSuccessView.h"

@interface YZErCodeRechargeViewController ()

@end

@implementation YZErCodeRechargeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.clientId isEqualToString:@"alipay_img_qr"]) {
        self.title = @"支付宝充值";
    }else if ([self.clientId isEqualToString:@"jiuge_lftpay_weixin_qr"])
    {
        self.title = @"微信充值";
    }

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n1、充值免手续费，充值金额不可提现\n2、如充值未到账，请及时联系客服"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
    self.tishiLabel.attributedText = attStr;
    CGSize tishiSize = [attStr boundingRectWithSize:CGSizeMake(screenWidth-2 * YZMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.tishiLabel.height = tishiSize.height;//改变提示label的高度
    self.rechargeExplainBtn.y = CGRectGetMaxY(self.tishiLabel.frame) + 10;
}

//父类方法
- (void)rechargeBtnClick
{
    NSNumber *amount = [NSNumber numberWithFloat:[self.amountTextTield.text floatValue] * 100];
    
    waitingView;
    NSString * payInfoJson = [@{@"clientType":@(1)} JSONRepresentation];
    NSDictionary *dict = @{
                           @"cmd":@(8041),
                           @"userId":UserId,
                           @"amount":amount,
                           @"payType":self.paymentId,
                           @"payInfo":payInfoJson
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"json = %@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            //保存二维码
            NSDictionary * payResultDic = [self dictionaryWithJsonString:json[@"payResult"]];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:payResultDic[@"codeImgUrl"]]];
            UIImage *image = [UIImage imageWithData:data]; // 取得图片
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"rechargeBtnClick请求error");
    }];
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error)
    {
        [MBProgressHUD showError:@"保存失败"];
        return;
    }
    
    YZErCodeRechargeSuccessView * erCodeRechargeSuccessView = [[YZErCodeRechargeSuccessView alloc] initWithFrame:self.view.bounds clientId:self.clientId];
    erCodeRechargeSuccessView.ower = self;
    [self.view addSubview:erCodeRechargeSuccessView];
}

#pragma mark -- json转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) return nil;
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
