//
//  DJTaskNoticeTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/11.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskPushMsgModel+CoreDataProperties.h"
/**
 党建任务通知
 */
@interface DJTaskNoticeTableViewCell : UITableViewCell

/**
 对应的icon
 */
@property (nonatomic, strong)UIButton *iconBtn;
/**
 *
 */
@property (nonatomic, strong)TaskPushMsgModel * textModel;
@end
