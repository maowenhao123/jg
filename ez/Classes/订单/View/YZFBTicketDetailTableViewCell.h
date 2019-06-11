//
//  YZFBTicketDetailTableViewCell.h
//  ez
//
//  Created by apple on 16/10/11.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define lineWidth 0.8

#import <UIKit/UIKit.h>
#import "YZTicketList.h"

@interface YZFBTicketDetailTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) YZTicketList *ticketList;

@end
