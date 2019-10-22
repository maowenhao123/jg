//
//  YZIntegralConversionViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/1/4.
//  Copyright © 2018年 9ge. All rights reserved.
//

NSString * const HeaderId = @"IntegralDenominationCollectionViewHeaderId";
NSString * const CouponsCellId = @"IntegralCouponsCollectionViewCellId";
NSString * const DescriptionCellId = @"YZIntegralDescriptionCollectionViewCell";
NSString * const CountCellId = @"IntegralCountCollectionViewCellId";
NSString * const CustomCountCellId = @"YZIntegralCustomCountCollectionViewCellId";

#import "YZIntegralConversionViewController.h"
#import "YZIntegralHeaderView.h"
#import "YZIntegralCouponsCollectionViewCell.h"
#import "YZIntegralDescriptionCollectionViewCell.h"
#import "YZIntegralCountCollectionViewCell.h"
#import "YZIntegralCustomCountCollectionViewCell.h"

@interface YZIntegralConversionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, YZIntegralCustomCountCollectionViewCellDelegate>
{
    YZUser *_user;
}
@property (nonatomic,weak) UILabel *currentIntegralLabel;
@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *couponsArray;
@property (nonatomic,strong) NSArray *countArray;
@property (nonatomic,strong) YZIntegralCouponsModel *selectedCouponsModel;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger integral;
@property (nonatomic,weak) UILabel *amountLabel;

@end

@implementation YZIntegralConversionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"积分兑换";
    [self setupChilds];
    [self loadUserInfo];
    [self getData];
}

#pragma mark - 请求数据
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
            _user = user;
            [YZUserDefaultTool saveUser:user];
            [self setUserInfo];
        }
    } failure:^(NSError *error) {
        YZLog(@"账户error");
    }];
}

- (void)getData
{
    NSDictionary *dict = @{
                           };
    waitingView
    [[YZHttpTool shareInstance] postWithURL:BaseUrlPoint(@"/getPointCoupons") params:dict success:^(id json) {
        YZLog(@"getPointCoupons:%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS){
            self.couponsArray = [YZIntegralCouponsModel objectArrayWithKeyValuesArray:json[@"pointCoupons"]];
            [self.collectionView reloadData];
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

#pragma  mark - 布局视图
- (void)setupChilds
{
    //当前积分
    UIView * currentIntegralView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
    currentIntegralView.backgroundColor = YZWhiteLineColor;
    [self.view addSubview:currentIntegralView];
    
    UILabel *currentIntegralLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, currentIntegralView.width - 2 * 10, currentIntegralView.height)];
    self.currentIntegralLabel = currentIntegralLabel;
    currentIntegralLabel.text = @"当前积分0";
    currentIntegralLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    currentIntegralLabel.textColor = YZDrayGrayTextColor;
    currentIntegralLabel.textAlignment = NSTextAlignmentCenter;
    [currentIntegralView addSubview:currentIntegralLabel];
    
    //collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat bottomViewH = 49 + [YZTool getSafeAreaBottom];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(currentIntegralView.frame), screenWidth, screenHeight - statusBarH - navBarH - CGRectGetMaxY(currentIntegralView.frame) - bottomViewH) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    
    //注册
    [collectionView registerClass:[YZIntegralHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderId];
    [collectionView registerClass:[YZIntegralCouponsCollectionViewCell class] forCellWithReuseIdentifier:CouponsCellId];
    [collectionView registerClass:[YZIntegralDescriptionCollectionViewCell class] forCellWithReuseIdentifier:DescriptionCellId];
    [collectionView registerClass:[YZIntegralCountCollectionViewCell class] forCellWithReuseIdentifier:CountCellId];
    [collectionView registerClass:[YZIntegralCustomCountCollectionViewCell class] forCellWithReuseIdentifier:CustomCountCellId];

    //底栏
    CGFloat bottomViewW = screenWidth;
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = screenHeight - bottomViewH - statusBarH - navBarH;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];

    //分割线
    UIView * bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    bottomLineView.backgroundColor = YZWhiteLineColor;
    [bottomView addSubview:bottomLineView];

    //兑换按钮
    CGFloat confirmBtnH = 30;
    CGFloat confirmBtnW = 75;
    CGFloat confirmBtnY = (49 - confirmBtnH) / 2;
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(screenWidth - confirmBtnW - 15, confirmBtnY, confirmBtnW, confirmBtnH);
    [confirmBtn setBackgroundImage:[UIImage ImageFromColor:YZBaseColor WithRect:confirmBtn.bounds] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(163, 23, 27, 1) WithRect:confirmBtn.bounds] forState:UIControlStateHighlighted];
    [confirmBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.layer.cornerRadius = 2;
    [bottomView addSubview:confirmBtn];

    //共需积分
    UILabel *amountLabel = [[UILabel alloc] init];
    self.amountLabel = amountLabel;
    amountLabel.textColor = YZBlackTextColor;
    amountLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    CGFloat amountLabelX = 10;
    CGFloat amountLabelW = confirmBtn.x - 10 - amountLabelX;
    CGFloat amountLabelH = 25;
    CGFloat amountLabelY = (49 - amountLabelH) / 2;
    amountLabel.frame = CGRectMake(amountLabelX, amountLabelY, amountLabelW, amountLabelH);
    [bottomView addSubview:amountLabel];
    
    self.integral = 0;
    [self setIntegralText];
}

- (void)setUserInfo
{
    self.currentIntegralLabel.text = [NSString stringWithFormat:@"当前积分%@", _user.grade];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0 || section == 2) {
        return UIEdgeInsetsMake(0, 15, 15, 15);
    }else if (section == 1)
    {
        if (!YZStringIsEmpty(self.selectedCouponsModel.desc)) {
            return UIEdgeInsetsMake(0, 0, 10, 0);
        }else
        {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }else if (section == 3)
    {
        return UIEdgeInsetsMake(10, 0, 0, 0);
    }
    return UIEdgeInsetsZero;
}
//配置item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return CGSizeMake(collectionView.width * 0.21, 50);
    }else if (indexPath.section == 1)
    {
        if (!YZStringIsEmpty(self.selectedCouponsModel.desc)) {
            CGSize size = [self.selectedCouponsModel.desc sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(24)] maxSize:CGSizeMake(screenWidth - 2 * 15, MAXFLOAT)];
            return CGSizeMake(screenWidth, size.height);
        }
        return CGSizeMake(screenWidth, 1);
    }else if (indexPath.section == 2)
    {
        return CGSizeMake(collectionView.width * 0.21, 33);
    }else if (indexPath.section == 3)
    {
        return CGSizeMake(screenWidth, 36);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 2) {
        return CGSizeMake(screenWidth, 45);
    }
    return CGSizeZero;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.couponsArray.count;
    }else if (section == 2)
    {
        return self.countArray.count;
    }else if (section == 1 || section == 3)
    {
        return 1;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        YZIntegralCouponsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CouponsCellId forIndexPath:indexPath];
        cell.couponsModel = self.couponsArray[indexPath.row];
        return cell;
    }else if (indexPath.section == 1)
    {
        YZIntegralDescriptionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DescriptionCellId forIndexPath:indexPath];
        cell.desc = self.selectedCouponsModel.desc;
        return cell;
    }else if (indexPath.section == 2)
    {
        YZIntegralCountCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CountCellId forIndexPath:indexPath];
        cell.count = [self.countArray[indexPath.row] integerValue];
        cell.customSelected = cell.count == self.count;
        return cell;
    }else if (indexPath.section == 3)
    {
        YZIntegralCustomCountCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CustomCountCellId forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader && (indexPath.section == 0 || indexPath.section == 2)) {
        YZIntegralHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderId forIndexPath:indexPath];
        headerView.hideLine = indexPath.section == 0;
        if (indexPath.section == 0) {
            headerView.title = @"选择彩券面额";
        }else if (indexPath.section == 2)
        {
            headerView.title = @"选择兑换张数";
        }
        
        return headerView;
        
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        for (YZIntegralCouponsModel *couponsModel in self.couponsArray) {
            couponsModel.selected = indexPath.row == [self.couponsArray indexOfObject:couponsModel];
        }
        self.selectedCouponsModel = self.couponsArray[indexPath.row];
        [UIView performWithoutAnimation:^{
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }];
        [self setIntegralText];
    }else if (indexPath.section == 2)
    {
        self.count = [self.countArray[indexPath.row] integerValue];
        [UIView performWithoutAnimation:^{
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
        }];
        
        YZIntegralCustomCountCollectionViewCell * cell = (YZIntegralCustomCountCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        cell.countTextField.text = nil;
        [self setIntegralText];
    }
}

