//
//  SMKSFPopoverViewCell.h
//  下拉菜单
//
//  Created by 石山岭 on 2018/3/21.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMKSFPopoverAction.h"

UIKIT_EXTERN float const PopoverViewCellHorizontalMargin; ///< 水平间距边距
UIKIT_EXTERN float const PopoverViewCellVerticalMargin; ///< 垂直边距
UIKIT_EXTERN float const PopoverViewCellTitleLeftEdge; ///< 标题左边边距
@interface SMKSFPopoverViewCell : UITableViewCell
@property (nonatomic, assign) PopoverViewStyle style;

/*! @brief 标题字体
 */
+ (UIFont *)titleFont;

/*! @brief 底部线条颜色
 */
+ (UIColor *)bottomLineColorForStyle:(PopoverViewStyle)style;

- (void)setAction:(SMKSFPopoverAction *)action;

- (void)showBottomLine:(BOOL)show;

@end
