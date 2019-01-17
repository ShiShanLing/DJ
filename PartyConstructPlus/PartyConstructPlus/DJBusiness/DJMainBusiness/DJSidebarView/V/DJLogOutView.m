//
//  DJLogOutView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/8.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJLogOutView.h"

@implementation DJLogOutView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.iconBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_iconBtn setImage:[UIImage imageNamed:@"DJLogOut"] forState:(UIControlStateNormal)];
        _iconBtn.userInteractionEnabled = NO;
        [self addSubview:_iconBtn];
        _iconBtn.sd_layout.leftSpaceToView(self, kFit(45)).widthIs(kFit(18)).heightIs(kFit(18)).centerYEqualToView(self);
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColorRGB(253, 115, 98, 1);
        _titleLabel.text = @"退出登录";//高48  宽 38
        _titleLabel.font = MFont(kFit(16));
        [self addSubview:_titleLabel];
        _titleLabel .sd_layout.leftSpaceToView(_iconBtn, kFit(10)).centerYEqualToView(self).heightIs(kFit(15.5)).rightSpaceToView(self, kFit(15));
        
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleSingleFingerEvent)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        
        [self addGestureRecognizer:singleFingerOne];

        
    }
    return self;
}
- (void)handleSingleFingerEvent {
    if ([_delegate respondsToSelector:@selector(logOut)]) {
        [_delegate logOut];
    }
    
    
}


@end
