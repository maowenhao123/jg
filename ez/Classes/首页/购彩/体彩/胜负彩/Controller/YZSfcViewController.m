//
//  YZSfcViewController.m
//  ez
//
//  Created by apple on 14-12-12.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
typedef void(^completion)(void);

#define topBgViewH 44

#import "YZSfcViewController.h"
#import "YZTitleButton.h"
#import "YZSfcCell.h"
#import "YZSfcCellStatus.h"
#import "YZMatchInfosStatus.h"
#import "YZGameIndosStatus.h"
#import "YZSfcBetViewController.h"
#import "YZFootBallTool.h"
#import "YZScjqViewController.h"

@interface YZSfcViewController ()<UITableViewDataSource,UITableViewDelegate,YZSfcCellDelegate>
{
    BOOL _openTitleMenu;//是否打开title菜单
    NSInteger _selectedPlayTypeBtnTag;//选中的玩法的tag
    NSArray *_playTypeBtnTitles;//玩法按钮的title数组
}
@property (nonatomic, weak) YZTitleButton *titleBtn;
@property (nonatomic, weak) UIView *playTypeBackView;//title菜单的背景view
@property (nonatomic, weak) UIButton *termIdChooseBtn;//期数选择按钮
@property (nonatomic, weak) UILabel *endTimeLabel;
@property (nonatomic, weak) UIImageView *topBgView;
@property (nonatomic, weak) UIView *termIdChooseBgView;

@end

