//
//  YZChooseBirthdayView.m
//  ez
//
//  Created by 毛文豪 on 2018/7/13.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZChooseBirthdayView.h"
#import "YZChooseBirthdayTableViewCell.h"

@interface YZChooseBirthdayView ()<UITableViewDelegate, UITableViewDataSource, YZChooseBirthdayTableViewCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation YZChooseBirthdayView

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
    YZChooseBirthdayTableViewCell * cell = [YZChooseBirthdayTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.dateComponents = self.dataArray[indexPath.row];
    cell.addButton.hidden = indexPath.row == 2;
    cell.addButton.enabled = indexPath.row == self.dataArray.count - 1;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return 50 + 20 + 20;
    }
    return 50 + 30 + 20;
}

- (void)chooseBirthdayTableViewCellAddBirthday:(YZChooseBirthdayTableViewCell *)cell
{
    NSDateComponents * dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 0;
    dateComponents.month = 0;
    dateComponents.day = 0;
    [self.dataArray addObject:dateComponents];
    if (self.dataArray.count == 3) {
        self.tableView.height = 100 * self.dataArray.count - 30 + 20;
        self.height = self.tableView.height;
    }else
    {
        self.tableView.height = 100 * self.dataArray.count + 20;
        self.height = self.tableView.height;
    }
    [self.tableView reloadData];
}

#pragma mark - 初始化
- (NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
        NSDateComponents * dateComponents = [[NSDateComponents alloc] init];
        dateComponents.year = 0;
        dateComponents.month = 0;
        dateComponents.day = 0;
        [_dataArray addObject:dateComponents];
    }
    return _dataArray;
}

@end
