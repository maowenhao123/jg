//
//  YZIntegralCountCollectionViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/2/5.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZIntegralCountCollectionViewCell.h"

@interface YZIntegralCountCollectionViewCell ()

@property (nonatomic,weak) UILabel *label;

@end

@implementation YZIntegralCountCollectionViewCell

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
    self.layer.cornerRadius = 2;
    self.layer.borderWidth = 1;
    self.layer.borderColor = YZGrayLineColor.CGColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label = label;
    label.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
}

- (void)setCount:(NSInteger)count
{
    _count = count;
    
    self.label.text = [NSString stringWithFormat:@"%ld张", _count];
}

- (void)setCustomSelected:(BOOL)customSelected
{
    _customSelected = customSelected;
    
    if (_customSelected) {
        self.label.textColor = [UIColor whiteColor];
        self.backgroundColor = YZBaseColor;
        self.layer.borderWidth = 0;
        self.layer.borderColor = YZBaseColor.CGColor;
    }else
    {
        self.label.textColor = YZBlackTextColor;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = YZGrayLineColor.CGColor;
    }
}

@end
