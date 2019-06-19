//
//  YZCircleDetailViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZCircleDetailViewController.h"
#import "YZCircleTableViewCell.h"
#import "YZCircleCommentTableViewCell.h"

@interface YZCircleDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) YZCircleModel *circleModel;
@property (nonatomic, strong) NSMutableArray *commentDataArray;

@end

@implementation YZCircleDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"彩友圈详情";
    [self setupChilds];
}

#pragma mark - 布局子视图
- (void)setupChilds
{
    YZCircleModel *circleModel = [YZCircleModel new];
    circleModel.nickName = @"昵称";
    circleModel.content = @"内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容";
    circleModel.createTime = 123;
    self.circleModel = circleModel;
    
    CGFloat tableViewH = screenHeight - statusBarH - navBarH - 45;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, tableViewH) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.commentDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        YZCircleTableViewCell * cell = [YZCircleTableViewCell cellWithTableView:tableView];
        cell.circleModel = self.circleModel;
        return cell;
    }else
    {
        YZCircleCommentTableViewCell* cell = [YZCircleCommentTableViewCell cellWithTableView:tableView];
        cell.commentModel = self.commentDataArray[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.circleModel.cellH;
    }else
    {
        YZCircleCommentModel *commentModel = self.commentDataArray[indexPath.row];
        return commentModel.cellH;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 9 + 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 49)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    //分割线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 9)];
    lineView.backgroundColor = YZBackgroundColor;
    [headerView addSubview:lineView];
    
    //评论数
    UILabel * numberLabel = [[UILabel alloc] init];
    numberLabel.text = @"评论：128";
    numberLabel.frame = CGRectMake(YZMargin, 9, screenWidth - 2 * YZMargin, 40);
    numberLabel.textColor = YZBlackTextColor;
    numberLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [headerView addSubview:numberLabel];
    
    return headerView;
}

#pragma mark - 初始化
- (NSMutableArray *)commentDataArray
{
    if (!_commentDataArray) {
        _commentDataArray = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            YZCircleCommentModel *commentModel = [YZCircleCommentModel new];
            commentModel.nickName = @"昵称";
            commentModel.content = @"内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容";
            commentModel.createTime = 123;
            [_commentDataArray addObject:commentModel];
        }
    }
    return _commentDataArray;
}

@end
