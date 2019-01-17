//
//  DJMapUserShowView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/9/3.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 地图共享位置功能 展示用户详情信息的view
 */
@interface DJMapUserShowView : UIView
/**
 *
 */
@property (nonatomic, strong)UIImageView *userHeadImageView;
/**
 *
 */
@property (nonatomic, strong)UILabel * userNameLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel * userAddressLabel;
@end
