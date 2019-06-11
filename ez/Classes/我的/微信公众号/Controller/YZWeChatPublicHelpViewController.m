//
//  YZWeChatPublicHelpViewController.m
//  ez
//
//  Created by 毛文豪 on 2017/8/12.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZWeChatPublicHelpViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZDateTool.h"

@interface YZWeChatPublicHelpViewController ()

@end

@implementation YZWeChatPublicHelpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"如何关注公众号";
    self.view.backgroundColor = YZBackgroundColor;
    [self setupChilds];
}
- (void)setupChilds
{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH)];
    [self.view addSubview:scrollView];
    
    UILabel * promptLabel = [[UILabel alloc]init];
    promptLabel.numberOfLines = 0;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    NSString * promptStr = @"1. 长按下方二维码保存图片至相册，打开微信扫一扫，从相册中选取保存的二维码图片扫描即可关注\n2. 直接使用手机扫描下方二维码进行关注\n3. 打开微信点击右上角“添加朋友”搜索公众号：jiugecp进行关注";
    NSMutableAttributedString * promptAttStr = [[NSMutableAttributedString alloc]initWithString:promptStr];
    [promptAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(0, promptAttStr.length)];
    [promptAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, promptAttStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    [promptAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, promptAttStr.length)];
    promptLabel.attributedText = promptAttStr;
    CGSize promptSize = [promptLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - YZMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    promptLabel.frame = CGRectMake(YZMargin, 15, screenWidth - YZMargin * 2, promptSize.height);
    [scrollView addSubview:promptLabel];
    
    //二维码
    CGFloat codeImageViewWH = 190;
    CGFloat codeImageViewX = (screenWidth - codeImageViewWH) / 2;
    UIImageView *codeImageView = [[UIImageView alloc] init];
    codeImageView.image = self.codeImage;
    codeImageView.frame = CGRectMake(codeImageViewX, CGRectGetMaxY(promptLabel.frame) + 20, codeImageViewWH, codeImageViewWH);
    [scrollView addSubview:codeImageView];
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    codeImageView.userInteractionEnabled = YES;
    [codeImageView addGestureRecognizer:longPress];
    
    scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(codeImageView.frame) + 10);
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
    UIImage *image = self.codeImage; // 取得图片
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

@end
