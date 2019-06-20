//
//  YZGiveVoucherView.m
//  ez
//
//  Created by 孔琪琪 on 2018/3/28.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZGiveVoucherView.h"
#import "YZVoucherViewController.h"
#import "YZGiveVoucherTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "YZDateTool.h"

@interface YZGiveVoucherView ()<UIGestureRecognizerDelegate, UITableViewDelegate,UITableViewDataSource, YZGiveVoucherTableViewCellDelegate>

@property (nonatomic,strong) YZGiveVoucherModel *giveVoucherModel;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic,weak) UIView *backView;
@property (nonatomic,weak) UIImageView *topImageView;
@property (nonatomic,weak) UIImageView * bgImageView;

@end

@implementation YZGiveVoucherView

- (instancetype)initWithFrame:(CGRect)frame giveVoucherModel:(YZGiveVoucherModel *)giveVoucherModel
{
    self = [super initWithFrame:frame];
    if (self) {
        self.giveVoucherModel = giveVoucherModel;
        [self setupChildViews];
    }
    return self;
}

- (void)getGiveVoucherData
{
    if (!UserId) return;
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"timestamp":[YZDateTool getNowTimeTimestamp],
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrl(@"promotion/couponRedPackageList") params:dict success:^(id json) {
        YZLog(@"couponRedpackageList:%@",json);
        if (SUCCESS) {
            YZGiveVoucherModel * giveVoucherModel = [YZGiveVoucherModel objectWithKeyValues:json];
            NSArray * couponRedpackageList = [CouponRedPackage objectArrayWithKeyValuesArray:json[@"couponRedpackageList"]];
            giveVoucherModel.couponRedpackageList = couponRedpackageList;
            self.giveVoucherModel = giveVoucherModel;
        }
    } failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
    }];
}

- (void)setGiveVoucherModel:(YZGiveVoucherModel *)giveVoucherModel
{
    _giveVoucherModel = giveVoucherModel;
    
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:_giveVoucherModel.couponRedPackagePromotion.imgPath] placeholderImage:[UIImage imageNamed:@"give_voucher_top"]];
    [self.tableView reloadData];
}

- (void)setupChildViews
{
    //背景
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = YZColor(0, 0, 0, 0.5);
    [self addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
    tap.delegate = self;
    [backView addGestureRecognizer:tap];
    
    NSInteger count = self.giveVoucherModel.couponRedpackageList.count > 3 ? 3 : self.giveVoucherModel.couponRedpackageList.count;
    CGFloat topImageViewH = 131 * screenHeight / 667;
    CGFloat bgImageViewH = (70 + count * 85) * screenHeight / 667;
    CGFloat closeImageViewH = 37 * screenHeight / 667;
    //顶部图片
    CGFloat topImageViewY = (self.height - topImageViewH - bgImageViewH - 25 - closeImageViewH) / 2;
    CGFloat topImageViewW = 320 * screenWidth / 375;
    CGFloat topImageViewX = (self.width - topImageViewW) / 2;
    
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(topImageViewX, topImageViewY, topImageViewW, topImageViewH)];
    self.topImageView = topImageView;
    topImageView.image = [UIImage imageNamed:@"give_voucher_top"];
    [backView addSubview:topImageView];
    
    //背景图片
    CGFloat bgImageViewY = CGRectGetMaxY(topImageView.frame);
    CGFloat bgImageViewW = 320 * screenWidth / 375;
    CGFloat bgImageViewX = (self.width - bgImageViewW) / 2;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageViewX, bgImageViewY, bgImageViewW, bgImageViewH)];
    self.bgImageView = bgImageView;
    bgImageView.image = [UIImage imageNamed:@"give_voucher_bg"];
    bgImageView.userInteractionEnabled = YES;
    [backView addSubview:bgImageView];
    
    //tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, bgImageView.width, count * 85)];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:tableView];
    
    //查看我的彩券
    UIButton * goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [goButton setTitle:@"查看我的彩券" forState:UIControlStateNormal];
    [goButton setTitleColor:UIColorFromRGB(0xffcb30) forState:UIControlStateNormal];
    goButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    CGSize goButtonSize = [goButton.currentTitle sizeWithLabelFont:goButton.titleLabel.font];
    goButton.frame = CGRectMake((bgImageView.width - goButtonSize.width) / 2, bgImageView.height - 40, goButtonSize.width, goButtonSize.height);
    [goButton addTarget:self action:@selector(gotoVoucher) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:goButton];
    
    //关闭图片
    CGFloat closeImageViewY = CGRectGetMaxY(bgImageView.frame) + 25;
    CGFloat closeImageViewW = 37 * screenWidth / 375;
    CGFloat closeImageViewX = (self.width - closeImageViewW) / 2;
    
    UIImageView *closeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(closeImageViewX, closeImageViewY, closeImageViewW, closeImageViewH)];
    closeImageView.image = [UIImage imageNamed:@"give_voucher_close"];
    [backView addSubview:closeImageView];
    
    UITapGestureRecognizer * closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeImageViewDidClick)];
    closeImageView.userInteractionEnabled = YES;
    [closeImageView addGestureRecognizer:closeTap];
}

- (void)gotoVoucher
{
    YZVoucherViewController * voucherVC = [[YZVoucherViewController alloc] init];
    [self.owerViewController pushViewController:voucherVC animated:YES];
    
//    [self removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint topPos = [touch locationInView:self.topImageView.superview];
        CGPoint bgPos = [touch locationInView:self.bgImageView.superview];
        if (CGRectContainsPoint(self.topImageView.frame, topPos) || CGRectContainsPoint(self.bgImageView.frame, bgPos)) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.giveVoucherModel.couponRedpackageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZGiveVoucherTableViewCell * cell = [YZGiveVoucherTableViewCell cellWithTableView:tableView];
    cell.promotionId = self.giveVoucherModel.couponRedPackagePromotion.promotionId;
    cell.couponRedPackage = self.giveVoucherModel.couponRedpackageList[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (void)receiveVoucher
{
    [self getGiveVoucherData];
}

- (void)useVoucher
{
    [self removeFromSuperview];
}
#pragma mark - 关闭彩券
- (void)closeImageViewDidClick
{
    if (!UserId) return;
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"promotionId":self.giveVoucherModel.couponRedPackagePromotion.promotionId,
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrl(@"promotion/closeCouponRedPackage") params:dict success:^(id json) {
        YZLog(@"closeCouponRedPackage:%@",json);
        if (SUCCESS) {
            [self removeFromSuperview];
        }
    } failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
    }];
}


@end
