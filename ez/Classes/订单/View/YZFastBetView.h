//
//  YZFastBetView.h
//  ez
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YZFastBetViewDelegate <NSObject>

- (void)FastBetViewCancelBtnClick;
- (void)FastBetViewCancelBtnClickWithTermNumber:(int)termNumber multipleNumber:(int)multipleNumber winStop:(BOOL)winStop;
- (void)FastBetViewgotoRecharge;

@end
@interface YZFastBetView : UIView

@property (nonatomic, weak) id<YZFastBetViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame amount:(int)amount termNumber:(int)termNumber multipleNumber:(int)multipleNumber winStop:(BOOL)winStop;

@end
