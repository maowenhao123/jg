//
//  YZStartUnionBuyViewController.m
//  ez
//
//  Created by 毛文豪 on 2017/7/26.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define bottomViewH 49

#import "YZStartUnionBuyViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZLoginViewController.h"
#import "YZNavigationController.h"
#import "NSString+YZ.h"
#import "UIImage+YZ.h"
#import "YZValidateTool.h"
#import "YZUnionBuyComfirmPayTool.h"
#import "YZUnionChangeNickNameView.h"
#import "YZTextView.h"
#import "YZBottomPickerView.h"

@interface YZStartUnionBuyViewController ()<UITextFieldDelegate, YZUnionChangeNickNameViewDelegate>
{
    NSString *_gameId;
    NSInteger _amountAmoney;
    NSUInteger _selfBuyMinNumber;//自购最低值
    YZStartUnionbuyModel *_unionbuyModel;
    NSInteger _index;
}
@property (nonatomic, weak) UITextField *commissionTd;//佣金输入框
@property (nonatomic, weak) UILabel *moneyLabel;//应付金额label
@property (nonatomic, weak) UITextField *selfBuyTd;//自购
@property (nonatomic, weak) UITextField *guaranteeTd;//保底
@property (nonatomic, weak) UIButton *selectedSettingBtn;
@property (nonatomic, weak) UITextField *titleTd;//标题
@property (nonatomic, weak) UILabel *desTitleLabel;
@property (nonatomic, weak) YZTextView *descTV;//描述

@end

@implementation YZStartUnionBuyViewController

