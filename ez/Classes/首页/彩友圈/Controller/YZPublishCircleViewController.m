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

@interface YZPublishCircleViewController ()

@property (nonatomic, weak) YZCirclePlayTypePickerView * playTypePickerView;
@property (nonatomic, weak) UITextField *playTypeTF;
@property (nonatomic, weak) YZTextView *descTV;
@property (nonatomic,strong) NSArray *playTypeArray;

@end

@implementation YZPublishCircleViewController

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
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/getAllCommunityPlayTypeList") params:dict success:^(id json) {
        YZLog(@"getAllCommunityPlayTypeList:%@",json);
        if (SUCCESS){
            
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
}

- (void)selectPickerView:(UIButton *)button
{
    [self.view endEditing:YES];//取消其他键盘
    [self.playTypePickerView show];
}

- (void)publishBarDidClick
{
    
}

#pragma mark - 初始化
- (NSArray *)playTypeArray
{
    if (_playTypeArray == nil) {
        _playTypeArray = [NSArray array];
    }
    return _playTypeArray;
}

@end
