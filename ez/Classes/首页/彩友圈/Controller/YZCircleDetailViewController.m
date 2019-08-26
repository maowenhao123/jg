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
#import "YZCircleCommentListView.h"
#import "YZSendCommentView.h"
#import "IQKeyboardManager.h"

@interface YZCircleDetailViewController ()<UITableViewDelegate, UITableViewDataSource, SendCommentViewDelegate, CircleCommentTableViewCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) YZSendCommentView *sendCommentTextView;
@property (nonatomic, strong) YZCircleModel *circleModel;
@property (nonatomic, strong) NSMutableArray *commentDataArray;
@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic, weak) MJRefreshGifHeader *header;
@property (nonatomic, weak) MJRefreshBackGifFooter *footer;
@property (nonatomic, assign) int pageIndex;

@end

@implementation YZCircleDetailViewController

#pragma mark - 控制器的生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enableAutoToolbar = NO;
    keyboardManager.enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enableAutoToolbar = YES;
    keyboardManager.enable = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"彩友圈详情";
    [self setupChilds];
    waitingView
    self.pageIndex = 0;
    [self getTopicInfo];
    [self getCommentList];
    // 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - 键盘
// 键盘弹出会调用
- (void)keyboardWillShow:(NSNotification *)note
{
    // 获取键盘frame
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight = endFrame.size.height;
    // 获取键盘弹出时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.sendCommentTextView.y = screenHeight - statusBarH - navBarH - self.sendCommentTextView.height - endFrame.size.height;
                     }];
    
    self.sendCommentTextView.praiseButton.hidden = YES;
    self.sendCommentTextView.commentButton.hidden = YES;
    self.sendCommentTextView.sendButton.hidden = NO;
    [UIView animateWithDuration:animateDuration animations:^{
        self.sendCommentTextView.textView.width = screenWidth - 60 - YZMargin;
    }];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    // 获取键盘弹出时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.sendCommentTextView.y = screenHeight - statusBarH - navBarH - self.sendCommentTextView.height - [YZTool getSafeAreaBottom];
                         
                     }];
    
    self.sendCommentTextView.praiseButton.hidden = NO;
    self.sendCommentTextView.commentButton.hidden = NO;
    self.sendCommentTextView.sendButton.hidden = YES;
    [UIView animateWithDuration:animateDuration animations:^{
        self.sendCommentTextView.textView.width = screenWidth - 95 - YZMargin;
    }];
}

#pragma mark - 请求数据
- (void)getTopicInfo
{
    NSDictionary *dict = @{
                           @"pageIndex": @(self.pageIndex),
                           @"pageSize": @(10),
                           @"topicId": self.topicId
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/getTopicInfo") params:dict success:^(id json) {
        YZLog(@"getTopicInfo:%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS){
            YZCircleModel *circleModel = [YZCircleModel objectWithKeyValues:json[@"topics"]];
            circleModel.circleTableViewType = CircleTableViewDetail;
            NSDictionary * extInfo = json[@"topics"][@"extInfo"];
            if (!YZDictIsEmpty(extInfo)) {
                NSArray * ticketList = extInfo[@"ticketList"];
                if (!YZArrayIsEmpty(ticketList) && [ticketList isKindOfClass:[NSArray class]]) {
                    circleModel.extInfo.ticketList = [YZTicketList objectArrayWithKeyValuesArray:extInfo[@"ticketList"]];
                    circleModel.extInfo.description_ = extInfo[@"description"];
                }
            }
            self.circleModel = circleModel;
            self.sendCommentTextView.circleModel = circleModel;
            [self.tableView reloadData];
            [self.header endRefreshing];
        }else
        {
            ShowErrorView
            [self.header endRefreshing];
        }
    }failure:^(NSError *error)
    {
        YZLog(@"error = %@",error);
        [MBProgressHUD hideHUDForView:self.view];
        [self.header endRefreshing];
    }];
}

- (void)getCommentList
{
    return;
    
    NSDictionary *dict = @{
                           @"topicId": self.topicId,
                           @"pageIndex": @(self.pageIndex),
                           @"pageSize": @(10)
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/getTopicCommentList") params:dict success:^(id json) {
        YZLog(@"getTopicCommentList:%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS){
            NSArray *commentDataArray = [YZCircleCommentModel objectArrayWithKeyValuesArray:json[@"topicComments"]];
            for (YZCircleCommentModel * commentModel in commentDataArray) {
                NSInteger index = [commentDataArray indexOfObject:commentModel];
                NSArray *topicCommentReplys = [YZTopicCommentReplyModel objectArrayWithKeyValuesArray:json[@"topicComments"][index][@"topicCommentReplys"]];
                commentModel.topicCommentReplys = topicCommentReplys;
            }
            [self.commentDataArray addObjectsFromArray:commentDataArray];
            [self.tableView reloadData];
            [self.header endRefreshing];
            
            if (commentDataArray.count == 0) {//没有新的数据
                [self.footer endRefreshingWithNoMoreData];
            }else
            {
                [self.footer endRefreshing];
            }
        }else
        {
            ShowErrorView
            [self.tableView reloadData];
            [self.header endRefreshing];
            [self.footer endRefreshing];
        }
    }failure:^(NSError *error)
     {
         YZLog(@"error = %@",error);
         [MBProgressHUD hideHUDForView:self.view];
         [self.tableView reloadData];
         [self.header endRefreshing];
         [self.footer endRefreshing];
     }];
}

