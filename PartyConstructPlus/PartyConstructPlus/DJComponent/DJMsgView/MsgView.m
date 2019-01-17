//
//  MsgView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/10.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "MsgView.h"

@implementation MsgView

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
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [UILabel new];
        _titleLabel.textAlignment = 2;
        _titleLabel.text = @"待办(30) ";
        _titleLabel.font = MFont(kFit(15));
        [self addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 5).bottomSpaceToView(self, 0);
        
        self.RedDotLabel = [[UILabel alloc] init];
        _RedDotLabel.backgroundColor = [UIColor redColor];
        _RedDotLabel.layer.cornerRadius = 3.5;
        _RedDotLabel.layer.masksToBounds = YES;
        [self addSubview:_RedDotLabel];
        _RedDotLabel.sd_layout.rightSpaceToView(self, 0).topSpaceToView(self, 0).widthIs(7).heightIs(7);
        
        
    }
    return self;
}

@end
