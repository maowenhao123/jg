//
//  YZChooseBirthdayTableViewCell.h
//  ez
//
//  Created by 毛文豪 on 2018/7/16.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZChooseBirthdayTableViewCell;
@protocol YZChooseBirthdayTableViewCellDelegate <NSObject>

- (void)chooseBirthdayTableViewCellAddBirthday:(YZChooseBirthdayTableViewCell *)cell;

@end

@interface YZChooseBirthdayTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) UIButton * addButton;

@property (nonatomic, strong) NSDateComponents *dateComponents;

@property (nonatomic, weak) id <YZChooseBirthdayTableViewCellDelegate> delegate;

@end
