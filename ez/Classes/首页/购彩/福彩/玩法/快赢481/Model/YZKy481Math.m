//
//  YZKy481Math.m
//  ez
//
//  Created by dahe on 2019/11/14.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481Math.h"
#import "YZBallBtn.h"

@implementation YZKy481Math

+ (int)getBetCountWithSelStatusArray:(NSArray *)selStatusArray selectedPlayTypeBtnTag:(NSInteger)selectedPlayTypeBtnTag
{
    NSInteger composeCount = 0;
    if (selectedPlayTypeBtnTag == 0 || selectedPlayTypeBtnTag == 1 || selectedPlayTypeBtnTag == 2 || selectedPlayTypeBtnTag == 6) {
        NSInteger count1 = 0;
        NSInteger count2 = 0;
        NSInteger count3 = 0;
        NSInteger count4 = 0;
        for (NSArray * cellStatusArray in selStatusArray) {
            NSInteger index = [selStatusArray indexOfObject:cellStatusArray];
            if (index == 0) {
                count1 = cellStatusArray.count;
            }else if (index == 1)
            {
                count2 = cellStatusArray.count;
            }else if (index == 2)
            {
                count3 = cellStatusArray.count;
            }else if (index == 3)
            {
                count4 = cellStatusArray.count;
            }
        }
        if (selectedPlayTypeBtnTag == 0) {//任选一
            composeCount = count1 + count2 + count3 + count4;
        }else if (selectedPlayTypeBtnTag == 1)//任选二
        {
            NSArray * counts = @[@(count1), @(count2), @(count3), @(count4)];
            for (int i = 0; i < counts.count; i++) {
                for (int j = i + 1; j < counts.count; j++) {
                    composeCount += [counts[i] integerValue] * [counts[j] integerValue];
                }
            }
        }else if (selectedPlayTypeBtnTag == 2)//任选三
        {
            NSArray * counts = @[@(count1), @(count2), @(count3), @(count4)];
            for (int i = 0; i < counts.count; i++) {
                for (int j = i + 1; j < counts.count; j++) {
                    for (int k = j + 1; k < counts.count; k++) {
                        composeCount += [counts[i] integerValue] * [counts[j] integerValue] * [counts[k] integerValue];
                    }
                }
            }
        }else if (selectedPlayTypeBtnTag == 6)//直选
        {
            composeCount = count1 * count2 * count3 * count4;
        }
    }else if (selectedPlayTypeBtnTag == 3)//任选二全包
    {
        NSMutableArray * counts1 = [NSMutableArray array];
        NSMutableArray * counts2 = [NSMutableArray array];
        for (NSArray * cellStatusArray in selStatusArray) {
            NSInteger index = [selStatusArray indexOfObject:cellStatusArray];
            for (YZBallBtn *ball in cellStatusArray) {
                if (index == 0) {
                    [counts1 addObject:@(ball.tag)];
                }else if (index == 1)
                {
                    [counts2 addObject:@(ball.tag)];
                }
            }
        }
        
        int countTwoSame = [self countTwoSameCountWithArray1:counts1 array2:counts2];
        if (countTwoSame == 1) {
            NSInteger countTwoNoSame = counts1.count * counts2.count - countTwoSame;
            composeCount = countTwoSame * 6 + countTwoNoSame * 12;
        }else
        {
            NSInteger total = counts1.count * counts2.count - countTwoSame;
            //重复两不同组合数
            NSInteger repetitionTwoSame = countTwoSame * countTwoSame - countTwoSame;
            //非重复两不同组合数
            NSInteger noRepetitionTwoSame = total - repetitionTwoSame;
            NSInteger countTwoNoSame = repetitionTwoSame / 2 + noRepetitionTwoSame;
            composeCount = countTwoSame * 6 + countTwoNoSame * 12;
        }
    }else if (selectedPlayTypeBtnTag == 5)//任选三全包
    {
        NSMutableArray * counts1 = [NSMutableArray array];
        NSMutableArray * counts2 = [NSMutableArray array];
        NSMutableArray * counts3 = [NSMutableArray array];
        for (NSArray * cellStatusArray in selStatusArray) {
            NSInteger index = [selStatusArray indexOfObject:cellStatusArray];
            for (YZBallBtn *ball in cellStatusArray) {
                if (index == 0) {
                    [counts1 addObject:@(ball.tag)];
                }else if (index == 1)
                {
                    [counts2 addObject:@(ball.tag)];
                }else if (index == 2)
                {
                    [counts3 addObject:@(ball.tag)];
                }
            }
        }
        
        NSMutableSet *threeSameList = [self getThreeSameSetWithArray1:counts1 array2:counts2 array3:counts3];
        NSInteger countThreeSame = threeSameList.count;
        
        NSMutableSet *twoSameFirst = [self getTwoSameSetWithArray1:counts1 array2:counts2 array3:counts3];
        NSMutableSet *twoSameSecond = [self getTwoSameSetWithArray1:counts2 array2:counts3 array3:counts1];
        NSMutableSet *twoSameThird = [self getTwoSameSetWithArray1:counts3 array2:counts1 array3:counts2];
        [twoSameFirst unionSet:twoSameSecond];
        [twoSameFirst unionSet:twoSameThird];
        [twoSameFirst minusSet:threeSameList];
        
        NSInteger countTotalTwoSame = twoSameFirst.count;
        
        NSMutableSet * thirdNoSameList = [self getThirdNoSameSetWithArray1:counts1 array2:counts2 array3:counts3];
        [thirdNoSameList minusSet:twoSameFirst];
        [thirdNoSameList minusSet:threeSameList];
        NSInteger countThreeNoSame = thirdNoSameList.count;
        
        composeCount = countThreeSame * 4 + countTotalTwoSame * 12 + countThreeNoSame * 24;
    }else if (selectedPlayTypeBtnTag == 8 || selectedPlayTypeBtnTag == 10)//组6 组24
    {
        int ballcount = 0;
        int dancount = 0;
        for (NSArray * cellStatusArray in selStatusArray) {
            NSInteger index = [selStatusArray indexOfObject:cellStatusArray];
            if (index == 0) {
                ballcount = (int)cellStatusArray.count;
            }else if (index == 1)
            {
                dancount = (int)cellStatusArray.count;
            }
        }
        if (selectedPlayTypeBtnTag == 10) {
            int i = ballcount - dancount;
            int top = 1;
            int left = 1;
            int right = 1;
            if (ballcount > 4) {
                while (i >= 1) {
                    top = top * i;
                    i--;
                }
                i = 4 - dancount;
                while (i >= 1) {
                    left = left * i;
                    i--;
                }
                i = ballcount - 4;
                while (i >= 1) {
                    right = right * i;
                    i--;
                }
                
                composeCount = top / (left * right);
            } else if (ballcount == 4 && dancount == 0)
            {
                composeCount = 1;
            }
        } else if (selectedPlayTypeBtnTag == 8) {
            int top = 1;
            int left = 1;
            int right = 1;
            int i = ballcount - dancount;
            if (ballcount > 2) {
                while (i >= 1) {
                    top = top * i;
                    i--;
                }
                i = 2 - dancount;
                while (i >= 1) {
                    left = left * i;
                    i--;
                }
                i = ballcount - 2;
                while (i >= 1) {
                    right = right * i;
                    i--;
                }
                composeCount = top / (left * right);
            } else if (ballcount == 2) {
                composeCount = 1;
            }
        }
    }else if (selectedPlayTypeBtnTag == 7 || selectedPlayTypeBtnTag == 9)//组4 组12
    {
        int ballcount = 0;
        int chongcount = 0;
        for (NSArray * cellStatusArray in selStatusArray) {
            NSInteger index = [selStatusArray indexOfObject:cellStatusArray];
            if (index == 0) {
                chongcount = (int)cellStatusArray.count;
            }else if (index == 1)
            {
                ballcount = (int)cellStatusArray.count;
            }
        }
        int composeCount_ = 1;
        if (selectedPlayTypeBtnTag == 9) {//组12
            int basecount = 3;
            if (ballcount == 3) {
                composeCount_ = basecount;
            } else
            {
                int i = ballcount;
                while (i >= 1) {
                    composeCount_ = composeCount_ * i;
                    i--;
                }
                composeCount_ = composeCount_ / 6;
                i = ballcount - 3;
                while (i >= 1) {
                    composeCount_ = composeCount_ / i;
                    i--;
                }
                composeCount_ = composeCount_ * basecount;
            }
            if (chongcount == 0) {
                composeCount = composeCount_;
            }else
            {
                if (ballcount > 2) {
                    composeCount = (composeCount_ / (ballcount - 2)) * chongcount;
                }else
                {
                    composeCount = composeCount_ + chongcount;
                }
            }
        }else if (selectedPlayTypeBtnTag == 7) {//组4
            int basesum = 2;
            if (ballcount == 2) {
                composeCount_ = basesum;
            } else {
                int i = ballcount;
                while (i >= 1) {
                    composeCount_ = composeCount_ * i;
                    i--;
                }
                composeCount_ = composeCount_ / 2;
                i = ballcount - 2;
                while (i >= 1) {
                    composeCount_ = composeCount_ / i;
                    i--;
                }
                composeCount_ = composeCount_ * basesum;
            }
            if (chongcount == 0) {
                composeCount = composeCount_;
            }else
            {
                if (ballcount > 1) {
                    composeCount = (composeCount_ / (ballcount - 1)) * chongcount;
                }else
                {
                    composeCount = composeCount_ + chongcount;
                }
            }
        }
    }else if (selectedPlayTypeBtnTag == 4)//任选二万能
    {
        int basesum = 6;
        NSArray * cellStatusArray = selStatusArray[0];
        for (YZBallBtn * ballBtn in cellStatusArray) {
            NSString * number = ballBtn.currentTitle;
            if (!YZStringIsEmpty(number) && number.length == 2) {
                NSString * subNumber1 = [number substringWithRange:NSMakeRange(0, 1)];
                NSString * subNumber2 = [number substringWithRange:NSMakeRange(1, 1)];
                if ([subNumber1 isEqualToString:subNumber2]) {
                    composeCount += basesum;
                }else
                {
                    composeCount += basesum * 2;
                }
            }
        }
    }
    return (int)composeCount;
}

