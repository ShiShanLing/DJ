//
//  YTLPieView.m
//  YouTiaoLi
//
//  Created by 天蓝 on 2017/8/9.
//  Copyright © 2017年 PT. All rights reserved.
//

#import "YTLPieView.h"
#import "UIView+Extend.h"


@interface YTLPieView ()


// 外环半径
@property (nonatomic, assign) CGFloat pieR;
// 环形的宽度
@property (nonatomic, assign) CGFloat pieW;
// 圆心
@property (nonatomic, assign) CGPoint pieCenter;
@end

@implementation YTLPieView

- (instancetype)initWithFrame:(CGRect)frame
                    dataItems:(NSArray *)dataItems
                   colorItems:(NSArray *)colorItems
                  upTextItems:(NSArray *)upTextItems
                downTextItems:(NSArray *)downTextItems
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.dataItems = dataItems;
        self.colorItems = colorItems;
        self.upTextItems = upTextItems;
        self.downTextItems = downTextItems;
        
        self.animationTime = 1;
        self.pieR = self.height * 0.25;
        self.pieW = 20;
        self.pieCenter = CGPointMake(self.width/2, self.height/2);
        
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // 数组求和
    CGFloat max = [[self.dataItems valueForKeyPath:@"@sum.floatValue"] floatValue];
    
    CGFloat startAngle = -M_PI_2;
    for (int i = 0; i < self.dataItems.count; i++)
    {
        // 扇形部分
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor =   [UIColor clearColor].CGColor;
        layer.strokeColor = [self.colorItems[i] CGColor];
        layer.lineWidth = self.pieW;
        [self.layer addSublayer:layer];


        CGFloat endAngle = [self.dataItems[i] floatValue]/max * (2*M_PI) + startAngle;
        UIBezierPath *layerPath = [UIBezierPath bezierPathWithArcCenter:self.pieCenter radius:self.pieR startAngle:startAngle endAngle:endAngle clockwise:YES];
        layer.path = layerPath.CGPath;
        
        
        
        // 小圆点数据
        CGPoint minPieCenter;// 小圆点中心
        CGFloat picOutR = self.pieR ;// 外层半径  要改变点的位置 就改变这个值
        CGFloat middleAngle = startAngle + (endAngle - startAngle)/2.0;// 扇形中间点角度
        
        
        // 折线数据
        CGPoint line_1_Point;// 转折点
        CGPoint line_2_Point;// 终点
        CGFloat line_1_W = 20;// 1线宽
        CGFloat lineSpace = 15;// 终点距两边的距离
        CGFloat lineAngle = M_PI_2/2;// 短线偏移角度

        
        if (middleAngle >= -M_PI_2 && middleAngle <= 0)
        {// 1
            CGFloat angle = 0 - middleAngle;
            minPieCenter = CGPointMake(self.pieCenter.x + cosf(angle)*picOutR, self.pieCenter.y - sinf(angle)*picOutR);
            
            
            if (angle > -M_PI_2/2)
            {
                lineAngle = M_PI_2/3;
            }
            line_1_Point = CGPointMake(minPieCenter.x + cosf(lineAngle)*line_1_W, minPieCenter.y - sinf(lineAngle)*line_1_W);
            line_2_Point = CGPointMake(self.width - lineSpace, line_1_Point.y);
            NSLog(@"11111111<<%f 11111111<<%f <<<<<<%f", self.pieCenter.x + cosf(angle)*picOutR, self.pieCenter.y - sinf(angle)*picOutR, angle);
        }else if (middleAngle >= 0 && middleAngle <= M_PI_2)
        {// 4
            minPieCenter = CGPointMake(self.pieCenter.x + cosf(middleAngle)*picOutR, self.pieCenter.y + sinf(middleAngle)*picOutR);
            NSLog(@"22222222--%f 2222222---%f", self.pieCenter.x + cosf(middleAngle)*picOutR, self.pieCenter.y + sinf(middleAngle)*picOutR);
            
            if (middleAngle > M_PI_2/2)
            {
                lineAngle = M_PI_2/3;
            }
            line_1_Point = CGPointMake(minPieCenter.x + cosf(lineAngle)*line_1_W, minPieCenter.y + sinf(lineAngle)*line_1_W);
            line_2_Point = CGPointMake(self.width - lineSpace, line_1_Point.y);
        }else if (middleAngle >= M_PI_2 && middleAngle <= 2*M_PI_2)
        {// 3
            CGFloat angle = M_PI - middleAngle;
            minPieCenter = CGPointMake(self.pieCenter.x - cosf(angle)*picOutR, self.pieCenter.y + sinf(angle)*picOutR);
            NSLog(@"33333333<<<%f 333333333<<<<%f <<<<<<%f", self.pieCenter.x - cosf(angle)*picOutR, self.pieCenter.y + sinf(angle)*picOutR, angle);
            
            if (middleAngle < 3*M_PI_2/2)
            {
                lineAngle = M_PI_2/3;
            }
            line_1_Point = CGPointMake(minPieCenter.x - cosf(lineAngle)*line_1_W, minPieCenter.y + sinf(lineAngle)*line_1_W);
            line_2_Point = CGPointMake(lineSpace, line_1_Point.y);
        }else
        {// 2
            CGFloat angle = middleAngle - M_PI;
            minPieCenter = CGPointMake(self.pieCenter.x - cosf(angle)*picOutR, self.pieCenter.y - sinf(angle)*picOutR);
            NSLog(@"44444444<<<%f 4444444444<<<<%f", self.pieCenter.x - cosf(angle)*picOutR, self.pieCenter.y - sinf(angle)*picOutR);
            
            if (middleAngle > 5*M_PI_2/2)
            {
                lineAngle = M_PI_2/3;
            }
            line_1_Point = CGPointMake(minPieCenter.x - cosf(lineAngle)*line_1_W, minPieCenter.y - sinf(lineAngle)*line_1_W);
            line_2_Point = CGPointMake(lineSpace, line_1_Point.y);
        }
        if (self.upTextItems.count == 1 && [self.upTextItems[0] isEqualToString:@"隐藏"]) {
            
        }else {
            // 圆点
            CAShapeLayer *minLayer = [CAShapeLayer layer];
            minLayer.fillColor = kColorRGB(97, 97, 97, 1).CGColor;
            [self.layer addSublayer:minLayer];
            
            UIBezierPath *minPath = [UIBezierPath bezierPathWithArcCenter:minPieCenter radius:2 startAngle:-M_PI_2 endAngle:3*M_PI_2 clockwise:YES];
            minLayer.path = minPath.CGPath;
            
            // 折线
            CAShapeLayer *lineLayer = [CAShapeLayer layer];
            lineLayer.strokeColor = kColorRGB(97, 97, 97, 1).CGColor;
            lineLayer.fillColor = [UIColor clearColor].CGColor;
            [self.layer addSublayer:lineLayer];
            
            UIBezierPath *linePath = [UIBezierPath bezierPath];
            [linePath moveToPoint:minPieCenter];
            [linePath addLineToPoint:line_1_Point];
            [linePath addLineToPoint:line_2_Point];
            lineLayer.path = linePath.CGPath;
            
            if (!self.isHiddenAnimation) {
                CABasicAnimation *lineAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
                lineAnimation.duration = self.animationTime;
                lineAnimation.repeatCount = 1;
                lineAnimation.fromValue = @(0);
                lineAnimation.toValue = @(1);
                lineAnimation.removedOnCompletion = NO;
                lineAnimation.fillMode = kCAFillModeForwards;
                lineAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                [lineLayer addAnimation:lineAnimation forKey:nil];
            }
            
            UILabel *upLabel = nil;
            UILabel *downLabel = nil;
            // 线上的文字
            if (i < self.upTextItems.count)
            {
                upLabel = [self createLabel:self.upTextItems[i] endPoint:line_2_Point isUp:YES];
            }
            
            // 线下的文字
            if (i < self.downTextItems.count)
            {
                downLabel = [self createLabel:self.downTextItems[i] endPoint:line_2_Point isUp:NO];
            }
            
            [UIView animateWithDuration:self.animationTime animations:^{
                upLabel.alpha = 1;
                downLabel.alpha = 1;
            }];
            
            startAngle = endAngle;
        }
        
        }
        
    
    // 遮盖的圆
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.fillColor = [UIColor clearColor].CGColor;
    backLayer.strokeColor = self.backgroundColor.CGColor;
    backLayer.lineWidth = self.pieW + 5;

    
    UIBezierPath *backLayerPath = [UIBezierPath bezierPathWithArcCenter:self.pieCenter radius:self.pieR startAngle:-M_PI_2 endAngle:3 * M_PI_2 clockwise:YES];
    backLayer.path = backLayerPath.CGPath;

    if (!self.isHiddenAnimation) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        animation.duration = self.animationTime;
        animation.repeatCount = 1;
        animation.fromValue = @(0);
        animation.toValue = @(1);
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [backLayer addAnimation:animation forKey:nil];
        [self.layer addSublayer:backLayer];
    }
 
    
    if (self.titleStr.length != 0) {
        UILabel *titleLabel= [UILabel new];
        titleLabel.text = self.titleStr;
        titleLabel.textColor = kColorRGB(51, 51, 51, 1);
        titleLabel.font = MFont(kFit(13));
        titleLabel.textAlignment = 1;
        titleLabel.numberOfLines = 2;
        [self addSubview:titleLabel];
        titleLabel.sd_layout.widthIs(kFit(70)).heightIs(kFit(50)).centerXEqualToView(self).centerYEqualToView(self);
    }
    
    
    
}

