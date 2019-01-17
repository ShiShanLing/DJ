//
//  ConfigurableIconTVCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConfigModuleModel;

@protocol ConfigurableIconTVCellDelegate <NSObject>

/**
 党建工作点击事件
 @param index 点击的模块下标
 */
- (void)ClickFunctionModuleIndex:(NSInteger)index; 

@end

@interface ConfigurableIconTVCell : UITableViewCell
/**
 *
 */
@property (nonatomic, assign)id<ConfigurableIconTVCellDelegate> delegate;

/**
 *
 */
@property (nonatomic, strong)NSArray *modelArray;
@end
