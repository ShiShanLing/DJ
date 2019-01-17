//
//  DJDAOrgChooseView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/27.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJDAOrgChooseView.h"

@implementation DJDAOrgChooseView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.orgNameBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_orgNameBtn setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
        _orgNameBtn.titleLabel.font = MFont(kFit(16));
        _orgNameBtn.titleLabel.textAlignment = 1;
        _orgNameBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        _orgNameBtn.titleLabel.numberOfLines = 0;
        [_orgNameBtn addTarget:self action:@selector(handleOrgNameClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_orgNameBtn setTitle:@"" forState:(UIControlStateNormal)];
        [self addSubview:_orgNameBtn];
        _orgNameBtn.sd_layout.centerXEqualToView(self).centerYEqualToView(self).maxWidthIs(kScreenWidth - 60).heightIs(self.height);
        self.iconBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_iconBtn setImage:[UIImage imageNamed:@"DJMenuExpand"] forState:(UIControlStateNormal)];
        [self addSubview:_iconBtn];
        _iconBtn.sd_layout.leftSpaceToView(_orgNameBtn, 0).widthIs(16).heightIs(16).centerYEqualToView(_orgNameBtn);
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setTitle:(NSString *)title {
    __weak  DJDAOrgChooseView *selfWeak = self;
    _title = title;
    [_orgNameBtn setTitle:title forState:(UIControlStateNormal)];
    CGSize size = [SmkBaseFuncation sizeWithText:title font:MFont(kFit(16)) maxSize:CGSizeMake(kScreenWidth - 60, kFit(18))];
    _orgNameBtn.sd_layout.centerYEqualToView(selfWeak).centerXEqualToView(selfWeak).heightIs(self.height).widthIs(size.width);
}

- (void)handleOrgNameClick  {
    if ([_delegate respondsToSelector:@selector(SwitchHistoricalOrg)]) {
        [_delegate SwitchHistoricalOrg];
    }
}

@end
