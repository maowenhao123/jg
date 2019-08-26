//
//  YZPublishUnionBuyCircleViewController.m
//  ez
//
//  Created by dahe on 2019/7/4.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZPublishUnionBuyCircleViewController.h"
#import "YZTicketList.h"

@interface YZPublishUnionBuyCircleViewController ()

@property (nonatomic, weak) UITextField * playTypeTF;
@property (nonatomic, copy) NSString * communityId;
@property (nonatomic, copy) NSString * playtypeId;
@property (nonatomic, copy) NSString * playtypeName;

@end

@implementation YZPublishUnionBuyCircleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布帖子";
    [self setupChilds];
    [self getData];
}

#pragma mark - 请求数据
- (void)getData
{
    NSDictionary *dict = @{
                           @"gameId": self.unionbuyModel.gameId
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/getCommunityPlayTypeByGameId") params:dict success:^(id json) {
        YZLog(@"getCommunityPlayTypeByGameId:%@",json);
        if (SUCCESS){
            NSDictionary * playType = json[@"playType"];
            self.communityId = playType[@"communityId"];
            self.playtypeId = playType[@"playtypeId"];
            self.playtypeName = playType[@"playtypeName"];
            self.playTypeTF.text = self.playtypeName;
        }else
        {
            ShowErrorView
        }
    }failure:^(NSError *error)
     {
         YZLog(@"error = %@",error);
     }];
}

#pragma mark - 布局子视图
- (void)setupChilds
{
    //发布
    UIBarButtonItem * publishBar = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishBarDidClick)];
    self.navigationItem.rightBarButtonItem = publishBar;
    
    //玩法
    UIView * playTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, YZCellH)];
    playTypeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:playTypeView];
    
    UILabel * playTypeTitleLabel = [[UILabel alloc]init];
    playTypeTitleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    playTypeTitleLabel.textColor = YZBlackTextColor;
    playTypeTitleLabel.text = @"玩法";
    CGSize size = [playTypeTitleLabel.text sizeWithLabelFont:playTypeTitleLabel.font];
    playTypeTitleLabel.frame = CGRectMake(YZMargin, 0, size.width, YZCellH);
    [playTypeView addSubview:playTypeTitleLabel];
    
    UITextField * playTypeTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(playTypeTitleLabel.frame), 0, screenWidth - CGRectGetMaxX(playTypeTitleLabel.frame) - YZMargin - 8 - 5, YZCellH)];
    self.playTypeTF = playTypeTF;
    playTypeTF.borderStyle = UITextBorderStyleNone;
    playTypeTF.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    playTypeTF.textColor = YZBlackTextColor;
    playTypeTF.textAlignment = NSTextAlignmentRight;
    playTypeTF.placeholder = @"请选择玩法";
    playTypeTF.text = self.playtypeName;
    playTypeTF.userInteractionEnabled = NO;
    [playTypeView addSubview:playTypeTF];
    
    UIButton *playTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playTypeBtn.frame = playTypeTF.frame;
    [playTypeView addSubview:playTypeBtn];
    //accessory
    CGFloat accessoryW = 8;
    CGFloat accessoryH = 11;
    UIImageView * accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - YZMargin - accessoryW, (YZCellH - accessoryH) / 2, accessoryW, accessoryH)];
    accessoryImageView.image = [UIImage imageNamed:@"accessory_dray"];
    [playTypeView addSubview:accessoryImageView];
    
    //分割线
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(playTypeView.frame), screenWidth, 1)];
    line1.backgroundColor = YZWhiteLineColor;
    [self.view addSubview:line1];
    
    //彩票信息
    UIView * lotteryView = [[UIView alloc] init];
    lotteryView.backgroundColor = YZColor(255, 251, 243, 1);
    [self.view addSubview:lotteryView];
    
    NSArray * lotteryMessages = @[[NSString stringWithFormat:@"合买宣言：%@", self.unionbuyModel.desc],
                                  [NSString stringWithFormat:@"%@ 第%@期", [YZTool gameIdNameDict][self.unionbuyModel.gameId], self.unionbuyModel.termId],
                                  [NSString stringWithFormat:@"倍数：%@", self.unionbuyModel.multiple], [NSString stringWithFormat:@"金额：%.2f", [self.unionbuyModel.amount floatValue] / 100],
                                  [NSString stringWithFormat:@"佣金：%@%%", self.unionbuyModel.commission],
                                  [NSString stringWithFormat:@"方案：%@", [YZTool getSecretStatus:[self.unionbuyModel.settings integerValue]]]];
    NSString * schemeContent = @"方案内容：";
    for (NSDictionary * ticketDic in self.unionbuyModel.ticketList) {
        NSString * betTypeStr = [[NSString stringWithFormat:@"%@", ticketDic[@"betType"]] isEqualToString:@"00"] ? @"[单式]" : @"[复式]";
        NSString *numbers = ticketDic[@"numbers"];
        numbers = [numbers stringByReplacingOccurrencesOfString:@";" withString:[NSString stringWithFormat:@"%@\n", betTypeStr]];
        int count = 0;
        if ([ticketDic.allKeys containsObject:@"count"]) {
            count = [ticketDic[@"count"] intValue];
        }else
        {
            count = [self.unionbuyModel.amount intValue] / 200 / [self.unionbuyModel.multiple intValue];
        }
        NSString * schemeContent_ = [NSString stringWithFormat:@"\n%@%@\n倍数：%@倍 注数：%d注", numbers, betTypeStr, self.unionbuyModel.multiple, count];
        schemeContent = [NSString stringWithFormat:@"%@%@", schemeContent, schemeContent_];
    }
    NSMutableAttributedString * schemeContentAttStr = [[NSMutableAttributedString alloc] initWithString:schemeContent];
    [schemeContentAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(30)] range:NSMakeRange(5, schemeContentAttStr.length - 5)];
    [schemeContentAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(0, 5)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [schemeContentAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(5, schemeContentAttStr.length - 5)];
    CGFloat logoImageViewWH = 60;
    CGFloat logoMaxH = 0;
    CGFloat lastLabelMaxY = 3;
    for(NSUInteger i = 0; i < 7; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        label.textColor = YZDrayGrayTextColor;
        label.numberOfLines = 0;
        CGSize labelSize;
        if (i < 6) {
            label.text = lotteryMessages[i];
            labelSize = [label.text sizeWithFont:label.font maxSize:CGSizeMake(screenWidth - 3 * YZMargin - logoImageViewWH, MAXFLOAT)];
        }else
        {
            label.attributedText = schemeContentAttStr;
            labelSize = [schemeContentAttStr boundingRectWithSize:CGSizeMake(screenWidth - 2 * YZMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        }
        label.frame = CGRectMake(YZMargin, lastLabelMaxY + 9, labelSize.width, labelSize.height);
        [lotteryView addSubview:label];
        lastLabelMaxY = CGRectGetMaxY(label.frame);
        if (i == 5) {
            logoMaxH = lastLabelMaxY + 9;
        }
    }
    
    //logo
    UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - YZMargin - logoImageViewWH, (logoMaxH - logoImageViewWH) / 2, logoImageViewWH, logoImageViewWH)];
    logoImageView.layer.masksToBounds = YES;
    logoImageView.layer.cornerRadius = 30;
#if JG
    logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@", self.unionbuyModel.gameId]];
#elif ZC
    logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_zc", self.unionbuyModel.gameId]];
#elif CS
    logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_zc", self.unionbuyModel.gameId]];
#endif
    [lotteryView addSubview:logoImageView];
    
    lotteryView.frame = CGRectMake(0, CGRectGetMaxY(line1.frame), screenWidth, lastLabelMaxY + 12);
}

