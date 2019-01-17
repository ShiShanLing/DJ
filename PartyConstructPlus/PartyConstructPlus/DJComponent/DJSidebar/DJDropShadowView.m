//
//  DJDropShadowView.m
//  DJNewVersion
//
//  Created by 石山岭 on 2018/3/7.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJDropShadowView.h"

@implementation DJDropShadowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    //添加阴影
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 0.7f;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = shadowPath.CGPath;
    
}
@end
