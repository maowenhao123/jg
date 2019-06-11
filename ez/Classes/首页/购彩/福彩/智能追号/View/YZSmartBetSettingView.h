//
//  YZSmartBetSettingView.h
//  ez
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZSmartBetSettingViewDelegate <NSObject>

- (void)SmartBetSettingViewCancelBtnClick;
- (void)SmartBetSettingViewConfirmBtnClickWithTermNumber:(int)termNumber multipleNumber:(int)multipleNumber type:(int)type profitArray:(NSArray *)profitArray isWinStop:(BOOL)winStop;

@end

@interface YZSmartBetSettingView : UIView

@property (nonatomic, assign) int termCount;
@property (nonatomic, assign) int multipleNumber;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSArray *profitArray;
@property (nonatomic, assign) BOOL winStop;
@property (nonatomic, weak) id<YZSmartBetSettingViewDelegate> delegate;

@end
