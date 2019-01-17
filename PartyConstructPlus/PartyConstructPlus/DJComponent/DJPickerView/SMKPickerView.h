//
//  SMKPickerView.h
//  PartyConstruct
//
//  Created by 廖锦锐 on 16/7/20.
//  Copyright © 2016年 廖锦锐. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMKPickerView;
typedef void(^SMKPickerViewBlock)(SMKPickerView *pcikerView, NSString *choiceString);

/**
 多个选项时选中的 str  以逗号隔开

 @param choiceString 选中的文字拼接,以逗号隔开
 */
typedef void(^PickerViewOptions)(NSString *choiceString);

@interface SMKPickerView : UIView
@property (copy, nonatomic) SMKPickerViewBlock callBack;
/**
 *
 */
@property (nonatomic, copy)PickerViewOptions selectedStr;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, strong)NSString *defaultStr;
/**
 *
 */
@property (nonatomic, assign)BOOL isMore;//是否是多选
//单条选择器

/**
 单个选项的选择器
 @param titleArray 内容 array 需要的数据@[@[]];
 @param headTitle  标题
 @param index 默认展示第几个row
 @param callBack 点击确认之后的block
 @return objc
 */
+ (instancetype)SMKPickerWithArray:(NSArray *)titleArray withHeadTitle:(NSString *)headTitle defaultIndex:(NSInteger)index withCall:(SMKPickerViewBlock)callBack;

/**
 多个选项的选择器
 @param MoreArray 多个选项的数组 结构 @[@[], @[], @[]];
 @param headTitle 标题
 @param indexArray 默认选中的下标 数据结构(和传进来的数据结构必须一样) @[@[1], @[3], @[1]
 @param callBack 返回str的block
 @return
 */
+ (instancetype)SMKPickerMoreComponent:(NSArray *)MoreArray  withHeadTitle:(NSString *)headTitle defaultIndex:(NSArray *)indexArray withCall:(PickerViewOptions)callBack;


//显示
-(void)show;
//销毁类
-(void)dismissPicker;
@end
