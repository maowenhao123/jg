//
//  YZBetCell.m
//  ez
//
//  Created by apple on 14-9-14.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZBetCell.h"

@implementation YZBetCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"bet";
    YZBetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZBetCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChilds];
    }
    return self;
}

- (void)setupChilds
{
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    self.label = label;
    [self addSubview:label];
    
    //删除按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"bet_delete_icon"] forState:UIControlStateNormal];
    self.deleteBtn = deleteBtn;
    [self addSubview:deleteBtn];
    deleteBtn.superview.userInteractionEnabled = YES;
    
    //分割线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    lineView.backgroundColor = YZWhiteLineColor;
    [self addSubview:lineView];
}

- (void)setStatus:(YZBetStatus *)status
{
    _status = status;
    
    //设置数据
    self.label.attributedText = _status.labelText;
    
    //设置label的frame
    CGFloat labelW = screenWidth - 2 * YZMargin - 5 - 18;
    self.label.frame = CGRectMake(YZMargin, 0, labelW, _status.cellH);

    //设置删除按钮的frame
    CGFloat deleteBtnW = 18;
    CGFloat deleteBtnH = 18;
    CGFloat deleteBtnX = screenWidth - YZMargin - deleteBtnW;
    self.deleteBtn.frame = CGRectMake(deleteBtnX, 0, deleteBtnW, deleteBtnH);
    self.deleteBtn.center = CGPointMake(self.deleteBtn.center.x, self.label.center.y);
}

@end
