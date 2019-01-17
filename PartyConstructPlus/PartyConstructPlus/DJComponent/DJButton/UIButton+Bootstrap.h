//
//  UIButton+Bootstrap.h
//  UIButton+Bootstrap
//
//  Created by Oskar Groth on 2013-09-29.
//  Copyright (c) 2013 Oskar Groth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"

@interface UIButton (Bootstrap)

- (void)addAwesomeIcon:(FAIcon)icon beforeTitle:(BOOL)before;
/**
 *给UIButton添加图片,文字和枚举值,自定义btn显示类型
 */
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;
-(void)bootstrapStyle;
-(void)defaultStyle:(NSString *)title;
-(void)successStyle;
-(void)infoStyle;
-(void)warningStyle;
-(void)dangerStyle;
-(void)backViewStyle;
-(void)loginStyle;
-(void)zhuceStyle;
-(void)rechargeStyle;
-(void)authCodeStyle;
- (UIImage *)buttonImageFromColor:(UIColor *)color;

@end
