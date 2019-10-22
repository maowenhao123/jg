//
//  YZSendCommentView.m
//  ez
//
//  Created by dahe on 2019/6/21.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZSendCommentView.h"
#import "UIButton+YZ.h"

@interface YZSendCommentView ()<UITextViewDelegate>

@end

@implementation YZSendCommentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self]; //通知:监听文字的改变
        [self setupChilds];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self]; //通知:监听文字的改变
        [self setupChilds];
    }
    return self;
}

- (void)setupChilds
{
    self.backgroundColor = [UIColor whiteColor];
    //阴影
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -4);
    self.layer.shadowOpacity = 0.5;
    
    //发送
    UIButton * sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton = sendButton;
    sendButton.hidden = YES;
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:YZBaseColor forState:UIControlStateNormal];
    [sendButton setTitleColor:YZGrayTextColor forState:UIControlStateDisabled];
    sendButton.enabled = NO;//默认不可选
    sendButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [sendButton addTarget:self action:@selector(sendButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    sendButton.frame = CGRectMake(self.width - 60, 0, 60, 40);
    [self addSubview:sendButton];
    
    //点赞
    UIButton * praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.praiseButton = praiseButton;
    praiseButton.frame = CGRectMake(self.width - 50, 0, 40, 40);
    [praiseButton setImage:[UIImage imageNamed:@"show_praise_gray"] forState:UIControlStateNormal];
    [praiseButton setImage:[UIImage imageNamed:@"show_praise_light"] forState:UIControlStateSelected];
    [praiseButton setTitleColor:YZGrayTextColor forState:UIControlStateNormal];
    praiseButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [praiseButton addTarget:self action:@selector(praiseButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:praiseButton];
    
    //评论
    UIButton * commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentButton = commentButton;
    commentButton.frame = CGRectMake(self.width - 90, 0, 40, 40);
    [commentButton setImage:[UIImage imageNamed:@"show_comment"] forState:UIControlStateNormal];
    [commentButton setTitleColor:YZGrayTextColor forState:UIControlStateNormal];
    commentButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [self addSubview:commentButton];
    
    [praiseButton setTitle:@"0" forState:UIControlStateNormal];
    [commentButton setTitle:@"0" forState:UIControlStateNormal];
    [praiseButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:2];
    [commentButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:2];
    
    YZTextView * textView = [[YZTextView alloc] init];
    self.textView = textView;
    textView.frame = CGRectMake(YZMargin, 5, commentButton.x - 5 - YZMargin, 30);
    textView.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    textView.tintColor = YZRedTextColor;
    textView.myPlaceholder = @"暂不支持评论";
    textView.userInteractionEnabled = NO;
//    textView.myPlaceholder = @"请评论...";
    textView.returnKeyType = UIReturnKeySend;
    textView.enablesReturnKeyAutomatically = YES;
    textView.delegate = self;
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 5;
    textView.layer.borderColor = YZWhiteLineColor.CGColor;
    textView.layer.borderWidth = 1;
    [self addSubview:textView];
}

- (void)sendButtonDidClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewSendButtonDidClickWithText:)]) {
        [self.delegate textViewSendButtonDidClickWithText:self.textView.text];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    self.sendButton.enabled = textView.text.length > 0;
    static CGFloat maxHeight = 100.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }else{
        if (size.height >= maxHeight)
        {
            size.height = maxHeight;
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    textView.height = size.height;
    self.sendButton.centerY = textView.centerY;
    self.height = size.height + 10;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewChangeHeight:)]) {
        [self.delegate textViewChangeHeight:self.frame.size.height];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [self sendButtonDidClick];
        return NO;
    }
    
    return YES;
}

- (void)dealloc {
    //注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setCircleModel:(YZCircleModel *)circleModel
{
    _circleModel = circleModel;
    
    self.praiseButton.selected = [_circleModel.likeStatus boolValue];
    [self.praiseButton setTitle:[NSString stringWithFormat:@"%@", _circleModel.likeNumber] forState:UIControlStateNormal];
    //    [self.commentButton setTitle:[NSString stringWithFormat:@"%@", _circleModel.concernNumber] forState:UIControlStateNormal];
    [self.commentButton setTitle:@"0" forState:UIControlStateNormal];
    [self.praiseButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:2];
    [self.commentButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:2];
}

- (void)reset
{
    self.textView.height = 30;
    self.height = 40;
    self.sendButton.centerY = self.textView.centerY;
    self.textView.text = nil;
    self.sendButton.enabled = NO;
    self.toUserId = @"";
    self.indexPath = nil;
    self.textView.myPlaceholder = @"请评论...";
}

#pragma mark - 点赞
- (void)praiseButtonDidClick
{
    NSString * topicId = self.circleModel.topicId;
    if (YZStringIsEmpty(topicId)) {
        topicId = self.circleModel.id;
    }
    NSDictionary *dict = @{
                           @"userId": UserId,
                           @"topicId": topicId,
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/topicLike") params:dict success:^(id json) {
        YZLog(@"topicLike:%@",json);
        if (SUCCESS){
            self.praiseButton.selected = [json[@"likeStatus"] boolValue];
            int likeNumber = [self.praiseButton.currentTitle intValue];
            if (self.praiseButton.selected) {
                likeNumber++;
            }else
            {
                likeNumber--;
            }
            [self.praiseButton setTitle:[NSString stringWithFormat:@"%d", likeNumber] forState:UIControlStateNormal];
        }else
        {
            ShowErrorView
        }
    }failure:^(NSError *error)
     {
         YZLog(@"error = %@",error);
     }];
}


@end
