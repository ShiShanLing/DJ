//
//  DJTaskSendObjectTypeChooseView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/23.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DJTaskSendObjectTypeChooseViewDelegate <NSObject>

- (void)switchSearchTypes:(NSInteger)index;

@end

/**
 任务发布 选择对象-搜索-选择搜索类型
 */
@interface DJTaskSendObjectTypeChooseView : UIView

/**
 *
 */
@property (nonatomic, assign)id<DJTaskSendObjectTypeChooseViewDelegate> delegate;
/**
 *
 */
@property (nonatomic, assign)NSInteger  searchType;
@end
