//
//  DJPromptCustomView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/31.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJPromptCustomView.h"

@implementation DJPromptCustomView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
      
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.2;
        [self addSubview:_backgroundView];
        _backgroundView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        
        self.bezelView = [UIView new];
        _bezelView.backgroundColor = [UIColor whiteColor];
        _bezelView.layer.masksToBounds = YES;
        _bezelView.layer.cornerRadius = kFit(10);
        [self  addSubview:_bezelView];
        _bezelView.sd_layout.widthIs(50).heightIs(60).centerXEqualToView(self).centerYEqualToView(self);
        
        
        self.promptLabel  = [UILabel new];
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.textAlignment = 1;
        _promptLabel.numberOfLines = 0;
        [self addSubview:_promptLabel];
        _promptLabel.sd_layout.centerYEqualToView(_bezelView).centerXEqualToView(_bezelView);
        
    }
    return self;
}


@end
