//
//  DJTaskTimeChooseViewController.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/28.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJBaseViewController.h"


typedef void (^DJTaskTime)(NSString *startDate, NSString *endDate);
/**
 发布任务时间选择
 */
@interface DJTaskTimeChooseViewController : DJBaseViewController
/**
 *
 */
@property (nonatomic, copy)DJTaskTime returnTime;
/**
 *
 */
@property (nonatomic, strong)NSDate *startDefaultDate;
/**
 *
 */
@property (nonatomic, strong)NSDate *endDefaultDate;
@end
