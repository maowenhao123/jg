//
//  YZWeChatPublicViewController.m
//  ez
//
//  Created by 毛文豪 on 2017/8/12.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZWeChatPublicViewController.h"
#import "YZWeChatPublicHelpViewController.h"
#import "YZLoadHtmlFileController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "YZQrCodeModel.h"
#import "YZDateTool.h"

@interface YZWeChatPublicViewController ()

@property (nonatomic,weak) UIScrollView * scrollView;
@property (nonatomic,weak) UIImageView *codeImageView;
@property (nonatomic,weak) UILabel * promptLabel;
@property (nonatomic,weak) UIButton * vipcnButton;
@property (nonatomic,strong) YZQrCodeModel *QrCodeModel;

@end

@implementation YZWeChatPublicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"微信公众号";
    self.view.backgroundColor = YZBackgroundColor;
    [self setupChilds];
    [self getData];
}

- (void)getData
{
    NSDictionary *dict = @{
                           @"type":@"PUBLIC_NUMBER",
                           @"timestamp":[YZDateTool getNowTimeTimestamp]
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlShare(@"/getQrCode") params:dict success:^(id json) {
        YZLog(@"getQrCode:%@",json);
        if (SUCCESS) {
            self.QrCodeModel = [YZQrCodeModel objectWithKeyValues:json[@"qrCode"]];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
    }];
}

- (void)setQrCodeModel:(YZQrCodeModel *)QrCodeModel
{
    _QrCodeModel = QrCodeModel;
    
    [self.codeImageView sd_setImageWithURL:[NSURL URLWithString:_QrCodeModel.url]];
    
    NSString * promptStr = _QrCodeModel.desc;
    if (YZStringIsEmpty(promptStr)) {
        self.vipcnButton.y = CGRectGetMaxY(self.codeImageView.frame) + 10;
    }else
    {
        NSMutableAttributedString * promptAttStr = [[NSMutableAttributedString alloc]initWithString:promptStr];
        [promptAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(0, promptAttStr.length)];
        [promptAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, promptAttStr.length)];
        NSMutableParagraphStyle *paragraphStyle_ = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle_.lineSpacing = 3;
        paragraphStyle_.alignment = NSTextAlignmentCenter;
        [promptAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle_ range:NSMakeRange(0, promptAttStr.length)];
        self.promptLabel.attributedText = promptAttStr;
        CGSize promptSize = [self.promptLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - YZMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.promptLabel.frame = CGRectMake(YZMargin,  CGRectGetMaxY(self.codeImageView.frame) + 10, screenWidth - YZMargin * 2, promptSize.height);
        
        self.vipcnButton.y = CGRectGetMaxY(self.promptLabel.frame) + 10;
    }
    
    self.scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(self.vipcnButton.frame) + 10);
}

- (void)setupChilds
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"如何关注？" style:UIBarButtonItemStylePlain target:self action:@selector(helpBarDidClicked)];
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH)];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
   
    //二维码
    CGFloat codeImageViewWH = 190;
    CGFloat codeImageViewX = (screenWidth - codeImageViewWH) / 2;
    UIImageView *codeImageView = [[UIImageView alloc] init];
    self.codeImageView = codeImageView;
    codeImageView.frame = CGRectMake(codeImageViewX, 30, codeImageViewWH, codeImageViewWH);
    [scrollView addSubview:codeImageView];
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    codeImageView.userInteractionEnabled = YES;
    [codeImageView addGestureRecognizer:longPress];
    
    //温馨提示
    UILabel * promptLabel = [[UILabel alloc] init];
    self.promptLabel = promptLabel;
    promptLabel.numberOfLines = 0;
    [scrollView addSubview:promptLabel];
    
    //复制
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.vipcnButton = copyBtn;
    copyBtn.backgroundColor = [UIColor whiteColor];
    [copyBtn setTitle:@"复制微信号" forState:UIControlStateNormal];
    [copyBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [copyBtn addTarget:self action:@selector(copyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    CGFloat copyBtnW = 90;
    CGFloat copyBtnH = 27;
    copyBtn.frame = CGRectMake((screenWidth - copyBtnW) / 2, CGRectGetMaxY(codeImageView.frame) + YZMargin, copyBtnW, copyBtnH);
    copyBtn.layer.masksToBounds = YES;
    copyBtn.layer.cornerRadius = 5;
    copyBtn.layer.borderWidth = 1;
    copyBtn.layer.borderColor = YZGrayLineColor.CGColor;
    [scrollView addSubview:copyBtn];
    
    scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(copyBtn.frame) + 10);
}

- (void)helpBarDidClicked
{
    YZWeChatPublicHelpViewController * weChatPublicHelpVC = [[YZWeChatPublicHelpViewController alloc] init];
    weChatPublicHelpVC.codeImage = self.codeImageView.image;
    [self.navigationController pushViewController:weChatPublicHelpVC animated:YES];
}

- (void)longPress
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"保存图片？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self saveImage];
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)saveImage
{
    UIImage *image = [UIImage imageNamed:@"weixin_code_jg"]; // 取得图片
     UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [MBProgressHUD showSuccess:@"保存成功"];
        [self performSelector:@selector(guideWeChat) withObject:self afterDelay:1.0f];
    }else
    {
        [MBProgressHUD showError:@"保存图片失败"];
    }
}

- (void)guideWeChat
{
    YZLoadHtmlFileController * updataActivityVC = [[YZLoadHtmlFileController alloc] initWithWeb:[NSString stringWithFormat:@"%@%@", baseH5Url, @"/zhongcai/html/wx-saoma.html"]];
    [self.navigationController pushViewController:updataActivityVC animated:YES];
}

- (void)copyBtnClick
{
    if (YZStringIsEmpty(self.QrCodeModel.weixin)) {
        return;
    }
    
    //复制账号
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    NSString *string = self.QrCodeModel.weixin;
    [pab setString:string];
    [MBProgressHUD showSuccess:@"复制成功"];
    [self performSelector:@selector(skipWeixin) withObject:self afterDelay:1.0f];
}

- (void)skipWeixin
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
}

@end
