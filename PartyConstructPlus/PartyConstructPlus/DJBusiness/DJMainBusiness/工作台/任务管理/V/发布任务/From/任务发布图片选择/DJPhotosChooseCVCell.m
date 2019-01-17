//
//  DJPhotosChooseCVCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/5.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJPhotosChooseCVCell.h"

@interface DJPhotosChooseCVCell ()

@end

@implementation DJPhotosChooseCVCell
-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        
        self.showImageView = [[UIImageView alloc] init];
        _showImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_showImageView];
        _showImageView.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
        self.stateBtn = [UIButton new];
        [_stateBtn setImage:[UIImage imageNamed:@"DJ_photo_selected"] forState:(UIControlStateNormal)];
        _stateBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_stateBtn];
        [self.stateBtn addTarget:self action:@selector(handleStateBtn) forControlEvents:(UIControlEventTouchUpInside)];
        _stateBtn.sd_layout.rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).widthIs(33).heightIs(33);
        
    }
    return self;
}

- (void)handleStateBtn {
    
    
    
}
@end
