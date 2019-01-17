//
//  DJButton.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJButton.h"
#define kSMKButtonTextColor [UIColor colorWithRed:20 green:20 blue:20 alpha:1]
@implementation DJButton

//最简单初始化按钮方法
-(id)initWithFrame:(CGRect)frame andTarget:(id)target andAction:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
//最简单初始化按钮方法  属性为Title
-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andTarget:(id)target andAction:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [self setTitle:title forState:UIControlStateNormal];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
//最简单初始化按钮方法  属性为Image
-(id)initWithFrame:(CGRect)frame andImage:(UIImage *)img andTarget:(id)target andAction:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [self setImage:img forState:UIControlStateNormal];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
//按钮样式为上图下文字
- (id)initWithFrame:(CGRect)frame andUpImage:(UIImage *)image andDownTitle:(NSString *)title andTarget:(id)target andAction:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
        [self.imageView setContentMode:UIViewContentModeCenter];
        [self setImageEdgeInsets:UIEdgeInsetsMake(-20.0,0.0,0.0,-titleSize.width)];
        [self setImage:image forState:UIControlStateNormal];
        [self.titleLabel setContentMode:UIViewContentModeCenter];
        [self.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [self.titleLabel setTextColor:kSMKButtonTextColor];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height,-image.size.width+24,0.0,0.0)];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:kSMKButtonTextColor forState:UIControlStateNormal];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (id)initWithSCFrame:(CGRect)frame andUpImage:(UIImage *)image andDownTitle:(NSString *)title andTarget:(id)target andAction:(SEL)action andState:(UIControlState)stateType
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
        
        [self.imageView setContentMode:UIViewContentModeCenter];
        [self setImageEdgeInsets:UIEdgeInsetsMake(-25.0,
                                                  0.0,
                                                  0.0,
                                                  -titleSize.width)];
        [self setImage:image forState:stateType];
        
        //[self setBackgroundImage:[self buttonImageFromColor:kColorRGB(235, 235, 235, 1)] forState:UIControlStateHighlighted];
        [self.titleLabel setContentMode:UIViewContentModeCenter];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.titleLabel setTextColor:kColorRGB(20, 20, 20, 1)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(35.0,
                                                  -image.size.width,
                                                  -5.0,
                                                  0.0)];
        [self setTitle:title forState:stateType];
        [self setTitleColor:kColorRGB(51, 51, 51, 1) forState:stateType];
    }
    return self;
}
//按钮样式为左图右文字
- (id)initWithFrame:(CGRect)frame andLeftImage:(UIImage *)image andRightTitle:(NSString *)title andTarget:(id)target andAction:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:kSMKButtonTextColor forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0,
                                                  2,
                                                  0.0,
                                                  0.0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0.0,
                                                  -8.0,
                                                  0.0,
                                                  0.0)];
        
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


//设置字体颜色
-(void)setTextColor:(UIColor *)textColor
{
    [self setTitleColor:textColor forState:UIControlStateNormal];
    [self setTitleColor:textColor forState:UIControlStateHighlighted];
}

//颜色转图片
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
