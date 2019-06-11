//
//  YZFbBetCell.m
//  ez
//
//  Created by apple on 14-12-3.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#define cellW (screenWidth-24)  //自动适配屏幕分辨率,宽320，则是296
#define btnsH 42
#import "YZFbBetCell.h"

@interface YZFbBetCell ()<YZBtnsViewDelegate>
@property (nonatomic, weak) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *vs1Label;
@property (nonatomic, strong) UILabel *vsLabel;
@property (nonatomic, strong) UILabel *vs2Label;
@property (nonatomic, weak) UIImageView *redLine;
@property (nonatomic, weak) UIView *greenLine;
@property (nonatomic, weak) UIView *btnsBgView;
@property (nonatomic, weak) UIButton *danBtn;

@end
@implementation YZFbBetCell

+ (YZFbBetCell *)cellWithTableView:(UITableView *)tableView andIndexpath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"fbBetCell";
    YZFbBetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZFbBetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        //布局子视图
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    int padding = 3;
    float imageScale = 1.6;
    
    //删除按钮
    UIButton *deleteBtn = [[UIButton alloc] init];
    self.deleteBtn = deleteBtn;
    UIImage *deleteImage = [UIImage imageNamed:@"round_deleteBtn"];
    [deleteBtn setBackgroundImage:deleteImage forState:UIControlStateNormal];
    CGFloat deleteBtnX = padding;
    CGFloat deleteBtnY = padding;
    CGFloat deleteBtnW = deleteImage.size.width * imageScale;
    CGFloat deleteBtnH = deleteImage.size.height * imageScale;
    deleteBtn.frame = CGRectMake(deleteBtnX, deleteBtnY, deleteBtnW, deleteBtnH);
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteBtn];
    
    //胆图片
    UIImage *danDisableImage = [UIImage imageNamed:@"fb_dan_disable"];
    UIImage *danNormalImage = [UIImage imageNamed:@"fb_dan_normal"];
    UIImage *danSelectedImage = [UIImage imageNamed:@"fb_dan_selected"];
    UIButton *danBtn = [[UIButton alloc] init];
    self.danBtn = danBtn;
    danBtn.enabled = NO;
    [danBtn setBackgroundImage:danDisableImage forState:UIControlStateDisabled];
    [danBtn setBackgroundImage:danNormalImage forState:UIControlStateNormal];
    [danBtn setBackgroundImage:danSelectedImage forState:UIControlStateSelected];
    CGFloat danBtnW = deleteBtnW;
    CGFloat danBtnH = deleteBtnH;
    CGFloat danBtnX = cellW - danBtnW - padding;
    CGFloat danBtnY = deleteBtnY;
    danBtn.frame = CGRectMake(danBtnX, danBtnY, danBtnW, danBtnH);
    [danBtn addTarget:self action:@selector(danBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:danBtn];
    
    //三个label显示文字
    CGFloat leftPadding = 30;
    CGFloat vsLabelMaxW = cellW - leftPadding * 2;
    CGFloat VsLabelH = 30;
    CGFloat vs1LabelW = 0;
    UILabel *lastLabel = nil;
    CGFloat vsLabelY = 15;
    for(int i = 0;i < 3;i++)
    {
        UILabel *VsLabel = [[UILabel alloc] init];
        lastLabel = VsLabel;
        VsLabel.backgroundColor = [UIColor clearColor];
        VsLabel.font = [UIFont systemFontOfSize:13];
        if(i == 0){//中间显示VS的label
            self.vsLabel = VsLabel;
            VsLabel.text = @"VS";
            CGSize labelSize = [VsLabel.text sizeWithFont:VsLabel.font maxSize:CGSizeMake(screenWidth, screenHeight)];
            vs1LabelW = (vsLabelMaxW - labelSize.width) / 2;
            CGFloat VsLabelX = leftPadding + vs1LabelW;
            VsLabel.frame = CGRectMake(VsLabelX, vsLabelY, labelSize.width, VsLabelH);
        }else if(i == 1){//vs左边的文字
            VsLabel.frame = CGRectMake(leftPadding, vsLabelY, vs1LabelW + 15, VsLabelH);
            self.vs1Label = VsLabel;
        }else{
            self.vs2Label = VsLabel;
            VsLabel.textAlignment = NSTextAlignmentRight;
            CGFloat vsLabelX = CGRectGetMaxX(self.vsLabel.frame);
            VsLabel.frame = CGRectMake(vsLabelX, vsLabelY, vs1LabelW - 15, VsLabelH);
        }
        [self.contentView addSubview:VsLabel];
    }
    
    //红色虚线
    UIImageView *redLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fb_redLine"]];
    self.redLine = redLine;
    CGFloat redLineX = leftPadding;
    CGFloat redLineY = CGRectGetMaxY(lastLabel.frame) + padding;
    CGFloat redLineW = cellW - leftPadding * 2;
    redLine.frame = CGRectMake(redLineX, redLineY, redLineW, 1);
    [self.contentView addSubview:redLine];

    
    //btnsView的背景view
    UIView *btnsBgView = [[UIView alloc] init];
    self.btnsBgView = btnsBgView;
    CGFloat btnsBgViewX = redLineX;
    CGFloat btnsBgViewW = redLineW;
    CGFloat btnsBgViewY = CGRectGetMaxY(redLine.frame) + 3;
    btnsBgView.frame = CGRectMake(btnsBgViewX, btnsBgViewY, btnsBgViewW, 0);
    [self.contentView addSubview:btnsBgView];

    //绿色底线
    UIView *greenLine = [[UIView alloc] init];
    self.greenLine = greenLine;
    greenLine.backgroundColor = YZColor(97, 180, 59, 1);//草绿
    [self.contentView addSubview:greenLine];
    
}
- (void)setStatus:(YZFbBetCellStatus *)status
{
    _status = status;
    if (_status.playType >= 7) {
        self.danBtn.hidden = YES;
    }else
    {
        self.danBtn.hidden = NO;
    }
    
    if(_status.danBtnState == danBtnStateDisabled)
    {
        self.danBtn.selected = NO;
        self.danBtn.enabled = NO;
    }else if(_status.danBtnState == danBtnStateNormal)
    {
        self.danBtn.enabled = YES;
        self.danBtn.selected = NO;
    }else if(_status.danBtnState == danBtnStateSelected)
    {
        self.danBtn.enabled = YES;
        self.danBtn.selected = YES;
    }
    
    self.vs1Label.attributedText = _status.vs1MuAttText;
    self.vs2Label.text = _status.vs2Text;
    self.btnsBgView.height = _status.btnsBgViewH;
    
    //再次添加前删除之前的子视图
    for (UIView * view in _btnsBgView.subviews) {
        [view removeFromSuperview];
    }
    
    float lastBtnsViewY = 0;
    //非让
    if (_status.feirangNum > 0) {
        YZBtnsView *btnsView = [[YZBtnsView alloc] initWithFrame:CGRectMake(0,lastBtnsViewY, btnsViewW, btnsH * _status.feirangNum)];
        btnsView.tag = 0;
        NSArray * selMatchArray = _status.matchInfosStatus.selMatchArr[0];
        btnsView.rates = selMatchArray;
        btnsView.delegate = self;
        [_btnsBgView addSubview:btnsView];
        lastBtnsViewY = CGRectGetMaxY(btnsView.frame);
    }
    //让球
    if (_status.rangNum > 0) {
        YZBtnsView *btnsView = [[YZBtnsView alloc] initWithFrame:CGRectMake(0,lastBtnsViewY, btnsViewW, btnsH * _status.rangNum)];
        btnsView.tag = 100;
        NSArray * selMatchArray = _status.matchInfosStatus.selMatchArr[1];
        btnsView.rates = selMatchArray;
        btnsView.delegate = self;
        [_btnsBgView addSubview:btnsView];
        lastBtnsViewY = CGRectGetMaxY(btnsView.frame);
    }
    //二选一
    if (_status.erxuanyiNum > 0) {
        YZBtnsView *btnsView = [[YZBtnsView alloc] initWithFrame:CGRectMake(0,lastBtnsViewY, btnsViewW, btnsH * _status.erxuanyiNum)];
        btnsView.tag = 200;
        NSArray * selMatchArray = _status.matchInfosStatus.selMatchArr[2];
        btnsView.rates = selMatchArray;
        btnsView.delegate = self;
        [_btnsBgView addSubview:btnsView];
        lastBtnsViewY = CGRectGetMaxY(btnsView.frame);
    }
    //半全场
    if (_status.banquanchangNum > 0) {
        YZBtnsView *btnsView = [[YZBtnsView alloc] initWithFrame:CGRectMake(0,lastBtnsViewY, btnsViewW, btnsH * _status.banquanchangNum)];
        btnsView.tag = 300;
        NSArray * selMatchArray = _status.matchInfosStatus.selMatchArr[3];
        btnsView.rates = selMatchArray;
        btnsView.delegate = self;
        [_btnsBgView addSubview:btnsView];
        lastBtnsViewY = CGRectGetMaxY(btnsView.frame);
    }
    //总进球
    if (_status.zongjinqiuNum > 0) {
        YZBtnsView *btnsView = [[YZBtnsView alloc] initWithFrame:CGRectMake(0,lastBtnsViewY, btnsViewW, btnsH * _status.zongjinqiuNum)];
        btnsView.tag = 500;
        NSArray * selMatchArray = _status.matchInfosStatus.selMatchArr[5];
        btnsView.rates = selMatchArray;
        btnsView.delegate = self;
        [_btnsBgView addSubview:btnsView];
        lastBtnsViewY = CGRectGetMaxY(btnsView.frame);
    }
    //比分
    if (_status.bifenNum > 0) {
        YZBtnsView *btnsView = [[YZBtnsView alloc] initWithFrame:CGRectMake(0,lastBtnsViewY, btnsViewW, btnsH * _status.bifenNum)];
        btnsView.tag = 400;
        NSArray * selMatchArray = _status.matchInfosStatus.selMatchArr[4];
        btnsView.rates = selMatchArray;
        btnsView.delegate = self;
        [_btnsBgView addSubview:btnsView];
        lastBtnsViewY = CGRectGetMaxY(btnsView.frame);
    }
    //绿色底线的frame
    CGFloat greenLineW = cellW;
    CGFloat greenLineH = 2;
    CGFloat greenLineY = _status.cellH - greenLineH;
    self.greenLine.frame = CGRectMake(0, greenLineY, greenLineW, greenLineH);
    
}
//胆按钮点击
- (void)danBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    _status.danBtnState =  btn.isSelected ? danBtnStateSelected : danBtnStateNormal;
    if([self.delegate respondsToSelector:@selector(fbBetCellDidClickDanBtn:inCell:)])
    {
        [self.delegate fbBetCellDidClickDanBtn:btn inCell:self];
    }
}
//删除按钮点击
- (void)deleteBtnClick:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(fbBetCellDidClickDeleteBtn:inCell:)])
    {
        [self.delegate fbBetCellDidClickDeleteBtn:btn inCell:self];
    }
}
//YZBtnsViewDelegate的代理方法
-(void)btnsViewDidClickOddInfoBtn:(UIButton *)btn inBtnsView:(UIView *)btnsView
{
    if([self.delegate respondsToSelector:@selector(fbBetCellDidClickOddsInfoBtn:inBtnsView:inCell:)])
    {
        [self.delegate fbBetCellDidClickOddsInfoBtn:btn inBtnsView:btnsView inCell:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
