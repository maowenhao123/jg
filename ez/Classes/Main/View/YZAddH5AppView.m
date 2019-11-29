//
//  YZAddH5AppView.m
//  ez
//
//  Created by dahe on 2019/11/27.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZAddH5AppView.h"

@interface YZAddH5AppView ()<UIGestureRecognizerDelegate>

@property (nonatomic,weak) UIImageView * backView;

@end

@implementation YZAddH5AppView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    self.backgroundColor = YZColor(0, 0, 0, 0.4);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidClick)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    CGFloat backViewW = 320;
    CGFloat backViewH = 510;
    UIImageView * backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backViewW, backViewH)];
    self.backView = backView;
    backView.center = self.center;
    backView.image = [UIImage imageNamed:@"addH5App_bg"];
    backView.userInteractionEnabled = YES;
    [self addSubview:backView];
    
    CGFloat closeButtonWH = 50;
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(backView.width - closeButtonWH, 0, closeButtonWH, closeButtonWH);
    [closeButton setImage:[UIImage imageNamed:@"addH5App_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(tapDidClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:closeButton];
    
    CGFloat noRemindButtonW = 130;
    CGFloat noRemindButtonH = 23;
    UIButton *noRemindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    noRemindButton.frame = CGRectMake((backView.width - noRemindButtonW) / 2, backView.height - 10 - noRemindButtonH, noRemindButtonW, noRemindButtonH);
    [noRemindButton setImage:[UIImage imageNamed:@"addH5App_No_remind"] forState:UIControlStateNormal];
    [noRemindButton setImage:[UIImage imageNamed:@"addH5App_No_remind_selected"] forState:UIControlStateSelected];
    [noRemindButton addTarget:self action:@selector(noRemindButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:noRemindButton];
    
    CGFloat addButtonW = 280;
    CGFloat addButtonH = 50;
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake((backView.width - addButtonW) / 2, noRemindButton.y - 15 - addButtonH, addButtonW, addButtonH);
    [addButton setBackgroundImage:[UIImage imageNamed:@"addH5App_button"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:addButton];
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    
    [self.backView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@"addH5App_bg"]];
}

- (void)noRemindButtonDidClick:(UIButton *)button
{
    NSString * uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary *dict = @{
                           @"uuid":uuid,
                           @"layerId": self.layerId
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlSalesManager(@"/refusedLayer") params:dict success:^(id json) {
        YZLog(@"refusedLayer：%@", json);
        if(SUCCESS)
        {
            button.selected = !button.selected;
            [self tapDidClick];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"自动登录error");
    }];
}

- (void)addButtonDidClick
{
    NSString * uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary *dict = @{
                           @"uuid":uuid
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlSalesManager(@"/getDescriptionFile") params:dict success:^(id json) {
        YZLog(@"getDescriptionFile：%@", json);
        if(SUCCESS)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:json[@"url"]]];
            [self tapDidClick];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"自动登录error");
    }];
}

- (void)tapDidClick
{
    [self removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint pos = [touch locationInView:self.backView.superview];
        if (CGRectContainsPoint(self.backView.frame, pos)) {
            return NO;
        }
    }
    return YES;
}

@end
