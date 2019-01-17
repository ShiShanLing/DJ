//
//  DJMyTaskProgressTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/9.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJMyTaskProgressTableViewCellDelegate <NSObject>

- (void)TaskPerformBtn;

- (void)TaskAskLeaveBtn;

@end

/**
 我的任务详情界面进度展示
 */
@interface DJMyTaskProgressTableViewCell : UITableViewCell

- (void)configControls:(NSIndexPath *)indexPath  modelArray:(NSArray *)array;

/**
 *
 */
@property (nonatomic, assign)id<DJMyTaskProgressTableViewCellDelegate> delegate;
/**
 *
 */
@property (nonatomic, strong)TaskStepModel * model;
/**
 *
 */
@property (nonatomic, strong)NSString *sendUserName;

@property (nonatomic, strong)UILabel * taskContentLabel;

@property (nonatomic, strong)NSIndexPath *indexPath;



@end
