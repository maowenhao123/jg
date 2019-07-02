//
//  YZCircleCommentListView.m
//  ez
//
//  Created by dahe on 2019/6/28.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZCircleCommentListView.h"
#import "YZSendCommentView.h"
#import "YZNoDataTableViewCell.h"
#import "YZCircleCommentListTableViewCell.h"

@interface YZCircleCommentListView ()<UITableViewDelegate, UITableViewDataSource, SendCommentViewDelegate, UIGestureRecognizerDelegate>
{
    CGFloat _lastTranslationY;
}
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UILabel * titleLabel;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) YZSendCommentView *sendCommentTextView;
@property (nonatomic, copy) NSString *topicId;
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) MJRefreshGifHeader *refreshHeader;
@property (nonatomic, weak) MJRefreshBackGifFooter *refreshFooter;
@property (nonatomic,assign) CGFloat keyboardHeight;

@end

@implementation YZCircleCommentListView

- (instancetype)initWithTopicId:(NSString *)topicId commentId:(NSString *)commentId
{
    self = [super init];
    if (self) {
        self.topicId = topicId;
        self.commentId = commentId;
        [self setupViews];
        [self getData];
        // 监听键盘弹出
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
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
                         self.sendCommentTextView.y = self.contentView.height - self.sendCommentTextView.height - endFrame.size.height;
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
                         self.sendCommentTextView.y = self.contentView.height - self.sendCommentTextView.height - [YZTool getSafeAreaBottom];
                         
                     }];
    
    self.sendCommentTextView.praiseButton.hidden = NO;
    self.sendCommentTextView.commentButton.hidden = NO;
    self.sendCommentTextView.sendButton.hidden = YES;
    [UIView animateWithDuration:animateDuration animations:^{
        self.sendCommentTextView.textView.width = screenWidth - 95 - YZMargin;
    }];
}

#pragma mark - 请求数据
- (void)getData
{
    NSDictionary *dict = @{
                           @"pageIndex":@(self.pageIndex),
                           @"pageSize":@(10),
                           @"topicId": self.topicId,
                           @"commentId": self.commentId
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/getReplyList") params:dict success:^(id json) {
        YZLog(@"getReplyList:%@",json);
        if (SUCCESS){
            NSArray * dataArray = [YZTopicCommentReplyModel objectArrayWithKeyValuesArray:json[@"replyInfos"]];
            [self.dataArray addObjectsFromArray:dataArray];
            [self.tableView reloadData];
            [self.refreshHeader endRefreshing];
            
            if (dataArray.count == 0) {//没有新的数据
                [self.refreshFooter endRefreshingWithNoMoreData];
            }else
            {
                [self.refreshFooter endRefreshing];
            }
        }else
        {
            ShowErrorView
            [self.tableView reloadData];
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
        }
    }failure:^(NSError *error)
    {
        YZLog(@"error = %@",error);
        [self.tableView reloadData];
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];
}

#pragma mark - 布局子视图
- (void)setupViews{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = YZColor(0, 0, 0, 0.4);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    //内容
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight, screenWidth, screenHeight - statusBarH)];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    CGFloat radius = 15; // 圆角大小
    UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerTopRight; // 圆角位置，全部位置
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = contentView.bounds;
    maskLayer.path = path.CGPath;
    contentView.layer.mask = maskLayer;
    
    //增加拖动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewPan:)];
    [contentView addGestureRecognizer:pan];
    
    //close
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat closeButtonWH = 30;
    closeButton.frame = CGRectMake(15, 10, closeButtonWH, closeButtonWH);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"login_close_icon"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeButton];
    
    //title
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 4, self.width, 44);
    titleLabel.text = @"全部玩法";
    titleLabel.textColor = YZBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:17];;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLabel];
    
    CGFloat commentViewH = 40;
    
    //tableView
    CGFloat tableViewH = self.contentView.height - titleLabel.height - commentViewH - [YZTool getSafeAreaBottom];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, titleLabel.height, screenWidth, tableViewH)];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    tableView.showsVerticalScrollIndicator = NO;
    [contentView addSubview:tableView];
    
    //初始化头部刷新控件
    MJRefreshGifHeader *refreshHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderData:refreshHeader];
    self.refreshHeader = refreshHeader;
    tableView.mj_header = refreshHeader;
    
    //初始化底部刷新控件
    MJRefreshBackGifFooter *refreshFooter = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshViewBeginRefreshing)];
    [YZTool setRefreshFooterData:refreshFooter];
    self.refreshFooter = refreshFooter;
    tableView.mj_footer = refreshFooter;
    
    //评论
    YZSendCommentView * sendCommentTextView = [[YZSendCommentView alloc] initWithFrame:CGRectMake(0, contentView.height - commentViewH - [YZTool getSafeAreaBottom], screenWidth, commentViewH)];
    self.sendCommentTextView = sendCommentTextView;
    sendCommentTextView.delegate = self;
    sendCommentTextView.praiseButton.hidden = NO;
    sendCommentTextView.sendButton.hidden = YES;
    [contentView addSubview:sendCommentTextView];
}

