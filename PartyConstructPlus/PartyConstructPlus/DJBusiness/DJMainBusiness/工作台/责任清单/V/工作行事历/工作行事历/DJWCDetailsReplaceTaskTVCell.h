//
//  DJWCDReplaceTaskTVCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/15.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJWCDetailsReplaceTaskTVCellDelegate <NSObject>

/**
 行事历执行按钮

 @param indexPath 下标
 */
- (void)WCPerform:(NSIndexPath *)indexPath;

@end

/**
 在工作行事历详情里面点击补办任务 (还有一种在代办行事历详情里面补办任务)
 */
@interface DJWCDetailsReplaceTaskTVCell : UITableViewCell

/**
 *任务状态
 */
@property (nonatomic, strong)UILabel *stateLabel;
/**
 *时间
 */
@property (nonatomic, strong)UILabel * timeLabel;
/**
 *操作按钮 (还没超期 待执行)
 */
@property (nonatomic, strong)UIButton * waitExecutionBtn;

/**
 *操作按钮 (已经超期待执行)
 */
@property (nonatomic, strong)UIButton * waitReplaceBtn;
/**
 *
 */
@property (nonatomic, assign)id<DJWCDetailsReplaceTaskTVCellDelegate> delegate;
/**
 *
 */
@property (nonatomic, strong)NSIndexPath * indexPath;
@end
