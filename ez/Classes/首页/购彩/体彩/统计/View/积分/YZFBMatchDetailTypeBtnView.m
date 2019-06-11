//
//  YZFBMatchDetailTypeBtnView.m
//  ez
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZFBMatchDetailTypeBtnView.h"
#import "UIImage+YZ.h"

@interface YZFBMatchDetailTypeBtnView ()

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation YZFBMatchDetailTypeBtnView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleArray = titleArray;
        [self setupChildViews];
    }
    return self;
}
- (void)setupChildViews
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:self.titleArray];
    self.segmentedControl = segmentedControl;
    segmentedControl.frame = self.bounds;
    segmentedControl.tintColor = YZMDGreenColor;
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self
                         action:@selector(typeSegmentControlAction:)
               forControlEvents:UIControlEventValueChanged];
    [self addSubview:segmentedControl];
}
//类型按钮点击
- (void)typeSegmentControlAction:(UISegmentedControl *)segmentedControl
{
   if (_delegate && [_delegate respondsToSelector:@selector(typeSegmentControlSelectedIndex:)]) {
        [_delegate typeSegmentControlSelectedIndex:segmentedControl.selectedSegmentIndex];
    }
}
@end
