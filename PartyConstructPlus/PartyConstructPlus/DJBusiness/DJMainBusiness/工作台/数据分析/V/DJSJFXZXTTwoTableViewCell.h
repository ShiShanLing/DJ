//
//  DJSJFXZXTTwoTableViewCell.h
//  数据分析实现
//
//  Created by 石山岭 on 2018/9/12.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 数据分析里面的第二个折线图 用于
 个人每月任务平均完成时间统计
 个人每月积分统计
 */
@interface DJSJFXZXTTwoTableViewCell : UITableViewCell

- (void)ChartColor:(NSArray *)colors title:(BOOL)isShow dataType:(NSInteger)dataType dataArray:(NSArray *)dataArray;

@end
