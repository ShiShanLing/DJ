//
//  NSDate+Conversion.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/26.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Conversion)

/**
 根据传进来的date获取当前月份有多少天
 @param date 需要获取的时间
 @return 天数
 */
+ (NSInteger)getNumberOfDaysTheCurrentMonth:(NSDate *)date;

@end
