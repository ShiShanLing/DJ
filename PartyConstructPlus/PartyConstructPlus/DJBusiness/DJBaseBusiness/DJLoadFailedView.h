//
//  DJLoadFailedView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReloadData)(NSString *temp);

//加载失败
@interface DJLoadFailedView : UIView
/**
 *
 */
@property (nonatomic, strong)UIImageView * failureImageView;
/**
 *
 */
@property (nonatomic, strong)UILabel * promptLabel;
/**
 *
 */
@property (nonatomic, strong)UIButton * ReloadBtn;
/**
 *
 */
@property (nonatomic, strong)CAGradientLayer *gradientLayer;
/**
 *
 */
@property (nonatomic, strong) UILabel *ReloadLabel;
/**
 *
 */
@property (nonatomic, copy)ReloadData  reloadData;
@end
