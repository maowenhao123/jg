//
//  YZPublishCircleViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZPublishCircleViewController.h"
#import "YZTextView.h"
#import "YZCirclePlayTypePickerView.h"
#import "YZAddMultipleImageView.h"

@interface YZPublishCircleViewController ()

@property (nonatomic, weak) YZCirclePlayTypePickerView * playTypePickerView;
@property (nonatomic, weak) UITextField *playTypeTF;
@property (nonatomic, weak) YZTextView *descTV;
@property (nonatomic, weak) YZAddMultipleImageView * addImageView;
@property (nonatomic, strong) NSMutableArray *uploadImageUrlArray;
@property (nonatomic, copy) NSString * communityId;
@property (nonatomic, copy) NSString * playtypeId;

@end

@implementation YZPublishCircleViewController

#pragma mark - 控制器的生命周期
#if JG
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 取出appearance对象
    UINavigationBar *navBar = self.navigationController.navigationBar;
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:YZBaseColor WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
}
#elif ZC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 取出appearance对象
    UINavigationBar *navBar = self.navigationController.navigationBar;
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
}
#elif CS
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 取出appearance对象
    UINavigationBar *navBar = self.navigationController.navigationBar;
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
}
#elif RR
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 取出appearance对象
    UINavigationBar *navBar = self.navigationController.navigationBar;
    // 设置背景
    if (IsBangIPhone) {
        // 设置背景
        [navBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_rr_88"] forBarMetrics:UIBarMetricsDefault];
    }else
    {
        // 设置背景
        [navBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_rr_64"] forBarMetrics:UIBarMetricsDefault];
    }
}
#endif
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布帖子";
    [self setupChilds];
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
    playTypeTF.userInteractionEnabled = NO;
    [playTypeView addSubview:playTypeTF];
    
    UIButton *playTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playTypeBtn.frame = playTypeTF.frame;
    [playTypeBtn addTarget:self action:@selector(selectPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [playTypeView addSubview:playTypeBtn];
    //accessory
    CGFloat accessoryW = 8;
    CGFloat accessoryH = 11;
    UIImageView * accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - YZMargin - accessoryW, (YZCellH - accessoryH) / 2, accessoryW, accessoryH)];
    accessoryImageView.image = [UIImage imageNamed:@"accessory_dray"];
    [playTypeView addSubview:accessoryImageView];
    
    //选择玩法
    YZCirclePlayTypePickerView * playTypePickerView = [[YZCirclePlayTypePickerView alloc] init];
    self.playTypePickerView = playTypePickerView;
    __weak typeof(self) wself = self;
    playTypePickerView.block = ^(NSDictionary * communityDic, NSDictionary * gameDic){
        wself.communityId = communityDic[@"id"];
        wself.playtypeId = gameDic[@"id"];
        wself.playTypeTF.text = [NSString stringWithFormat:@"%@", gameDic[@"name"]];
    };
    
    //分割线
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(playTypeView.frame), screenWidth, 1)];
    line1.backgroundColor = YZWhiteLineColor;
    [self.view addSubview:line1];
    
    //描述
    YZTextView * descTV = [[YZTextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame), screenWidth, 200)];
    self.descTV = descTV;
    descTV.backgroundColor = [UIColor whiteColor];
    descTV.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    descTV.textColor = YZBlackTextColor;
    descTV.myPlaceholder = @"请输入描述";
    [self.view addSubview:descTV];
    
    //分割线
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(descTV.frame), screenWidth, 1)];
    line2.backgroundColor = YZWhiteLineColor;
    [self.view addSubview:line2];
    
    //添加图片
    YZAddMultipleImageView * addImageView = [[YZAddMultipleImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame) + 1, screenWidth, 0)];
    self.addImageView = addImageView;
    addImageView.height = [addImageView getViewHeight];
    addImageView.maxImageCount = 9;
    NSMutableAttributedString * addImageAttStr = [[NSMutableAttributedString alloc] initWithString:@"添加图片"];
    addImageView.titleLabel.attributedText = addImageAttStr;
    [self.view addSubview:addImageView];
}

