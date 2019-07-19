//
//  YZMessageViewController.m
//  ez
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZMessageViewController.h"
#import "YZNoDataTableViewCell.h"
#import "YZMessageTableViewCell.h"
#import "YZMessageStstus.h"
#import "JPUSHService.h"

@interface YZMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, assign) int pageIndex1;//系统消息的页数
@property (nonatomic, assign) int pageIndex2;//我的消息的页数
@property (nonatomic, assign) int currentPageIndex;//当前的页数
@property (nonatomic, strong) NSMutableArray *headerViews;
@property (nonatomic, strong) NSMutableArray *footerViews;

@end

@implementation YZMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"消息中心";
    [self setupChilds];
}
#pragma mark - 布局视图
- (void)setupChilds
{
    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(emptyBarDidClicked)];
    self.navigationItem.rightBarButtonItem = editBarButton;
    
    //添加btnTitle
    self.btnTitles = @[@"系统消息", @"我的消息"];
    //添加tableview
    CGFloat scrollViewH = screenHeight - statusBarH - navBarH - topBtnH;
    for(int i = 0; i < 2; i++)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, scrollViewH) style:UITableViewStyleGrouped];
        tableView.tag = i;
        tableView.backgroundColor = YZBackgroundColor;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
        [self.views addObject:tableView];
        
        //初始化头部刷新控件
        MJRefreshGifHeader *headerView = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
        [YZTool setRefreshHeaderData:headerView];
        [self.headerViews addObject:headerView];
        tableView.mj_header = headerView;
        
        //初始化底部刷新控件
        MJRefreshBackGifFooter *footerView = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshViewBeginRefreshing)];
        [YZTool setRefreshFooterData:footerView];
        [self.footerViews addObject:footerView];
        tableView.mj_footer = footerView;
    }
    //完成配置
    [super configurationComplete];
    waitingView_loadingData;
    [super topBtnClick:self.topBtns[0]];
    
    self.scrollView.scrollEnabled = NO;
}

