//
//  DJMyTaskShowTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/12.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJMyTaskShowTableViewCell : UITableViewCell
/**
 *任务name
 */
@property (nonatomic, strong)UILabel * taskNameLabel;
/**
 *任务时间
 */
@property (nonatomic, strong)UILabel * taskTimeLabel;
/**
 *任务状态
 */
@property (nonatomic, strong)UILabel * taskStateLabel;

/**
 *
 */
@property (nonatomic, strong)IReceivedTaskModel * model;
/**
 *cell分割线
 */
@property (nonatomic, strong)UILabel *dividerLabel ;
@end
