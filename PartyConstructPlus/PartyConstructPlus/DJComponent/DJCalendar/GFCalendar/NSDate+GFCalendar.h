//
//  NSDate+GFCalendar.h
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (GFCalendar)

/**
 *  获得当前 NSDate 对象对应的日子
 */
- (NSInteger)dateDay;

/**
 *  获得当前 NSDate 对象对应的月份
 */
- (NSInteger)dateMonth;

/**
 *  获得当前 NSDate 对象对应的年份
 */
- (NSInteger)dateYear;

/**
 *  获得当前 NSDate 对象的上个月的某一天（此处定为15号）的 NSDate 对象
 */
- (NSDate *)previousMonthDate;

/**
 *  获得当前 NSDate 对象的下个月的某一天（此处定为15号）的 NSDate 对象
 */
- (NSDate *)nextMonthDate;

/**
 *  获得当前 NSDate 对象对应的月份的总天数
 */
- (NSInteger)totalDaysInMonth;

/**
 *  获得当前 NSDate 对象对应月份当月第一天的所属星期
 */
- (NSInteger)firstWeekDayInMonth;

/**
 字符串转换时间

 @param string 时间字符串
 @param format 格式
 @return date
 */
+ (NSDate *)stringToDate:(NSString*)string format:(NSString *)format;
/**
 date转字符串
 @param date 需要转换的date
 @param format 需要的格式
 @return 时间字符串
 */
+ (NSString *) dateString:(NSDate*)date format:(NSString *)format;

/**
 获取当前时间

 @return <#return value description#>
 */
+ (NSInteger )getCurrentHour;


@end
