//
//  DJAgendaWCTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/14.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJAgendaWCTableViewCellDelegte <NSObject>

- (void)completeCalendar:(NSIndexPath *)indexPath;

@end

/**
 工作待办行事历
 */
@interface DJAgendaWCTableViewCell : UITableViewCell

/**
 *任务状态
 */
@property (nonatomic, strong)UIButton * stateBtn;

/**
 *补办状态 背景
 */
@property (nonatomic, strong)UIButton * waitReplaceBtn;
/**
 *如果任务超时 显示的标签
 */
@property (nonatomic, strong)UILabel * timeoutLabel;

/**
 *
 */
@property (nonatomic, strong)AgendaWorkingCalendarListModel * model;
/**
 *
 */
@property (nonatomic, strong)NSIndexPath * indexPath;
/**
 *
 */
@property (nonatomic, assign)id<DJAgendaWCTableViewCellDelegte> delegate;


@end
