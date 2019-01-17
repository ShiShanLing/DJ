//
//  DJMyAssignedTaskReadMemberViewController.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJBaseViewController.h"

/**
 我的交办任务 已读 未读人展示
 */
@interface DJMyAssignedTaskReadMemberViewController : DJBaseViewController


/**
 *n 未读  y已读
 */
@property (nonatomic, strong)NSString * isRead;
/**
 *
 */
@property (nonatomic, strong)NSString * taskId;
@end
