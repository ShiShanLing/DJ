//
//  DJResumptionExplainListTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/15.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 履职说明说list展示
 */
@interface DJResumptionExplainListTableViewCell : UITableViewCell
/**
 *标题
 */
@property (nonatomic, strong)UILabel *titleLabel;
/**
 *组织名称
 */
@property (nonatomic, strong)UILabel * orgName;
/**
 *岗位
 */
@property (nonatomic, strong)UILabel * jobsLabel;
/**
 *时间
 */
@property (nonatomic, strong)UILabel * timeLabel;
@end
