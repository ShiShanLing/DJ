//
//  DJTaskMainViewController.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/25.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJBaseViewController.h"
//任务管理
/**
 *任务管理
 */
@interface DJTaskMainViewController : DJBaseViewController
/**
 * push进来的传1  present进来传2
 */
@property (nonatomic, assign)NSInteger  type;
@end