- (void)publishBarDidClick
{
    waitingView
    NSInteger count = [self.unionbuyModel.amount intValue] / 200 / [self.unionbuyModel.multiple intValue];
    NSMutableArray * ticketList = [NSMutableArray array];
    for (NSDictionary *ticketDic in self.unionbuyModel.ticketList) {
        NSMutableDictionary *ticketDic_ = [NSMutableDictionary dictionaryWithDictionary:ticketDic];
        [ticketDic_ setValue:self.unionbuyModel.gameId forKey:@"gameId"];
        [ticketDic_ setValue:self.unionbuyModel.multiple forKey:@"multiple"];
        if (![ticketDic.allKeys containsObject:@"count"]) {
            [ticketDic_ setValue:@(count) forKey:@"count"];
        }
        [ticketList addObject:ticketDic_];
    }
    NSDictionary * extInfo = @{
                               @"description": self.unionbuyModel.desc,
                               @"issue": self.unionbuyModel.termId,
                               @"money": self.unionbuyModel.amount,
                               @"commission": self.unionbuyModel.commission,
                               @"settings": self.unionbuyModel.settings,
                               @"ticketList": ticketList,
                               @"gameId": self.unionbuyModel.gameId,
                               @"gameName": self.playtypeName,
                               @"multiple": self.unionbuyModel.multiple,
                               @"userId": UserId,
                               @"unionBuyUserId": self.unionbuyModel.unionBuyPlanId
                               };
    
    NSDictionary * topicInfo = @{
                                 @"communityId": self.communityId,
                                 @"playTypeId": self.playtypeId,
                                 @"extInfo": extInfo,
                                 @"userId": UserId,
                                 @"type": @(1),
                                 @"topicAlbumList": [NSArray array],
                                 @"content": @""
                                 };
    NSDictionary * dict = @{
                            @"topicInfo": topicInfo
                            };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/releaseTopic") params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"getUserInfo:%@",json);
        if (SUCCESS){
            [MBProgressHUD showSuccess:@"发布成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
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

@end
