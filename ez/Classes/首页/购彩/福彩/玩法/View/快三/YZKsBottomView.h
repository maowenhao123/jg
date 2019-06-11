//
//  YZKsBottomView.h
//  ez
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KsBottomViewDelegate <NSObject>

- (void)bottomViewDeleteBtnClick;
- (void)bottomViewConfirmBtnClick;

@end

@interface YZKsBottomView : UIView

@property (nonatomic, weak) id <KsBottomViewDelegate> delegate;

- (void)setBetCount:(int)betCount;

@end
