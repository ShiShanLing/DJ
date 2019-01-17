//
//  DJTaskPerFormViewController.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/12.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJBaseViewController.h"

typedef NS_ENUM(NSInteger, DJTaskOperationType) {
    DJTaskOperationTypePerform,
    DJTaskOperationTypeAskLeave,
    DJTaskOperationTypeFillDo,
    DJTaskOperationTypeComplaint,
    DJTaskOperationTypeComments
};

/**
 党建任务执行-补办-请假-申诉-评论
 */
@interface DJTaskPerFormViewController : DJBaseViewController

/**
 *
 */
@property (nonatomic, strong)NSString * taskId;
/**
 *
 */
@property (nonatomic, strong)NSString *oldStatus;

/**
 *
 */
@property (nonatomic, assign)DJTaskOperationType taskOperationType;
/**
 *
 */
@property (nonatomic, strong)NSString * mainTaskId;

/**
 *
 */
@property (nonatomic, strong)OrgInfoModel * orgModel;
@end
