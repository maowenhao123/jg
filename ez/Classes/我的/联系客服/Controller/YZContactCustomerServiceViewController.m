//
//  YZContactCustomerServiceViewController.m
//  ez
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZContactCustomerServiceViewController.h"
#import "YZChatViewController.h"

@interface YZContactCustomerServiceViewController ()

@property (nonatomic, strong) NSMutableArray *titleAttStrings;
@property (nonatomic, strong) NSArray *subTities;
@property (nonatomic, strong) NSArray *logos;
@property (nonatomic,weak) UILabel * bageLabel;//未读消息数
@property (nonatomic, weak) UIView *phoneNumberView;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, weak) UILabel *phoneNumberLabel;
@end

@implementation YZContactCustomerServiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"联系客服";
    [self setupChilds];
    //获取未读消息数
    [self setupUnreadMessageCount];
    //获取客服电话
    [self getPhoneNumber];
    //有新消息时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"haveNewMessageNote" object:nil];
    //未读消息数改变时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    
}
- (void)getPhoneNumber
{
    NSDictionary *dict = @{
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlSalesManager(@"/getServiceTelephone") params:dict success:^(id json) {
        if (SUCCESS) {
            self.phoneNumber = json[@"phoneNumber"];
            if (!YZStringIsEmpty(self.phoneNumber)) {
                self.phoneNumberView.hidden = NO;
                self.phoneNumberLabel.attributedText = [self getAttributedStringWithBlackText:@"客服电话" blueText:self.phoneNumber];
            }else
            {
                self.phoneNumberView.hidden = YES;
            }
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error)
     {
         YZLog(@"error = %@",error);
     }];
}
// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *hConversations = [[HChatClient sharedClient].chatManager loadAllConversations];
    long badgeValue = 0;
    for (HConversation *conv in hConversations) {
        badgeValue += conv.unreadMessagesCount;
    }
    NSString *badge = nil;
    if (badgeValue == 0) {
        badge = nil;
    } else {
        badge = [NSString stringWithFormat:@"%ld",badgeValue];
        if (badgeValue > 99) {
            badge = @"99+";
        }
    }
   
    if (!YZStringIsEmpty(badge)) {
        self.bageLabel.hidden = NO;
        self.bageLabel.text = [NSString stringWithFormat:@"%@", badge];
    }else{
        self.bageLabel.hidden = YES;
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:badgeValue];
}
- (void)setupChilds
{
    //消息
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setBackgroundImage:[UIImage imageNamed:@"message_bar"] forState:UIControlStateNormal];
    messageButton.frame = (CGRect){CGPointZero, messageButton.currentBackgroundImage.size};
    [messageButton addTarget:self action:@selector(chatDidBarClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    
    //未读消息数
    CGFloat bageLabelWH = 15;
    UILabel * bageLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageButton.width - bageLabelWH / 2 - 1.5,  - bageLabelWH / 2 + 1.5, bageLabelWH, bageLabelWH)];
    self.bageLabel = bageLabel;
    bageLabel.backgroundColor = [UIColor whiteColor];
    bageLabel.textColor = YZRedTextColor;
    bageLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    bageLabel.textAlignment = NSTextAlignmentCenter;
    bageLabel.layer.masksToBounds = YES;
    bageLabel.layer.cornerRadius = bageLabelWH / 2;
    bageLabel.adjustsFontSizeToFitWidth = YES;
    bageLabel.hidden = YES;
    [messageButton addSubview:bageLabel];
    
    CGFloat viewH = 50;
    for (int i = 0; i < self.titleAttStrings.count; i++) {
        CGFloat viewY = 10 + i * (viewH + 10);
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, viewY, screenWidth, viewH)];
#if JG
        view.tag = i;
#elif ZC
        if (i == 1) {
            view.tag = 2;
        }
#elif CS
        if (i == 1) {
            view.tag = 2;
        }
#endif
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        //添加手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [view addGestureRecognizer:tap];

        //logo
        CGFloat logoWH = 18;
        CGFloat logoY = (viewH - logoWH) / 2;
        UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(YZMargin, logoY, logoWH, logoWH)];
        logoImageView.image = [UIImage imageNamed:self.logos[i]];
        [view addSubview:logoImageView];
        
        //title
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + YZMargin, 5, screenWidth - CGRectGetMaxX(logoImageView.frame) - 10, 25)];
        titleLabel.attributedText = self.titleAttStrings[i];
        [view addSubview:titleLabel];
        
        //subTitle
        UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.x, CGRectGetMaxY(titleLabel.frame), titleLabel.width, 15)];
        subTitleLabel.text = self.subTities[i];
        subTitleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        subTitleLabel.textColor = YZGrayTextColor;
        [view addSubview:subTitleLabel];
        if ([subTitleLabel.text isEqualToString:@"点击拨打电话"]) {
            self.phoneNumberLabel = titleLabel;
            self.phoneNumberView = view;
            view.hidden = YES;
        }
    }
}

