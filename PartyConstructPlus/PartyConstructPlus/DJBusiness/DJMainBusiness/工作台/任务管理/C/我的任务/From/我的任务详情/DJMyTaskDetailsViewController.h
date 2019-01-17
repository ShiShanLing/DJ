//
//  DJMyTaskDetailsViewController.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/9.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJBaseViewController.h"

/**
 我的任务详情
 */
@interface DJMyTaskDetailsViewController : DJBaseViewController
/**
 *
 */
@property (nonatomic, strong)IReceivedTaskModel * taskDetailsModel;
/**
 *
 */
@property (nonatomic, strong)NSString *taskId;
/**
 *
 */
@property (nonatomic, strong)OrgInfoModel * orgModel;
/**
 * 进来的类型 present 或者 push
 */
@property (nonatomic, strong) NSString *animationType;
@end
