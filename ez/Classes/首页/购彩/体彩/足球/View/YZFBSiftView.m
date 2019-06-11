//
//  YZFBSiftView.m
//  ez
//
//  Created by 毛文豪 on 2019/5/10.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZFBSiftView.h"

@interface YZFBSiftView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *matchNameArray;
@property (nonatomic, strong)  NSMutableArray *matchNameBtns;//放比赛名称按钮的数组
@property (nonatomic, strong)  NSMutableArray *currentMatchNames;//当前比赛名称的数组
@property (nonatomic, weak) UIView *siftView;
@property (nonatomic, assign) CGFloat siftViewH;

@end

@implementation YZFBSiftView

- (instancetype)initWithFrame:(CGRect)frame matchNameArray:(NSArray *)matchNameArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.matchNameArray = matchNameArray;
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    //筛选view
    UIView *siftView = [[UIView alloc] init];
    self.siftView = siftView;
    siftView.backgroundColor = [UIColor whiteColor];
    siftView.layer.masksToBounds = YES;
    [self addSubview:siftView];
    
    //三个按钮的bgview
    int maxColums = 3;//每行几个
    CGFloat btnH = 35;
    int padding = 5;
    UIView *topBtnBgView = [[UIView alloc] init];
    topBtnBgView.backgroundColor = YZColor(240, 240, 240, 1);//灰色
    topBtnBgView.frame = CGRectMake(0, padding * 2, screenWidth, btnH + 10);
    [siftView addSubview:topBtnBgView];
    
    //三个按钮
    int topBtnCount = 3;
    NSArray *topBtnTitles = @[@"全选", @"反选", @"五大联赛"];
    for(int i = 0; i < topBtnCount; i++)
    {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"ft_btn_pressed"] forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        CGFloat btnW = (screenWidth - topBtnCount * 2 * padding) / topBtnCount;
        CGFloat btnX = padding + i *(btnW + 2 * padding);
        btn.frame = CGRectMake(btnX, 5, btnW,btnH);
        [btn setTitle:topBtnTitles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(siftSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topBtnBgView addSubview:btn];
    }
    
    //比赛名称按钮
    int btnCount = (int)self.matchNameArray.count;
    UIButton *lastBtn;
    NSMutableArray *matchNameBtns = [NSMutableArray array];
    for(int i = 0; i < btnCount; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        lastBtn = btn;
        btn.tag = i;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitle:self.matchNameArray[i] forState:UIControlStateNormal];//设置比赛名称
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        btn.selected = YES;
        CGFloat btnW = (screenWidth - maxColums * 2 * padding) / maxColums;
        CGFloat btnX = padding + (i % maxColums) * (btnW + 2 * padding);
        CGFloat btnY = CGRectGetMaxY(topBtnBgView.frame) + 2 * padding + (i / maxColums) * (btnH + 2 * padding);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn addTarget:self action:@selector(matchNameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [siftView addSubview:btn];
        
        [matchNameBtns addObject:btn];
    }
    self.matchNameBtns = matchNameBtns;//赋值给比赛按钮数组
    
    //确认和取消按钮
    NSArray *confirmTitles = @[@"取消",@"确认"];
    for(int i = 0;i < 2;i++)
    {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        CGFloat btnW = (screenWidth - 2 * 2 * padding) / 2;
        CGFloat btnX = padding + i * (btnW + 2 * padding);
        CGFloat btnY = CGRectGetMaxY(lastBtn.frame) + btnH;
        btn.frame = CGRectMake(btnX, btnY, btnW,btnH);
        btn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
        [btn setTitle:confirmTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"ft_btn_pressed"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [siftView addSubview:btn];
    }
    self.siftViewH = CGRectGetMaxY(lastBtn.frame) + 2 * btnH + 10;
    siftView.frame = CGRectMake(0, statusBarH + navBarH, screenWidth, 0);
}

//筛选面板上面的三个按钮
- (void)siftSelectBtnClick:(UIButton *)btn
{
    if(btn.tag == 0)//全选按钮
    {
        //所有按钮选中
        for(UIButton *btn in self.matchNameBtns)
        {
            btn.selected = YES;
        }
    }else if(btn.tag == 1)//反选按钮
    {
        for(UIButton *btn in self.matchNameBtns)
        {
            btn.selected = !btn.selected;//反选
        }
    }else//五大联赛按钮
    {
        for(UIButton *btn in self.matchNameBtns)
        {
            NSArray *fiveNames = @[@"德甲", @"德国甲级联赛", @"法甲", @"法国甲级联赛", @"西甲", @"西班牙甲级联赛", @"英超", @"英格兰超级联赛", @"意甲", @"意大利甲级联赛"];
            btn.selected = [fiveNames containsObject:btn.currentTitle];
        }
    }
}

//比赛名称按钮点击
- (void)matchNameBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

//筛选面板的取消和确认按钮
- (void)confirmClick:(UIButton *)btn
{
    [self hidden];
    //获取已选比赛名称
    NSMutableArray *selectedMatchNames = [NSMutableArray array];
    for(UIButton *btn in self.matchNameBtns)
    {
        if(btn.isSelected)
        {
            [selectedMatchNames addObject:btn.currentTitle];
        }
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(siftDidClickWithSelectedMatchNames:)])
    {
        [_delegate siftDidClickWithSelectedMatchNames:selectedMatchNames];
    }
}

- (void)show
{
    self.hidden = NO;
    
    [UIView animateWithDuration:animateDuration animations:^{
        self.siftView.height = self.siftViewH;
    }];
}

- (void)hidden
{
    [UIView animateWithDuration:animateDuration animations:^{
        self.siftView.height = 0;
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.siftView) {
            CGPoint pos = [touch locationInView:self.siftView.superview];
            if (CGRectContainsPoint(self.siftView.frame, pos)) {
                return NO;
            }
        }
    }
    return YES;
}

@end
