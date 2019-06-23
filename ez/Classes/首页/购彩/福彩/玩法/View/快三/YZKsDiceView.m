//
//  YZKsDiceView.m
//  ez
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZKsDiceView.h"

@interface YZKsDiceView ()

@property (nonatomic, strong) NSMutableArray * imageViews;

@end

@implementation YZKsDiceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)setNumber:(int)number count:(int)count
{
    self.animationImages = self.imageViews;
    self.image = [UIImage imageNamed:[NSString stringWithFormat:@"ks_dice_small_%d",number]];
    self.animationDuration = 1;
    self.animationRepeatCount = count;
    [self startAnimating];
}
- (NSMutableArray *)imageViews
{
    if (_imageViews == nil) {
        _imageViews = [NSMutableArray array];
        for (int i = 1; i < 7; i++) {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"ks_dice_gif_%d",i]];
            [_imageViews addObject:image];
        }
    }
    return _imageViews;
}
- (void)diceRandomPostionAnimationWithCount:(int)count index:(int)index
{
    __block int blockCount = count;
    [UIView animateWithDuration:animateDuration
                     animations:^{
                         self.center = [self getRandomPointWithIndex:index];
                     } completion:^(BOOL finished) {
                         if (finished)
                         {
                             blockCount--;
                             if (blockCount > 0){//位置变化次数
                                 [self diceRandomPostionAnimationWithCount:blockCount index:index];
                             }
                         }
                     }];
}
//获取一个随机位置变化
- (CGPoint)getRandomPointWithIndex:(int)index
{
//    int imageViewWH = 100;
//    int padding = 10;
//    int KWidth = screenWidth;
//    int KHeight = screenHeight;
//    CGRect rect;
//    if (index == 0) {
//        rect = CGRectMake(KWidth / 2 - imageViewWH - padding, KHeight / 2 - imageViewWH - padding, imageViewWH, imageViewWH);
//    }else if (index == 1)
//    {
//        rect = CGRectMake(KWidth / 2 + padding, KHeight / 2 - imageViewWH - padding, imageViewWH, imageViewWH);
//    }else if (index == 2)
//    {
//        rect = CGRectMake(KWidth / 2 - imageViewWH / 2, KHeight / 2 + padding, imageViewWH, imageViewWH);
//    }
//    int x = rect.origin.x + rect.size.width / 2 + arc4random() % KWidth / 4 - KWidth / 8;
//    int y = rect.origin.y + rect.size.height / 2 + arc4random() % KHeight / 3 - KHeight / 6;
//    CGPoint point = CGPointMake(x, y);
    int KWidth = screenWidth;
    int KHeight = screenHeight;
    int x = KWidth / 4 + arc4random() % KWidth / 2;
    int y = KHeight / 5 + arc4random() % KHeight * 3 / 5;
    CGPoint point = CGPointMake(x, y);
    return point;
}
@end