@implementation YZSfcViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _playTypeBtnTitles = @[@"胜负彩", @"任九场"];
    
    [self setupSonChilds];
    self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithIcon:@"back_btn_flat" highIcon:@"back_btn_flat" target:self action:@selector(backToBuyLottery)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewNeedReload) name:@"tableViewNeedReload" object:nil];
    
}
- (void)setupSonChilds
{
    //设置底下文字
    self.bottomMidLabel.text = @"  还需选择14场比赛";
    _minMatchCounts = [NSArray arrayWithObjects:@(14),@(9), nil];
    //titlebutton
    YZTitleButton *titleBtn = [[YZTitleButton alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    titleBtn.userInteractionEnabled = NO;
    self.titleBtn = titleBtn;
    [titleBtn setTitle:@"胜负彩" forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
    UIImageView *topBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ft_navigationbar_background"]];
    self.topBgView = topBgView;
    topBgView.userInteractionEnabled = YES;
    topBgView.frame = CGRectMake(0, 0, screenWidth, topBgViewH);
    [self.view addSubview:topBgView];
    
    //期数选择按钮
    CGFloat termIdChooseBtnW = 110;
    UIButton *termIdChooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, termIdChooseBtnW, topBgViewH)];
    self.termIdChooseBtn = termIdChooseBtn;
    termIdChooseBtn.userInteractionEnabled = NO;
    termIdChooseBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [termIdChooseBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    [termIdChooseBtn setTitle:@"加载中..." forState:UIControlStateNormal];
    UIImage *termIdChooseBtnImage = [UIImage imageNamed:@"down_black_accessory"];
    [termIdChooseBtn setImage:termIdChooseBtnImage forState:UIControlStateNormal];
    [termIdChooseBtn addTarget:self action:@selector(termIdChooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat imageW = termIdChooseBtnImage.size.width;
    CGFloat flexible = 10;
    CGFloat left = termIdChooseBtnW - imageW - flexible;
    [termIdChooseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, left, 0, flexible)];
    [termIdChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, imageW + flexible)];
    [topBgView addSubview:termIdChooseBtn];
    
    //分割线
    UIView *greenSeparator = [[UIView alloc] init];
    greenSeparator.backgroundColor = [UIColor darkGrayColor];
    CGFloat greenSeparatorX = CGRectGetMaxX(termIdChooseBtn.frame);
    CGFloat greenSeparatorW = 0.5;
    greenSeparator.frame = CGRectMake(greenSeparatorX, 0, greenSeparatorW, topBgViewH);
    [topBgView addSubview:greenSeparator];
    
    //截止时间
    UILabel *endTimeLabel = [[UILabel alloc] init];
    self.endTimeLabel = endTimeLabel;
    endTimeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    endTimeLabel.textColor = YZBlackTextColor;
    endTimeLabel.textAlignment = NSTextAlignmentCenter;
    endTimeLabel.text = @"加载中...";
    CGFloat endTimeLabelX = CGRectGetMaxX(greenSeparator.frame);
    CGFloat endTimeLabelW = screenWidth - endTimeLabelX;
    endTimeLabel.frame  = CGRectMake(endTimeLabelX, 0, endTimeLabelW, topBgViewH);
    [topBgView addSubview:endTimeLabel];
    
    //tableView
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    CGFloat tableViewH = self.bottomView.y - topBgViewH;
    CGFloat tableViewY = CGRectGetMaxY(topBgView.frame);
    tableView.frame = CGRectMake(0, tableViewY, screenWidth, tableViewH);
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view insertSubview:tableView belowSubview:self.bottomView];
    
}
#pragma mark - tableView的数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *termIdStatusArray = [NSMutableArray array];
    if((int)self.statusArray.count > _selectedTermIdBtnTag)
    {
        termIdStatusArray = self.statusArray[_selectedTermIdBtnTag];
    }
    return  termIdStatusArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSfcCell *cell = [YZSfcCell cellWithTableView:tableView];
    cell.delegate = self;
    NSMutableArray *termIdStatusArray = self.statusArray[_selectedTermIdBtnTag];
    cell.status = termIdStatusArray[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return sfcCellH;
}
#pragma mark - cell的赔率按钮点击
- (void)sfcCellOddsInfoBtnDidClick:(UIButton *)btn withCell:(YZSfcCell *)cell
{
    
    NSMutableArray *termIdStatusArray = self.statusArray[_selectedTermIdBtnTag];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YZSfcCellStatus *status = termIdStatusArray[indexPath.row];
    
    status.btnStateArray[btn.tag] = btn.isSelected ? @(1) : @(0);//按钮状态改相反
    
    if(btn.selected)
    {
        status.btnSelectedCount ++;
    }else
    {
        status.btnSelectedCount --;
    }
    
    //设置底部的文字
    [self setBottomMidLabelText];
}
#pragma mark - 期数按钮点击
- (void)termIdChooseBtnClick:(YZTitleButton *)btn
{
    if(_termIds.count < 2) return;
    UIView *termIdChooseBgView = [[UIView alloc] init];
    self.termIdChooseBgView = termIdChooseBgView;
    termIdChooseBgView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.navigationController.view addSubview:termIdChooseBgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(termIdChooseBgViewTap:)];
    [termIdChooseBgView addGestureRecognizer:tap];
    
    UIView *termIdChooseView = [[UIView alloc] init];
    termIdChooseView.backgroundColor = YZColor(246, 252, 243, 1);
    termIdChooseView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    termIdChooseView.layer.shadowRadius = 0.5;
    termIdChooseView.layer.shadowOffset = CGSizeMake(2, 2);
    int btnCount = (int)_termIds.count;//按钮个数
    CGFloat btnH = 40;
    CGFloat menuViewW = 88;
    CGFloat menuViewH = btnH * btnCount;
    CGFloat menuViewY = statusBarH + navBarH + topBgViewH;
    termIdChooseView.frame = CGRectMake(0, menuViewY, menuViewW, menuViewH + btnCount);
    [termIdChooseBgView addSubview:termIdChooseView];
    
    for(int i = 0;i < btnCount;i++)
    {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        [btn setTitle:_termIds[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(1, i * (btnH + 1), menuViewW, btnH);
        [btn addTarget:self action:@selector(termIdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [termIdChooseView addSubview:btn];
        
        //红虚线
        if(i < btnCount - 1)
        {
            UIImageView *redline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_redline"]];
            redline.frame = CGRectMake(0, CGRectGetMaxY(btn.frame), menuViewW, 1);
            [termIdChooseView addSubview:redline];
        }
    }
    
    termIdChooseView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
        termIdChooseView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
- (void)termIdBtnClick:(UIButton *)btn
{
    if(_selectedTermIdBtnTag == btn.tag)
    {
        return;
    }
    _selectedTermIdBtnTag = (int)btn.tag;//设置选中的termid
    
    [btn.superview removeFromSuperview];
    
    [self setTopViewText];//设置顶部文字
    [self.tableView reloadData];
}
#pragma mark - 标题按钮点击
- (void)titleBtnClick:(YZTitleButton *)btn
{
    [UIView animateWithDuration:animateDuration animations:^{
        if(!_openTitleMenu)
        {
            btn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
        }else
        {
            btn.imageView.transform = CGAffineTransformIdentity;
        }
    }];
    
    _openTitleMenu = !_openTitleMenu;
    
    //底部背景遮盖
    UIView *playTypeBackView = [[UIView alloc] init];
    self.playTypeBackView = playTypeBackView;
    playTypeBackView.backgroundColor = [UIColor clearColor];
    playTypeBackView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePlayTypeBackView)];
    [playTypeBackView addGestureRecognizer:tap];
    [self.tabBarController.view addSubview:playTypeBackView];
    
    //玩法view
    UIView *playTypeView = [[UIView alloc] init];
    playTypeView.backgroundColor = [UIColor whiteColor];
    [playTypeBackView addSubview:playTypeView];
    
    CGFloat btnH = 44;
    CGFloat btnW = 120;
    int padding = 10;
    CGFloat btnY = padding;
    int btnCount = (int)_playTypeBtnTitles.count;
    UIButton *lastBtn;
    for(int i = 0;i < btnCount;i++)
    {
        //玩法按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitle:_playTypeBtnTitles[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        CGFloat btnX = 0;
        if(i == 0)
        {
            btnX = padding;
        }else
        {
            btnX = screenWidth - padding - btnW;
        }
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        lastBtn = btn;
        [playTypeView addSubview:btn];
        [btn addTarget:self action:@selector(playTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        if(_selectedPlayTypeBtnTag == i)//有就选择相应地按钮
        {
            btn.selected = YES;
        }
    }
    CGFloat playTypeViewH = CGRectGetMaxY(lastBtn.frame) + 20;
    playTypeView.frame = CGRectMake(0, statusBarH +navBarH, screenWidth, playTypeViewH);
    
    //绿色分割线
    UIImage *image = [UIImage imageNamed:@"ft_bottomline"];
    UIImageView *greenLine = [[UIImageView alloc] initWithImage:image];
    CGFloat greenLineH = image.size.height;
    CGFloat greenLineY = playTypeViewH - greenLineH;
    greenLine.frame = CGRectMake(0, greenLineY, screenWidth, greenLineH);
    [playTypeView addSubview:greenLine];
    
    playTypeView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
        playTypeView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
#pragma mark -  玩法按钮点击
- (void)playTypeBtn:(UIButton *)btn
{
    if(btn.tag == _selectedPlayTypeBtnTag)
    {
        [self removePlayTypeBackView];
        return;//一样就不动
    }
    _selectedPlayTypeBtnTag = btn.tag;
    
    //设置titlebtn的title
    if(btn.tag == 0)
    {
        [self.titleBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
    }else
    {
        [self.titleBtn setTitle:@"任选九场" forState:UIControlStateNormal];
    }
    
    [self deleteBtnClick];
    
    [self setBottomMidLabelText];//设置注数label
    
    [self removePlayTypeBackView];
}
#pragma mark -  确认按钮点击
- (void)confirmBtnClick
{
    if(_betCount == 0)
    {
        [MBProgressHUD showError:@"至少选择一注"];
        return;
    }
    if(_selectedPlayTypeBtnTag == 1 && _selectedMatchCount > 9){
        [MBProgressHUD showError:@"只能选择九场比赛"];
        return;
    }
    YZSfcBetViewController *betVc = [[YZSfcBetViewController alloc] initWithPlayTypeTag:(int)_selectedPlayTypeBtnTag statusArray:[self getBetStatus]];
    betVc.gameId = self.gameId;
    betVc.termId = _termIds[_selectedTermIdBtnTag];
    betVc.title = [NSString stringWithFormat:@"%@投注",self.titleBtn.currentTitle];
    [self.navigationController pushViewController:betVc animated:YES];
}
- (NSMutableArray *)getBetStatus
{
    NSMutableArray *betStatusArray = [NSMutableArray array];
    if (!self.statusArray.count) return nil;
    NSMutableArray *currentStatus = self.statusArray[_selectedTermIdBtnTag];
    for(int i = 0;i < currentStatus.count;i ++)
    {
        YZSfcCellStatus *status = currentStatus[i];
        if(status.btnSelectedCount > 0)//有按钮被选中
        {
            [betStatusArray addObject:status];
        }
    }
    return betStatusArray;
}
#pragma  mark - 获取到了比赛信息后调用
- (void)getCurrentMatchInfoEnded
{
    [self setStatusArray];//设置当前的数据
    self.matchInfosStatusArray.count > 0 ? [self setTopViewText] : (self.topBgView.hidden = YES);//设置顶部的文字
    if(!self.matchInfosStatusArray.count) return;

    self.titleBtn.userInteractionEnabled = YES;
    self.termIdChooseBtn.userInteractionEnabled = YES;
    [self.tableView reloadData];
}
- (void)getCurrentMatchInfoFailed
{
    self.topBgView.hidden = YES;
}
#pragma mark - 设置顶部的文字
- (void)setTopViewText
{
    //设置期数
    NSString *termIdChooseBtnTitle = [NSString stringWithFormat:@"%@期",_termIds[_selectedTermIdBtnTag]];
    [self.termIdChooseBtn setTitle:termIdChooseBtnTitle forState:UIControlStateNormal];
    
    //设置截止时间
    YZMatchInfosStatus *matchInfo = self.matchInfosStatusArray[_selectedTermIdBtnTag];
    NSString *endTime = [NSString stringWithFormat:@"截止日期:%@",[matchInfo.endTime substringWithRange:NSMakeRange(5, 11)]];
    self.endTimeLabel.text = endTime;
}
- (void)setBottomMidLabelText
{
    int count = 0;
    
    for(YZSfcCellStatus *status in self.statusArray[_selectedTermIdBtnTag])
    {
        if(status.btnSelectedCount > 0) count ++;//cell有被选中的按钮，计数加1
    }
    _selectedMatchCount = count;
    
    NSString *title = nil;
    int minMatchCount = [_minMatchCounts[_selectedPlayTypeBtnTag] intValue];
    if(count < minMatchCount)
    {
        title = [NSString stringWithFormat:@"  还需选择%d场比赛",minMatchCount-count];
        _betCount = 0;
    }else
    {
        if(_selectedPlayTypeBtnTag == 1 && _selectedMatchCount > 9){
            return ;
        }
        title = [NSString stringWithFormat:@"  您已选择%d注",[self computeBetCount]];
    }
    self.bottomMidLabel.text = title;
}
- (void)deleteBtnClick
{
    if(!self.statusArray.count) return;
    for(YZSfcCellStatus *status in self.statusArray[_selectedTermIdBtnTag])
    {
        if(status.btnSelectedCount > 0)
        {
            [status deleteAllSelBtn];//删除所有选中按钮
        }
    }
    _selectedMatchCount = 0;
    [self.tableView reloadData];
    NSString *title = [NSString stringWithFormat:@"  还需选择%d场比赛",[_minMatchCounts[_selectedPlayTypeBtnTag] intValue]];
    self.bottomMidLabel.text = title;
}
#pragma mark - 计算注数的
- (int)computeBetCount
{
    int count = 1;
    
    NSMutableArray *cellSelBtnCountArr = [NSMutableArray array];
    for(YZSfcCellStatus *status in self.statusArray[_selectedTermIdBtnTag])
    {
        int selBtnCount = 0;
        for(NSNumber *num in status.btnStateArray)
        {
            if([num intValue])//yes就是按钮已选
            {
                selBtnCount ++;
            }
        }
        if(selBtnCount > 0)
        {
            [cellSelBtnCountArr addObject:@(selBtnCount)];
        }
    }
    
    if(_selectedPlayTypeBtnTag == 0)//算胜负彩的注数
    {
        for(NSNumber *num in cellSelBtnCountArr)
        {
            count = count * [num intValue];
        }
    }else//任九场的注数
    {
        if(_selectedMatchCount < 9)
        {
            for(NSNumber *num in cellSelBtnCountArr)
            {
                count = count * [num intValue];
            }
        }else
        {
            count = [YZFootBallTool getRenjiuBetCount:cellSelBtnCountArr :9];
        }
    }
    _betCount = count;
    return count;
}

- (void)setStatusArray
{
    //数据源数组
    NSMutableArray *statusArray = [NSMutableArray array];
    
    //设置期数数组
    NSMutableArray *termIds = [NSMutableArray array];
    for(YZGameIndosStatus *gameInfos in self.matchInfosStatusArray)
    {
        [termIds addObject:gameInfos.termId];//期数数组
        
        NSMutableArray *termIdstatusArray = [NSMutableArray array];
        NSArray *detailInfos = [gameInfos.matchGames componentsSeparatedByString:@";"];//元素是nsstring,是一场比赛
        for(int i = 0; i < detailInfos.count;i++)
        {
            NSString *cellStatusStr = detailInfos[i];
            NSArray *cellStatusArray = [cellStatusStr componentsSeparatedByString:@"|"];
            YZSfcCellStatus *status = [[YZSfcCellStatus alloc] init];
            status.number = i+1;
            status.matchName = cellStatusArray[1];
            NSString *endTimeTemp = [[cellStatusArray firstObject] substringWithRange:NSMakeRange(8, 4)];
            NSMutableString *muEndTimeTemp = [endTimeTemp mutableCopy];
            [muEndTimeTemp insertString:@":" atIndex:2];
            status.endTime = [muEndTimeTemp copy];
            
            status.vsText = [NSString stringWithFormat:@"%@ vs %@",cellStatusArray[2],cellStatusArray[3]];
            status.oddsInfo = [[cellStatusArray lastObject] componentsSeparatedByString:@" "];
            status.code = [cellStatusArray firstObject];
            [termIdstatusArray addObject:status];
        }
        [statusArray  addObject:termIdstatusArray];
    }
    _termIds = termIds;//期数数组
    _statusArray = statusArray;//数据源
}
- (void)tableViewNeedReload
{
    [self.tableView reloadData];
    //设置底部的文字
    [self setBottomMidLabelText];
}
- (void)termIdChooseBgViewTap:(UITapGestureRecognizer *)recognizer
{
    [recognizer.view removeFromSuperview];
}
- (void)removePlayTypeBackView
{
    [UIView animateWithDuration:animateDuration animations:^{
        self.titleBtn.imageView.transform = CGAffineTransformIdentity;
    }];
    _openTitleMenu = !_openTitleMenu;
    [self.playTypeBackView removeFromSuperview];
}
- (void)backToBuyLottery
{
    //胜负彩和四场进球控制器，有选号的号码时，弹框警示
    BOOL isNeed = NO;
    if([self isKindOfClass:[YZScjqViewController class]])
    {
        YZScjqViewController *scjq = (YZScjqViewController *)self;
        NSMutableArray *statusArray = [scjq getBetStatus];
        for(int i = 0;i < statusArray.count;i++)
        {
            YZScjqCellStatus *status = statusArray[i];
            if([[status.btnSelectedCountArr firstObject] intValue] > 0 || [[status.btnSelectedCountArr lastObject] intValue] > 0)
            {
                isNeed = YES;
                break;
            }
        }
    }else
    {
        if([self getBetStatus].count) isNeed = YES;
    }
    
    if(isNeed)
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定清空所选的内容吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tableViewNeedReload" object:nil];
    [self.termIdChooseBgView removeFromSuperview];
}

@end
