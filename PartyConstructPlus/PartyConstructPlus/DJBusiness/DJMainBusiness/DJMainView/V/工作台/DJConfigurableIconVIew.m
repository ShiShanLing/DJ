//
//  DJConfigurableIconVIew.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/10.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJConfigurableIconVIew.h"

@implementation DJConfigurableIconVIew


-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleSingleFingerEvent:)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        
        [self addGestureRecognizer:singleFingerOne];
    }
    return self;
}
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)tap {
    

    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
