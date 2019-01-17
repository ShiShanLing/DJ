//
//  DJCalendarTimeShowHeadView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/28.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DJCalendarTimeShowHeadViewDelegate <NSObject>

/**
 时间选择

 @param index 0 开始时间 1 结束时间
 */
- (void)timeChoose:(NSInteger )index;

@end

/**
 党建任务发布界面日历空间选择时间展示
 */
@interface DJCalendarTimeShowHeadView : UIView
- (void)directlyShow;
/**
 显示时间
 */
- (void)show;
/**
 *开始时间展示label
 */
@property (nonatomic, strong)UILabel * startTimeShowLabel;
/**
 结束时间展示label
 */
@property (nonatomic, strong)UILabel * endTimeShowLabel;

/**
 *
 */
@property (nonatomic, assign)id<DJCalendarTimeShowHeadViewDelegate> delegate;
@end
