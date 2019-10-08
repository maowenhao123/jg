//
//  YZHtmlRechargeViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/1/29.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZHtmlRechargeViewController.h"
#import "YZLoadHtmlFileController.h"

@implementation YZHtmlRechargeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!YZStringIsEmpty(self.intro))
    {
        NSDictionary *optoins = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
        NSData *data = [self.intro dataUsingEncoding:NSUnicodeStringEncoding];
        NSError * error;
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:data options:optoins documentAttributes:nil error:&error];
        if (!error) {
            self.tishiLabel.attributedText = attributeString;
        }
    }else
    {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n1、充值免手续费，充值金额不可提现\n2、交易限额由发卡银行统一设定，若超出限额请更换银行卡\n3、如充值未到账，请及时联系客服"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
        self.tishiLabel.attributedText = attStr;
    }
    CGSize tishiSize = [self.tishiLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - 2 * YZMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.tishiLabel.height = tishiSize.height;//改变提示label的高度
    
    self.rechargeExplainBtn.y = CGRectGetMaxY(self.tishiLabel.frame) + 10;
}

//父类方法
- (void)rechargeBtnClick
{
    NSNumber *amount = [NSNumber numberWithFloat:[self.amountTextTield.text floatValue] * 100];
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
        if (SUCCESS) {
            if (self.goBrowser) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:json[@"payResult"]]];
            }else
            {
                YZLoadHtmlFileController * payVC = [[YZLoadHtmlFileController alloc] initWithWeb:json[@"payResult"]];
                payVC.title = self.title;
                [self.navigationController pushViewController:payVC animated:YES];
            }
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"rechargeBtnClick请求error");
    }];
}

@end
