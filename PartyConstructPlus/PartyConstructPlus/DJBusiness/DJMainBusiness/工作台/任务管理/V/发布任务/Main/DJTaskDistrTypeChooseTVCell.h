//
//  DJTaskDistrTypeChooseTVCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/18.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 任务发布界面 任务类型选择
 */
@interface DJTaskDistrTypeChooseTVCell : UITableViewCell

/**
 *
 */
@property (nonatomic, strong)UIImageView * iconImageView;
/**
 *
 */
@property (nonatomic, strong)UILabel * titleLabel;
/**
 *
 */
@property (nonatomic, strong)UIImageView * pointToImage;
/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
/**
 *cell分割线
 */
@property (nonatomic, strong)UILabel *dividerLabel ;
@end
