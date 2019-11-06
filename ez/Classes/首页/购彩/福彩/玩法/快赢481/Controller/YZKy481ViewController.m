//
//  YZKy481ViewController.m
//  ez
//
//  Created by dahe on 2019/11/5.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481ViewController.h"
#import "YZKy481PlayTypeView.h"
#import "YZKy481WanNengView.h"
#import "YZKy481ChongView.h"
#import "YZKy481DanView.h"
#import "YZTitleButton.h"

@interface YZKy481ViewController ()<UITableViewDelegate, UITableViewDataSource, YZKy481PlayTypeViewDelegate, YZSelectBallCellDelegate, YZBallBtnDelegate>

@property (nonatomic, weak) YZTitleButton *titleBtn;//title按钮
@property (nonatomic, weak) YZKy481PlayTypeView * playTypeView;
@property (nonatomic, assign) NSInteger selectedPlayTypeBtnTag;//选中的玩法的tag
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) YZKy481WanNengView *wanNengView;
@property (nonatomic, weak) YZKy481ChongView *chongView;
@property (nonatomic, weak) YZKy481DanView *danView;
@property (nonatomic, strong) NSMutableArray *allStatusArray;//所有的数据
@property (nonatomic, strong) NSMutableArray *currentStatusArray;//当前tableview的数据

@end

@implementation YZKy481ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedPlayTypeBtnTag = 0;
    [self setupSonChilds];    
}

