//
//  YZBasketBallPassWayView.m
//  ez
//
//  Created by 毛文豪 on 2018/5/29.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZBasketBallPassWayView.h"
#import "YZFbasketBallTool.h"

@interface YZBasketBallPassWayView()
{
    int _maxWayCount;
}
@property (nonatomic, strong) NSArray *freeWayTitles;
@property (nonatomic, strong) NSArray *moreWayTitles;
@property (nonatomic, strong) NSMutableArray *statusArray;

@end

@implementation YZBasketBallPassWayView

- (instancetype)initWithFrame:(CGRect)frame statusArray:(NSMutableArray *)statusArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.statusArray = statusArray;
        _maxWayCount = [YZFbasketBallTool getMaxWayCountByStatusArray:statusArray];
        [self setupChilds];
    }
    return self;
}

#pragma mark - 布局视图
- (void)setupChilds
{
    CGFloat padding = 10;
    int maxColums = 4;
    UIButton *lastBtn;
    CGFloat btnH = 30;
    CGFloat btnW = (self.width - maxColums * padding) / maxColums;
    CGFloat labelH = 30;
    UILabel *lastLabel;
    UIScrollView *scrollView;
    for(int i = 0;i < 2;i++)//2个label
    {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        label.backgroundColor = YZColor(240, 240, 240, 1);
        label.textColor = YZBlackTextColor;
        label.frame = CGRectMake(0, 0, self.width, labelH);
        lastLabel = label;
        [self addSubview:label];
        if(i == 0)
        {
            label.text = @"  自由过关";
            NSArray *titles = self.currentFreeWayTitles;
            for(int i = 0;i < titles.count;i++)//自由过关下面的按钮
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                lastBtn = btn;
                btn.tag = i;
                btn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
                btn.layer.borderWidth = 0.5;
                btn.layer.borderColor = YZColor(0, 0, 0, 0.2).CGColor;
                [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
                [btn setTitleColor:YZGrayTextColor forState:UIControlStateDisabled];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
                [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
                [btn setTitle:titles[i] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(freePassWayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                CGFloat btnX = padding / 2 + (i % maxColums) * (btnW + padding);
                CGFloat btnY = CGRectGetMaxY(lastLabel.frame) + padding + (i / maxColums) * (btnH + padding);
                btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
                [self addSubview:btn];
                if (i == titles.count - 1) {
                    btn.selected = YES;
                    [self.selFreeWayButtons addObject:btn];
                }
            }
        }else if (i == 1)
        {
            if(self.statusArray.count < 3)
            {
                [label removeFromSuperview];
                break;
            }
            label.text = @"  多串过关";
            label.y = CGRectGetMaxY(lastBtn.frame) + padding;
            scrollView = [[UIScrollView alloc] init];
            CGFloat scrollViewY = CGRectGetMaxY(label.frame);
            CGFloat scrollViewH = 160;
            scrollView.frame = CGRectMake(0, scrollViewY, self.width, scrollViewH);
            [self addSubview:scrollView];
            
            //取出相应地多串过关标题
            NSArray *titles = self.currentMoreWayTitles;
            for(int i = 0;i < titles.count;i++)//多串过关下面的按钮
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

                lastBtn = btn;
                btn.tag = i;
                btn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
                btn.layer.borderWidth = 0.5;
                btn.layer.borderColor = YZColor(0, 0, 0, 0.2).CGColor;
                [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
                [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
                [btn setTitle:titles[i] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(morePassWayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                CGFloat btnX = padding / 2 + (i % maxColums) * (btnW + padding);
                CGFloat btnY = padding + (i / maxColums) * (btnH + padding);
                btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
                [scrollView addSubview:btn];
            }
           
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, CGRectGetMaxY(lastBtn.frame) + padding);
            //重新设置scrollview的高度
            if((CGRectGetMaxY(lastBtn.frame) + padding) < scrollViewH)
            {
                scrollView.height = CGRectGetMaxY(lastBtn.frame) + padding;
            }
        }
    }
    
    CGFloat maxY = 0;
    if(scrollView)
    {
        maxY = CGRectGetMaxY(scrollView.frame);
    }else//没有scrollview
    {
        maxY = CGRectGetMaxY(lastBtn.frame) + padding;
    }
    self.height = maxY;
}

- (void)freePassWayBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [self.selFreeWayButtons addObject:button];
    }else
    {
        [self.selFreeWayButtons removeObject:button];
    }
}

- (void)morePassWayBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [self.selMoreWayButtons addObject:button];
    }else
    {
        [self.selMoreWayButtons removeObject:button];
    }
}

//每次get都是最新的数据
- (NSMutableArray *)currentFreeWayTitles
{
    NSMutableArray * currentFreeWayTitles = [NSMutableArray array];
    if(self.statusArray.count >= 2)
    {
        if(self.statusArray.count > _maxWayCount) {
            currentFreeWayTitles = [[self.freeWayTitles subarrayWithRange:NSMakeRange(0, _maxWayCount - 1)] mutableCopy];
        }else
        {
            currentFreeWayTitles = [[self.freeWayTitles subarrayWithRange:NSMakeRange(0, self.statusArray.count - 1)] mutableCopy];
        }
    }else
    {
        currentFreeWayTitles = [NSMutableArray array];
    }
    return currentFreeWayTitles;
}

- (NSArray *)currentMoreWayTitles
{
    NSMutableArray * currentMoreWayTitles = [NSMutableArray array];
    
    if(self.statusArray.count >= _maxWayCount)
    {
        for(int i = 0; i < self.moreWayTitles.count; i++)
        {
            NSString *str = self.moreWayTitles[i];
            if([str hasPrefix:[NSString stringWithFormat:@"%d",_maxWayCount]])
            {
                currentMoreWayTitles = [[self.moreWayTitles subarrayWithRange:NSMakeRange(0, i + 1)] mutableCopy];
            }
        }
    }else
    {
        for(int i = 0;i < self.moreWayTitles.count;i++)
        {
            NSString *str = self.moreWayTitles[i];
            if([str hasPrefix:[NSString stringWithFormat:@"%ld",(unsigned long)self.statusArray.count]])
            {
                currentMoreWayTitles = [[self.moreWayTitles subarrayWithRange:NSMakeRange(0, i + 1)] mutableCopy];
            }
        }
    }
    return currentMoreWayTitles;
}

#pragma mark - 初始化
- (NSMutableArray *)selFreeWayButtons
{
    if (!_selFreeWayButtons) {
        _selFreeWayButtons = [NSMutableArray array];
    }
    return _selFreeWayButtons;
}

- (NSMutableArray *)selMoreWayButtons
{
    if (!_selMoreWayButtons) {
        _selMoreWayButtons = [NSMutableArray array];
    }
    return _selMoreWayButtons;
}

- (NSArray *)freeWayTitles
{
    if (!_freeWayTitles) {
        _freeWayTitles = @[@"2串1", @"3串1", @"4串1", @"5串1", @"6串1", @"7串1", @"8串1"];
    }
    return _freeWayTitles;
}

- (NSArray *)moreWayTitles
{
    if (!_moreWayTitles) {
        _moreWayTitles = @[@"3串3", @"3串4", @"4串4", @"4串5", @"4串6", @"4串11", @"5串5",@"5串6", @"5串10", @"5串16", @"5串20", @"5串26", @"6串6", @"6串7",@"6串15", @"6串20", @"6串22", @"6串35", @"6串42", @"6串50", @"6串57",@"7串7", @"7串8", @"7串21", @"7串35", @"7串120", @"8串8", @"8串9",@"8串28", @"8串56", @"8串70", @"8串247"];
    }
    return _moreWayTitles;
}

@end
