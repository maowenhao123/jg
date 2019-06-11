//
//  YZDateTool.m
//  ez
//
//  Created by apple on 16/11/23.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZDateTool.h"

@implementation YZDateTool

//把时间戳转换为字符串
+ (NSString *)getTimeByTimestamp:(long long)timestamp format:(NSString *)format
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSTimeInterval)getTimestampByTime:(NSString *)time format:(NSString *)format
{
    NSDate * date = [self getDateFromDateString:time format:format];
    return [date timeIntervalSince1970];
}

+ (NSString *)getWeekFromDateString:(NSString *)dateString format:(NSString *)format
{
    NSDate *date = [self getDateFromDateString:dateString format:format];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unit fromDate:date];
    NSArray *weakDayArray = @[@"",@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    NSInteger weekDay = components.weekday;
    NSString *weekStr = weakDayArray[weekDay];
    return  weekStr;
}

+ (NSString *)getChineseDateStringFromDateString:(NSString *)dateString format:(NSString *)format
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDate *date = [self getDateFromDateString:dateString format:format];
    NSDateComponents *components = [calendar components:unit fromDate:date];
    NSArray *weakDayArray = [[NSArray alloc] initWithObjects:@"",@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSInteger weekDay = components.weekday;
    NSString *weakDayStr = weakDayArray[weekDay];
    NSString *chineseDateStr = [NSString stringWithFormat:@"%ld年%02ld月%02ld日 %@",(long)components.year,(long)components.month,(long)components.day,weakDayStr];
    return chineseDateStr;
}
+ (NSString *)getDateStringFromDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    NSString *string = [dateFormatter stringFromDate:date];
    return string;
}
+ (NSDateComponents *)getDeltaDateToDateString:(NSString *)dateString format:(NSString *)format
{
    NSDate *toDate = [self getDateFromDateString:dateString format:format];
    NSDate *fromday = [NSDate date];//得到当前时间
    //用来得到具体的时差
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *deltaDate = [cal components:unitFlags fromDate:fromday toDate:toDate options:0];
    return deltaDate;
}
+ (NSDateComponents *)getDeltaDateFromDateString:(NSString *)fromDateString fromFormat:(NSString *)fromFormat toDateString:(NSString *)toDateString ToFormat:(NSString *)toFormat
{
    NSDate *toDate = [self getDateFromDateString:toDateString format:toFormat];
    NSDate *fromday = [self getDateFromDateString:fromDateString format:fromFormat];

    //用来得到具体的时差
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *deltaDate = [cal components:unitFlags fromDate:fromday toDate:toDate options:0];
    return deltaDate;
}
+ (NSDate *)getDateFromDateString:(NSString *)dateString format:(NSString *)format
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = format;
    NSDate *date = [fmt dateFromString:dateString];
    if(!dateString)
    {
        date = [NSDate date];
    }
    return date;
}
+ (NSDateComponents *)getDateComponentsBySeconds:(NSInteger)seconds
{
    NSDateComponents * deltaDate = [[NSDateComponents alloc]init];
    deltaDate.day = seconds / (24 * 60 * 60);
    deltaDate.hour = (seconds / (60 * 60)) % 24;
    deltaDate.minute = (seconds / 60) % 60;
    deltaDate.second = seconds % 60;
    return deltaDate;
}

//获取当前时间戳（以毫秒为单位）
+ (NSString *)getNowTimeTimestamp
{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[datenow timeIntervalSince1970] * 1000];
    
    return timeSp;
}

@end
