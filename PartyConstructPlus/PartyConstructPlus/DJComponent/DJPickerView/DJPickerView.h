//
//  DJPickerView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/29.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DJPickerView;
/**
 多个选项时选中的 str  以逗号隔开
 @param choiceString 选中的文字拼接,以逗号隔开
 */
typedef void(^DJPickerViewOptions)(NSString *choiceString);

@interface DJPickerView : UIView
/**
 *
 */
@property (nonatomic, copy)DJPickerViewOptions selectedStr;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, strong)NSString *defaultStr;


/**
 多个选项的选择器
 @param MoreArray 多个选项的数组 结构 @[@[], @[], @[]];
 @param headTitle 标题
 @param indexArray 默认选中的下标 数据结构(和传进来的数据结构必须一样) @[@[1], @[3], @[1]
 @param callBack 返回str的block
 @return
 */
+ (instancetype)SMKPickerMoreComponent:(NSArray *)MoreArray  withHeadTitle:(NSString *)headTitle defaultIndex:(NSArray *)indexArray withCall:(DJPickerViewOptions)callBack;


//显示
-(void)show;
//销毁类
-(void)dismissPicker;
@end
