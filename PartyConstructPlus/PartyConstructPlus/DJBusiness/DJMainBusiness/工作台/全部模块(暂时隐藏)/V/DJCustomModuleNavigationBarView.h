//
//  DJCustomModuleNavigationBarView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/31.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 自定义导航条
 */
@interface DJCustomModuleNavigationBarView : UIView

/**
 *左边的btn
 */
@property (nonatomic, strong)UIButton  *leftBtn;
/**
 *右边的btn
 */
@property (nonatomic, strong)UIButton  *rightBtn;
/**
 *标题label
 */
@property (nonatomic, strong)UILabel * titleLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel *SegmentationLineLabel;
/**
 *
 */
@property (nonatomic, strong)NSString * title;
@end
