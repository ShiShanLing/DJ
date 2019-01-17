//
//  DJMyTaskInfoTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/9.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJMyTaskInfoTableViewCellDelegate <NSObject>

- (void)imageClick:(NSInteger)index imageView:(UIImageView*)imageView; 

@end

/**
 我的任务 详情,任务信息展示
 */
@interface DJMyTaskInfoTableViewCell : UITableViewCell

/**
 *
 */
@property (nonatomic, strong)UILabel * taskNameLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel * taskTimeLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel * taskTagLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel * taskContentLabel;
/**
 *
 */
@property (nonatomic, strong)UIView *ScrollContentView;
/**
 *
 */
@property (nonatomic, strong)IReceivedTaskModel * model;
@end
