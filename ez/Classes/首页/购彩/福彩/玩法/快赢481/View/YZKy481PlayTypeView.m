//
//  YZKy481PlayTypeView.m
//  ez
//
//  Created by dahe on 2019/11/5.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481PlayTypeView.h"

@interface YZKy481PlayTypeView ()<UIGestureRecognizerDelegate>
{
    NSDictionary *_playTypeBtnTitleDic;
}

@property (nonatomic, weak) UIView *playTypeView;

@end

@implementation YZKy481PlayTypeView

- (instancetype)initWithFrame:(CGRect)frame selectedPlayTypeBtnTag:(NSInteger)selectedPlayTypeBtnTag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedPlayTypeBtnTag = selectedPlayTypeBtnTag;
        _playTypeBtnTitleDic = @{
                                @"任选": @[@"任选一", @"任选二", @"任选三", @"任选二全包", @"任选二万能两码", @"任选三全包"],
                                @"直选": @[@"直选"],
                                @"组选": @[@"组选4", @"组选6", @"组选12", @"组选24"],
                                @"283": @[@"三不重", @"三不重胆拖", @"二带一单式", @"二带一包单", @"二带一包对", @"二带一包号", @"包2", @"包3", @"豹子", @"形态", @"拖拉机"]
                                };
        [self setupSonChilds];
    }
    return self;
}

#pragma mark - 布局子视图
- (void)setupSonChilds
{
    self.backgroundColor = YZColor(0, 0, 0, 0.4);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    //玩法view
    UIView *playTypeView = [[UIView alloc] init];
    self.playTypeView = playTypeView;
    playTypeView.backgroundColor = [UIColor whiteColor];
    playTypeView.layer.cornerRadius = 5;
    playTypeView.clipsToBounds = YES;
    CGFloat playTypeViewW = screenWidth - 2 * YZMargin;
    playTypeView.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.5);
    [self addSubview:playTypeView];
    
    int maxColums = 3;
    CGFloat padding = 10;
    CGFloat labelH = 35;
    CGFloat btnH = 40;
    UIButton *lastBtn;
    UILabel *lastLabel;
    int tag = 0;
    NSArray *playTypeBtnTitles = @[@"任选", @"直选", @"组选", @"283"];
    for(int i = 0; i < playTypeBtnTitles.count; i++)
    {
        NSString * key = playTypeBtnTitles[i];
        NSArray * value = _playTypeBtnTitleDic[key];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(32)];
        label.backgroundColor = YZColor(240, 240, 240, 1);
        label.textColor = YZBlackTextColor;
        label.text = key;
        label.textAlignment = NSTextAlignmentCenter;
        label.frame =CGRectMake(padding, padding + CGRectGetMaxY(lastBtn.frame), playTypeViewW - 2 * padding, labelH);
        lastLabel = label;
        [playTypeView addSubview:label];
        
        for (int j = 0; j < value.count; j++) {
           //玩法按钮
           UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
           btn.tag = tag;
           [btn setTitle:value[j] forState:UIControlStateNormal];
           [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
           [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
           [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
           btn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
           btn.titleLabel.numberOfLines = 0;
           btn.titleLabel.textAlignment = NSTextAlignmentCenter;
           [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
           [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = YZColor(0, 0, 0, 0.2).CGColor;
           if(self.selectedPlayTypeBtnTag == i * 100 + j)//有就选择相应地按钮
           {
                btn.selected = YES;
           }
           CGFloat btnW = (playTypeViewW - 2 * padding) / maxColums;
           CGFloat btnX = padding + (j % maxColums) * btnW;
           CGFloat btnY =  CGRectGetMaxY(lastLabel.frame) + padding + (j / maxColums) * btnH;
           btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
           [btn addTarget:self action:@selector(playTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
           int selectedPlayTypeBtnTag = [YZUserDefaultTool getIntForKey:@"selectedky481PlayTypeBtnTag"];//没有存储，取出来默认是0
           if(selectedPlayTypeBtnTag == tag)//有就选择相应地按钮
           {
               btn.selected = YES;
           }
            [playTypeView addSubview:btn];
            
           lastBtn = btn;
           tag++;
        }
    }
    CGFloat playTypeViewH = CGRectGetMaxY(lastBtn.frame) + padding;
    playTypeView.bounds = CGRectMake(0, 0, playTypeViewW, playTypeViewH);
    
    self.hidden = YES;
}

- (void)setSelectedPlayTypeBtnTag:(NSInteger)selectedPlayTypeBtnTag
{
    _selectedPlayTypeBtnTag = selectedPlayTypeBtnTag;
    
    for (UIView *subView in self.playTypeView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)subView;
            button.selected = button.tag == _selectedPlayTypeBtnTag;
        }
    }
}

#pragma mark -  按钮点击
- (void)playTypeBtn:(UIButton *)btn
{
    if(btn.tag == self.selectedPlayTypeBtnTag)//一样就不动
    {
        [self hidden];
        return;
    }
    
    for (UIView *subView in self.playTypeView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)subView;
            button.selected = NO;
        }
    }
    btn.selected = YES;
    self.selectedPlayTypeBtnTag = btn.tag;
    [self hidden];
    
    if(_delegate && [_delegate respondsToSelector:@selector(playTypeDidClickBtn:)])
    {
        [_delegate playTypeDidClickBtn:btn];
    }
}

- (void)show
{
    self.hidden = NO;
    
    self.playTypeView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
        self.titleBtn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
        self.playTypeView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)hidden
{
    [UIView animateWithDuration:animateDuration animations:^{
        self.titleBtn.imageView.transform = CGAffineTransformIdentity;
    }];
    
    self.hidden = YES;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.playTypeView) {
            CGPoint pos = [touch locationInView:self.playTypeView.superview];
            if (CGRectContainsPoint(self.playTypeView.frame, pos)) {
                return NO;
            }
        }
    }
    return YES;
}

@end