- (instancetype)initWithGameId:(NSString *)gameId amountMoney:(NSInteger)amountAmoney unionbuyModel:(YZStartUnionbuyModel *)unionbuyModel
{
    self = [super init];
    if(self)
    {
        _gameId = gameId;
        _amountAmoney = amountAmoney;
        _unionbuyModel = unionbuyModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发起合买";
    [self setupChilds];
}
- (void)setupChilds
{
    //说明按钮
    self.navigationItem.rightBarButtonItem =  [UIBarButtonItem itemWithIcon:@"unionBuy_guide" highIcon:@"unionBuy_guide" target:self action:@selector(unionBuyGuideButtonClick)];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH - bottomViewH - [YZTool getSafeAreaBottom])];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];

    //2个label
    UILabel *lastLabel = nil;
    for(NSUInteger i = 0;i < 2; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        NSMutableAttributedString *attStr = nil;
        NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)_amountAmoney]];
        if(i == 0)
        {
            attStr = [[NSMutableAttributedString alloc] initWithString:@"金额： 元"];
            [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:NSMakeRange(0, attStr.length)];
            [attStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, attStr.length)];
            NSDictionary *attDict = @{NSForegroundColorAttributeName : YZRedTextColor, NSFontAttributeName : [UIFont systemFontOfSize:YZGetFontSize(28)]};
            [attStr1 addAttributes:attDict range:NSMakeRange(0, attStr1.length)];
        }else
        {
            attStr = [[NSMutableAttributedString alloc] initWithString:@"份数： 份（1元每份）"];
            [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:NSMakeRange(0, attStr.length)];
            [attStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, attStr.length)];
            [attStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:NSMakeRange(0, attStr1.length)];
            [attStr1 addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, attStr1.length)];
        }
        [attStr insertAttributedString:attStr1 atIndex:3];
        label.attributedText = attStr;
        CGFloat labelH = [label.attributedText boundingRectWithSize:CGSizeMake(screenWidth, screenHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        CGFloat padding = (73 - 2 * labelH) / 3;
        label.frame = CGRectMake(YZMargin, padding + i * (labelH + padding), screenWidth - 2 * YZMargin, labelH);
        [scrollView addSubview:label];
        lastLabel = label;
    }
    
    //2个分割线
    UIView *lastSeparator = nil;
    for(NSUInteger i = 0;i < 2;i ++)
    {
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = YZWhiteLineColor;
        separator.frame = CGRectMake(0, CGRectGetMaxY(lastLabel.frame) + YZMargin, screenWidth, 1);
        [scrollView addSubview:separator];
        lastSeparator = separator;
    }
    
    //三个输入框
    CGFloat labelH = 25;
    NSArray *label1Titles = @[@"佣金",@"自购",@"保底"];
    NSArray *label2Titles = @[@"%(最高10%)",@"元（最少5%）",@"元"];
    UITextField *lastTextfield = nil;
    for(NSUInteger i = 0;i < 3;i ++)
    {
        for(NSUInteger j = 0;j < 2;j ++)
        {
            CGFloat textfieldW = 120;
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = (j == 0 ? label1Titles[i] : label2Titles[i]);
            label.textColor = YZBlackTextColor;
            label.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
            CGSize labelSize = [label.text sizeWithLabelFont:label.font];
            CGFloat labelY = CGRectGetMaxY(lastSeparator.frame) + YZMargin + i * (labelH + YZMargin);
            label.frame = CGRectMake(YZMargin + j * (CGRectGetWidth(lastLabel.frame) + textfieldW + YZMargin), labelY, labelSize.width, labelH);
            [scrollView addSubview:label];
            lastLabel = label;
            
            if(j == 0)
            {
                UITextField *textfield = [[UITextField alloc] init];
                textfield.tag = i;
                lastTextfield = textfield;
                textfield.delegate = self;
                textfield.textColor = YZBlackTextColor;
                textfield.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
                textfield.keyboardType = UIKeyboardTypeNumberPad;
                textfield.layer.masksToBounds = YES;
                textfield.layer.cornerRadius = 2;
                textfield.layer.borderColor = YZColor(213, 213, 213, 1).CGColor;
                textfield.layer.borderWidth = 1;
                if(i == 0)
                {
                    textfield.placeholder = @"0";
                    self.commissionTd = textfield;
                }else
                {
                    if(i == 1)
                    {
                        self.selfBuyTd = textfield;
                        NSInteger minNumber = (NSInteger)(_amountAmoney * 0.05) > 1 ? (NSInteger)(_amountAmoney * 0.05) : 1;
                        textfield.text = [NSString stringWithFormat:@"%ld",(long)minNumber];
                    }else
                    {
                        self.guaranteeTd = textfield;
                    }
                }
                textfield.textAlignment = NSTextAlignmentCenter;
                CGFloat textfieldX = CGRectGetMaxX(label.frame) + YZMargin / 2;
                CGFloat textfieldH = labelH;
                textfield.frame = CGRectMake(textfieldX, labelY,  textfieldW, textfieldH);
                [scrollView addSubview:textfield];
                
                if(i == 0)
                {
                    for(NSUInteger k = 0;k < 2;k ++)
                    {
                        //减小和增大按钮
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.tag = k;
                        CGFloat btnWH = textfieldH;
                        CGFloat btnX = 0;
                        if(k == 1)
                        {
                            btnX = textfieldW - btnWH - 1;
                        }
                        btn.frame = CGRectMake(btnX, 0, btnWH, btnWH);
                        NSString *imageName = @"bet_subtract_icon";
                        if(k == 1)
                        {
                            imageName = @"bet_add_icon";
                        }
                        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                        [btn setBackgroundImage:[UIImage ImageFromColor:YZColor(238, 238, 238, 1) WithRect:btn.bounds] forState:UIControlStateNormal];
                        [btn setBackgroundImage:[UIImage ImageFromColor:YZGrayTextColor WithRect:btn.bounds] forState:UIControlStateSelected];
                        [btn addTarget:self action:@selector(plusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [textfield addSubview:btn];
                    }
                }
            }
        }
    }
    
    lastSeparator.y = CGRectGetMaxY(lastTextfield.frame) + YZMargin;
    
    //保密设置
    UILabel *secreteLabel = [[UILabel alloc] init];
    secreteLabel.text = @"保密设置";
    secreteLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    secreteLabel.textColor = YZBlackTextColor;
    CGSize secreteLabelSize = [secreteLabel.text sizeWithLabelFont:secreteLabel.font];
    secreteLabel.frame = CGRectMake(YZMargin, CGRectGetMaxY(lastSeparator.frame) + 15, screenWidth - 2 * YZMargin, secreteLabelSize.height);
    [scrollView addSubview:secreteLabel];
    
    NSArray *btnTitles = @[@"完全公开", @"参与可见", @"截止公开", @"完全保密"];
    NSUInteger btnCount = 4;
    CGFloat btnW = (screenWidth - (btnCount + 1) * YZMargin) / btnCount;
    CGFloat btnH = 35;
    CGFloat btnY = CGRectGetMaxY(secreteLabel.frame) + 10;
    UIButton *lastBtn = nil;;
    for(NSUInteger i = 0;i < btnCount;i ++)
    {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setFrame:CGRectMake(YZMargin + i * (btnW + YZMargin), btnY, btnW, btnH)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:YZGetFontSize(24)]];
        [btn setBackgroundImage:[UIImage ImageFromColor:YZColor(238, 238, 238, 1) WithRect:btn.bounds] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage ImageFromColor:YZBaseColor] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage ImageFromColor:YZBaseColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(settingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 2;
        [scrollView addSubview:btn];
        lastBtn = btn;
        if(i == 0)
        {
            [self settingBtnClick:btn];
        }
    }
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastBtn.frame) + 15, screenWidth, 8)];
    lineView.backgroundColor = YZBackgroundColor;
    [scrollView addSubview:lineView];
    
    UIView *descView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), screenWidth, 0)];
    descView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:descView];
    
    //标题
    NSArray *descTitles = @[@"方案标题", @"个人宣言"];
    CGFloat maxViewY = 10;
    for(NSUInteger i = 0; i < 2; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(YZMargin, maxViewY + i * YZMargin, screenWidth - 2 * YZMargin, 30)];
        label.text = descTitles[i];
        label.textColor = YZBlackTextColor;
        label.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [descView addSubview:label];
        maxViewY = CGRectGetMaxY(label.frame);
        
        if (i == 0) {
            UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(YZMargin, maxViewY + 5, screenWidth - 2 * YZMargin, 40)];
            self.titleTd = textfield;
            textfield.borderStyle = UITextBorderStyleNone;
            textfield.text = [NSString stringWithFormat:@"%@合买方案", [YZTool gameIdNameDict][_gameId]];
            textfield.textColor = YZBlackTextColor;
            textfield.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
            textfield.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
            textfield.leftViewMode = UITextFieldViewModeAlways;
            textfield.layer.borderColor = YZGrayLineColor.CGColor;
            textfield.layer.borderWidth = 1;
            textfield.layer.masksToBounds = YES;
            textfield.layer.cornerRadius = 5;
            [descView addSubview:textfield];
            maxViewY = CGRectGetMaxY(textfield.frame);
        }else
        {
            UIView * chooseDesView = [[UIView alloc] initWithFrame:CGRectMake(YZMargin, maxViewY + 5, screenWidth - 2 * YZMargin, 140)];
            chooseDesView.layer.borderColor = YZGrayLineColor.CGColor;
            chooseDesView.layer.borderWidth = 1;
            chooseDesView.layer.masksToBounds = YES;
            chooseDesView.layer.cornerRadius = 5;
            [descView addSubview:chooseDesView];
            maxViewY = CGRectGetMaxY(chooseDesView.frame);
            
            UIView *separator = [[UIView alloc] init];
            separator.backgroundColor = YZGrayLineColor;
            separator.frame = CGRectMake(0, 40, screenWidth, 1);
            [chooseDesView addSubview:separator];
            
            UILabel *desTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, chooseDesView.width - 8 - 30, 40)];
            self.desTitleLabel = desTitleLabel;
            desTitleLabel.text = [NSString stringWithFormat:@"%@合买方案", [YZTool gameIdNameDict][_gameId]];
            desTitleLabel.textColor = YZBlackTextColor;
            desTitleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
            [chooseDesView addSubview:desTitleLabel];
            
            //accessory
            UIButton *accessoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            accessoryBtn.frame =  CGRectMake(0, 0, chooseDesView.width, desTitleLabel.height);
            [accessoryBtn setImageEdgeInsets:UIEdgeInsetsMake(0, accessoryBtn.width - 10 - 20, 0, 0)];
            [accessoryBtn setImage:[UIImage imageNamed:@"unionBuy_graydownArrow"] forState:UIControlStateNormal];
            [accessoryBtn addTarget:self action:@selector(chooseDesPickerView) forControlEvents:UIControlEventTouchUpInside];
            [chooseDesView addSubview:accessoryBtn];
            
            YZTextView *textView = [[YZTextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(desTitleLabel.frame), chooseDesView.width, 100)];
            self.descTV = textView;
            textView.textColor = YZBlackTextColor;
            textView.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
            textView.myPlaceholder = @"您还可以自定义您的合买宣言";
            [chooseDesView addSubview:textView];
        }
    }
    descView.height = maxViewY + YZMargin;
    scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(descView.frame));
    
    //底栏
    CGFloat bottomViewW = screenWidth;
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = screenHeight - bottomViewH - statusBarH - navBarH - [YZTool getSafeAreaBottom];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH + [YZTool getSafeAreaBottom])];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    //分割线
    UIView * bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    bottomLineView.backgroundColor = YZWhiteLineColor;
    [bottomView addSubview:bottomLineView];
    
    //付款
    YZBottomButton *confirmBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    CGFloat confirmBtnH = 30;
    CGFloat confirmBtnW = 75;
    confirmBtn.frame = CGRectMake(screenWidth - confirmBtnW - 15, (bottomViewH - confirmBtnH) / 2, confirmBtnW, confirmBtnH);
    [confirmBtn setTitle:@"付款" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmBtn];
    
    //剩余moneylabel
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.backgroundColor = [UIColor clearColor];;
    self.moneyLabel = moneyLabel;
    moneyLabel.textColor = YZBlackTextColor;
    moneyLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    CGFloat moneyLabelY = 0;
    CGFloat moneyLabelW = CGRectGetMinX(confirmBtn.frame) - YZMargin;
    CGFloat moneyLabelH = bottomViewH;
    moneyLabel.frame = CGRectMake(YZMargin, moneyLabelY, moneyLabelW, moneyLabelH);
    [bottomView addSubview:moneyLabel];
    [self setMoneyLabelText];
    
    scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(descView.frame));
}
//说明按钮点击
- (void)unionBuyGuideButtonClick
{
    YZLoadHtmlFileController *htmlVc = [[YZLoadHtmlFileController alloc] initWithFileName:@"unionBuy.html"];
    htmlVc.title = @"合买大厅说明";
    [self.navigationController pushViewController:htmlVc animated:YES];
}
- (void)chooseDesPickerView
{
    [self.view endEditing:YES];
    
    NSArray * desArr = @[@"一起来合买，中奖一起乐！",
                         @"众人拾柴火焰高，跟我中奖一起乐！",
                         @"梦想还是要有的，万一实现了呢？让我们一起向梦想冲刺！",
                         @"少数人的智慧，一伙儿人的梦想！",
                         @"你我不相识，合买成朋友！",
                         @"一人中奖很孤单，一起中奖来狂欢！",
                         @"合买！又要中了！不能少了您……",
                         @"我用战绩来说话，快来跟单吧！",
                         @"不怕不懂号，就怕专家来选号，快来跟单吧！",
                         @"刚中过，跟我一起合买来中更大奖！"];
    YZBottomPickerView * desChooseView = [[YZBottomPickerView alloc]initWithArray:desArr index:_index];
    desChooseView.block = ^(NSInteger selectedIndex){
        _index = selectedIndex;
        self.desTitleLabel.text = desArr[selectedIndex];
        self.descTV.text = desArr[selectedIndex];
    };
    [desChooseView show];
}
#pragma  mark - 保密设置按钮点击
- (void)settingBtnClick:(UIButton *)btn
{
    if(!btn.selected)
    {
        btn.selected = YES;
        self.selectedSettingBtn.selected = NO;
        self.selectedSettingBtn = btn;
    }
}
#pragma  mark - 加减按钮点击
- (void)plusBtnClick:(UIButton *)btn
{
    NSInteger multiple = [self.commissionTd.text integerValue];
    NSInteger minNumber = (NSInteger)(_amountAmoney * 0.05) > 1 ? (NSInteger)(_amountAmoney * 0.05) : 1;
    if(btn.tag == 0 && multiple != minNumber)//是减小按钮
    {
        multiple--;
    }else if(btn.tag == 1 && multiple != 10)//增大按钮
    {
        multiple++;
    }
    self.commissionTd.text = [NSString stringWithFormat:@"%ld",(long)multiple];
}
#pragma  mark - 确认按钮点击
- (void)confirmBtnClick
{
    if(!UserId)//没登录
    {
        YZLoginViewController *loginVc = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:loginVc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    if ([YZTool needChangeNickName]) {
        YZUnionChangeNickNameView * changeNickNameView = [[YZUnionChangeNickNameView alloc] initWithFrame:self.view.bounds];
        changeNickNameView.delegate = self;
        [self.view addSubview:changeNickNameView];
        return;
    }
    [self buy];
}
- (void)confirmBtnDidClick:(NSString *)nickName
{
    if (YZStringIsEmpty(nickName)) return;
    YZUser *user = [YZUserDefaultTool user];
    NSDictionary *dict = @{
                           @"cmd":@(8126),
                           @"userId":UserId,
                           @"userName":user.userName,
                           @"nickName":nickName
                           };
    waitingView
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            [self loadUserInfo];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"修改昵称失败"];
    }];
}
- (void)loadUserInfo
{
    if (!UserId) return;
    NSDictionary *dict = @{
                           @"cmd":@(8006),
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        YZLog(@"%@",json);
        if (SUCCESS) {
            //存储用户信息
            YZUser *user = [YZUser objectWithKeyValues:json];
            [YZUserDefaultTool saveUser:user];
            [MBProgressHUD showSuccess:@"修改成功"];
        }
    } failure:^(NSError *error) {
        YZLog(@"账户error");
    }];
}
- (void)buy
{
    _unionbuyModel.title = self.titleTd.text;
    _unionbuyModel.desc = self.descTV.text;
    _unionbuyModel.commission = @([self.commissionTd.text integerValue]);
    _unionbuyModel.money = @([self.selfBuyTd.text integerValue] * 100);
    _unionbuyModel.deposit = @([self.guaranteeTd.text integerValue] * 100);
    _unionbuyModel.settings = @(self.selectedSettingBtn.tag + 1);
    
    [[YZUnionBuyComfirmPayTool shareInstance] startUnionBuyOfAllWithParam:_unionbuyModel sourceController:self];
}
#pragma  mark - 设置显示钱的label文字
- (void)setMoneyLabelText
{
    NSInteger money = [self.selfBuyTd.text integerValue] + [self.guaranteeTd.text integerValue];
    NSString *str = [NSString stringWithFormat:@"应付金额：%ld元",(long)money];
    NSDictionary *dict = @{NSForegroundColorAttributeName : YZRedTextColor};
    NSMutableAttributedString *attStr = [str attributedStringWithAttributs:dict firstString:@"：" secondString:@"元"];
    self.moneyLabel.attributedText = attStr;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger maxNumber =  10;
    NSInteger minNumber = 1;
    if(textField.tag == 1)
    {
        maxNumber = _amountAmoney - [self.guaranteeTd.text integerValue];
        minNumber = (NSInteger)(_amountAmoney * 0.05) > 1 ? (NSInteger)(_amountAmoney * 0.05) : 1;
    }else if(textField.tag == 2)
    {
        maxNumber = _amountAmoney - [self.selfBuyTd.text integerValue];
    }
    
    NSString *allStr = textField.text;
    if([allStr integerValue] > maxNumber)
    {
        textField.text = [NSString stringWithFormat:@"%@",@(maxNumber)];
    }
    if(textField.tag == 1 && [allStr integerValue] < minNumber)
    {
        textField.text = [NSString stringWithFormat:@"%@",@(minNumber)];
    }
    
    [self setMoneyLabelText];
}

@end
