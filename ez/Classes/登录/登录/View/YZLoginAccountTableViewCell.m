//
//  YZLoginAccountTableViewCell.m
//  ez
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZLoginAccountTableViewCell.h"
#define KWidth 278.5
#define KHeight 44

@interface YZLoginAccountTableViewCell ()
@property (nonatomic, weak) UIButton *deleteBtn;
@property (nonatomic, weak) UILabel *historyAccountLabel;
@end

@implementation YZLoginAccountTableViewCell
//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"historyAccountCell";
    YZLoginAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZLoginAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupChilds];
    }
    return  self;
}
- (void)setupChilds
{
    UILabel * historyAccountLabel = [[UILabel alloc]init];
    self.historyAccountLabel = historyAccountLabel;
    historyAccountLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    historyAccountLabel.textColor = YZBlackTextColor;
    [self.contentView addSubview:historyAccountLabel];
    
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn = deleteBtn;
    [deleteBtn setImage:[UIImage imageNamed:@"login_account_delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteBtn];
}
- (void)setHistoryAccount:(NSString *)historyAccount
{
    self.historyAccountLabel.text = historyAccount;
    [self setFrame];
}
- (void)setFrame
{
    CGFloat padding = 10;
    CGFloat btnWH = 15;
    self.historyAccountLabel.frame = CGRectMake(10, 0, KWidth - 2 * padding -btnWH, KHeight);
    self.deleteBtn.frame = CGRectMake(KWidth - btnWH - padding, (KHeight - btnWH) / 2, btnWH, btnWH);
}
- (void)deleteAccount:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(loginAccountCellDidClickAccountDeleteBtn:inCell:)]) {
        [_delegate loginAccountCellDidClickAccountDeleteBtn:button inCell:self];
    }
}

@end
