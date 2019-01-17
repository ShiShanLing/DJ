//
//  DJButton.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 自定义btn
 */
@interface DJButton : UIButton

@property (nonatomic, strong)NSIndexPath *indexPath;

//最简单初始化按钮方法
-(id)initWithFrame:(CGRect)frame andTarget:(id)target andAction:(SEL)action;
//最简单初始化按钮方法  属性为Title
-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andTarget:(id)target andAction:(SEL)action;
//最简单初始化按钮方法  属性为Image
-(id)initWithFrame:(CGRect)frame andImage:(UIImage *)img andTarget:(id)target andAction:(SEL)action;
//按钮样式为上图下文字
- (id)initWithFrame:(CGRect)frame andUpImage:(UIImage *)image andDownTitle:(NSString *)title andTarget:(id)target andAction:(SEL)action;
//按钮样式为上图下文字 第二课堂
- (id)initWithSCFrame:(CGRect)frame andUpImage:(UIImage *)image andDownTitle:(NSString *)title andTarget:(id)target andAction:(SEL)action andState:(UIControlState)stateType;

//按钮样式为左图右文字
- (id)initWithFrame:(CGRect)frame andLeftImage:(UIImage *)image andRightTitle:(NSString *)title andTarget:(id)target andAction:(SEL)action;
//设置字体颜色
-(void)setTextColor:(UIColor *)textColor;

- (UIImage *)buttonImageFromColor:(UIColor *)color;
@end
