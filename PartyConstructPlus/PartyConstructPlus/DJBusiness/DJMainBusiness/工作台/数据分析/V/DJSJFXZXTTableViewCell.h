//
//  DJSJFXZXTTableViewCell.h
//  数据分析实现
//
//  Created by 石山岭 on 2018/9/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,DJSJFXZXTTableViewCellChartType) {
    DJSJFXZXTTableViewCelChartTypeColumn = 0,
    DJSJFXZXTTableViewCelChartTypeBar,
    DJSJFXZXTTableViewCelChartTypeArea,
    DJSJFXZXTTableViewCelChartTypeAreaspline,
    DJSJFXZXTTableViewCelChartTypeLine,
    DJSJFXZXTTableViewCelChartTypeSpline,
    DJSJFXZXTTableViewCelChartTypeStepLine,
    DJSJFXZXTTableViewCelChartTypeStepArea,
    DJSJFXZXTTableViewCelChartTypeScatter,
};
/**
 党建数据分析里面的折线图
 用于
 个人年度行事历任务统计
 个人年度交办任务统计
  */
@interface DJSJFXZXTTableViewCell : UITableViewCell
@property (nonatomic, assign) DJSJFXZXTTableViewCellChartType chartType;
@property (nonatomic,  assign) NSInteger dataType;
/**
 *
 */
@property (nonatomic, strong)NSArray * dataArray;

- (void)createChartviewDataType:(NSInteger)dataType dataArray:(NSArray *)dataArray;

@end
