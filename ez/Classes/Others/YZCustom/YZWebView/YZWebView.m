//
//  YZWebView.m
//  ez
//
//  Created by 毛文豪 on 2018/12/11.
//  Copyright © 2018 9ge. All rights reserved.
//

#import "YZWebView.h"

@interface YZWebView ()

@property (nonatomic, weak) UIView *progressView;

@end

@implementation YZWebView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupChilds];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChilds];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame configuration:(nonnull WKWebViewConfiguration *)configuration
{
    self = [super initWithFrame:frame configuration:configuration];
    if (self) {
        [self setupChilds];
    }
    return self;
}

#pragma mark - 布局视图
- (void)setupChilds
{
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 2.5)];
    self.progressView = progressView;
    progressView.backgroundColor = YZBaseColor;
    [self addSubview:progressView];
    
    [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self setProgress:self.estimatedProgress animated:YES];
    }
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    BOOL isGrowing = progress > 0.0;
    [UIView animateWithDuration:(isGrowing && animated) ? 0.27 : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.progressView.frame;
        frame.size.width = progress * self.size.width;
        self.progressView.frame = frame;
    } completion:nil];
    
    if (progress >= 1.0) {
        [UIView animateWithDuration:animated ? 0.27 : 0.0 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.progressView.alpha = 0.0;
        } completion:^(BOOL completed){
            CGRect frame = self.progressView.frame;
            frame.size.width = 0;
            self.progressView.frame = frame;
        }];
    }
    else {
        [UIView animateWithDuration:animated ? 0.27 : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.progressView.alpha = 1.0;
        } completion:nil];
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
