//
//  NSDate+Conversion.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/26.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "NSDate+Conversion.h"

@implementation NSDate (Conversion)
+ (NSInteger)getNumberOfDaysTheCurrentMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSRange是一个结构体，其中location是一个以0为开始的index，length是表示对象的长度。他们都是NSUInteger类型。
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}
@end
