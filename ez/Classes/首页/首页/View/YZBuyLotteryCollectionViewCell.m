//
//  YZBuyLotteryCollectionViewCell.m
//  ez
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define logoWH 50
#define cellH 90

#import "YZBuyLotteryCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "YZSupView.h"

@interface YZBuyLotteryCollectionViewCell ()

@property (nonatomic, weak) UIImageView *logoImageView;//logo
@property (nonatomic, weak) UILabel *titleLabel;//玩法
@property (nonatomic, weak) UILabel *descriptionLabel;//描述
@property (nonatomic, weak) YZSupView *supView;//角标
@property (nonatomic, weak) UIImageView *supImageView;//角标图片
@property (nonatomic, weak) UIView *line1;//下分割线

@end

@implementation YZBuyLotteryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView * selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = YZColor(217, 217, 217, 1);//被选的颜色
        self.selectedBackgroundView = selectedBackgroundView;
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    //logo
    UIImageView *logoImageView = [[UIImageView alloc]init];
    self.logoImageView = logoImageView;
    logoImageView.frame = CGRectMake(10, 40 - logoWH / 2, logoWH, logoWH);
    [self addSubview:logoImageView];
    
    //玩法
    UILabel * titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(35)];
    titleLabel.textColor = YZBlackTextColor;
    [self addSubview:titleLabel];
    
    //描述
    UILabel * descriptionLabel = [[UILabel alloc]init];
    self.descriptionLabel = descriptionLabel;
    descriptionLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    descriptionLabel.textColor = YZGrayTextColor;
    [self addSubview:descriptionLabel];
    
    //角标
    UIImageView *supImageView = [[UIImageView alloc]init];
    self.supImageView = supImageView;
    supImageView.hidden = YES;
    [self addSubview:supImageView];
    
    //分割线
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, cellH - 1, screenWidth / 2, 1)];
    self.line1 = line1;
    line1.backgroundColor = YZWhiteLineColor;
    [self addSubview:line1];
    
    CGFloat padding = 15;
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(screenWidth / 2 - 1, padding, 1, cellH - 2 * padding)];
    self.line2 = line2;
    line2.backgroundColor = YZWhiteLineColor;
    [self addSubview:line2];
}
- (void)setStatus:(YZBuyLotteryCellStatus *)status
{
    _status = status;
    for (UIView * subView in self.subviews) {
        if ([subView isKindOfClass:[YZSupView class]]) {
            [subView removeFromSuperview];
        }
    }

    YZSupView *supView = [[YZSupView alloc]init];
    self.supView = supView;
    supView.backgroundColor = [UIColor clearColor];
    supView.hidden = YES;
    [self addSubview:supView];
    
    //icon图标
    self.logoImageView.image = nil;
    if ([status.icon[@"type"] isEqualToString:@"NORMAL"]) {//普通
        if ([_status.gameId isEqualToString:@"TT"]) {
            self.logoImageView.image = [UIImage imageNamed:@"scheme_setmeal"];
        }else
        {
            self.logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",status.gameId]];
        }
    }else if ([status.icon[@"type"] isEqualToString:@"PRIZE"])//今日开奖
    {
        self.logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"today_%@",status.gameId]];
        if ([status.gameId isEqualToString:@"T54"]) {//T53和T54用的一个图片
            self.logoImageView.image = [UIImage imageNamed:@"today_T53"];
        }
    }else if ([status.icon[@"type"] isEqualToString:@"WEB"])//web
    {
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:status.icon[@"url"]]];
    }
    
    //彩种名称
    self.titleLabel.text = status.gameName;
    //彩种描述
    self.descriptionLabel.text = nil;
    self.descriptionLabel.textColor = YZGrayTextColor;
    if ([status.title[@"type"] isEqualToString:@"TEXT"]) {//文本
        NSString * descriptionStr = status.title[@"text"][@"content"];
        if ([descriptionStr isKindOfClass:[NSString class]]) {//是字符串
            self.descriptionLabel.text = descriptionStr;
        }
        NSString * colorStr = status.title[@"text"][@"color"];
        if ([colorStr isKindOfClass:[NSString class]]) {//是字符串
            colorStr = [colorStr stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
            unsigned long colorInt = strtoul([colorStr UTF8String],0,0);//转换成16进制
            self.descriptionLabel.textColor = UIColorFromRGB(colorInt);
        }
    }else if ([status.title[@"type"] isEqualToString:@"HTML"])//html
    {
        NSString * descriptionHtml = status.title[@"html"];
        if(!YZStringIsEmpty(descriptionHtml)){
            NSDictionary *optoins = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
            NSData *data= [descriptionHtml dataUsingEncoding:NSUnicodeStringEncoding];
            NSError * error;
            NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:data options:optoins documentAttributes:nil error:&error];
            if (!error) {
                NSMutableAttributedString * muAttributeString = [[NSMutableAttributedString alloc]initWithAttributedString:attributeString];
                //字体大小
                [muAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(0, muAttributeString.length)];
                //段落格式
                NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
                [ps setLineBreakMode:NSLineBreakByTruncatingTail];
                [muAttributeString addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, muAttributeString.length)];
                self.descriptionLabel.attributedText = muAttributeString;
            }
        }
    }
    
    //角标
    if ([status.gameName isEqualToString:@"快乐11选5"]) {
        NSLog(@"%@", status.sup);
    }
    self.supImageView.hidden = YES;
    self.supView.hidden = YES;
    if ([status.sup[@"type"] isEqualToString:@"NORMAL"]) {//文本
        NSString * supStr = status.sup[@"text"];
        if ([supStr isKindOfClass:[NSString class]]) {//是字符串
            if (!YZStringIsEmpty(supStr)) {
                self.supView.text = supStr;
                self.supView.hidden = NO;
            }
        }
    }else if ([status.sup[@"type"] isEqualToString:@"WEB"])//web
    {
        [self.supImageView sd_setImageWithURL:[NSURL URLWithString:status.sup[@"url"]]];
        self.supImageView.hidden = NO;
    }
    
    //frame
    CGSize titleSize = [self.titleLabel.text sizeWithLabelFont:self.titleLabel.font];
    CGSize descriptionSize;
    if ([status.title[@"type"] isEqualToString:@"TEXT"]) {//文本
       descriptionSize = [self.descriptionLabel.text sizeWithLabelFont:self.descriptionLabel.font];
    }else if ([status.title[@"type"] isEqualToString:@"HTML"])//html
    {
        descriptionSize = [self.descriptionLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth, screenHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    }
    
    CGFloat titleLabelY = (cellH - titleSize.height - descriptionSize.height - 10) / 2;
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 10, titleLabelY, titleSize.width, titleSize.height);
    self.descriptionLabel.frame = CGRectMake(self.titleLabel.x, CGRectGetMaxY(self.titleLabel.frame) + 10, screenWidth / 2 - self.titleLabel.x, descriptionSize.height);
    //角标
    self.supView.frame = CGRectZero;
    self.supImageView.frame = CGRectZero;
    if ([status.sup[@"type"] isEqualToString:@"NORMAL"] && !YZStringIsEmpty(status.sup[@"text"])) {//文本
        CGSize supSize = [self.supView.text sizeWithLabelFont:[UIFont systemFontOfSize:YZGetFontSize(20)]];
        int supViewW = (int)(supSize.width + 0.5) + 9;//加0.5四舍五入
        self.supView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 1, 0, supViewW, 15);
        self.supView.centerY = self.titleLabel.centerY;
    }else if ([status.sup[@"type"] isEqualToString:@"WEB"])//图片
    {
        self.supImageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 1, 0, 25, 15);
        self.supImageView.centerY = self.titleLabel.centerY;
    }
}

@end
