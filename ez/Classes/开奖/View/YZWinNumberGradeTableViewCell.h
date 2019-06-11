//
//  YZWinNumberGradeTableViewCell.h
//  ez
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGrade.h"

@interface YZWinNumberGradeTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, strong) YZGrade *grade;

@end
