//
//  YZPublishLotteryCircleViewController.m
//  ez
//
//  Created by dahe on 2019/7/2.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZPublishLotteryCircleViewController.h"
#import "XLPhotoBrowser.h"

@interface YZPublishLotteryCircleViewController ()

@property (nonatomic, weak) UITextField * playTypeTF;
@property (nonatomic, copy) NSString * communityId;
@property (nonatomic, copy) NSString * playtypeId;
@property (nonatomic, copy) NSString * playtypeName;

@end

@implementation YZPublishLotteryCircleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布帖子";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChilds];
    [self getData];
}

#pragma mark - 请求数据
- (void)getData
{
    NSDictionary *dict = @{
                           @"gameId": self.gameId
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
    
    //截图
    CGFloat imageViewWH = screenWidth * 0.8;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth - imageViewWH) / 2, CGRectGetMaxY(line1.frame), imageViewWH, imageViewWH)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.image = self.image;
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tap];
}

- (void)imageViewDidClick
{
    [XLPhotoBrowser showPhotoBrowserWithImages:@[self.image] currentImageIndex:0];
}

- (void)publishBarDidClick
{
    NSDictionary *dict = @{
                           @"type": @"community",
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/getAliOssToken") params:dict success:^(id json) {
        YZLog(@"getAliOssToken:%@",json);
        if (SUCCESS){
            [[YZHttpTool shareInstance] uploadWithImage:self.image currentIndex:0 totalCount:1 aliOssToken:json[@"aliOssToken"] Success:^(NSString * picUrl) {
                [self uploadCircleWithPicUrl:picUrl];
            } Failure:^(NSError *error) {
                [MBProgressHUD showError:@"上传图片失败"];
            }  Progress:^(float percent) {
                
            }];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"error = %@",error);
    }];
}

- (void)uploadCircleWithPicUrl:(NSString *)picUrl
{
    waitingView
    NSMutableArray * topicAlbumList = [NSMutableArray array];
    for (int i = 0; i < 1; i++) {
        NSDictionary *topicAlbumDic = @{
                                        @"order": @(0),
                                        @"url":picUrl
                                        };
        [topicAlbumList addObject:topicAlbumDic];
    }
    NSDictionary * topicInfo = @{
                                 @"communityId": self.communityId,
                                 @"playTypeId": self.playtypeId,
                                 @"userId": UserId,
                                 @"type": @(0),
                                 @"topicAlbumList": topicAlbumList,
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
