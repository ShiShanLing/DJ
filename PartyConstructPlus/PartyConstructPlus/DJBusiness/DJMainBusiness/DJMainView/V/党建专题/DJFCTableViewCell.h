//
//  DJFCTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DJFCTableViewCellDelegate <NSObject>

/**
 点击党建专题模块

 @param index 下标
 */
- (void)ClickGracefulBearingModule:(NSInteger)index;

@end

/**
 主界面党建风采 横向滑动的cell
 */
@interface DJFCTableViewCell : UITableViewCell
/**
 *
 */
@property (nonatomic, assign)id<DJFCTableViewCellDelegate> delegate;

@end

