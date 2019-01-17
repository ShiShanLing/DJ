//
//  DJSJFXHeadView.m
//  数据分析实现
//
//  Created by 石山岭 on 2018/9/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJSJFXHeadView.h"

@implementation DJSJFXHeadView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [UILabel new];
        _titleLabel.text = @"一 .  个人本月实时数据排行";
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(15)];
        _titleLabel.textColor = kColorRGB(51, 51, 51, 1);
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).centerYEqualToView(self.contentView).rightSpaceToView(self.contentView, kFit(100)).heightIs(kFit(15));
        
        self.subtitleLabel = [UILabel new];
        _subtitleLabel.text = @"单位 ( 个 )";
        _subtitleLabel.font = MFont(kFit(14));
        _subtitleLabel.textAlignment = 2;
        _subtitleLabel.textColor = kColorRGB(51, 51, 51, 1);
        [self.contentView addSubview:_subtitleLabel];
        _subtitleLabel.sd_layout.leftSpaceToView(_titleLabel, kFit(15)).centerYEqualToView(self.contentView).rightSpaceToView(self.contentView, kFit(15)).heightIs(kFit(15));
    }
    return self;
}


@end
