//
//  YZWinNumberGradeTableViewCell.m
//  ez
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZWinNumberGradeTableViewCell.h"

@interface YZWinNumberGradeTableViewCell ()

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *gCountLabel;
@property (nonatomic, weak) UILabel *bonusLabel;

@end

@implementation YZWinNumberGradeTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"WinNumberGradeCell";
    YZWinNumberGradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZWinNumberGradeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChildViews];
    }
    return self;
}
- (void)setupChildViews
{
    for (int i = 0; i < 3; i++) {
        UILabel * label = [[UILabel alloc]init];
        label.textColor = YZBlackTextColor;
        label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];

        if (i == 0) {
            self.nameLabel = label;
        }else if (i == 1)
        {
            self.gCountLabel = label;
        }else if (i == 2)
        {
            self.bonusLabel = label;
        }
    }
}
- (void)setGrade:(YZGrade *)grade
{
    _grade = grade;
    self.nameLabel.text = _grade.name;
    if ([grade.gCount intValue] == 0) {
        self.gCountLabel.text = @"-";
    }else
    {
        self.gCountLabel.text = [NSString stringWithFormat:@"%@",_grade.gCount];
    }
    
    if ([grade.bonus intValue] == 0) {
        self.bonusLabel.text = @"-";
    }else
    {
        self.bonusLabel.text = [NSString stringWithFormat:@"%d",[_grade.bonus intValue] / 100];
    }
}
- (void)setGameId:(NSString *)gameId
{
    _gameId = gameId;
    if ([_gameId isEqualToString:@"F04"] || [_gameId isEqualToString:@"T05"] || [self.gameId isEqualToString:@"T61"] || [self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T63"] || [self.gameId isEqualToString:@"T64"]) {//快三和11选5不显示注数
        self.nameLabel.frame = CGRectMake(0, 0, screenWidth / 2, 35);
        self.gCountLabel.frame = CGRectZero;
        self.bonusLabel.frame = CGRectMake(screenWidth / 2, 0, screenWidth / 2, 35);
    }else
    {
        self.nameLabel.frame = CGRectMake(0, 0, screenWidth / 3, 35);
        self.gCountLabel.frame = CGRectMake(screenWidth / 3, 0, screenWidth / 3, 35);
        self.bonusLabel.frame = CGRectMake(screenWidth * 2 / 3, 0, screenWidth / 3, 35);
    }
}
@end
