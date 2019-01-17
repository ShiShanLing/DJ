//
//  DJMapOrgSearchShowTVCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/27.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MapNearOrgModel;

/**
 地图上的搜索功能,-搜索出来的组织展示cell
 */
@interface DJMapOrgSearchShowTVCell : UITableViewCell
/**
 *
 */
@property (nonatomic, strong)UILabel * OrgNameLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel * orgAddressLabel;
/**
 *
 */
@property (nonatomic, strong)MapNearOrgModel * model;
@end
