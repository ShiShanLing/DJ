//
//  DJOrgMemberListView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/7.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJOrgMemberListViewDelegate <NSObject>

- (void)orgMembersEdit:(NSArray *)memberArray;

@end

/**
 组织用户列表  用来选择任务发送对象
 */
@interface DJOrgMemberListView : UIView


/**
 *
 */
@property (nonatomic, strong)NSMutableArray * dataArray;

/**
 *
 */
@property (nonatomic, strong)UILabel * titleLabel;
/**
 *确定btn
 */
@property (nonatomic, strong)UIButton * determinebtn;
/**
 *DJOrg
 */
@property (nonatomic, assign)id<DJOrgMemberListViewDelegate> delegate;
@end
