//
//  DJTaskTypeView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/6.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskTypeView.h"

@implementation DJTaskTypeView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        //244 180
        self.iconBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_iconBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        _iconBtn.userInteractionEnabled  = NO;
        [self addSubview:_iconBtn];
        _iconBtn.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, kFit(22)).rightSpaceToView(self, 0).heightIs(kFit(23));
        
        self.titleLabel = [UILabel new];
        _titleLabel.textColor = kColorRGB(51, 51, 51, 1);
        _titleLabel.textAlignment = 1;
        _titleLabel.font = MFont(13);
        _titleLabel.text = @"全部";
        [self addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(self, 0).topSpaceToView(_iconBtn, kFit(10)).rightSpaceToView(self, 0).heightIs(kFit(13));
        
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleSingleFingerEvent)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        
        
        [self addGestureRecognizer:singleFingerOne];

    }
    return self;
}
- (void)handleSingleFingerEvent{
    if ([_delegate respondsToSelector:@selector(ClickTaskType:)]) {
        [_delegate ClickTaskType:self];
    }
}

@end
