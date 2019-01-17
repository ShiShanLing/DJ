//
//  DJTaskTypeView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/6.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DJTaskTypeView;

@protocol DJTaskTypeViewDelegate <NSObject>

- (void)ClickTaskType:(DJTaskTypeView *)view;

@end

@interface DJTaskTypeView : UIView
/**
 *
 */
@property (nonatomic, strong)UIButton * iconBtn;
/**
 *
 */
@property (nonatomic, strong)UILabel * titleLabel;

/**
 *任务分类按钮点击
 */
@property (nonatomic, assign)id<DJTaskTypeViewDelegate> delegate;
@end
