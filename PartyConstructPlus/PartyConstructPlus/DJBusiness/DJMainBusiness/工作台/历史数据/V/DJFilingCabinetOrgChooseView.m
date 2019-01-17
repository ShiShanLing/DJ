//
//  DJFilingCabinetOrgChooseView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/21.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJFilingCabinetOrgChooseView.h"

@interface DJFilingCabinetOrgChooseView ()

@property (nonatomic, strong)UIButton *chooseBen;
@end

@implementation DJFilingCabinetOrgChooseView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        
        self.chooseBen = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_chooseBen setTitle:@"" forState:(UIControlStateNormal)];
        [_chooseBen setImage:[UIImage imageNamed:@"DJMenuExpand"] forState:(UIControlStateNormal)];
        _chooseBen.titleLabel.font = MFont(kFit(16));
        _chooseBen.titleLabel.textAlignment = 0;
        [_chooseBen setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
        CGFloat widht = [self calculateRowWidth:@"上城12345678987654345678987"];
        if (widht*2 > kScreenWidth ) {
            widht = kScreenWidth- 60;
        }else {
            widht = widht*2;
        }
        _chooseBen.imageEdgeInsets = UIEdgeInsetsMake(0, widht, 0, 0);
         _chooseBen.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        
        NSLog(@"widht%f _chooseBen.titleEdgeInsets.left%f", widht, _chooseBen.titleEdgeInsets.left);
        [self addSubview:_chooseBen];
        _chooseBen.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        
    }
    return self;
}
- (CGFloat)calculateRowWidth:(NSString *)string {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:kFit(17)]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, kFit(20))/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
