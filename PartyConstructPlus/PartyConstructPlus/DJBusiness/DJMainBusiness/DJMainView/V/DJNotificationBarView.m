//
//  DJNotificationBarView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/20.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJNotificationBarView.h"

@implementation DJNotificationBarView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIImageView *showImageView = [UIImageView new];
        showImageView.image = [UIImage imageNamed:@"DJNotificationBar"];
        [self.contentView addSubview:showImageView];
        showImageView.contentMode =UIViewContentModeCenter;
        showImageView.sd_layout.leftSpaceToView(self.contentView, kFit(6)).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(kFit(30));
        
        self.arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"DJRegistrationRight"];
        _arrowImageView.contentMode =UIViewContentModeCenter;
        [self.contentView addSubview:_arrowImageView];
        _arrowImageView.sd_layout.rightSpaceToView(self.contentView, 0).widthIs(kFit(40)).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
        
        self.contentLabel = [UILabel new];
        _contentLabel.textColor = kColorRGB(102, 102, 102, 1);
        _contentLabel.font = MFont(kFit(14));
        [self.contentView addSubview:_contentLabel];
        _contentLabel.sd_layout.leftSpaceToView(showImageView, 0).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).rightSpaceToView(_arrowImageView, kFit(23));
    }
    return self;
}

@end