//判断两个数组相同的值的个数
+ (int)countTwoSameCountWithArray1:(NSArray *)array1 array2:(NSArray *)array2
{
    int sameCount = 0;
    for (int i = 0; i < array1.count; i++) {
        if ([array2 containsObject:array1[i]]) {
            sameCount++;
        }
    }
    return sameCount;
}

//获取三个数组相同的值
+ (NSMutableSet *)getThreeSameSetWithArray1:(NSArray *)array1 array2:(NSArray *)array2 array3:(NSArray *)array3
{
    NSMutableSet * resultSet = [NSMutableSet set];
    for (int i = 0; i < array1.count; i++) {
        if ([array2 containsObject:array1[i]] && [array3 containsObject:array1[i]]) {
            NSString * code = [NSString stringWithFormat:@"%@,%@,%@", array1[i], array1[i], array1[i]];
            [resultSet addObject:code];
        }
    }
    return resultSet;
}

//从第一位数组和第二位数组中得到相同的数的数组, 然后,计算二同组合数.
+ (NSMutableSet *)getTwoSameSetWithArray1:(NSArray *)array1 array2:(NSArray *)array2 array3:(NSArray *)array3
{
    NSMutableArray * twoSameArray = [NSMutableArray array];
    for (int i = 0; i < array1.count; i++) {
        if ([array2 containsObject:array1[i]]) {
            [twoSameArray addObject:array1[i]];
        }
    }
    NSMutableSet * resultSet = [NSMutableSet set];
    for (NSNumber * number1 in twoSameArray) {
        for (NSNumber * number2 in array3) {
            if ([number1 integerValue] == [number2 integerValue]) {
                continue;
            }
            NSMutableArray * codes = [NSMutableArray arrayWithArray:@[number1, number1, number2]];
            [codes sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
                return obj1 > obj2;
            }];
            NSString * code = [NSString stringWithFormat:@"%@,%@,%@", codes[0], codes[1], codes[2]];
            [resultSet addObject:code];
        }
    }
    return resultSet;
}

//从第一位集合数和第二位集合数中得到相同的数的集合, 然后,计算二同组合数.
+ (NSMutableSet *)getThirdNoSameSetWithArray1:(NSArray *)array1 array2:(NSArray *)array2 array3:(NSArray *)array3
{
    NSMutableSet * resultSet = [NSMutableSet set];
    for (NSNumber * number1 in array1) {
        for (NSNumber * number2 in array2) {
            for (NSNumber * number3 in array3) {
                if ([number1 integerValue] == [number2 integerValue] && [number1 integerValue] == [number3 integerValue]) {
                    continue;
                }
                NSMutableArray * codes = [NSMutableArray arrayWithArray:@[number1, number2, number3]];
                [codes sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
                    return obj1 > obj2;
                }];
                NSString * code = [NSString stringWithFormat:@"%@,%@,%@", codes[0], codes[1], codes[2]];
                [resultSet addObject:code];
            }
        }
    }
    return resultSet;
}


@end
