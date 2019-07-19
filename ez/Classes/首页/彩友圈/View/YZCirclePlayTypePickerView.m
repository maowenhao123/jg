//
//  YZCirclePlayTypePickerView.m
//  ez
//
//  Created by dahe on 2019/6/25.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZCirclePlayTypePickerView.h"

@interface YZCirclePlayTypePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIPickerView * pickView;
@property (nonatomic, strong) NSArray *sortArray1;
@property (nonatomic, strong) NSArray *sortArray2;
@property (nonatomic, assign) NSInteger selectedIndex1;
@property (nonatomic, assign) NSInteger selectedIndex2;
@property (nonatomic, strong) id json;

@end

@implementation YZCirclePlayTypePickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidden = YES;
        self.frame = [UIScreen mainScreen].bounds;
        UIView *topView = [KEY_WINDOW.subviews firstObject];
        [topView addSubview:self];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight, screenWidth, 44 + 250)];
        self.contentView = contentView;
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        
        //工具栏取消和选择
        UIToolbar * toolBar = [[UIToolbar alloc]init];
        toolBar.frame = CGRectMake(0, 0, screenWidth, 44);
        [contentView addSubview:toolBar];
        
        UIBarButtonItem * barButtonItem1 = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(hide)];
        UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * barButtonItem2 = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectBarClicked)];
        
        //设置字体大小
        NSDictionary * attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
        [barButtonItem1 setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [barButtonItem2 setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        [toolBar setItems:@[barButtonItem1,spaceItem,barButtonItem2]];
        
        //PickerView
        UIPickerView * pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, screenWidth, 250)];
        self.pickView = pickView;
        pickView.backgroundColor = [UIColor whiteColor];
        pickView.delegate = self;
        pickView.dataSource = self;
        [pickView selectRow:0 inComponent:0 animated:NO];
        [contentView addSubview:pickView];
        
        [self getData];
    }
    return self;
}

- (void)getData
{
    NSDictionary *dict = @{
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/getAllCommunityPlayTypeList") params:dict success:^(id json) {
        YZLog(@"getAllCommunityPlayTypeList:%@",json);
        if (SUCCESS){
            self.json = json;
            [self setSortArray1];
            [self setSortArray2WithRow1:0];
            [self.pickView reloadAllComponents];
        }else
        {
            ShowErrorView
        }
    }failure:^(NSError *error)
    {
        YZLog(@"error = %@",error);
    }];
}

//设置数据
- (void)setSortArray1
{
    NSArray * sortArr = self.json[@"community"];
    NSMutableArray *sortMuArr = [NSMutableArray array];
    for (NSDictionary * sortDic in sortArr) {
        [sortMuArr addObject:sortDic[@"name"]];
    }
    self.sortArray1 = [NSArray arrayWithArray:sortMuArr];
}
- (void)setSortArray2WithRow1:(NSInteger)row1
{
    NSArray * sortArr = self.json[@"community"];
    
    NSDictionary * sortDic_child = sortArr[row1];
    NSArray * sortArr_child = sortDic_child[@"playTypes"];
    
    NSMutableArray *sortMuArr = [NSMutableArray array];
    for (NSDictionary * sortDic in sortArr_child) {
        [sortMuArr addObject:sortDic[@"name"]];
    }
    self.sortArray2 = [NSArray arrayWithArray:sortMuArr];
}

#pragma  mark - function
- (void)selectBarClicked
{
    NSArray * sortArr = self.json[@"community"];
    
    NSDictionary * sortDic_child = sortArr[self.selectedIndex1];
    NSArray * sortArr_child = sortDic_child[@"playTypes"];
    
    if (self.block) {
        self.block(sortArr[self.selectedIndex1], sortArr_child[self.selectedIndex2]);
    }
    [self hide];
}

- (void)show{
    self.hidden = NO;
    [UIView animateWithDuration:animateDuration animations:^{
        self.contentView.y = screenHeight - 255;
        self.backgroundColor = YZColor(0, 0, 0, 0.4);
    }];
}
- (void)hide{
    [UIView animateWithDuration:animateDuration animations:^{
        self.contentView.y = screenHeight;
        self.backgroundColor = YZColor(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.sortArray1.count;
    }
    return self.sortArray2.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.sortArray1[row];
    }
    return self.sortArray2[row];
}
#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textColor = YZBlackTextColor;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:YZGetFontSize(32)]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //刷新数据
    if (component == 0) {
        [self setSortArray2WithRow1:row];
        self.selectedIndex2 = 0;
        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView reloadComponent:1];
        
        self.selectedIndex1 = row;
    }else if (component == 1)
    {
        self.selectedIndex2 = row;
    }
}
#pragma mark - 初始化
- (NSArray *)sortArray1
{
    if (!_sortArray1)
    {
        _sortArray1 = [NSArray array];
    }
    return _sortArray1;
}
- (NSArray *)sortArray2
{
    if (!_sortArray2)
    {
        _sortArray2 = [NSArray array];
    }
    return _sortArray2;
}
@end
