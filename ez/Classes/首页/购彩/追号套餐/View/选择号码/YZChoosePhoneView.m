//
//  YZChoosePhoneView.m
//  ez
//
//  Created by 毛文豪 on 2018/7/13.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZChoosePhoneView.h"
#import "YZChoosePhoneTableViewCell.h"

@interface YZChoosePhoneView ()<UITableViewDelegate, UITableViewDataSource, YZChoosePhoneTableViewCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation YZChoosePhoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChilds];
    }
    return self;
}
#pragma mark - 创建视图
- (void)setupChilds
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, self.width - 20, 100 + 20)];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:tableView];
    
    self.height = tableView.height;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZChoosePhoneTableViewCell * cell = [YZChoosePhoneTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.phone = self.dataArray[indexPath.row];
    cell.addButton.hidden = indexPath.row == 1;
    cell.addButton.enabled = indexPath.row == self.dataArray.count - 1;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 50 + 20 + 20;
    }
    return 50 + 30 + 20;
}

- (void)choosePhoneTableViewCellAddPhone:(YZChoosePhoneTableViewCell *)cell
{
    NSString * phone = @"";
    [self.dataArray addObject:phone];
    if (self.dataArray.count == 2) {
        self.tableView.height = 100 * self.dataArray.count - 30 + 20;
        self.height = self.tableView.height;
    }else
    {
        self.tableView.height = 100 * self.dataArray.count + 20;
        self.height = self.tableView.height;
    }
    [self.tableView reloadData];
}

- (void)choosePhoneTableViewCell:(YZChoosePhoneTableViewCell *)cell phoneDidChange:(NSString *)phone
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    self.dataArray[indexPath.row] = phone;
}

#pragma mark - 初始化
- (NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
        NSString * phone = @"";
        [_dataArray addObject:phone];
    }
    return _dataArray;
}

@end
