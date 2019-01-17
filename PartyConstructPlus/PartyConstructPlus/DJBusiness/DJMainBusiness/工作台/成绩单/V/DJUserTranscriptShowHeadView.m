//
//  DJUserTranscriptShowHeadView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/20.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJUserTranscriptShowHeadView.h"

@interface DJUserTranscriptShowHeadView ()

/**
 *背景
 */
@property (nonatomic, strong)UIImageView * backgroundImageView;

@end

@implementation DJUserTranscriptShowHeadView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
      
        self.backgroundColor = kColorRGB(246, 246, 246, 1);
        self.backgroundImageView = [UIImageView new];
        _backgroundImageView.image = [UIImage imageNamed:@"DJ_results_head_background"];
        [self addSubview:_backgroundImageView];
        _backgroundImageView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(kFit(115));
        
        self.headImageView = [UIImageView new];
        _headImageView.image = [UIImage imageNamed:@"DJUserDefaultHead"];
//        _headImageView.layer.cornerRadius = kFit(65)/2;
//        _headImageView.layer.masksToBounds = YES;
        [_backgroundImageView addSubview:_headImageView];
        _headImageView.sd_layout.leftSpaceToView(_backgroundImageView, kFit(20)).widthIs(kFit(65)).heightIs(kFit(65)).centerYEqualToView(_backgroundImageView);
        [_headImageView updateLayout];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_headImageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:_headImageView.bounds.size];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        //设置大小
        maskLayer.frame = _headImageView.bounds;
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        _headImageView.layer.mask = maskLayer;
        
        
        self.resultsImageView = [UIImageView  new];
        _resultsImageView.image = [UIImage imageNamed:@"DJ_results_state"];
        _resultsImageView.alpha = 0.0;
        [_backgroundImageView addSubview:_resultsImageView];
        _resultsImageView.sd_layout.rightSpaceToView(_backgroundImageView, 8).centerYEqualToView(_backgroundImageView).widthIs(kFit(80)).heightIs(kFit(80));
        
        self.resultsState = [UILabel new];
        _resultsState.text = @"优秀";
        _resultsState.textColor = kColorRGB(226, 126, 0, 1);
        _resultsState.font = [UIFont fontWithName:@"STSongti-SC-Bold" size:kFit(16)];
        _resultsState.textAlignment = 1;
        [_resultsImageView addSubview:_resultsState];
        _resultsState.sd_layout.leftSpaceToView(_resultsImageView, 0).topSpaceToView(_resultsImageView, kFit(24)).rightSpaceToView(_resultsImageView, 0).heightIs(kFit(22));
        
        self.userNameLabel = [UILabel new];
        _userNameLabel.text = @"";
        _userNameLabel.textColor = kColorRGB(255, 255, 255, 1);
        _userNameLabel.font = MFont(kFit(17));
        [_backgroundImageView addSubview:_userNameLabel];
        _userNameLabel.sd_layout.leftSpaceToView(_headImageView, kFit(15)).topEqualToView(_headImageView).heightIs(kFit(30)).rightSpaceToView(_resultsImageView, kFit(15));
        
        self.orgNameLabel = [UILabel new];
        _orgNameLabel.textColor = kColorRGB(255, 255, 255, 1);
        _orgNameLabel.font = MFont(kFit(13));
        _orgNameLabel.text = @"";
        [_backgroundImageView  addSubview:_orgNameLabel];
        _orgNameLabel.sd_layout.leftSpaceToView(_headImageView, kFit(15)).topSpaceToView(_userNameLabel, 0).heightIs(kFit(19)).rightSpaceToView(_resultsImageView, kFit(15));
        
        self.rankingLabel = [UILabel new];
        _rankingLabel.textColor = kColorRGB(255, 255, 255, 1);
        _rankingLabel.font = MFont( kFit(13));
        _rankingLabel.text = @"";
        [_backgroundImageView addSubview:_rankingLabel];
        _rankingLabel.sd_layout.leftSpaceToView(_headImageView, kFit(15)).bottomEqualToView(_headImageView).heightIs(kFit(17)).rightSpaceToView(_resultsImageView, kFit(15));
        
        UIView *  integralView = [UIView new];
        integralView.backgroundColor = [UIColor whiteColor];
        [self  addSubview:integralView];
        integralView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(_backgroundImageView, kFit(5)).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        
        
        UIButton *  showImageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [showImageBtn setImage:[UIImage imageNamed:@"DJ_results_detail"]  forState:(UIControlStateNormal)];
        [integralView addSubview:showImageBtn];
        showImageBtn.sd_layout.leftSpaceToView(integralView, kFit(6)).topSpaceToView(integralView, 0).bottomSpaceToView(integralView, 0).widthIs(kFit(30));
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.textColor = kColorRGB(51, 51, 51, 1);
        titleLabel.text = @"积分明细";
        titleLabel.font = MFont(kFit(16));
        [integralView addSubview:titleLabel];
        titleLabel.sd_layout.leftSpaceToView(showImageBtn, 0).heightIs(16).centerYEqualToView(integralView).rightSpaceToView(integralView, kFit(15));
        
        self.dividerLabel = [UILabel new];
        _dividerLabel.backgroundColor = kCellColorDivider;
        [integralView addSubview:_dividerLabel];
        _dividerLabel.sd_layout.leftSpaceToView(integralView, 0).bottomSpaceToView(integralView, 0).heightIs(kCellDividerHeight).rightSpaceToView(integralView, 0);
    }
    return self;
}


-(void)setState:(NSInteger)state {
    _state = state;
  
    
}

- (NSString *)accordingScoreRating:(NSString *)Score {
    
    NSInteger results = Score.integerValue;
    NSString *resultsStr= @"合格";
    
    if (results < 75) {
        resultsStr = @"合格";
    }
    if ( results<93 && results >= 75) {
        resultsStr =  @"良好";
    }
    
    if (results >= 93) {
        resultsStr =  @"优秀";
    }
    return resultsStr;
}
@end