- (void)chatDidBarClick
{
    //注册
    NSDictionary *dict = @{
                           @"userId":UserId,
                           };
    waitingView
    [[YZHttpTool shareInstance] postWithURL:BaseUrlEasemob(@"/register") params:dict success:^(id json) {
        if (SUCCESS) {
            YZLog(@"%@", json);
            //异步登录
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                HChatClient *client = [HChatClient sharedClient];
                HError *error = [client loginWithUsername:json[@"userInfo"][@"username"] password:json[@"userInfo"][@"password"]];
                if (!error)
                {
                    YZLog(@"登录成功");
                    YZUser *user = [YZUserDefaultTool user];
                    [[EMClient sharedClient] setApnsNickname:user.nickName];
                    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
                    options.displayStyle = EMPushDisplayStyleMessageSummary;// 显示消息内容
                    EMError *pushError = [[EMClient sharedClient] updatePushOptionsToServer]; // 更新配置到服务器，该方法为同步方法，如果需要，请放到单独线程
                    if(!pushError) {
                        YZLog(@"更新成功");
                    }else {
                        YZLog(@"更新失败");
                    }
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view];
                        // 进入会话页面
                        YZChatViewController *chatVC = [[YZChatViewController alloc] initWithConversationChatter:CECIM];
                        chatVC.title = @"在线聊天";
                        [self.navigationController pushViewController:chatVC animated:YES];
                    });
                } else
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view];
                        [MBProgressHUD showError:@"发起聊天失败"];
                    });
                }
            });
        }else
        {
            [MBProgressHUD hideHUDForView:self.view];
            ShowErrorView
        }
    } failure:^(NSError *error)
    {
        YZLog(@"error = %@",error);
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    NSInteger tag = tap.view.tag;
    if (tag == 0) {
        [self chatDidBarClick];
    }else if (tag == 1)//跳转QQ
    {
        NSString *urlStr = @"http://wpa.b.qq.com/cgi/wpa.php?ln=2&uin=4007001898";
        NSURL *url = [NSURL URLWithString:urlStr];
        UIWebView *webView = [UIWebView new];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:webView];
    }else//打电话
    {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@", self.phoneNumber];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
}
#pragma mark - 初始化
- (NSMutableArray *)titleAttStrings
{
    if (_titleAttStrings == nil) {
        _titleAttStrings = [NSMutableArray array];
#if JG
        NSMutableAttributedString * attString1 = [self getAttributedStringWithBlackText:@"在线客服" blueText:@""];
        
        NSMutableAttributedString * attString2 = [self getAttributedStringWithBlackText:@"QQ客服" blueText:@"4007001898"];
        
        NSMutableAttributedString * attString3 = [[NSMutableAttributedString alloc]initWithString:@""];
        
        [_titleAttStrings addObject:attString1];
        [_titleAttStrings addObject:attString2];
        [_titleAttStrings addObject:attString3];
#elif ZC
        NSMutableAttributedString * attString1 = [self getAttributedStringWithBlackText:@"在线客服" blueText:@""];
    
        NSMutableAttributedString * attString3 = [[NSMutableAttributedString alloc]initWithString:@""];
        
        [_titleAttStrings addObject:attString1];
        [_titleAttStrings addObject:attString3];
#elif CS
        NSMutableAttributedString * attString1 = [self getAttributedStringWithBlackText:@"在线客服" blueText:@""];
        
        NSMutableAttributedString * attString3 = [[NSMutableAttributedString alloc]initWithString:@""];
        
        [_titleAttStrings addObject:attString1];
        [_titleAttStrings addObject:attString3];
#endif
    }
    return _titleAttStrings;
}
- (NSArray *)subTities
{
    if (_subTities == nil) {
#if JG
        _subTities = @[@"点击发起咨询", @"点击发起聊天", @"点击拨打电话"];
#elif ZC
        _subTities = @[@"点击发起咨询", @"点击拨打电话"];
#elif CS
        _subTities = @[@"点击发起咨询", @"点击拨打电话"];
#endif
    }
    return _subTities;
}
- (NSArray *)logos
{
    if (_logos == nil) {
#if JG
        _logos = @[@"contact_customerService_chat", @"contact_customerService_qq", @"contact_customerService_phone"];
#elif ZC
        _logos = @[@"contact_customerService_chat", @"contact_customerService_phone"];
#elif CS
        _logos = @[@"contact_customerService_chat", @"contact_customerService_phone"];
#endif
    }
    return _logos;
}

- (NSMutableAttributedString *)getAttributedStringWithBlackText:(NSString *)blackText blueText:(NSString *)blueText
{
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@", blackText, blueText]];
    [attString addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:[attString.string rangeOfString:blackText]];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[attString.string rangeOfString:blueText]];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:NSMakeRange(0, attString.length)];
    return attString;
}

@end
