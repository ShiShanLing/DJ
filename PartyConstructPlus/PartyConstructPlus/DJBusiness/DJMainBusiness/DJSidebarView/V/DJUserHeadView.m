//
//  DJUserHeadView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/8.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJUserHeadView.h"

@implementation DJUserHeadView

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
        self.bottomImage = [[UIImageView alloc] init];
        _bottomImage.image = [UIImage imageNamed:@"DJUserHeadView"];
        _bottomImage.userInteractionEnabled  = YES;
        [self addSubview:_bottomImage];
        _bottomImage.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).bottomSpaceToView(self, 0).widthIs(frame.size.width);
        

        self.nameBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_nameBtn setTitle:@"登录/注册" forState:(UIControlStateNormal)];
        [_nameBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_nameBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateHighlighted)];
        _nameBtn.font =MFont(kFit(17));
        [_nameBtn addTarget:self action:@selector(handlerClickName) forControlEvents:(UIControlEventTouchUpInside)];
        [_bottomImage addSubview:_nameBtn];
        _nameBtn.sd_layout.leftSpaceToView(_bottomImage, 0).bottomSpaceToView(_bottomImage, kFit(25)).rightSpaceToView(_bottomImage, 0).heightIs(kFit(37));
        
        self.headImage =[[UIImageView alloc ] init];
        _headImage.image = [UIImage imageNamed:@"DJUserDefaultHead"];
        _headImage.userInteractionEnabled = YES;
        [_bottomImage addSubview:_headImage];
        _headImage.sd_layout.bottomSpaceToView(_nameBtn, kFit(5)).centerXEqualToView(_bottomImage).widthIs(kFit(65)).heightIs(kFit(65));
        [_headImage updateLayout];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_headImage.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:_headImage.bounds.size];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        //设置大小
        maskLayer.frame = _headImage.bounds;
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        _headImage.layer.mask = maskLayer;
        
        
        
    }
    return self;
}

- (void)handlerClickName {
    
    if ([_delegate respondsToSelector:@selector(ClickUserCenter)]) {
        [_delegate ClickUserCenter];
    }
    
}
@end