- (UILabel *)createLabel:(NSString *)text endPoint:(CGPoint)endPoint isUp:(BOOL)isUp
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:0.35f green:0.35f blue:0.37f alpha:1.00f];
    label.font = [UIFont systemFontOfSize:10];
    label.text = text;
    label.alpha = 0;
    [self addSubview:label];
    
    if (endPoint.x > self.width/2)
    {
        label.textAlignment = NSTextAlignmentRight;
    }
    
    if (isUp)
    {// 线上
        
        if (endPoint.x > self.width/2)
        {
            label.sd_layout.heightIs(15).bottomSpaceToView(self,  (self.height - endPoint.y)).rightSpaceToView(self,  (self.width - endPoint.x));
            
        }else
        {
            label.sd_layout.heightIs(15).bottomSpaceToView(self, (self.height - endPoint.y)).leftSpaceToView(self, endPoint.x);
            
        }
    }else
    {// 线下

            if (endPoint.x > self.width/2)
            {
                label.sd_layout.heightIs(15).topSpaceToView(self, endPoint.y).rightSpaceToView(self, (self.width - endPoint.x));
                
            }else
            {
                label.sd_layout.heightIs(15).topSpaceToView(self, endPoint.y).leftSpaceToView(self, endPoint.x);
            }

    }
    
    return label;
}

@end
