//
//  YZBankRemitController.m
//  ez
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZBankRemitController.h"
#import "YZLoadHtmlFileController.h"

@implementation YZBankRemitController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"银行汇款";
    
    //背景view
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    CGFloat backViewH = 3.0 * YZCellH;
    backView.frame = CGRectMake(0, 10, screenWidth, backViewH);
    [self.view addSubview:backView];
#if JG
    NSArray*textArray = @[@"收款人：北京九歌在线科技有限责任公司",@"开户行：中国建设银行股份有限责任公司北京远洋支行", @"账号：1100 1028 9000 5300 6780"];
#elif ZC
    NSArray*textArray = @[@"收款人：北京中彩迅达科技有限公司",@"开户行：中国建设银行股份有限责任公司北京远洋支行", @"账号：1100 1028 9000 5301 7458"];
#elif CS
    NSArray*textArray = @[@"收款人：北京中彩迅达科技有限公司",@"开户行：中国建设银行股份有限责任公司北京远洋支行", @"账号：1100 1028 9000 5301 7458"];
#endif
    // 三行文字、下面两行文字 2条红色虚线
    for(int i = 0;i < 3;i++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = textArray[i];
        label.textColor = YZBlackTextColor;
        label.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        label.numberOfLines = 0;
        label.frame = CGRectMake(YZMargin, i * YZCellH, screenWidth - 2 * YZMargin, YZCellH);
        [backView addSubview:label];
        //分割线
        if (i != 2) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, YZCellH * (i + 1) - 1, screenWidth, 1)];
            line.backgroundColor = YZWhiteLineColor;
            [backView addSubview:line];
        }
    }
//    UILabel *callLabel = [[UILabel alloc] init];
//    callLabel.text = @"汇款成功后请致电";
//    callLabel.textColor = YZGrayTextColor;
//    callLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
//    CGFloat callLabelY = CGRectGetMaxY(backView.frame) + 10;
//    CGFloat callLabelW = screenWidth - 2 * YZMargin;
//    CGFloat callLabelH = 20;
//    CGSize callLabelSize = [callLabel.text sizeWithFont:callLabel.font maxSize:CGSizeMake(callLabelW, MAXFLOAT)];
//    callLabel.frame = CGRectMake(YZMargin, callLabelY, callLabelSize.width, callLabelH);
//    [self.view addSubview:callLabel];
//
//    UIButton * callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [callBtn setTitleColor:YZBlueBallColor forState:UIControlStateNormal];
//    [callBtn setTitle:@"400-700-1898" forState:UIControlStateNormal];
//    callBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
//    CGSize callBtnSize = [callBtn.currentTitle sizeWithLabelFont:callBtn.titleLabel.font];
//    callBtn.frame = CGRectMake(CGRectGetMaxX(callLabel.frame) + 3, callLabelY, callBtnSize.width, callLabelH);
//    [callBtn addTarget:self action:@selector(kefuClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:callBtn];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.textColor = YZGrayTextColor;
    promptLabel.numberOfLines = 0;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n1、ATM机暂时不支持汇款到对公账号；\n2、仅支持网银转账、银行柜台汇款，工作日9:00-16:00汇款当天到账，16:00后次日到账。周末及节假日顺延至下一工作日处理；\n3、汇款后请尽量保留相关凭证，以便需要时与客服核实确认；\n4、建议3000元以上充值使用银行汇款，小额充值尽量使用在线充值方式。\n5、充值金额不可提现，奖金可以提现。"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(22)] range:NSMakeRange(0, attStr.length)];
    promptLabel.attributedText = attStr;
    CGFloat labelY = CGRectGetMaxY(backView.frame) + 10;
    CGFloat labelW = screenWidth - 2 * YZMargin;
    CGSize labelSize = [promptLabel.attributedText boundingRectWithSize:CGSizeMake(labelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    promptLabel.frame = CGRectMake(YZMargin, labelY, labelW, labelSize.height);
    [self.view addSubview:promptLabel];
    
    //充值说明
    if (!YZStringIsEmpty(self.detailUrl)) {
        UIButton * rechargeExplainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rechargeExplainBtn setTitle:@"充值说明（点击查看）" forState:UIControlStateNormal];
        [rechargeExplainBtn setTitleColor:YZRedTextColor forState:UIControlStateNormal];
        rechargeExplainBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [rechargeExplainBtn addTarget:self action:@selector(rechargeExplainBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        CGSize rechargeExplainBtnSize = [rechargeExplainBtn.currentTitle sizeWithLabelFont:rechargeExplainBtn.titleLabel.font];
        rechargeExplainBtn.frame = CGRectMake(promptLabel.x, CGRectGetMaxY(promptLabel.frame) + 10, rechargeExplainBtnSize.width, rechargeExplainBtnSize.height);
        [self.view addSubview:rechargeExplainBtn];
    }
}

- (void)rechargeExplainBtnDidClick
{
    YZLoadHtmlFileController * updataActivityVC = [[YZLoadHtmlFileController alloc] initWithWeb:self.detailUrl];
    [self.navigationController pushViewController:updataActivityVC animated:YES];
}

- (void)kefuClick
{
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSString *telUrl = @"tel://4007001898";
    NSURL *telURL =[NSURL URLWithString:telUrl];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}
@end
