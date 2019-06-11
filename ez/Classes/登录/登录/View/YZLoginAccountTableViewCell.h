//
//  YZLoginAccountTableViewCell.h
//  ez
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZLoginAccountTableViewCell;
@protocol YZLoginAccountTableViewCellDelegate <NSObject>

- (void)loginAccountCellDidClickAccountDeleteBtn:(UIButton *)btn inCell:(YZLoginAccountTableViewCell *)cell;

@end

@interface YZLoginAccountTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *historyAccount;
@property (nonatomic, weak) id<YZLoginAccountTableViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
