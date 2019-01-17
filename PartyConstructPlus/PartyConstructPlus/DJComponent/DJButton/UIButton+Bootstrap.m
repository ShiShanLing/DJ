//
//  UIButton+Bootstrap.m
//  UIButton+Bootstrap
//
//  Created by Oskur on 2013-09-29.
//  Copyright (c) 2013 Oskar Groth. All rights reserved.
//
#import "UIButton+Bootstrap.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIButton (Bootstrap)
#pragma mark -基本样式
-(void)bootstrapStyle{
    self.layer.borderWidth = 1;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:self.titleLabel.font.pointSize]];
}

-(void)backViewStyle
{
    [self setImage:[UIImage imageNamed:@"ic_topview_back"] forState:UIControlStateNormal];
}
//验证码
-(void)authCodeStyle
{
    [self setTitleColor:[SmkBaseFuncation getColor:@"#0050e2"] forState:UIControlStateNormal];
    self.titleLabel.font = MFont(12);
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
//充值按钮
-(void)rechargeStyle
{
    [self setBackgroundImage:[UIImage imageNamed:@"chongzhi-button"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"chaxun_hightlight_button"] forState:UIControlStateHighlighted];
    [self setTitle:@"充值" forState:UIControlStateNormal];
    [self setTitleColor:kColorRGB(102,102,102,1) forState:UIControlStateNormal];
}
//基本样式
-(void)defaultStyle:(NSString *)title{
    [self setBackgroundImage:[UIImage imageNamed:@"button_dis"] forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:kColorRGB(255, 255, 255, 1) forState:UIControlStateNormal];
}

- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;

    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-25.0,
                                              0.0,
                                              0.0,
                                              -titleSize.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.titleLabel setTextColor:kColorRGB(51, 51, 51, 1)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(50.0,
                                              -image.size.width,
                                              -5.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
    [self setTitleColor:kColorRGB(20, 20, 20, 1) forState:stateType];
    
    
}

-(void)loginStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor whiteColor].CGColor; 
    [self setTitleColor:[UIColor colorWithRed:40/255.0 green:171/255.0 blue:82/255.0 alpha:1] forState:UIControlStateNormal];
}

-(void)zhuceStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

-(void)successStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:250/255.0 blue:246/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:134/255.0 blue:52/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:255/255.0 green:50/255.0 blue:246/255.0 alpha:1]] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor colorWithRed:255/255.0 green:134/255.0 blue:52/255.0 alpha:1] forState:UIControlStateNormal];
    
}

-(void)infoStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:91/255.0 green:192/255.0 blue:222/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:70/255.0 green:184/255.0 blue:218/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:57/255.0 green:180/255.0 blue:211/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)warningStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:247/255.0 green:114/255.0 blue:18/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:238/255.0 green:162/255.0 blue:54/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:237/255.0 green:155/255.0 blue:67/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)dangerStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:63/255.0 blue:58/255.0 alpha:1] CGColor];
}

- (void)addAwesomeIcon:(FAIcon)icon beforeTitle:(BOOL)before
{
    NSString *iconString = [NSString stringFromAwesomeIcon:icon];
    self.titleLabel.font = [UIFont fontWithName:@"FontAwesome"
                                           size:self.titleLabel.font.pointSize];
    
    NSString *title = [NSString stringWithFormat:@"%@", iconString];
    
    if(self.titleLabel.text) {
        if(before)
            title = [title stringByAppendingFormat:@" %@", self.titleLabel.text];
        else
            title = [NSString stringWithFormat:@"%@  %@", self.titleLabel.text, iconString];
    }
    
    [self setTitle:title forState:UIControlStateNormal];
}

- (UIImage *)buttonImageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
