//
//  YZShopInfoViewController.m
//  zc
//
//  Created by dahe on 2020/3/31.
//  Copyright © 2020 9ge. All rights reserved.
//

#import <Photos/Photos.h>
#import "YZShopInfoViewController.h"
#import "YZShopModel.h"
#import "YZShareTool.h"
#import "Masonry.h"

@interface YZShopInfoViewController ()

@property (nonatomic, weak) UIScrollView * scrollView;
@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *addressLabel;
@property (nonatomic, weak) UILabel *phoneLabel;
@property (nonatomic, weak) UILabel *weixinLabel;
@property (nonatomic, weak) UIButton *weixinCopyButton;
@property (nonatomic, weak) UIView *noticeView;
@property (nonatomic, weak) UILabel *noticeLabel;
@property (nonatomic, weak) UILabel * payLabel;
@property (nonatomic, weak) UIImageView * line;
@property (nonatomic, weak) UIImageView *erCodeImageView;
@property (nonatomic, weak) UIButton * shareButton;
@property (nonatomic, strong) YZShopModel * shopModel;

@end

@implementation YZShopInfoViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else
    {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZColor(249, 96, 66, 1);
    [self setupChilds];
    [self getShopInfo];
}

#pragma mark - 请求数据
- (void)getShopInfo
{
    waitingView;
    NSDictionary *dict = @{
    };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlSalesManager(@"/getStoreInfo") params:dict success:^(id json) {
        YZLog(@"%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            YZShopModel *shopModel = [YZShopModel objectWithKeyValues:json[@"store"]];
            shopModel.payList = [YZShopPayModel objectArrayWithKeyValuesArray:json[@"store"][@"payTypeList"]];
            self.shopModel = shopModel;
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"error：%@", error);
    }];
}

#pragma mark - Setting
- (void)setShopModel:(YZShopModel *)shopModel
{
    _shopModel = shopModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_shopModel.headUrl] placeholderImage:[UIImage imageNamed:@"avatar_zc"]];
    self.nameLabel.text = _shopModel.name;
    NSString *notice = _shopModel.notice;
    if (YZStringIsEmpty(notice)) {
        notice = @"暂无公告";
    }
    NSMutableAttributedString *noticeAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"店铺公告：%@", notice]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    [noticeAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, noticeAttStr.length)];
    [noticeAttStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:YZGetFontSize(28)] range:[noticeAttStr.string rangeOfString:@"店铺公告："]];
    [noticeAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:[noticeAttStr.string rangeOfString:notice]];
    self.noticeLabel.attributedText = noticeAttStr;
    self.addressLabel.attributedText = [self getAttributedStringWithImageName:@"shop_address_icon" text:[NSString stringWithFormat:@" %@", _shopModel.address]];
    self.phoneLabel.attributedText = [self getAttributedStringWithImageName:@"shop_phone_icon" text:[NSString stringWithFormat:@" %@", _shopModel.phone]];
    if (YZStringIsEmpty(_shopModel.weixin)) {
        self.weixinLabel.hidden = YES;
        self.weixinCopyButton.hidden = YES;
    }else
    {
        self.weixinLabel.hidden = NO;
        self.weixinCopyButton.hidden = NO;
        self.weixinLabel.attributedText = [self getAttributedStringWithImageName:@"shop_weixin_icon" text:[NSString stringWithFormat:@" %@", _shopModel.weixin]];
    }
    
    if (_shopModel.payList.count == 0) {
        self.payLabel.text = @"本店支持：店主未设置收款方式";
        CGSize payLabelSize = [self.payLabel.text sizeWithLabelFont:self.payLabel.font];
        [self.payLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(payLabelSize.width + 3);
        }];
    }else
    {
        for (int i = 0; i < _shopModel.payList.count; i++) {
            YZShopPayModel * payModel = _shopModel.payList[i];
            UIImageView *payImageView = [[UIImageView alloc] init];
            if (payModel.type == 1) {
                payImageView.image = [UIImage imageNamed:@"shop_weixin_pay_icon"];
            }else if (payModel.type == 2)
            {
                payImageView.image = [UIImage imageNamed:@"shop_zfb_icon"];
            }
            [self.scrollView addSubview:payImageView];
            [payImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.payLabel.mas_top);
                make.left.equalTo(self.payLabel.mas_right).with.offset((20 + 7) * i);
                make.width.mas_equalTo(20);
                make.height.mas_equalTo(20);
            }];
        }
    }
    self.erCodeImageView.image = [self generateQRCodeWithString:_shopModel.url];
    
    CGFloat nameLabelH = [self.nameLabel sizeThatFits:CGSizeMake(screenWidth - 2 * YZMargin - 60 - 20 - 10 - YZMargin, MAXFLOAT)].height;
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(nameLabelH);
    }];
    CGFloat addressLabelH = [self.addressLabel sizeThatFits:CGSizeMake(screenWidth - 2 * YZMargin - 60 - 20 - 10 - YZMargin, MAXFLOAT)].height;
    [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(addressLabelH);
    }];
    CGFloat phoneLabelW = [self.phoneLabel sizeThatFits:CGSizeMake(screenWidth, screenHeight)].width;
    [self.phoneLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(phoneLabelW);
    }];
    CGFloat weixinLabelW = [self.weixinLabel sizeThatFits:CGSizeMake(screenWidth, screenHeight)].width;
    [self.weixinLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weixinLabelW);
    }];
    CGFloat noticeLabellH = [self.noticeLabel sizeThatFits:CGSizeMake(screenWidth - 2 * YZMargin - 2 * 20 - 2 * YZMargin, MAXFLOAT)].height;
    [self.noticeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(noticeLabellH + 30);
    }];
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.shareButton).with.offset(40);
    }];
}

