//
//  DJSystemNoticeViewController.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/11.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJBaseViewController.h"

/**
 系统通知
 */
@interface DJSystemNoticeViewController : DJBaseViewController
/**
 * 进来的类型 present 或者 push
 */
@property (nonatomic, strong) NSString *animationType;
@end
