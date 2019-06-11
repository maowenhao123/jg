//
//  YZCycleScrollViewCollectionViewCell.m
//  ez
//
//  Created by apple on 16/12/29.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define cycleScrollViewH 27

#import "YZCycleScrollViewCollectionViewCell.h"
#import "YZGameIdViewController.h"
#import "YZCycleScrollView.h"

@interface YZCycleScrollViewCollectionViewCell ()

@property (nonatomic, weak) UIImageView * goldImageView;
@property (nonatomic, strong) YZCycleScrollView *cycleScrollView;

@end

@implementation YZCycleScrollViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZBackgroundColor;
        [self setupChilds];
    }
    return self;
}

- (void)setCycleDatas:(NSArray *)cycleDatas
{
    _cycleDatas = cycleDatas;
    self.goldImageView.hidden = _cycleDatas.count == 0;
    self.cycleScrollView.titleArray = [self getMessagesByDatas:_cycleDatas];
}

- (NSArray *)getMessagesByDatas:(NSArray *)datas
{
    NSMutableArray * messages = [NSMutableArray array];
    for (YZNoticeStatus * status in datas) {
        NSString * message = status.message;
        if (!YZStringIsEmpty(message)) {
            [messages addObject:message];
        }
    }
    if (messages.count > 0) {
        self.goldImageView.hidden = NO;
    }else
    {
        self.goldImageView.hidden = YES;
    }
    return messages;
}

#pragma mark - 布局视图
- (void)setupChilds
{
    //金币
    UIImageView * goldImageView = [[UIImageView alloc]init];
    self.goldImageView = goldImageView;
    goldImageView.image = [UIImage imageNamed:@"homePage_gold"];
    goldImageView.frame = CGRectMake(YZMargin, (cycleScrollViewH - 13) / 2, 16, 13);
    goldImageView.hidden = YES;
    [self addSubview:goldImageView];
    
    //轮播的文字
    YZCycleScrollView * cycleScrollView = [[YZCycleScrollView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(goldImageView.frame) + 3, 0, screenWidth - CGRectGetMaxX(goldImageView.frame) - 3, cycleScrollViewH) titleArray:nil animationDuration:2.5f];
    self.cycleScrollView = cycleScrollView;
    //点击事件
    cycleScrollView.TapActionBlock = ^(NSInteger pageIndex){
        if (pageIndex >= self.cycleDatas.count) return;
        YZNoticeStatus * status = self.cycleDatas[pageIndex];
        NSString * gameId = status.gameId;
        YZGameIdViewController *destVc = (YZGameIdViewController *)[[[YZTool gameDestClassDict][gameId] alloc] initWithGameId:gameId];
        [self.viewController.navigationController pushViewController:destVc animated:YES];
    };
    [self addSubview:cycleScrollView];
}

@end