- (void)integralCustomCount:(NSInteger)count
{
    self.count = count;
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
    }];
    [self setIntegralText];
}

#pragma mark - 设置注数
- (void)setIntegralText
{
    self.integral = [self.selectedCouponsModel.points integerValue] * self.count;
    NSString *temp = [NSString stringWithFormat:@"共需%ld积分", self.integral];
    NSRange range = [temp rangeOfString:[NSString stringWithFormat:@"%ld", self.integral]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temp];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedBallColor range:range];
    self.amountLabel.attributedText = attStr;
}

#pragma mark - 兑换
- (void)confirmBtnClick
{
    if (!self.selectedCouponsModel) {
        [MBProgressHUD showError:@"您还为未选择兑换彩券"];
        return;
    }
    
    if (self.count == 0) {
        [MBProgressHUD showError:@"您还为未选择兑换数量"];
        return;
    }
    
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"couponId":self.selectedCouponsModel.id,
                           @"couponCount":@(self.count),
                           @"points":@(self.integral),
                           };
    waitingView
    [[YZHttpTool shareInstance] postWithURL:BaseUrlPoint(@"/pointChangeCoupon") params:dict success:^(id json) {
        YZLog(@"pointChangeCoupon:%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS){
            [MBProgressHUD showSuccess:@"兑换成功"];
            
            //重制页面
            for (YZIntegralCouponsModel *couponsModel in self.couponsArray) {
                couponsModel.selected = NO;
            }
            self.selectedCouponsModel = nil;
            self.count = 0;
            YZIntegralCustomCountCollectionViewCell * cell = (YZIntegralCustomCountCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
            cell.countTextField.text = nil;
            [self.collectionView reloadData];
            [self loadUserInfo];
            [self setIntegralText];
            
            //积分兑换成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:IntegralConversionSuccessNote object:nil];
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
- (NSArray *)couponsArray
{
    if (_couponsArray == nil) {
        _couponsArray = [NSArray array];
    }
    return _couponsArray;
}
- (NSArray *)countArray
{
    if (_countArray == nil) {
        _countArray = @[@"1", @"2", @"3", @"5", @"10", @"20"];
    }
    return _countArray;
}

@end