#pragma mark - SendCommentViewDelegate
- (void)textViewSendButtonDidClickWithText:(NSString *)text
{
    NSDictionary * topicCommentReply = @{
                                         @"userId": UserId,
                                         @"topicId": self.topicId,
                                         @"commentId": self.commentId,
                                         @"content": text
                                         };
    NSDictionary *dict = @{
                         @"topicCommentReply": topicCommentReply
                         };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/replyComment") params:dict success:^(id json) {
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
          YZLog(@"error = %@",error);
     }];
}

- (void)setCircleModel:(YZCircleModel *)circleModel
{
    _circleModel = circleModel;
 
    self.sendCommentTextView.circleModel = _circleModel;
}

#pragma  mark - 刷新
- (void)headerRefreshViewBeginRefreshing
{
    //清空数据
    self.pageIndex = 0;
    [self.dataArray removeAllObjects];
    [self getData];
}

- (void)footerRefreshViewBeginRefreshing
{
    self.pageIndex++;
    [self getData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count == 0 ? 1 : self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        YZNoDataTableViewCell *cell = [YZNoDataTableViewCell cellWithTableView:tableView cellId:@"noCircleCommentListCell"];
        cell.imageName = @"no_recharge";
        cell.noDataStr = @"暂无数据";
        return cell;
    }else
    {
        YZCircleCommentListTableViewCell * cell = [YZCircleCommentListTableViewCell cellWithTableView:tableView];
        cell.commentModel = self.dataArray[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return tableView.height * 0.7;
    }
    YZTopicCommentReplyModel *circleModel = self.dataArray[indexPath.row];
    return circleModel.cellH;
}


#pragma mark - 显示隐藏
- (void)show{
    UIView *topView = [KEY_WINDOW.subviews firstObject];
    [topView addSubview:self];
    
    [UIView animateWithDuration:animateDuration animations:^{
        self.contentView.y = statusBarH;
    }];
}
- (void)hide{
    [UIView animateWithDuration:animateDuration animations:^{
        self.alpha = 0;
        self.contentView.y = screenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - 手势滑动tableview
- (void)contentViewPan:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:self.contentView];
    if(pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged)
    {
        if(((self.contentView.y + translation.y) > statusBarH)|| (translation.y < 0 && self.contentView.y > statusBarH) || (translation.y > 0 && self.contentView.y < screenHeight))//向上且y值大于endTimeBg的最大Y值，或者，向下且y值小于下面固定的某一值
        {
            [self.contentView setCenter:CGPointMake(self.contentView.center.x, self.contentView.center.y + translation.y)];
            [pan setTranslation:CGPointZero inView:self.contentView];
        }
        if(translation.y < 0 && self.contentView.y < statusBarH)//向上且y值小于endTimeBg的最大Y值
        {
            self.contentView.y = statusBarH;
        }else if(translation.y > 0 && self.contentView.y > screenHeight)//向下且y值大于下面固定的某一值
        {
            self.contentView.y = screenHeight;
        }
        _lastTranslationY = translation.y;
    }
    
    if(pan.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:animateDuration
                         animations:^{
                             if(_lastTranslationY > 2)//有向下滑的趋势
                             {
                                 self.contentView.y = screenHeight;
                             }else if (_lastTranslationY < -2)//有向上滑的趋势
                             {
                                 self.contentView.y = statusBarH;
                             }else//无趋势
                             {
                                 if(self.contentView.y < statusBarH + self.contentView.height / 2)//tableview在endTimeBg上面了就归位
                                 {
                                     self.contentView.y = statusBarH;
                                 }else if(self.contentView.y >= statusBarH + self.contentView.height / 2)//y值中间的一半以外，下去
                                 {
                                     self.contentView.y = screenHeight;
                                 }else if(self.contentView.y > screenHeight)//y值大于下面一栏的y值就归位下去
                                 {
                                     self.contentView.y = screenHeight;
                                 }
                             }
                         }completion:^(BOOL finished) {
                             if (self.contentView.y == screenHeight) {
                                 [self removeFromSuperview];
                             }
                         }];
    }else if (pan.state == UIGestureRecognizerStateCancelled)
    {
        [UIView animateWithDuration:animateDuration animations:^{
            self.contentView.y = statusBarH;
        }];
    }
    //设置透明度
    CGFloat layerScale = (self.contentView.y - statusBarH) / (screenHeight - statusBarH);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:(1 - layerScale) * 0.4];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint pos = [touch locationInView:self.contentView.superview];
        if (CGRectContainsPoint(self.contentView.frame, pos)) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 初始化
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