#pragma mark - 布局视图
- (void)setupChilds
{
    //返回
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back_btn_flat"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).with.offset(statusBarH);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(navBarH);
    }];
    
    //标题
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"店铺二维码";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(statusBarH);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(navBarH);
    }];
    
    //内容
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.layer.cornerRadius = 5;
    scrollView.layer.masksToBounds = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.view.mas_left).with.offset(YZMargin);
        make.right.equalTo(self.view.mas_right).with.offset(-YZMargin);
        if (IsBangIPhone) {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-[YZTool getSafeAreaBottom]);
        }else
        {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-YZMargin);
        }
    }];
    
    //头像
    UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
    self.avatarImageView = avatarImageView;
    avatarImageView.image = [UIImage imageNamed:@"avatar_zc"];
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = avatarImageView.width / 2;
    [scrollView addSubview:avatarImageView];
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_top).with.offset(20);
        make.left.equalTo(scrollView.mas_left).with.offset(20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    //店铺名
    UILabel * nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.text = @"店铺名";
    nameLabel.textColor = YZBlackTextColor;
    nameLabel.numberOfLines = 0;
    nameLabel.font = [UIFont boldSystemFontOfSize:YZGetFontSize(30)];
    [scrollView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarImageView.mas_right).with.offset(7);
        make.top.equalTo(scrollView.mas_top).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-YZMargin * 2);
        make.height.mas_equalTo(20);
    }];
    
    //店铺信息
    for (int i = 0; i < 3; i++) {
        UILabel * label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.userInteractionEnabled = YES;
        if (i == 0) {
            self.addressLabel = label;
            label.attributedText = [self getAttributedStringWithImageName:@"shop_address_icon" text:@""];
        }else if (i == 1)
        {
            self.phoneLabel = label;
            label.attributedText = [self getAttributedStringWithImageName:@"shop_phone_icon" text:@""];
        }else if (i == 2)
        {
            self.weixinLabel = label;
            label.attributedText = [self getAttributedStringWithImageName:@"shop_weixin_icon" text:@""];
        }
        [scrollView addSubview:label];
        CGSize labelSize = [label sizeThatFits:CGSizeMake(screenWidth - 2 * YZMargin - 60 - 20 - 10 - YZMargin, MAXFLOAT)];
        if (i == 0) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(avatarImageView.mas_right).with.offset(7);
                make.top.equalTo(nameLabel.mas_bottom).with.offset(7);
                make.right.equalTo(self.view.mas_right).with.offset(-YZMargin * 2);
                make.height.mas_equalTo(labelSize.height);
            }];
        }else if (i == 1)
        {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(avatarImageView.mas_right).with.offset(7);
                make.top.equalTo(self.addressLabel.mas_bottom).with.offset(7);
                make.width.mas_equalTo(labelSize.width);
                make.height.mas_equalTo(labelSize.height);
            }];
        }else if (i == 2)
        {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.phoneLabel.mas_right).with.offset(5);
                make.top.equalTo(self.addressLabel.mas_bottom).with.offset(7);
                make.width.mas_equalTo(labelSize.width);
                make.height.mas_equalTo(labelSize.height);
            }];
        }
    }
    
    //复制微信号
    UIButton * weixinCopyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.weixinCopyButton = weixinCopyButton;
    [weixinCopyButton setImage:[UIImage imageNamed:@"shop_copy_icon"] forState:UIControlStateNormal];
    [weixinCopyButton addTarget:self action:@selector(copyButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:weixinCopyButton];
    [weixinCopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weixinLabel.mas_right);
        make.top.equalTo(self.addressLabel.mas_bottom);
        make.width.mas_equalTo(34);
        make.height.mas_equalTo(34);
    }];
    
    //店铺公告
    UIView * noticeView = [[UIView alloc] init];
    self.noticeView = noticeView;
    noticeView.backgroundColor = YZColor(244, 244, 244, 1);
    noticeView.layer.masksToBounds = YES;
    noticeView.layer.cornerRadius = 3;
    [scrollView addSubview:noticeView];
    [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView.mas_left).with.offset(20);
        make.top.equalTo(self.phoneLabel.mas_bottom).with.offset(20);
        make.width.equalTo(scrollView.mas_width).with.offset(-40);
        make.height.mas_equalTo(60);
    }];
    
    UILabel * noticeLabel = [[UILabel alloc] init];
    self.noticeLabel = noticeLabel;
    noticeLabel.text = @"店铺公告：";
    noticeLabel.textColor = YZBlackTextColor;
    noticeLabel.numberOfLines = 0;
    [noticeView addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noticeView.mas_top);
        make.left.equalTo(noticeView.mas_left).with.offset(YZMargin);
        make.right.equalTo(noticeView.mas_right).with.offset(-YZMargin);
        make.bottom.equalTo(noticeView.mas_bottom);
    }];
    
    //支持支付方式
    UILabel * payLabel = [[UILabel alloc] init];
    self.payLabel = payLabel;
    payLabel.text = @"本店支持：";
    payLabel.textColor = YZBlackTextColor;
    payLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [scrollView addSubview:payLabel];
    CGSize payLabelSize = [payLabel.text sizeWithLabelFont:payLabel.font];
    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarImageView.mas_left);
        make.top.equalTo(noticeView.mas_bottom).with.offset(20);
        make.width.mas_equalTo(payLabelSize.width + 3);
        make.height.mas_equalTo(20);
    }];
    
    //分割线
    UIImageView * line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shop_info_line"]];
    self.line = line;
    [scrollView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView.mas_left);
        make.width.equalTo(scrollView.mas_width);
        make.top.equalTo(payLabel.mas_bottom).with.offset(20);
        make.height.mas_equalTo(30);
    }];
    
    
    //二维码
    UILabel *erCodeLabel = [[UILabel alloc] init];
    erCodeLabel.text = @"扫一扫二维码，立即购彩";
    erCodeLabel.textAlignment = NSTextAlignmentCenter;
    erCodeLabel.textColor = YZDrayGrayTextColor;
    erCodeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [scrollView addSubview:erCodeLabel];
    [erCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView.mas_left);
        make.width.equalTo(scrollView.mas_width);
        make.top.equalTo(line.mas_bottom).with.offset(20);
        make.height.mas_equalTo(20);
    }];
    
    CGFloat erCodeImageViewWH = 180;
    UIImageView *erCodeImageView = [[UIImageView alloc] init];
    self.erCodeImageView = erCodeImageView;
    erCodeImageView.backgroundColor = YZColor(247, 246, 251, 1);
    [scrollView addSubview:erCodeImageView];
    [erCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView.mas_centerX);
        make.top.mas_equalTo(erCodeLabel.mas_bottom).with.offset(10);
        make.width.mas_equalTo(erCodeImageViewWH);
        make.height.mas_equalTo(erCodeImageViewWH);
    }];
    
    //按钮
    CGFloat buttonW = 118;
    CGFloat buttonH = 33;
    CGFloat buttonPadding = (screenWidth - 2 * YZMargin - 2 * buttonW) / 3;
    for (int i = 0; i < 2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        if (i == 0) {
            self.shareButton = button;
            [button setBackgroundImage:[UIImage imageNamed:@"shop_share_btn"] forState:UIControlStateNormal];
        }else
        {
            [button setBackgroundImage:[UIImage imageNamed:@"shop_save_erCode_btn"] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(scrollView.mas_left).with.offset(buttonPadding + i * (buttonPadding + buttonW));
            make.top.mas_equalTo(erCodeImageView.mas_bottom).with.offset(40);
            make.width.mas_equalTo(buttonW);
            make.height.mas_equalTo(buttonH);
        }];
    }
}