#pragma mark - 布局子视图
- (void)setupSonChilds
{
    //移除父控制器不必要的控件
    [self.backView removeFromSuperview];//移除俩个按钮
    [self.scrollView removeFromSuperview];//移除scrollview
    
    //titleBtn
    YZTitleButton *titleBtn = [[YZTitleButton alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    self.titleBtn = titleBtn;
    [titleBtn setTitle:@"任选一" forState:UIControlStateNormal];
    #if JG
        [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    #elif ZC
        [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
    #elif CS
        [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
    #elif RR
        [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    #endif
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
    //选择玩法类型
    YZKy481PlayTypeView * playTypeView = [[YZKy481PlayTypeView alloc] initWithFrame:KEY_WINDOW.bounds selectedPlayTypeBtnTag:self.selectedPlayTypeBtnTag];
    self.playTypeView = playTypeView;
    playTypeView.titleBtn = titleBtn;
    playTypeView.delegate = self;
    [KEY_WINDOW addSubview:playTypeView];
    
    //玩法
    CGFloat tableViewY = CGRectGetMaxY(self.endTimeLabel.frame);
    CGFloat tableViewH = self.bottomView.y - CGRectGetMaxY(self.endTimeLabel.frame);
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, screenWidth, tableViewH)];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:tableView];
    
    //任选二万能两码
    YZKy481WanNengView *wanNengView = [[YZKy481WanNengView alloc] initWithFrame:CGRectMake(0, tableViewY, screenWidth, tableViewH)];
    self.wanNengView = wanNengView;
    wanNengView.hidden = YES;
    [self.view addSubview:wanNengView];
    
    //组选4 组选12
    YZKy481ChongView *chongView = [[YZKy481ChongView alloc] initWithFrame:CGRectMake(0, tableViewY, screenWidth, tableViewH)];
    self.chongView = chongView;
    chongView.hidden = YES;
    [self.view addSubview:chongView];
    
    //组选6 组选24
    YZKy481DanView *danView = [[YZKy481DanView alloc] initWithFrame:CGRectMake(0, tableViewY, screenWidth, tableViewH)];
    self.danView = danView;
    danView.hidden = YES;
    [self.view addSubview:danView];
    
    self.currentStatusArray = self.allStatusArray[self.selectedPlayTypeBtnTag];//记录的数据源
}

#pragma mark -  按钮点击
- (void)titleBtnClick:(YZTitleButton *)btn
{
    [self.playTypeView show];
}

- (void)playTypeDidClickBtn:(UIButton *)btn
{
    self.selectedPlayTypeBtnTag = btn.tag;
    [self.titleBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
    
    self.wanNengView.hidden = YES;
    self.danView.hidden = YES;
    self.chongView.hidden = YES;
    self.tableView.hidden = YES;
    self.currentStatusArray = self.allStatusArray[btn.tag];
    if (btn.tag == 4) {
        self.wanNengView.hidden = NO;
        self.wanNengView.status = self.currentStatusArray.firstObject;
    }else if (btn.tag == 7 || btn.tag == 9)//组选4 组选12
    {
        self.chongView.hidden = NO;
        self.chongView.status = self.currentStatusArray.firstObject;
    }else if (btn.tag == 8 || btn.tag == 10)//组选6 组选24
    {
        self.danView.hidden = NO;
        self.danView.status = self.currentStatusArray.firstObject;
    }else
    {
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
}

#pragma mark - tableview的代理数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentStatusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSelectBallCell *cell = [YZSelectBallCell cellWithTableView:tableView andIndexpath:indexPath];
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.tag = indexPath.row;
    cell.status = self.currentStatusArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSelectBallCellStatus * status = self.currentStatusArray[indexPath.row];
    return status.cellH;
}

#pragma  mark -  数据源
- (NSMutableArray *)allStatusArray
{
    if(_allStatusArray == nil)
    {
        _allStatusArray = [NSMutableArray array];
        //任选一 任选一 任选一 直选
        NSMutableArray * playTypeBalls6 = [NSMutableArray array];
        NSArray * yongTitles = @[@"自由泳", @"仰泳", @"蛙泳", @"蝶泳"];
        NSArray * hitTitles = @[@"任选一项，猜中一项即中9元", @"任选二项，猜中任意2项且顺序一致即中74元", @"任选三项，猜中任意3项且顺序一致即中593元", @"开奖号码与所选号码相同即中4751元"];
        for (int i = 0; i < hitTitles.count; i++) {
            NSMutableArray * playTypeBalls = [NSMutableArray array];
            for (int j = 0; j < yongTitles.count; j++) {
                NSString * hitTitle = @"";
                NSString * yongTitle = yongTitles[j];
                if (j == 0) {
                    hitTitle = hitTitles[i];
                }
                YZSelectBallCellStatus *status = [self setupStatusWithTitle:hitTitle ballsCount:8 leftTitle:yongTitle icon:@"" startNumber:@"1"];
                if (i == 3) {
                    [playTypeBalls6 addObject:status];
                }else
                {
                    [playTypeBalls addObject:status];
                }
            }
            if (i != 3) {
                [_allStatusArray addObject:playTypeBalls];
            }
        }
        
        //任选二全包
        NSMutableArray * playTypeBalls3 = [NSMutableArray array];
        YZSelectBallCellStatus *status31 = [self setupStatusWithTitle:@"开奖号码中包含所选的两位即中74元" ballsCount:8 leftTitle:@"" icon:@"one_flat" startNumber:@"1"];
        [playTypeBalls3 addObject:status31];
        YZSelectBallCellStatus *status32 = [self setupStatusWithTitle:@"" ballsCount:8 leftTitle:@"" icon:@"two_flat" startNumber:@"1"];
        [playTypeBalls3 addObject:status32];
        [_allStatusArray addObject:playTypeBalls3];
        
        //任选二万能两码
        NSMutableArray * playTypeBalls4 = [NSMutableArray array];
        YZSelectBallCellStatus *status4 = [self setupStatusWithTitle:@"开奖号码中包含所选的两位即中74元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls4 addObject:status4];
        [_allStatusArray addObject:playTypeBalls4];
        
        //任选三全包
        NSMutableArray * playTypeBalls5 = [NSMutableArray array];
        NSArray * weiTitles = @[@"第一位", @"第二位", @"第三位"];
        for (int i = 0; i < weiTitles.count; i++) {
            NSString * hitTitle = @"";
            if (i == 0) {
                hitTitle = @"开奖号码中包含所选的三位即中593元";
            }
            YZSelectBallCellStatus *status = [self setupStatusWithTitle:hitTitle ballsCount:8 leftTitle:weiTitles[i] icon:@"" startNumber:@"1"];
            [playTypeBalls5 addObject:status];
        }
        [_allStatusArray addObject:playTypeBalls5];
        
        //直选
        [_allStatusArray addObject:playTypeBalls6];
        
        //组选4
        NSMutableArray * playTypeBalls7 = [NSMutableArray array];
        YZSelectBallCellStatus *status7 = [self setupStatusWithTitle:@"开奖号码与所选号码相同即中1187元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls7 addObject:status7];
        [_allStatusArray addObject:playTypeBalls7];
        
        //组选6
        NSMutableArray * playTypeBalls8 = [NSMutableArray array];
        YZSelectBallCellStatus *status8 = [self setupStatusWithTitle:@"开奖号码与所选号码相同即中791元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls8 addObject:status8];
        [_allStatusArray addObject:playTypeBalls8];
        
        //组选12
        NSMutableArray * playTypeBalls9 = [NSMutableArray array];
        YZSelectBallCellStatus *status9 = [self setupStatusWithTitle:@"开奖号码与所选号码相同即中395元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls9 addObject:status9];
        [_allStatusArray addObject:playTypeBalls9];
        
        //组选24
        NSMutableArray * playTypeBalls10 = [NSMutableArray array];
        YZSelectBallCellStatus *status10 = [self setupStatusWithTitle:@"开奖号码与所选号码相同即中197元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls10 addObject:status10];
        [_allStatusArray addObject:playTypeBalls10];
    }
    return  _allStatusArray;
}

#pragma mark - 带“中元”的数据生成方法
- (YZSelectBallCellStatus *)setupStatusWithTitle:(NSString *)title ballsCount:(int)ballsCount leftTitle:(NSString *)leftTitle icon:(NSString *)icon startNumber:(NSString *)startNumber
{
    YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
    if(!YZStringIsEmpty(title))
    {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:title];
        NSRange zhongRange = [[attStr string] rangeOfString:@"即中"];
        NSRange yuanRange = [[attStr string] rangeOfString:@"元"];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(zhongRange.location+2, yuanRange.location-zhongRange.location-2)];
        status.title = attStr;
    }
    status.ballsCount = ballsCount;
    status.leftTitle = leftTitle;
    status.startNumber = startNumber;
    status.isRed = YES;
    status.icon = icon;
    return status;
}

@end
