//
//  YZChoosePhoneTableViewCell.h
//  ez
//
//  Created by 毛文豪 on 2018/7/16.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZChoosePhoneTableViewCell;
@protocol YZChoosePhoneTableViewCellDelegate <NSObject>

- (void)choosePhoneTableViewCellAddPhone:(YZChoosePhoneTableViewCell *)cell;
- (void)choosePhoneTableViewCell:(YZChoosePhoneTableViewCell *)cell phoneDidChange:(NSString *)phone;

@end

@interface YZChoosePhoneTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) UIButton * addButton;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, weak) id <YZChoosePhoneTableViewCellDelegate> delegate;

@end