#pragma mark - 布局子视图
- (void)setupChilds
{
    CGFloat commentViewH = 40;
    CGFloat tableViewH = screenHeight - statusBarH - navBarH - commentViewH - [YZTool getSafeAreaBottom];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, tableViewH)];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    
    //初始化头部刷新控件
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderData:header];
    self.header = header;
    self.tableView.mj_header = header;
    
//    //初始化底部刷新控件
//    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshViewBeginRefreshing)];
//    [YZTool setRefreshFooterData:footer];
//    self.footer = footer;
//    tableView.mj_footer = footer;
    
    YZSendCommentView * sendCommentTextView = [[YZSendCommentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tableView.frame), screenWidth, commentViewH)];
    self.sendCommentTextView = sendCommentTextView;
    sendCommentTextView.delegate = self;
    sendCommentTextView.praiseButton.hidden = NO;
    sendCommentTextView.sendButton.hidden = YES;
    [self.view addSubview:sendCommentTextView];
}

#pragma  mark - 刷新
- (void)headerRefreshViewBeginRefreshing
{
    //清空数据
    self.pageIndex = 0;
    [self.commentDataArray removeAllObjects];
    [self getTopicInfo];
    [self getCommentList];
}

- (void)footerRefreshViewBeginRefreshing
{
    self.pageIndex++;
    [self getCommentList];
}

#pragma mark - SendCommentViewDelegate
- (void)textViewSendButtonDidClickWithText:(NSString *)text
{
    NSDictionary *dict = [NSDictionary dictionary];
    NSString * url = @"";
    if (self.sendCommentTextView.indexPath) {
        YZCircleCommentModel * commentModel = self.commentDataArray[self.sendCommentTextView.indexPath.row];
        NSDictionary * topicCommentReply = @{
                                             @"userId": UserId,
                                             @"topicId": self.topicId,
                                             @"commentId": commentModel.id,
                                             @"content": text
                                             };
        dict = @{
                 @"topicCommentReply": topicCommentReply
                 };
        url = BaseUrlInformation(@"/replyComment");
    }else
    {
        dict = @{
                 @"userId": UserId,
                 @"topicId": self.topicId,
                 @"content": text
                 };
        url = BaseUrlInformation(@"/commentTopic");
    }
    [[YZHttpTool shareInstance] postWithURL:url params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"commentTopic:%@",json);
        if (SUCCESS){
            [self.sendCommentTextView reset];
            [self.sendCommentTextView.textView resignFirstResponder];
            
            [self headerRefreshViewBeginRefreshing];
        }else
        {
            ShowErrorView
        }
    }failure:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view];
         YZLog(@"error = %@",error);
     }];
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
        cell.delegate = self;
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
    if (self.circleModel) {
        numberLabel.text = [NSString stringWithFormat:@"评论：%@", self.circleModel.concernNumber];
    }
    numberLabel.frame = CGRectMake(YZMargin, 9, screenWidth - 2 * YZMargin, 40);
    numberLabel.textColor = YZBlackTextColor;
    numberLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [headerView addSubview:numberLabel];
    
    return headerView;
}

#pragma mark - CircleCommentTableViewCellDelegate
- (void)replyButtonDidClickWithCell:(YZCircleCommentTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    YZCircleCommentModel * commentModel = self.commentDataArray[indexPath.row];
    [self.sendCommentTextView.textView becomeFirstResponder];
    self.sendCommentTextView.textView.myPlaceholder = [NSString stringWithFormat:@"回复：%@", commentModel.userName];
    self.sendCommentTextView.indexPath = indexPath;
}

- (void)allCommentButtonDidClickWithCell:(YZCircleCommentTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    YZCircleCommentModel * commentModel = self.commentDataArray[indexPath.row];
    YZCircleCommentListView *commentListView = [[YZCircleCommentListView alloc] initWithTopicId:commentModel.topicId commentId:commentModel.id];
    [commentListView show];
    commentListView.circleModel = self.circleModel;
    
}
#pragma mark - 初始化
- (NSMutableArray *)commentDataArray
{
    if (!_commentDataArray) {
        _commentDataArray = [NSMutableArray array];
    }
    return _commentDataArray;
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIKeyboardWillShowNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIKeyboardWillHideNotification
                                                 object:nil];
}

@end
