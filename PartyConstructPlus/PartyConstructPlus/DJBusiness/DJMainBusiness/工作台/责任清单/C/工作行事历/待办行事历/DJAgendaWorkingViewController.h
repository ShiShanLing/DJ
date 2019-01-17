//
//  DJAgendaWorkingViewController.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/14.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJBaseViewController.h"

/**
 待办工作行事历
 */
@interface DJAgendaWorkingViewController : DJBaseViewController

/**
 *
 */
@property (nonatomic, strong)AgendaWorkingCalendarListModel *model;
/**
 *
 */
@property (nonatomic, strong)OrgInfoModel  *orgModel;
/**
 *从哪个界面过来的    FilingCabinet 档案柜 否者就是党建任务
 */
@property (nonatomic, strong)NSString * DidYouComeFromStr;

@end
