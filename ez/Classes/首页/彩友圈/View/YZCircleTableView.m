//
//  YZCircleTableView.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZCircleTableView.h"
#import "YZCircleDetailViewController.h"
#import "YZCircleTableViewCell.h"

@interface YZCircleTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;//近期开奖数据

@end

@implementation YZCircleTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZBackgroundColor;
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self setEstimatedSectionHeaderHeightAndFooterHeight];
//        [self getData];
    }
    return self;
}

#pragma mark - 请求数据
- (void)getData
{
    NSDictionary *dict = @{
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlCircle(@"/getTopicList") params:dict success:^(id json) {
        YZLog(@"getTopicList:%@",json);
        if (SUCCESS){
            
        }else
        {
            ShowErrorView
        }
    }failure:^(NSError *error)
    {
        YZLog(@"error = %@",error);
    }];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZCircleTableViewCell * cell = [YZCircleTableViewCell cellWithTableView:tableView];
    cell.circleModel = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZCircleModel *circleModel = self.dataArray[indexPath.row];
    return circleModel.cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZCircleDetailViewController * circleDetailVC = [[YZCircleDetailViewController alloc] init];
    [self.viewController.navigationController pushViewController:circleDetailVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_circleDelegate && [_circleDelegate respondsToSelector:@selector(circleTableViewDidScroll:)]) {
        [_circleDelegate circleTableViewDidScroll:scrollView];
    }
}

#pragma mark - 初始化
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            YZCircleModel *circleModel = [YZCircleModel new];
            circleModel.nickName = @"昵称";
            circleModel.content = @"内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容";
            circleModel.createTime = 123;
            circleModel.imageCount = arc4random() % 3;//图片数量
            [_dataArray addObject:circleModel];
        }
    }
    return _dataArray;
}

@end
