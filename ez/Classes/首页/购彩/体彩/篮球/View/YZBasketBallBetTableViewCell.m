//
//  YZBasketBallBetTableViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/5/30.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZBasketBallBetTableViewCell.h"

@interface YZBasketBallBetTableViewCell()

@property (nonatomic, strong) NSMutableArray *titleLabels;
@property (nonatomic, strong) NSMutableArray *conetntLabels;

@end

@implementation YZBasketBallBetTableViewCell

+ (YZBasketBallBetTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZBasketBallBetTableViewCellId";
    YZBasketBallBetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZBasketBallBetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = YZBackgroundColor;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupChilds];
    }
    return self;
}

#pragma mark - 布局视图
- (void)setupChilds
{
    for (int i = 0; i < 4; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.font= [UIFont systemFontOfSize:YZGetFontSize(24)];
        titleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:titleLabel];
        [self.titleLabels addObject:titleLabel];
        
        UILabel *conetntLabel = [[UILabel alloc] init];
        conetntLabel.textColor = YZRedTextColor;
        conetntLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        conetntLabel.numberOfLines = 0;
        [self addSubview:conetntLabel];
        [self.conetntLabels addObject:conetntLabel];
    }
}

- (void)setMatchInfosModel:(YZMatchInfosStatus *)matchInfosModel
{
    _matchInfosModel = matchInfosModel;
    
    for (int i = 0; i < 4; i++) {
        UILabel *titleLabel = self.titleLabels[i];
        UILabel *conetntLabel = self.conetntLabels[i];
        
        NSString *titleLabelStr = _matchInfosModel.titleLabelStrs[i];
        NSString *conetntLabelStr = _matchInfosModel.conetntLabelStrs[i];
        CGRect titleLabelF = [_matchInfosModel.titleLabelFs[i] CGRectValue];
        CGRect conetntLabelF = [_matchInfosModel.conetntLabelFs[i] CGRectValue];
        
        titleLabel.text = titleLabelStr;
        titleLabel.frame = titleLabelF;
        conetntLabel.text = conetntLabelStr;
        conetntLabel.frame = conetntLabelF;
    }
}

#pragma mark - 初始化
- (NSMutableArray *)titleLabels
{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (NSMutableArray *)conetntLabels
{
    if (_conetntLabels == nil) {
        _conetntLabels = [NSMutableArray array];
    }
    return _conetntLabels;
}

@end
