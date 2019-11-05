//
//  YZksHistoryWinNumberView.m
//  ez
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZksHistoryWinNumberView.h"

#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height

@interface YZksHistoryWinNumberView ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel * winNumberLabel;
@property (nonatomic, weak) UILabel * countLabel;

@end

@implementation YZksHistoryWinNumberView

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
    NSString *imageName = @"redBg";
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    self.imageView = imageView;
    imageView.hidden = YES;
    imageView.frame = self.bounds;
    [self addSubview:imageView];
    
    UILabel * winNumberLabel = [[UILabel alloc]initWithFrame:self.bounds];
    self.winNumberLabel = winNumberLabel;
    winNumberLabel.hidden = YES;
    winNumberLabel.font = [UIFont systemFontOfSize:13];
    winNumberLabel.textColor = [UIColor whiteColor];
    winNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:winNumberLabel];
    
    UILabel * countLabel = [[UILabel alloc]initWithFrame:CGRectMake(KWidth - 9, 1, 8, 8)];
    self.countLabel = countLabel;
    countLabel.hidden = YES;
    countLabel.backgroundColor = [UIColor yellowColor];
    countLabel.textColor = [UIColor redColor];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.font = [UIFont systemFontOfSize:7.0f];
    countLabel.clipsToBounds = YES;
    countLabel.layer.cornerRadius = 4;
    [self addSubview:countLabel];
}
- (void)setWinNumber:(NSString *)winNumber
{
    self.imageView.hidden = NO;
    self.winNumberLabel.hidden = NO;
    self.winNumberLabel.text = winNumber;
}
- (void)setCount:(NSString *)count
{
    self.countLabel.hidden = NO;
    self.countLabel.text = count;
}
@end
