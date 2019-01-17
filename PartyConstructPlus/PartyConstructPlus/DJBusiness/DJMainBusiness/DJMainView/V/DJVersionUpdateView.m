//
//  DJVersionUpdateView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJVersionUpdateView.h"
#import "YYTextLayout.h"

@interface DJVersionUpdateView ()

@property (nonatomic, strong)UIView *upDataView;

@end

@implementation DJVersionUpdateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        backgroundView.backgroundColor =[UIColor blackColor];
        backgroundView.alpha = 0.4;
        [self addSubview:backgroundView];
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handlHiddenSelf)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        
        
        [backgroundView addGestureRecognizer:singleFingerOne];

        
        self.upDataView = [[UIView alloc] init];
        _upDataView.layer.cornerRadius = kFit(10);
        _upDataView.backgroundColor = [UIColor whiteColor];
        _upDataView.layer.masksToBounds = YES;
        [self addSubview:_upDataView];
        
        _upDataView.sd_layout.leftSpaceToView(self, kFit(45)).rightSpaceToView(self, kFit(45)).centerYEqualToView(self).heightIs(kFit(266));
        
        UIImageView *showImageView = [UIImageView new];
        showImageView.image = [UIImage imageNamed:@"DJ_Version_upData"];
        showImageView.clipsToBounds = YES;
        [_upDataView addSubview:showImageView];
        showImageView.sd_layout.leftSpaceToView(_upDataView, 0).topSpaceToView(_upDataView, 0).rightSpaceToView(_upDataView, 0).heightIs(kFit(144));
        UILabel *content1 = [UILabel new];
        content1.textColor =kColorRGB(51, 51, 51, 1);
        content1.font = MFont(kFit(16));
        content1.numberOfLines = 0;
        NSString *testStr = @"1.这里是更新内容这里";
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:testStr];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:kFit(10)];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [testStr length])];
        [content1 setAttributedText:attributedString1];
        
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kFit(228), CGFLOAT_MAX) text:attributedString1];
        
        self.contentLabel = content1;
        [_upDataView addSubview:content1];
        
        
        content1.sd_layout.widthIs(kFit(228)).topSpaceToView(showImageView, kFit(5)).heightIs(layout.textBoundingSize.height+2).centerXEqualToView(_upDataView);
        [content1 updateLayout];
        _upDataView.sd_layout.leftSpaceToView(self, kFit(45)).rightSpaceToView(self, kFit(45)).centerYEqualToView(self).heightIs(kFit(195+71)+content1.height);
        
        UIImageView *upDataImageView =[[UIImageView alloc] init];
        upDataImageView.image =  [UIImage imageNamed:@"DJ_qgx"];
        upDataImageView.userInteractionEnabled = YES;
        self.upDataImageView = upDataImageView;
        [_upDataView addSubview:upDataImageView];
        upDataImageView.sd_layout.leftSpaceToView(_upDataView, kFit(25.5)).rightSpaceToView(_upDataView, kFit(25.5)).topSpaceToView(content1, kFit(17.5)).heightIs(kFit(70));
        
        UIButton *upDataBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [upDataBtn setTitle:@"立即更新" forState:(UIControlStateNormal)];
        [upDataBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        upDataBtn.titleLabel.font = MFont(kFit(16));
        [upDataBtn addTarget:self action:@selector(handleUpDataBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [upDataImageView addSubview:upDataBtn];
        self.upDataBtn = upDataBtn;
        upDataBtn.sd_layout.widthIs(kFit(215)).topSpaceToView(upDataImageView, 10).bottomSpaceToView(upDataImageView, kFit(20)).centerXEqualToView(upDataImageView);
        
        UIButton *LaterUpDataBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [LaterUpDataBtn setTitle:@"稍后再说" forState:(UIControlStateNormal)];
        [LaterUpDataBtn setTitleColor:kColorRGB(252, 107, 74, 1) forState:(UIControlStateNormal)];
        LaterUpDataBtn.titleLabel.font = MFont(kFit(16));
        [LaterUpDataBtn addTarget:self action:@selector(handleLaterUpDataBtn) forControlEvents:(UIControlEventTouchUpInside)];
        self.LaterUpDataBtn = LaterUpDataBtn;
        [_upDataView addSubview:LaterUpDataBtn];
        LaterUpDataBtn.sd_layout.widthIs(kFit(80)).heightIs(kFit(18)).topSpaceToView(upDataImageView, kFit(-8)).centerXEqualToView(upDataImageView);
    }
    return self;
}

- (void)handleUpDataBtn {
    
    self.versionUpData(0);
}

- (void)handleLaterUpDataBtn {
    self.versionUpData(1);
}
- (void)handlHiddenSelf {
    
}

- (void)setUpDatatype:(NSInteger)upDatatype {
    switch (upDatatype) {
        case 0:
            break;
        case 1:
            _LaterUpDataBtn.alpha = 0;
            _upDataImageView.sd_layout.leftSpaceToView(_upDataView, kFit(25.5)).rightSpaceToView(_upDataView, kFit(25.5)).topSpaceToView(_contentLabel, kFit(27.5)).heightIs(kFit(70));
            _upDataBtn.sd_layout.widthIs(kFit(215)).topSpaceToView(_upDataImageView, 10).bottomSpaceToView(_upDataImageView, kFit(20)).centerXEqualToView(_upDataImageView);
            break;
            
        default:
            break;
    }
}
@end
