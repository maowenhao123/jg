//
//  YZTextView.m
//  ez
//
//  Created by dahe on 2019/6/20.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZTextView.h"

@interface YZTextView ()<UITextViewDelegate>

@property (nonatomic,weak) UILabel *placeholderLabel; //这里先拿出这个label以方便我们后面的使用
@property (nonatomic, weak) UILabel *maxLimitNumLabel;

@end

@implementation YZTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor= [UIColor clearColor];
        self.font = [UIFont systemFontOfSize:13]; //设置默认的字体
        self.contentInset = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f);
        
        //placeholder
        UILabel *placeholderLabel = [[UILabel alloc]init];//添加一个占位label
        self.placeholderLabel = placeholderLabel; //赋值保存
        placeholderLabel.backgroundColor = [UIColor clearColor];
        placeholderLabel.numberOfLines = 0; //设置可以输入多行文字时可以自动换行
        [self addSubview:placeholderLabel];
        self.myPlaceholderColor= YZColor(210, 210, 210, 1); //设置占位文字默认颜色
        //字数限制
        UILabel *maxLimitNumLabel = [[UILabel alloc] init];
        self.maxLimitNumLabel = maxLimitNumLabel;
        maxLimitNumLabel.font = self.font;
        maxLimitNumLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:maxLimitNumLabel];
        
        self.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self]; //通知:监听文字的改变
    }
    return self;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.size.height = self.font.lineHeight + 2;
    return originalRect;
}

#pragma mark -监听文字改变
- (void)textDidChange {
    self.placeholderLabel.hidden = self.hasText;
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.placeholderLabel.y = 8; //设置UILabel 的 y值
    self.placeholderLabel.x = 5;//设置 UILabel 的 x 值
    self.placeholderLabel.width = self.width - self.placeholderLabel.x * 2.0; //设置 UILabel 的 x
    //根据文字计算高度
    CGSize placeholderLabelSize = CGSizeMake(self.placeholderLabel.width,MAXFLOAT);
    self.placeholderLabel.height = [self.myPlaceholder boundingRectWithSize:placeholderLabelSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLabel.font} context:nil].size.height;
    
    CGSize maxLimitNumSize = [self.maxLimitNumLabel.text boundingRectWithSize:self.size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
    self.maxLimitNumLabel.y = self.height - maxLimitNumSize.height - 8;
    self.maxLimitNumLabel.x = self.width - maxLimitNumSize.width - 5;
    self.maxLimitNumLabel.size = maxLimitNumSize;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if (self.maxLimitNums <= 0) {
        return YES;
    }
    UITextRange *selecteYZange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selecteYZange.start offset:0];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selecteYZange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selecteYZange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selecteYZange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < self.maxLimitNums) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = self.maxLimitNums - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            self.maxLimitNumLabel.text = [NSString stringWithFormat:@"%d/%ld",0,(long)self.maxLimitNums];
            //重新计算子控件frame
            [self setNeedsLayout];
        }
        return NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.maxLimitNums <= 0) {
        return;
    }
    UITextRange *selecteYZange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selecteYZange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selecteYZange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > self.maxLimitNums)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:self.maxLimitNums];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    self.maxLimitNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",MAX(0, existTextNum),(long)self.maxLimitNums];
    //重新计算子控件frame
    [self setNeedsLayout];
}
#pragma mark - setter
- (void)setMyPlaceholder:(NSString*)myPlaceholder{
    
    _myPlaceholder= [myPlaceholder copy];
    [self textDidChange];
    //设置文字
    self.placeholderLabel.text= myPlaceholder;
    //重新计算子控件frame
    [self setNeedsLayout];
}
- (void)setMyPlaceholderColor:(UIColor*)myPlaceholderColor{
    
    _myPlaceholderColor= myPlaceholderColor;
    //设置颜色
    self.placeholderLabel.textColor= myPlaceholderColor;
}
- (void)setFont:(UIFont*)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
    self.maxLimitNumLabel.font = font;
    //重新计算子控件frame
    [self setNeedsLayout];
}
- (void)setMaxLimitNums:(NSInteger)maxLimitNums
{
    _maxLimitNums = maxLimitNums;
    self.maxLimitNumLabel.text = [NSString stringWithFormat:@"0/%ld",(long)_maxLimitNums];
    self.maxLimitNumLabel.hidden = _maxLimitNums <= 0;
}
- (void)setMaxLimitNumColor:(UIColor *)maxLimitNumColor
{
    _maxLimitNumColor = maxLimitNumColor;
    //设置颜色
    self.maxLimitNumLabel.textColor= maxLimitNumColor;
}
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange];
}
- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    self.placeholderLabel.hidden = self.hasText;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:UITextViewTextDidChangeNotification];
}
@end
