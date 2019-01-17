//
//  YTLPieView.h
//  YouTiaoLi
//
//  Created by 天蓝 on 2017/8/9.
//  Copyright © 2017年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTLPieView : UIView


/**
 数据统计饼图

 @param frame frame
 @param dataItems 每个部分的数据源
 @param colorItems 每个部分的颜色
 @param upTextItems 线上文字
 @param downTextItems 线下文字
 */
- (instancetype)initWithFrame:(CGRect)frame
                    dataItems:(NSArray *)dataItems
                   colorItems:(NSArray *)colorItems
                  upTextItems:(NSArray *)upTextItems
                downTextItems:(NSArray *)downTextItems;
/**
 *
 */
@property (nonatomic, strong)NSString *titleStr;

@property (nonatomic, strong) NSArray *dataItems;
@property (nonatomic, strong) NSArray *colorItems;
@property (nonatomic, strong) NSArray *upTextItems;
@property (nonatomic, strong) NSArray *downTextItems;
@property (nonatomic, assign) CGFloat animationTime;
/**
 *
 */
@property (nonatomic, assign)BOOL isHiddenAnimation;
@end
