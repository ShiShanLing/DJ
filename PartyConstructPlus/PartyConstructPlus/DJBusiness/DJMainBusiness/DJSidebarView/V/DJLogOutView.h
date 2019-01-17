//
//  DJLogOutView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/8.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DJLogOutViewDelegate <NSObject>

- (void)logOut;

@end

/**
 用户退出登录点击的模块
 */
@interface DJLogOutView : UIView
/**
 *
 */
@property (nonatomic, assign)id<DJLogOutViewDelegate> delegate;

/**
 *
 */
@property (nonatomic, strong)UIButton * iconBtn;
/**
 *
 */
@property (nonatomic, strong)UILabel * titleLabel;
@end
