//
//  YZCirclePlayTypePickerView.h
//  ez
//
//  Created by dahe on 2019/6/25.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CirclePlayTypePickerViewBlock)(NSDictionary * communityDic, NSDictionary * gameDic);

@interface YZCirclePlayTypePickerView : UIView

@property (copy, nonatomic)CirclePlayTypePickerViewBlock block;

- (void)show;

@end

NS_ASSUME_NONNULL_END
