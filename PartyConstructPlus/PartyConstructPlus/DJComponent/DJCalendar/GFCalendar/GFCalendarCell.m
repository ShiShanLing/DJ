//
//  GFCalendarCell.m
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import "GFCalendarCell.h"

#define kColorRGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]//RGB颜色
@implementation GFCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.leftColorView];
        self.leftColorView.sd_layout.leftSpaceToView(self.contentView, 0).widthIs(self.width/2).bottomSpaceToView(self.contentView, 0).heightIs(35);
        [self.contentView addSubview:self.rightColorView];
        self.rightColorView.sd_layout.leftSpaceToView(_leftColorView, 0).widthIs(self.width/2).bottomSpaceToView(self.contentView, 0).heightIs(35);
        [self.contentView addSubview:self.todayCircle];
        self.selectedBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.selectedBtn setBackgroundImage:[UIImage imageNamed:@"DJ_selectedDate"] forState:(UIControlStateNormal)];
        self.selectedBtn.userInteractionEnabled = NO;
        self.selectedBtn.hidden = YES;
        [self.contentView addSubview:self.selectedBtn];
        self.selectedBtn.sd_layout.bottomSpaceToView(self.contentView, 0).widthIs(35).centerXEqualToView(self.contentView).heightIs(35);
        
        
        self.repeatLabel = [UILabel new];
        _repeatLabel.textColor = kColorRGB(252, 106, 74, 1);
        _repeatLabel.font = MFont(9);
        _repeatLabel.hidden = YES;
        _repeatLabel.text = @"始/止";
        _repeatLabel.textAlignment = 1;
        [self.contentView addSubview:_repeatLabel];
        _repeatLabel.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 2).rightSpaceToView(self.contentView, 0).heightIs(9);
        
        [self.contentView addSubview:self.todayLabel];
        _todayLabel.backgroundColor = [UIColor clearColor];
        _todayLabel.sd_layout.topSpaceToView(_repeatLabel, 2).bottomSpaceToView(self.contentView, 0).widthIs(35).centerXEqualToView(self.contentView);
    }
    return self;
}

- (UIView *)leftColorView{
    if (!_leftColorView) {
        _leftColorView = [[UIView alloc] init];
        _leftColorView.hidden = YES;
        _leftColorView.backgroundColor = kColorRGB(255, 225, 220, 1);
//        [UIColor colorWithRed:255/255 green:225/255.0 blue:220/255 alpha:1];
    }
    return _leftColorView;
}
- (UIView *)rightColorView{
    if (!_rightColorView) {
        _rightColorView = [[UIView alloc] init];
        _rightColorView.hidden = YES;
        _rightColorView.backgroundColor = kColorRGB(255, 225, 220, 1);
    }
    return _rightColorView;
}
- (UIView *)todayCircle {
    if (_todayCircle == nil) {
        _todayCircle = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.8 * self.bounds.size.height, 0.8 * self.bounds.size.height)];
        _todayCircle.center = CGPointMake(0.5 * self.bounds.size.width, 0.5 * self.bounds.size.height);
        _todayCircle.layer.cornerRadius = 0.5 * _todayCircle.frame.size.width;
    }
    return _todayCircle;
}

- (UILabel *)todayLabel {
    if (_todayLabel == nil) {
        _todayLabel = [[UILabel alloc] init];
        _todayLabel.textAlignment = 1;
        _todayLabel.font = [UIFont boldSystemFontOfSize:15.0];
        _todayLabel.backgroundColor = [UIColor clearColor];
    }
    return _todayLabel;
}

@end
