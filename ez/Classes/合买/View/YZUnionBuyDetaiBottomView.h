//
//  YZUnionBuyDetaiBottomView.h
//  ez
//
//  Created by 毛文豪 on 2019/5/13.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZUnionBuyStatus.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YZUnionBuyDetaiBottomViewDelegate <NSObject>

- (void)bottomViewConfirmBtnClick;

@end


@interface YZUnionBuyDetaiBottomView : UIView

@property (nonatomic, strong) YZUnionBuyStatus *unionBuyStatus;//合买信息模型

@property (nonatomic, weak) UITextField *moneyTd;//输入钱的输入框

@property (nonatomic, weak) id<YZUnionBuyDetaiBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
