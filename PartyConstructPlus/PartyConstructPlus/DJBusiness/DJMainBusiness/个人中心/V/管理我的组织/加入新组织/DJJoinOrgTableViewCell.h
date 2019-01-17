//
//  DJJoinOrgTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/11.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RegisteredDataModel;
@protocol DJJoinOrgTableViewCellDelegate <NSObject>

- (void)SubmitApplication:(RegisteredDataModel *)model;

@end

@interface DJJoinOrgTableViewCell : UITableViewCell

/**
 *是否选择了要删除的组织
 */
@property (nonatomic, assign)BOOL isChooseDelete;

/**
 *
 */
@property (nonatomic, assign)id<DJJoinOrgTableViewCellDelegate> delegate;

- (void)refreshControlState;
@end
