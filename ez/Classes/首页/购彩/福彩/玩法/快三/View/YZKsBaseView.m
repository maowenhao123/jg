//
//  YZKsBaseView.m
//  ez
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZKsBaseView.h"
#import "YZKsBtn.h"
#import "YZKsBottomBtn.h"

@implementation YZKsBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        
        //背景
        UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.bgImageView = bgImageView;
        bgImageView.image = [UIImage imageNamed:@"ks_bg"];
        [self addSubview:bgImageView];
    
    }
    return self;
}
- (void)setContentSizeByMaxY:(CGFloat)maxY
{
    self.contentSize = CGSizeMake(screenWidth, maxY + 40);
    if (maxY + 40 > self.height) {
        self.bgImageView.frame = CGRectMake(0, 0, screenWidth, maxY + 40);
    }
}
#pragma mark - 选择对应的按钮
- (void)chooseNumberByTags:(NSMutableArray *)tags
{

}

#pragma mark - 删除所有按钮的选中状态
- (void)deleteAllSelectedNumbersState
{
    
}

@end
