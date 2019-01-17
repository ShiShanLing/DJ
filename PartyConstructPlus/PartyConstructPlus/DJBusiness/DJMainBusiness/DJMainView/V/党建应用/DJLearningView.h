//
//  DJLearningView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DJLearningView;

@protocol DJLearningViewDelegete <NSObject>

- (void)ClickLearningModule:(DJLearningView *)view;

@end

/**
 党建学习模块的view
 */
@interface DJLearningView : UIView

/**
 *
 */
@property (nonatomic, assign)id<DJLearningViewDelegete> delegate;

/**
 *
 */
@property (nonatomic, strong)NSDictionary * dataDic;

@end
