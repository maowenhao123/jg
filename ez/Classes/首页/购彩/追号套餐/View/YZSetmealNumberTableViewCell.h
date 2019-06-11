//
//  YZSetmealNumberTableViewCell.h
//  ez
//
//  Created by 毛文豪 on 2018/7/11.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZSetmealNumberTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) NSArray *numberArray;

@end
