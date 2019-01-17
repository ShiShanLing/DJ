//
//  ChangeColourView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/11.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ChangeColourViewDelegate <NSObject>

- (void)handleExitOrg;

@end

@interface ChangeColourView : UIView
/**
 确认按钮
 */
@property (nonatomic, strong)UIButton *ContinueBtn;


@property (nonatomic, strong)CAGradientLayer  *gradientLayer;

/**
 *
 */
@property (nonatomic, assign)id<ChangeColourViewDelegate> delegate;
@end
