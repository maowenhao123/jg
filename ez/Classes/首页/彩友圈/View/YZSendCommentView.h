//
//  YZSendCommentView.h
//  ez
//
//  Created by dahe on 2019/6/21.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZTextView.h"
#import "YZCircleModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SendCommentViewDelegate <NSObject>

@optional
- (void)textViewChangeHeight:(CGFloat)height;
- (void)textViewSendButtonDidClickWithText:(NSString *)text;
- (void)textViewPraiseDidClick;

@end

@interface YZSendCommentView : UIView

@property (nonatomic,weak) YZTextView * textView;
@property (nonatomic,weak) UIButton * sendButton;
@property (nonatomic, weak) UIButton * praiseButton;
@property (nonatomic, weak) UIButton * commentButton;
@property (nonatomic, weak) id<SendCommentViewDelegate> delegate;
@property (nonatomic, strong) YZCircleModel *circleModel;
@property (nonatomic,copy) NSString *toUserId;
@property (nonatomic,strong) NSIndexPath *indexPath;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
