//
//  DJMyTaskViewCommentsTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/9.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TaskCommentsModel;
/**
 我的任务详情界面 评论信息展示
 */
@interface DJMyTaskViewCommentsTableViewCell : UITableViewCell
/**
 *
 */
@property (nonatomic, strong)UILabel * dividerLabel;

- (void)noData;
/**
 *
 */
@property (nonatomic, strong)TaskCommentsModel *model;
/**
 *
 */
@property (nonatomic, strong)UIImageView * emptyImageView;
/**
 *
 */
@property (nonatomic, strong)UILabel * promptLabel;
@end
