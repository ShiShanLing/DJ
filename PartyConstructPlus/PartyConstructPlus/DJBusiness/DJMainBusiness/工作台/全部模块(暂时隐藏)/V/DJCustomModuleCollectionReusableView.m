//
//  DJCustomModuleCollectionReusableView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/30.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJCustomModuleCollectionReusableView.h"

@implementation DJCustomModuleCollectionReusableView


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColorRGB(51, 51, 51, 1);
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(17)];
        [self addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(self, kFit(15)).heightIs(kFit(26)).bottomSpaceToView(self, 0).rightSpaceToView(self, 15);
    }
    return self;
}


@end