#pragma mark - 按钮点击
- (void)backButtonDidClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)copyButtonDidClick
{
    //复制账号
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    NSString *string = self.shopModel.phone;
    [pab setString:string];
    [MBProgressHUD showSuccess:@"已复制，请打开微信添加店主好友"];
}

- (void)buttonDidClick:(UIButton *)button
{
    if (button.tag == 0) {
        YZUser *user = [YZUserDefaultTool user];
        [YZShareTool UMShareWithTitle:@"好店分享" content:@"推荐一家投注店，可线上下单，省时省力！很多彩友都在这里买，快来一起吧！" webpageUrl:[NSString stringWithFormat:@"%@/user/store/%@?parentId=%@", shareBaseUrl, self.shopModel.id, user.userId] thumImage:self.shopModel.headUrl];
    }else if (button.tag == 1)
    {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status) {
                    case PHAuthorizationStatusAuthorized:
                        UIImageWriteToSavedPhotosAlbum(self.erCodeImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                        break;
                    case PHAuthorizationStatusDenied:
                        [MBProgressHUD showError:@"访问相册被拒绝"];
                        break;
                    case PHAuthorizationStatusRestricted:
                        [MBProgressHUD showError:@"没有授权访问相册"];
                        break;
                    default:
                        [MBProgressHUD showError:@"访问相册失败"];
                        break;
                }
            });
        }];
    }
}

