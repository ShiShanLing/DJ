//
//  DJTaskSendObjectTypeChooseView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/23.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskSendObjectTypeChooseView.h"

@interface DJTaskSendObjectTypeChooseView  ()

@property (nonatomic, strong)UILabel *  underlineLabel;

@end


@implementation DJTaskSendObjectTypeChooseView {
    UIButton *leftBtn;
    
    UIButton *rightBtn;
}
-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
      
        UILabel *_dividerLabel = [UILabel new];
        _dividerLabel.backgroundColor = kCellColorDivider;
        [self addSubview:_dividerLabel];
        _dividerLabel.sd_layout.heightIs(kFit(15)).widthIs(kCellDividerHeight).centerXEqualToView(self).centerYEqualToView(self);
        
        
        leftBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [leftBtn setTitle:@"搜索用户姓名" forState:(UIControlStateNormal)];
        [leftBtn setTitleColor:kColorRGB(251, 85, 64, 1) forState:(UIControlStateNormal)];
        leftBtn.titleLabel.font = MFont(kFit(15));
        leftBtn.tag = 101;
        [leftBtn addTarget:self action:@selector(handleClickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:leftBtn];
        leftBtn.sd_layout.rightSpaceToView(_dividerLabel, 0).widthIs(kFit(118)).heightIs(kFit(15)).centerYEqualToView(self);
        [leftBtn updateLayout];
        rightBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [rightBtn setTitle:@"搜索组织" forState:(UIControlStateNormal)];
        [rightBtn setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
        rightBtn.tag = 102;
        rightBtn.titleLabel.font = MFont(kFit(15));
        [rightBtn addTarget:self action:@selector(handleClickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:rightBtn];
        rightBtn.sd_layout.leftSpaceToView(_dividerLabel, 0).widthIs(kFit(90)).heightIs(kFit(15)).centerYEqualToView(self);
        [rightBtn updateLayout];
        
        self.underlineLabel = [UILabel new];
        _underlineLabel.frame = CGRectMake(leftBtn.left+kFit(10), leftBtn.bottom+kFit(7), leftBtn.width-kFit(20), kFit(1.5));
        _underlineLabel.backgroundColor = kColorRGB(251, 85, 64, 1);
        [self addSubview:_underlineLabel];
        
    }
    return self;
}
- (void)handleClickBtn:(UIButton *)sender {
    if (sender.tag == 101) {
        [leftBtn setTitleColor:kColorRGB(251, 85, 64, 1) forState:(UIControlStateNormal)];
        [rightBtn setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
        [UIView animateWithDuration:0.3 animations:^{
        _underlineLabel.frame  =  CGRectMake(sender.left+kFit(10), sender.bottom+kFit(7), sender.width-kFit(20), kFit(1.5));
        }];
    }else {
        [rightBtn setTitleColor:kColorRGB(251, 85, 64, 1) forState:(UIControlStateNormal)];
        [leftBtn setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
        [UIView animateWithDuration:0.7 animations:^{
            _underlineLabel.frame  =  CGRectMake(sender.left+kFit(10), sender.bottom+kFit(7), sender.width-kFit(20), kFit(1.5));
        }];
    }
    if ([_delegate respondsToSelector:@selector(switchSearchTypes:)]) {
        [_delegate switchSearchTypes:sender.tag - 101];
    }
    
}


- (void)setSearchType:(NSInteger)searchType {
    switch (searchType) {
        case 0:
            [leftBtn setTitleColor:kColorRGB(251, 85, 64, 1) forState:(UIControlStateNormal)];
            [rightBtn setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
                _underlineLabel.frame  =  CGRectMake(leftBtn.left+kFit(10), leftBtn.bottom+kFit(7), leftBtn.width-kFit(20), kFit(1.5));
            break;
        case 1:
            [rightBtn setTitleColor:kColorRGB(251, 85, 64, 1) forState:(UIControlStateNormal)];
            [leftBtn setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
                _underlineLabel.frame  =  CGRectMake(rightBtn.left+kFit(10), rightBtn.bottom+kFit(7), rightBtn.width-kFit(20), kFit(1.5));
            break;
            
        default:
            break;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
