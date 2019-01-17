//
//  GFCalendarCell.h
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFCalendarCell : UICollectionViewCell

@property (nonatomic, strong) UIView *todayCircle; //!< 标示'今天'
@property (nonatomic, strong) UILabel *todayLabel; //!< 标示日期（几号）

/**
 *左边的带颜色的view
 */
@property (nonatomic, strong)UIView *leftColorView;

/**
 *左边的带颜色的view
 */
@property (nonatomic, strong)UIView *rightColorView;
/**
 *选中显示UIMage 的 Btn
 */
@property (nonatomic, strong)UIButton * selectedBtn;

/**
 *如果开始时间和结束时间是同一天.那么这个就显示出来
 */
@property (nonatomic, strong)UILabel * repeatLabel;
@end
