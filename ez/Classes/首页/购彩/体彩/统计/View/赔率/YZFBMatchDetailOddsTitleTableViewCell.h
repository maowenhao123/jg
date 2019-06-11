//
//  YZFBMatchDetailOddsTitleTableViewCell.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZFBMatchDetailOddsTitleTableViewCell : UITableViewCell

+ (YZFBMatchDetailOddsTitleTableViewCell *)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, assign) NSInteger oddsType;//赔率类型

@end
