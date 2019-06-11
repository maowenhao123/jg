//
//  YZDateTool.h
//  ez
//
//  Created by apple on 16/11/23.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZDateTool : NSObject

/**
 通过时间戳获取时间
 */
+ (NSString *)getTimeByTimestamp:(long long)timestamp format:(NSString *)format;
/**
 通过时间戳获取时间
 */
+ (NSTimeInterval)getTimestampByTime:(NSString *)time format:(NSString *)format;
/**
 *  从字符串获取星期几
 */
+ (NSString *)getWeekFromDateString:(NSString *)dateString format:(NSString *)format;
/**
 *  从日期字符串获取格式为
 */
+ (NSString *)getChineseDateStringFromDateString:(NSString *)dateString format:(NSString *)format;
/**
 *  从日期字符串获取格式为
 */
+ (NSString *)getDateStringFromDate:(NSDate *)date format:(NSString *)format;
/*
 获取时间差
 */
+ (NSDateComponents *)getDeltaDateToDateString:(NSString *)dateString format:(NSString *)format;
/*
 获取两个时间段的时间差
 */
+ (NSDateComponents *)getDeltaDateFromDateString:(NSString *)fromDateString fromFormat:(NSString *)fromFormat toDateString:(NSString *)toDateString ToFormat:(NSString *)toFormat;
/*
 把秒数转化成时间
 */
+ (NSDateComponents *)getDateComponentsBySeconds:(NSInteger)seconds;

/*
把时间字符串转化成date
*/
+ (NSDate *)getDateFromDateString:(NSString *)dateString format:(NSString *)format;

/*
 获取当前时间戳（以毫秒为单位）
 */
+ (NSString *)getNowTimeTimestamp;

@end
