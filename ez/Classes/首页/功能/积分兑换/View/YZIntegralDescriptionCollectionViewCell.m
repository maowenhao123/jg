//
//  YZIntegralDescriptionCollectionViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/2/5.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZIntegralDescriptionCollectionViewCell.h"

@interface YZIntegralDescriptionCollectionViewCell ()

@property (nonatomic,weak) UILabel *label;

@end

@implementation YZIntegralDescriptionCollectionViewCell

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
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label = label;
    label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    label.textColor = YZGrayTextColor;
    label.numberOfLines = 0;
    [self addSubview:label];
}

- (void)setDesc:(NSString *)desc
{
    _desc = desc;
    
    self.label.text = _desc;
    CGSize size = [self.label.text sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(24)] maxSize:CGSizeMake(screenWidth - 2 * 15, MAXFLOAT)];
    self.label.frame = CGRectMake(15, 0, size.width, size.height);
}

@end
