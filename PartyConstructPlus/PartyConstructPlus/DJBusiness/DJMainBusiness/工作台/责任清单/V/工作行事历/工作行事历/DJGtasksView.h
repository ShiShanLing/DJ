//
//  DJGtasksView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/14.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DJGtasksViewDelegate <NSObject>

- (void)ClickAgendaList;

@end

/**
 工作行事历悬浮提示框
 */
@interface DJGtasksView : UIView

/**
 *
 */
@property (nonatomic, strong)UIButton * showBtn;

/**
 *
 */
@property (nonatomic, assign)id<DJGtasksViewDelegate> delegate;
@end
