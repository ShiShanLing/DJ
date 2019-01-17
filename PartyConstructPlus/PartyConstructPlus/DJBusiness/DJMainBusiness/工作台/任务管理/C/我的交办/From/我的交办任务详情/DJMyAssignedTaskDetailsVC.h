//
//  DJMyAssignedTaskDetailsVC.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/12.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJBaseViewController.h"

/**
 我的交办任务详情
 */
@interface DJMyAssignedTaskDetailsVC : DJBaseViewController

/**
 *后台返回的的 taskid
 */
@property (nonatomic, strong)NSString * currentTaskId;
/**
 *后台返回的 id
 */
@property (nonatomic, strong)NSString * taskId;
/**
 *
 */
@property (nonatomic, strong)IReceivedTaskModel *taskDetailsModel;
/**
 *
 */
@property (nonatomic, strong)OrgInfoModel * orgModel;
@end
