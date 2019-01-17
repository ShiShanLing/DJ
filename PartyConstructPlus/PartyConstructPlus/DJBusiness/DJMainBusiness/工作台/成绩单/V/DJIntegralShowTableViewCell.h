//
//  DJIntegralShowTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/21.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 我的积分明细展示
 */
@interface DJIntegralShowTableViewCell : UITableViewCell
@property(nonatomic, strong)UILabel *  contentLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel * timeLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel * integralLabel;
@end
