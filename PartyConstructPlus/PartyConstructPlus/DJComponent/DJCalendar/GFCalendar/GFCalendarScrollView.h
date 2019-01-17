//
//  GFCalendarScrollView.h
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectDayHandler)(NSDate *);

@interface GFCalendarScrollView : UIScrollView


@property (nonatomic, strong) DidSelectDayHandler didSelectDayHandler; // 日期点击回调

- (void)refreshToCurrentMonth; // 刷新 calendar 回到当前日期月份

- (void)JumpToMonth:(NSDate *)date;
/**
 *
 */
@property (nonatomic, strong)NSDate *startDefaultDate;
/**
 *
 */
@property (nonatomic, strong)NSDate *endDefaultDate;
@end
