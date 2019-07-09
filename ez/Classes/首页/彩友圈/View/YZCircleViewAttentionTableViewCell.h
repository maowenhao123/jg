//
//  YZCircleViewAttentionTableViewCell.h
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZCircleViewAttentionTableViewCell;

@protocol YZCircleViewAttentionTableViewCellDelegate <NSObject>

- (void) circleViewAttentionTableViewCellAttentionBtnDidClick:(YZCircleViewAttentionTableViewCell *)cell;

@end


@interface YZCircleViewAttentionTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic, weak) UIButton *cancelAttentionButon;

@property (nonatomic, weak) id<YZCircleViewAttentionTableViewCellDelegate> delegate;

@end
