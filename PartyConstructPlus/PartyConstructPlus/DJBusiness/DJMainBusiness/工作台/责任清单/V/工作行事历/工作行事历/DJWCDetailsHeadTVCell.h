//
//  DJWCDetailsHeadTVCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/15.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJNoticeTextModel.h"
/**
 工作行事历详情head视图(行事历介绍)  Working calendar 简称  WC
 */
@interface DJWCDetailsHeadTVCell : UITableViewCell


/**
 *
 */
@property (nonatomic, strong)AgendaWorkingCalendarListModel * model;
/**
 *@"● 你好啊"
 */
@property (nonatomic, strong)UILabel *orgNameLabel;
@end
