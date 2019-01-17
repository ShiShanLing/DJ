//
//  ConfigurableIconVIew.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConfigurableIconVIew;

@protocol ConfigurableIconVIewDelegate <NSObject>

- (void)ClickConfigurableIcon:(ConfigurableIconVIew *)view;

@end

/**
 单个icons
 */
@interface ConfigurableIconVIew : UIView

/**
 图标
 */
@property(nonatomic, strong)UIImageView *iconImage;
/**
 *标题
 */
@property (nonatomic, strong)UILabel * titleLabel;
/**
 *
 */
@property (nonatomic, strong)UIButton * showNewTaskBtn;
/**
 *
 */
@property (nonatomic, assign)id<ConfigurableIconVIewDelegate>delegate ;

@end
