//
//  DJSJFXZTDRCYLTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/9/28.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,DJSJFXZTDRCYLTableViewCellChartType) {
    DJSJFXZTDRCYLTableViewCellChartTypeColumn = 0,
    DJSJFXZTDRCYLTableViewCellChartTypeBar,
    DJSJFXZTDRCYLTableViewCellChartTypeArea,
    DJSJFXZTDRCYLTableViewCellChartTypeAreaspline,
    DJSJFXZTDRCYLTableViewCellChartTypeLine,
    DJSJFXZTDRCYLTableViewCellChartTypeSpline,
    DJSJFXZTDRCYLTableViewCellChartTypeStepLine,
    DJSJFXZTDRCYLTableViewCellChartTypeStepArea,
    DJSJFXZTDRCYLTableViewCellChartTypeScatter,
};
NS_ASSUME_NONNULL_BEGIN

/**
 主题党日参与率
 */
@interface DJSJFXZTDRCYLTableViewCell : UITableViewCell
@property (nonatomic, assign) DJSJFXZTDRCYLTableViewCellChartType chartType;
- (void)createChartviewDataType:(NSInteger)dataType dataArray:(NSArray *)dataArray;
@end

NS_ASSUME_NONNULL_END
