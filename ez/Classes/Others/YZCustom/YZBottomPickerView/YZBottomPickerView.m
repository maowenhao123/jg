//
//  YZBottomPickerView.m
//  ez
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZBottomPickerView.h"

@interface YZBottomPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, copy) NSString *selectedString;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation YZBottomPickerView

- (instancetype)initWithArray:(NSArray *)dataArray index:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.dataArray = dataArray;
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = YZColor(0, 0, 0, 0.4);
        
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
        pickView.backgroundColor = [UIColor whiteColor];
        pickView.delegate = self;
        pickView.dataSource = self;
        [contentView addSubview:pickView];
        
        [pickView selectRow:index inComponent:0 animated:NO];
        self.selectedString = self.dataArray[index];
    }
    return self;
}
#pragma  mark - function
- (void)selectBarClicked
{
    NSInteger selectedIndex = [self.dataArray indexOfObject:self.selectedString];
    if (self.block) {
        self.block(selectedIndex);
    }
    [self hide];
}

- (void)show{
    UIView *topView = [KEY_WINDOW.subviews firstObject];
    [topView addSubview:self];
    
    [UIView animateWithDuration:animateDuration animations:^{
        self.contentView.y = screenHeight - self.contentView.height;
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

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataArray[row];
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 8.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textColor = YZBlackTextColor;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedString = self.dataArray[row];
}

@end
