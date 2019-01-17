//
//  DJCustomPopupWindow.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/30.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^DJCustomPopupBlock)(NSInteger index);

@interface DJCustomPopupWindow : UIView

/**
 *
 */
@property (nonatomic, copy)DJCustomPopupBlock  chooseBlock;
/**
 传入一个数组 数组为三个参数 参数作为按钮的名称

 @param titles 按钮的名字
 */
- (void)actionWithTitles:(NSArray *)titles;

@end
