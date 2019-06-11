//
//  YZNoDataTableViewCell.h
//  ez
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZNoDataTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *noDataStr;

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView cellId:(NSString *)cellId;

@end
