//
//  YZKy481BaseView.m
//  ez
//
//  Created by dahe on 2019/12/30.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481BaseView.h"

@interface YZKy481BaseView ()

@end

@implementation YZKy481BaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZBackgroundColor;
        [self setupChildViews];
    }
    return self;
}

#pragma mark - 布局子视图
- (void)setupChildViews
{
    //标题文字
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YZMargin, 10, screenWidth - 2 * YZMargin, 20)];
    self.titleLabel = titleLabel;
    titleLabel.textColor = YZBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [self addSubview:titleLabel];    
}

#pragma mark - Setting
- (void)setStatus:(YZSelectBallCellStatus *)status
{
    _status = status;
    
    self.titleLabel.attributedText = _status.title;
}

- (void)setSelectedPlayTypeBtnTag:(NSInteger)selectedPlayTypeBtnTag
{
    _selectedPlayTypeBtnTag = selectedPlayTypeBtnTag;
    
    [self setSelectedPlayTypeBtnTagWith:_selectedPlayTypeBtnTag];
}

- (void)setSelectedPlayTypeBtnTagWith:(NSInteger)selectedPlayTypeBtnTag
{
    
}

@end