- (void)emptyBarDidClicked
{
    if (self.messageArray.count == 0) {
        [MBProgressHUD showError:@"暂无消息"];
        return;
    }
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定清空消息列表?清空后不可恢复" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self emptyMessageList];
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)changeCurrentIndex:(int)currentIndex
{
    //没有数据时加载数据
    NSMutableArray *messageArray_ = self.messageArray[self.currentIndex];
    if(messageArray_.count == 0)
    {
        [self messageToRead];
        [self loadData];
    }
}
#pragma mark - MJRefresh的代理方法
- (void)headerRefreshViewBeginRefreshing
{
    NSMutableArray *messageArray_ = self.messageArray[self.currentIndex];
    if(messageArray_.count)
    {
        if(self.currentIndex == 0)
        {
            self.pageIndex1 = 0;
        }else if(self.currentIndex == 1)
        {
            self.pageIndex2 = 0;
        }
        self.currentPageIndex = 0;
    }
    [self.messageArray[self.currentIndex] removeAllObjects];
    //加载数据
    [self loadData];
}
- (void)footerRefreshViewBeginRefreshing
{
    if(self.currentIndex == 0)
    {
        self.pageIndex1 += 1;
        self.currentPageIndex = self.pageIndex1;
    }else if(self.currentIndex == 1)
    {
        self.pageIndex2 += 1;
        self.currentPageIndex = self.pageIndex2;
    }
    //加载数据
    [self loadData];
}
#pragma mark - 请求数据
- (void)messageToRead//消息标记为已读
{
    NSString * urlStr;
    if (self.currentIndex == 0) {//系统消息
        urlStr = @"/commonMessageToRead";
    }else
    {
        urlStr = @"/messageToRead";
    }
    
    NSDictionary *dict = @{
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlJiguang(urlStr) params:dict success:^(id json) {
        YZLog(@"messageToRead：%@",json);
        if (SUCCESS) {
            [JPUSHService setBadge:0];//重置JPush服务器上面的badge值。如果下次服务端推送badge传"+1",则会在你当时JPush服务器上该设备的badge值的基础上＋1；
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//apple自己的接口，变更应用本地（icon）的badge值；
            //刷新是否有新消息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"upDataHaveNewMessage" object:nil];
        }
    } failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
    }];
}
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self headerRefreshViewBeginRefreshing];
}
- (void)loadData
{
    NSString * urlStr;
    if (self.currentIndex == 0) {//系统消息
        urlStr = @"/getCommonMessageList";
    }else
    {
        urlStr = @"/getMessageList";
    }
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"pageIndex":@(self.currentPageIndex),
                           @"pageSize":@(10)
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithURL:BaseUrlJiguang(urlStr) params:dict success:^(id json) {
        YZLog(@"getMessageList：%@",json);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UITableView *tableView = self.views[self.currentIndex];
        if (SUCCESS) {;
            NSArray * messageList = [YZMessageStstus objectArrayWithKeyValuesArray:json[@"messageList"]];
            NSMutableArray *messageArray_ = self.messageArray[self.currentIndex];
            [messageArray_ addObjectsFromArray:messageList];
            [tableView reloadData];
            [self.headerViews[self.currentIndex] endRefreshing];
            if (messageList.count == 0) {//没有新的数据
                [self.footerViews[self.currentIndex] endRefreshingWithNoMoreData];
            }else
            {
                [self.footerViews[self.currentIndex] endRefreshing];
            }
        }else
        {
            ShowErrorView;
            [tableView reloadData];//刷新
            [self.headerViews[self.currentIndex] endRefreshing];
            [self.footerViews[self.currentIndex] endRefreshing];
        }
    }failure:^(NSError *error)
    {
        UITableView *tableView = self.views[self.currentIndex];
        [tableView reloadData];//刷新
        [self.headerViews[self.currentIndex] endRefreshing];
        [self.footerViews[self.currentIndex] endRefreshing];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         YZLog(@"error = %@",error);
    }];
}
//清空列表
- (void)emptyMessageList
{
    NSString * urlStr;
    if (self.currentIndex == 0) {//系统消息
        urlStr = @"/commonMessageClear";
    }else
    {
        urlStr = @"/messageClear";
    }
    NSDictionary *dict = @{
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlJiguang(urlStr) params:dict success:^(id json) {
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"清空消息列表成功"];
            NSMutableArray *messageArray_ = self.messageArray[self.currentIndex];
            [messageArray_ removeAllObjects];
            UITableView *tableView = self.views[self.currentIndex];
            [tableView reloadData];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
     }];
}
//删除数据
- (void)deleteDataWithMessageId:(NSString *)messageId indexPath:(NSIndexPath *)indexPath
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认删除该消息吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString * urlStr;
        if (self.currentIndex == 0) {//系统消息
            urlStr = @"/commonMessageDel";
        }else
        {
            urlStr = @"/messageDel";
        }
        NSDictionary *dict = @{
                               @"userId":UserId,
                               @"jpushMessageId":messageId
                               };
        [[YZHttpTool shareInstance] postWithURL:BaseUrlJiguang(urlStr) params:dict success:^(id json) {
            if (SUCCESS) {
                [MBProgressHUD showSuccess:@"消息删除成功"];
                NSMutableArray *messageArray_ = self.messageArray[self.currentIndex];
                [messageArray_ removeObjectAtIndex:indexPath.section];
                UITableView *tableView = self.views[self.currentIndex];
                if (messageArray_.count == 0) {
                    [tableView reloadData];
                }else
                {
                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }else
            {
                ShowErrorView;
            }
        } failure:^(NSError *error)
         {
             YZLog(@"error = %@",error);
         }];
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSMutableArray *messageArray_ = self.messageArray[self.currentIndex];
    return messageArray_.count == 0 ? 1 : messageArray_.count ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *messageArray_ = self.messageArray[self.currentIndex];
    if (messageArray_.count == 0) {
        YZNoDataTableViewCell *cell = [YZNoDataTableViewCell cellWithTableView:tableView cellId:@"noMessageCell"];
        cell.imageName = @"no_message";
        cell.noDataStr = @"暂时没有消息";
        return cell;
    }else
    {
        YZMessageTableViewCell *cell = [YZMessageTableViewCell cellWithTableView:tableView];
        YZMessageStstus * messageStstus = messageArray_[indexPath.section];
        cell.messageStstus = messageStstus;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *messageArray_ = self.messageArray[self.currentIndex];
    if (messageArray_.count > 0) {
        YZMessageStstus * messageStstus = messageArray_[indexPath.section];
        CGSize describeSize = [messageStstus.intro sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(24)] maxSize:CGSizeMake(screenWidth - 20 - 2 * YZMargin, MAXFLOAT)];
        CGFloat describeLabelH = describeSize.height + 20 > 62 ? describeSize.height + 20: 62;
        return 33 + describeLabelH;
    }
    return 300;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSMutableArray *messageArray_ = self.messageArray[self.currentIndex];
    if (section == messageArray_.count - 1) {
        return 10;
    }
    return 0.01;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *messageArray_ = self.messageArray[self.currentIndex];
    if (!messageArray_.count) {
        return NO;
    }
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *messageArray_ = self.messageArray[self.currentIndex];
    if (messageArray_.count == 0) {//没有数据时
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YZMessageStstus * messageStstus = messageArray_[indexPath.section];
        [self deleteDataWithMessageId:messageStstus.jpushMessageId indexPath:indexPath];
    }
}
#pragma mark - 初始化
- (NSMutableArray *)messageArray
{
    if (_messageArray == nil) {
        _messageArray = [NSMutableArray array];
        for (int i = 0; i < 2; i++) {
          NSMutableArray * messageArray_ = [NSMutableArray array];
            [_messageArray addObject:messageArray_];
        }
        return _messageArray;
    }
    return _messageArray;
}
- (NSMutableArray *)headerViews
{
    if(_headerViews == nil)
    {
        _headerViews = [NSMutableArray array];
    }
    return _headerViews;
}
- (NSMutableArray *)footerViews
{
    if(_footerViews == nil)
    {
        _footerViews = [NSMutableArray array];
    }
    return _footerViews;
}

@end
