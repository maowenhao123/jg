//
//  YZEditSegementView.m
//  ez
//
//  Created by dahe on 2019/6/20.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZEditSegementView.h"
#import "YZSegementCollectionViewCell.h"
#import "YZSegementFlowLayout.h"

NSString * const segementCollectionViewCellId = @"segementCollectionViewCellId";

@interface YZEditSegementView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
{
    CGFloat _lastTranslationY;
}
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIButton * editButton;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) YZSegementFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *btnTitles;
@property (nonatomic, copy) NSString * currentText;

@end

@implementation YZEditSegementView

- (instancetype)initWithBtnTitles:(NSMutableArray *)btnTitles currentText:(NSString *)currentText
{
    self = [super init];
    if (self) {
        self.btnTitles = btnTitles;
        self.currentText = currentText;
        [self setupViews];
    }
    return self;
}

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
    [self.contentView addSubview:titleLabel];
    
    //编辑
    UIButton * editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton = editButton;
    editButton.frame = CGRectMake(screenWidth - 70, 0, 70, 50);
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitle:@"完成" forState:UIControlStateSelected];
    [editButton setTitleColor:YZBaseColor forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [editButton addTarget:self action:@selector(editButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editButton];
    
    //collectionView
    CGFloat collectionViewH = self.contentView.height - CGRectGetMaxY(editButton.frame);
    YZSegementFlowLayout *layout = [[YZSegementFlowLayout alloc] init];
    self.layout = layout;
    CGFloat itemPadding = 15;
    layout.itemSize = CGSizeMake((screenWidth - 5 * itemPadding ) / 4, 45);
    layout.sectionInset = UIEdgeInsetsMake(10, itemPadding, 0, itemPadding);
    layout.minimumInteritemSpacing = itemPadding;//列间距
    layout.minimumLineSpacing = itemPadding;//行间距
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(editButton.frame), screenWidth, collectionViewH) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:collectionView];
    
    //注册
    [collectionView registerClass:[YZSegementCollectionViewCell class] forCellWithReuseIdentifier:segementCollectionViewCellId];
}

- (void)editButtonDidClick:(UIButton *)button
{
    if (button.selected) {
        if (_delegate && [_delegate respondsToSelector:@selector(editSegementDidCompleteWithBtnTitles:currentText:)]) {
            [_delegate editSegementDidCompleteWithBtnTitles:self.btnTitles currentText:self.currentText];
        }
        [self hide];
        return;
    }
    button.selected = !button.selected;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.btnTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    YZSegementCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:segementCollectionViewCellId forIndexPath:indexPath];
    cell.text = self.btnTitles[indexPath.row];
    cell.isCurrentItem = [cell.text isEqualToString:self.currentText];
    return cell;
}

#pragma mark - YZSegementDataSource
- (BOOL)collectionView:(UICollectionView *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row != 0 && self.editButton.selected;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
       itemAtIndexPath:(NSIndexPath *)sourceIndexPath
    canMoveToIndexPath:(NSIndexPath *)destinationIndexPath{
    return destinationIndexPath.row != 0 && self.editButton.selected;
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *text = self.btnTitles[sourceIndexPath.row];
    [self.btnTitles removeObjectAtIndex:sourceIndexPath.row];
    [self.btnTitles insertObject:text atIndex:destinationIndexPath.row];
    
    if ([_delegate respondsToSelector:@selector(collectionView:itemAtIndexPath:didMoveToIndexPath:)]) {
        [_delegate collectionView:collectionView itemAtIndexPath:sourceIndexPath didMoveToIndexPath:destinationIndexPath];
    }
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
- (NSMutableArray *)btnTitles
{
    if (!_btnTitles) {
        _btnTitles = [NSMutableArray array];
    }
    return _btnTitles;
}

@end
