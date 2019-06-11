//
//  YZIntegralCouponsCollectionViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/2/6.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZIntegralCouponsCollectionViewCell.h"

@interface YZIntegralCouponsCollectionViewCell ()

@property (nonatomic,weak) UILabel *label;

@end

@implementation YZIntegralCouponsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChilds];
    }
    return self;
}

- (void)setupChilds
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 1;
    self.layer.borderColor = YZGrayLineColor.CGColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label = label;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self addSubview:label];
}

- (void)setCouponsModel:(YZIntegralCouponsModel *)couponsModel
{
    _couponsModel = couponsModel;
    
    NSString * money = [NSString stringWithFormat:@"%@", _couponsModel.name];
    NSString * integral = [NSString stringWithFormat:@"%@分", _couponsModel.points];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", money, integral]];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:[attStr.string rangeOfString:money]];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:[attStr.string rangeOfString:integral]];
    if (_couponsModel.selected) {
        self.backgroundColor = YZBaseColor;
        self.layer.borderWidth = 0;
        self.layer.borderColor = YZBaseColor.CGColor;
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStr.length)];
    }else
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = YZGrayLineColor.CGColor;
        [attStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:[attStr.string rangeOfString:money]];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:[attStr.string rangeOfString:integral]];
    }
    self.label.attributedText = attStr;
}

@end