- (void)selectPickerView:(UIButton *)button
{
    [self.view endEditing:YES];//取消其他键盘
    [self.playTypePickerView show];
}

- (void)publishBarDidClick
{
    if (YZStringIsEmpty(self.playTypeTF.text))//未输入标题
    {
        [MBProgressHUD showError:@"请选择玩法"];
        return;
    }
    if (YZStringIsEmpty(self.descTV.text))//未输入标题
    {
        [MBProgressHUD showError:@"请输入帖子内容"];
        return;
    }

    if (YZArrayIsEmpty(self.addImageView.images))//未添加图片
    {
        [MBProgressHUD showError:@"请添加图片"];
        return;
    }
    
    NSDictionary *dict = @{
                           @"type": @"community",
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/getAliOssToken") params:dict success:^(id json) {
        YZLog(@"getAliOssToken:%@",json);
        if (SUCCESS){
            self.uploadImageUrlArray = [NSMutableArray array];
            [self uploadImageWithImage:self.addImageView.images[0] aliOssToken:json[@"aliOssToken"]];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"error = %@",error);
    }];
}

- (void)uploadImageWithImage:(UIImage *)image aliOssToken:(NSDictionary *)aliOssToken
{
    [[YZHttpTool shareInstance] uploadWithImage:image currentIndex:[self.addImageView.images indexOfObject:image] + 1 totalCount:self.addImageView.images.count aliOssToken:aliOssToken Success:^(NSString * picUrl) {
        [self.uploadImageUrlArray addObject:picUrl];
        if (self.uploadImageUrlArray.count == self.addImageView.images.count)
        {
            [self uploadCircle];
        }else
        {
            [self uploadImageWithImage:self.addImageView.images[self.uploadImageUrlArray.count] aliOssToken:aliOssToken];
        }
    } Failure:^(NSError *error) {
        [self.uploadImageUrlArray addObject:@""];
        if (self.uploadImageUrlArray.count == self.addImageView.images.count)
        {
            [self uploadCircle];
        }else
        {
            [self uploadImageWithImage:self.addImageView.images[self.uploadImageUrlArray.count] aliOssToken:aliOssToken];
        }
    }  Progress:^(float percent) {
        
    }];
}

- (void)uploadCircle
{
    waitingView
    NSMutableArray * topicAlbumList = [NSMutableArray array];
    for (int i = 0; i < self.uploadImageUrlArray.count; i++) {
        NSDictionary *topicAlbumDic = @{
                                        @"order": @(i),
                                        @"url":self.uploadImageUrlArray[i]
                                        };
        [topicAlbumList addObject:topicAlbumDic];
    }
    NSDictionary * topicInfo = @{
                                 @"communityId": self.communityId,
                                 @"playTypeId": self.playtypeId,
                                 @"userId": UserId,
                                 @"type": @(0),
                                 @"topicAlbumList": topicAlbumList,
                                 @"content": self.descTV.text
                                 };
    NSDictionary * dict = @{
                            @"topicInfo": topicInfo
                            };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/releaseTopic") params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"getUserInfo:%@",json);
        if (SUCCESS){
            [MBProgressHUD showSuccess:@"发布成功"];
            UIViewController * targetViewController = nil;
            for (UIViewController * viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[NSClassFromString(@"YZCircleViewController") class]]) {
                    targetViewController = viewController;
                }
            }
            if (YZObjectIsEmpty(targetViewController)) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else
            {
                [self.navigationController popToViewController:targetViewController animated:YES];
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCircleListNotification" object:nil];
            }
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

#pragma mark - 初始化
- (NSMutableArray *)uploadImageUrlArray
{
    if (!_uploadImageUrlArray) {
        _uploadImageUrlArray = [NSMutableArray array];
    }
    return _uploadImageUrlArray;
}

@end
