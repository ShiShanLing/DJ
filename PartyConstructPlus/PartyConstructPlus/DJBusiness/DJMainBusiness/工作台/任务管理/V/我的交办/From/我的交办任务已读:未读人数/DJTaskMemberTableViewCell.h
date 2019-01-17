//
//  DJTaskMemberTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 任务的用户显示  分为已读和未读的状态
 */
@interface DJTaskMemberTableViewCell : UITableViewCell

/**
 *
 */
@property (nonatomic, strong)UIImageView * memberHeadPortraitImageView;
/**
 *
 */
@property (nonatomic, strong)UILabel * membeNamerLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel * memberStateLable;
/**
 *
 */
@property (nonatomic, strong)UIButton * rightArrowBtn;
/**
 *cell分割线
 */
@property (nonatomic, strong)UILabel *dividerLabel ;
/**
 *
 */
@property (nonatomic, strong)IReceivedTaskModel * memberModel;

- (void)isRead:(NSString *)state;

@end
