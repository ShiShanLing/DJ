//
//  ConfigurableIconVIew.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "ConfigurableIconVIew.h"

@interface ConfigurableIconVIew ()

@end


@implementation ConfigurableIconVIew


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.iconImage = [[UIImageView alloc] init];
        _iconImage.image = [UIImage imageNamed:@"DJAllModule"];
        [self addSubview:self.iconImage];
        self.iconImage.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightEqualToWidth();
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = 1;
        self.titleLabel.text = @"全部";
        _titleLabel.font = MFont(11.5);
        [self addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self.iconImage, -5).rightSpaceToView(self, 0).heightIs(12);
        
        UIButton *newTaskBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [newTaskBtn setBackgroundImage:[UIImage imageNamed:@"DJ_New_task"] forState:(UIControlStateNormal)];
        newTaskBtn.hidden = YES;
        newTaskBtn.userInteractionEnabled = NO;
        [newTaskBtn setTitle:@"新任务" forState:(UIControlStateNormal)];
        [newTaskBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        newTaskBtn.titleLabel.font = MFont(kFit(8));
        [self addSubview:newTaskBtn];
        self.showNewTaskBtn = newTaskBtn;
        newTaskBtn.sd_layout.rightSpaceToView(self, -10).topSpaceToView(self, 0).widthIs(kFit(35)).heightIs(kFit(18));
        
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleSingleFingerEvent:)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        [self addGestureRecognizer:singleFingerOne];
    }
    
    return self;
}


- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(ClickConfigurableIcon:)]) {
        [_delegate ClickConfigurableIcon:self];
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
