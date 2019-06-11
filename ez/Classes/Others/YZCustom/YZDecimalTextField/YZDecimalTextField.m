//
//  YZDecimalTextField.m
//  ez
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 9ge. All rights reserved.
//  小数输入框

#import "YZDecimalTextField.h"

@interface YZDecimalTextField ()<UITextFieldDelegate>

@end

@implementation YZDecimalTextField
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.keyboardType = UIKeyboardTypeDecimalPad;
        self.delegate = self;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.keyboardType = UIKeyboardTypeDecimalPad;
        self.delegate = self;
    }
    return self;
}
#pragma mark- UITextFieldDelegate
//限制金额输入框只能输入整数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL isHaveDian = YES;
    if (textField.keyboardType == UIKeyboardTypeDecimalPad) {
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            isHaveDian=NO;
        }
        if ([string length]>0)
        {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if ((single >='0' && single<='9') || single=='.')//数据格式正确
            {
                //首字母不能为0和小数点
                if([textField.text length]==0){
                    if(single == '.'){
                        //  [self alertView:@"亲，第一个数字不能为小数点"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                        
                    }
                }else if (textField.text.length == 1 && [textField.text isEqualToString:@"0"]){
                    if (single != '.') {
                        //     [self alertView:@"亲，第一个数字不能为0"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                        
                    }
                }
                if (single=='.')
                {
                    if(!isHaveDian)//text中还没有小数点
                    {
                        isHaveDian=YES;
                        return YES;
                    }else
                    {
                        //   [self alertView:@"亲，您已经输入过小数点了"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                else
                {
                    if (isHaveDian)//存在小数点
                    {
                        //判断小数点的位数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        NSInteger tt=range.location-ran.location;
                        if (tt <= 2){
                            return YES;
                        }else{
                            // [self alertView:@"亲，您最多输入两位小数"];
                            return NO;
                        }
                    }
                    else
                    {
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                // [self alertView:@"亲，您输入的格式不正确"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            return YES;
        }
    }
    return YES;
}
@end
