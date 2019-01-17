//
//  DJLearningView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJLearningView.h"

@interface DJLearningView()

/**
 标题
 */
@property (nonatomic, strong)UILabel *titleLabel;
/**
 *图标
 */
@property (nonatomic, strong)UIImageView *iconImage;
@end

@implementation DJLearningView


-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorRGB(248, 248, 250, 1);
        self.iconImage = [[UIImageView alloc] init];
        _iconImage.image = [UIImage imageNamed:@"DJReading"];
        _iconImage.contentMode =  UIViewContentModeScaleToFill;
        [self addSubview:_iconImage];
        _iconImage.sd_layout.rightSpaceToView(self, kFit(17)).widthIs(kFit(43)).heightIs(kFit(43)).centerYEqualToView(self);
        
        
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(17)];
        _titleLabel.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [self addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(self, kFit(15)).heightIs(kFit(17)).rightSpaceToView(_iconImage, kFit(5)).centerYEqualToView(self);
        
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleSingleFingerEvent)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        [self addGestureRecognizer:singleFingerOne];
    }
    
    return self;
}
- (void)handleSingleFingerEvent {
    
    if ([_delegate respondsToSelector:@selector(ClickLearningModule:)]) {
        [_delegate ClickLearningModule:self];
    }
    
}


- (void)setDataDic:(NSDictionary *)dataDic {
    self.titleLabel.text = dataDic[@"title"];
    self.iconImage.image = [UIImage imageNamed:dataDic[@"icon"]];
    

}
@end
