//
//  DJGtasksView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/14.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJGtasksView.h"

@implementation DJGtasksView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        
        UIImageView *backgroundImage = [[UIImageView alloc] init];
        backgroundImage.image = [UIImage imageNamed:@"DJAgendaBackground"];
        [self addSubview:backgroundImage];
        backgroundImage.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        self.showBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_showBtn setTitle:@"待办行事历(12)" forState:(UIControlStateNormal)];
        [_showBtn setTitleColor:kColorRGB(253, 115, 77, 1) forState:(UIControlStateNormal)];
        [_showBtn setTitleColor:kColorRGB(134, 134, 134, 1) forState:(UIControlStateHighlighted)];
        _showBtn.font = MFont(16);
        [_showBtn setImage:[UIImage imageNamed:@"DJWaitDealWithWC"] forState:(UIControlStateNormal)];
        [_showBtn addTarget:self action:@selector(handleClickButton) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_showBtn];

        _showBtn.sd_layout.leftSpaceToView(self, 15).topSpaceToView(self, 10).rightSpaceToView(self, 15).heightIs(45);

    }
    return self;
}
- (void)handleClickButton {
    if ([_delegate respondsToSelector:@selector(ClickAgendaList)]) {
        [_delegate ClickAgendaList];
    }
}
@end
