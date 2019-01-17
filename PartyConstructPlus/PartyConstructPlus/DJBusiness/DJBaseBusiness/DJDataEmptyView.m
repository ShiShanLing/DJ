//
//  DJDataEmptyView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJDataEmptyView.h"

@implementation DJDataEmptyView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        
        self.dividerLabel = [UILabel new];
        _dividerLabel.backgroundColor = kCellColorDivider;
        [self addSubview:_dividerLabel];
        _dividerLabel.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).heightIs(kCellDividerHeight).rightSpaceToView(self, 0);
        
        self.backgroundColor = [UIColor whiteColor];
        UILabel *YCenterLineLabel = [UILabel new];
        [self addSubview:YCenterLineLabel];
        YCenterLineLabel.sd_layout.leftSpaceToView(self, 0).heightIs(1).rightSpaceToView(self, 0).centerYEqualToView(self);
        self.emptyImageView = [UIImageView new];
        _emptyImageView.image = [UIImage imageNamed:@"DJ_emptyData"];
        _emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_emptyImageView];
        CGFloat tempf = (self.height - kFit(315)) / 3;
        _emptyImageView.sd_layout.widthIs((kScreenWidth - 60)).heightIs(kFit(315)).centerXEqualToView(self).topSpaceToView(self, tempf);
        self.promptLabel = [UILabel new];
        _promptLabel.textColor = kColorRGB(136, 136, 136, 1);
//      _promptLabel.text = @"您尚未上传履职说明书";
        _promptLabel.textAlignment = 1;
        _promptLabel.numberOfLines = 2;
        _promptLabel.font = MFont(kFit(15));
        
        _emptyImageView.sd_layout.widthIs((kScreenWidth - 60)).heightIs(kFit(315)).centerXEqualToView(self).topSpaceToView(self, tempf);
        [_emptyImageView addSubview:_promptLabel];
        _promptLabel.sd_layout.leftSpaceToView(_emptyImageView, 0).rightSpaceToView(_emptyImageView, 0).topSpaceToView(_emptyImageView, kFit(180)).autoHeightRatio(0);
    }
    return self;
}

@end
