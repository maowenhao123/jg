//
//  YZFBMatchDetailTextTableViewCell.h
//  ez
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZFBMatchDetailTextTableViewCell : UITableViewCell

@property (nonatomic, weak) UILabel * contentLabel;
+ (YZFBMatchDetailTextTableViewCell *)cellWithTableView:(UITableView *)tableView;

@end
