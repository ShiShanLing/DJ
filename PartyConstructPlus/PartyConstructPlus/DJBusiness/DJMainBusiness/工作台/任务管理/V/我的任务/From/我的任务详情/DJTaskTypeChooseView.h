//
//  DJTaskTypeChooseView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/7.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJTaskTypeView.h"

@protocol DJTaskTypeChooseViewDelegate <NSObject>

- (void)taskTypeSelection:(NSInteger )index;

@end

/**
 我的任务类型选择界面
 */
@interface DJTaskTypeChooseView : UIView

/**
 *任务赛选
 */
@property (nonatomic, assign)id<DJTaskTypeChooseViewDelegate> delegate;


@end
