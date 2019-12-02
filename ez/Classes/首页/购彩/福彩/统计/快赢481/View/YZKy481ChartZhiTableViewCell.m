//
//  YZKy481ChartZhiTableViewCell.m
//  ez
//
//  Created by 毛文豪 on 2019/12/2.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481ChartZhiTableViewCell.h"

@interface YZKy481ChartZhiTableViewCell ()

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak) UILabel * noDataLabel;

@end


@implementation YZKy481ChartZhiTableViewCell

+ (YZKy481ChartZhiTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZKy481ChartZhiTableViewCellId";
    YZKy481ChartZhiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZKy481ChartZhiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  cell;
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

- (void)setupChilds
{
    
}

@end
