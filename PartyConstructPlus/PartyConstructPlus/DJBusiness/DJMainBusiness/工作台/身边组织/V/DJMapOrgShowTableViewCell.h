//
//  DJMapOrgShowTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/20.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJMapOrgShowTableViewCellDelegate <NSObject>

- (void)navigationGoToOrg:(NSIndexPath *)indexPath;

@end

@interface DJMapOrgShowTableViewCell : UITableViewCell

/**
 *组织名字
 */
@property (nonatomic, strong)UILabel *orgName;
/**
 *组织位置label
 */
@property (nonatomic, strong)UILabel * orgLocationLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel * phoneLabel;
/**
 *导航按钮
 */
@property (nonatomic, strong)UIButton * navigationBtn;
/**
 *
 */
@property (nonatomic, strong)NSString * phoneStr;
/**
 *
 */
@property (nonatomic, assign)id<DJMapOrgShowTableViewCellDelegate> delegate;
/**
 *
 */
@property (nonatomic, strong)NSIndexPath *indexPath;
@end
