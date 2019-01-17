//
//  DJLearningTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJLearningTableViewCellDelegate <NSObject>

/**
 用户点击了(党建)应用模块
 */
- (void)ClickLearningModule:(NSInteger)index;

@end

/**
 党建应用展示view
 */
@interface DJLearningTableViewCell : UITableViewCell
/**
 *
 */
@property (nonatomic, assign)id<DJLearningTableViewCellDelegate> delegate;
@end