#pragma mark - 保存到相册
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error){
        [MBProgressHUD showError:[NSString stringWithFormat:@"保存失败%@", error]];
    }else
    {
        [MBProgressHUD showSuccess:@"保存成功"];
    }
}

- (NSAttributedString *)getAttributedStringWithImageName:(NSString *)name text:(NSString *)text
{
    UIFont *font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc]initWithData:nil ofType:nil];
    textAttachment.bounds = CGRectMake(0, -3, 17, 17);
    textAttachment.image = [UIImage imageNamed:name];
    NSAttributedString *imageAttStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZDrayGrayTextColor range:NSMakeRange(0, attStr.length)];
    [attStr insertAttributedString:imageAttStr atIndex:0];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
    return attStr;
}
#pragma mark - 生成二维码
- (UIImage *)generateQRCodeWithString:(NSString *)string
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *image = [filter outputImage];
    UIImage *img = [self createNonInterpolatedUIImageFormCIImage:image withSize:screenWidth];
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    UIImage *centerImg = [UIImage imageNamed:@"logo1"];
    CGFloat centerW = img.size.width * 0.25;
    CGFloat centerH = centerW;
    CGFloat centerX = (img.size.width-centerW)*0.5;
    CGFloat centerY = (img.size.height -centerH)*0.5;
    [centerImg drawInRect:CGRectMake(centerX, centerY, centerW, centerH)];
    UIImage *finalImg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImg;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
