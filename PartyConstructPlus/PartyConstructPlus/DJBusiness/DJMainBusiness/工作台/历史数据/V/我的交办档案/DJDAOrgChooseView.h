//
//  DJDAOrgChooseView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/27.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJDAOrgChooseViewDelegate <NSObject>

/**
 历史组织点击  用户切换组织
 */
- (void)SwitchHistoricalOrg;

@end

@interface DJDAOrgChooseView : UIView

/**
 *
 */
@property (nonatomic, strong)UIButton * orgNameBtn;
/**
 *
 */
@property (nonatomic, strong)UIButton *iconBtn;

/**
 *
 */
@property (nonatomic, strong)NSString * title;
/**
 *
 */
@property (nonatomic, assign)id<DJDAOrgChooseViewDelegate> delegate;

@end
