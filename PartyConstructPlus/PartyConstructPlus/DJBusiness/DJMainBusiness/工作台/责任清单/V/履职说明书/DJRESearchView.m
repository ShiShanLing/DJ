//
//  DJRESearchView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/16.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJRESearchView.h"

@implementation DJRESearchView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [searchBtn setTitle:@"搜索" forState:(UIControlStateNormal)];
        [searchBtn setImage:[UIImage imageNamed:@"DJ_lzsms_search"] forState:(UIControlStateNormal)];
        searchBtn.font = MFont(kFit(13));
        searchBtn.backgroundColor  = kColorRGB(239, 239, 239, 1);
        searchBtn.layer.cornerRadius = 4;
        searchBtn.layer.masksToBounds = YES;
        [searchBtn setTitleColor:kColorRGB(173, 173, 173, 1) forState:(UIControlStateNormal)];
        [self addSubview:searchBtn];
        searchBtn.sd_layout.leftSpaceToView(self, 15).rightSpaceToView(self, 15).topSpaceToView(self, 5).heightIs(25);
    }
    return self;
}

@end
