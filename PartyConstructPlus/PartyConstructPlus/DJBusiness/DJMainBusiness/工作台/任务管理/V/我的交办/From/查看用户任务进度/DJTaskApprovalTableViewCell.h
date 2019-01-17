//
//  DJTaskApprovalTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/14.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJTaskApprovalTableViewCellDelegate <NSObject>

- (void)taskContentChange:(NSString *)str;
- (void)isAgreeApply:(BOOL)type;
@end

/**
 任务审批界面cell 包括请假审批 和申诉审批
 */
@interface DJTaskApprovalTableViewCell : UITableViewCell

/**
 *
 */
@property (nonatomic, assign)id<DJTaskApprovalTableViewCellDelegate> delegate;
/**
 *
 */
@property (nonatomic, strong)UITextView * contentTV;

/**
 *
 */
@property (nonatomic, assign)BOOL isAgreeApply;
/**
 *
 */
@property (nonatomic, strong)UILabel * titleLabel;

/**
 *leaveing appealing
 */
@property (nonatomic, strong)NSString *taskType;

@end

