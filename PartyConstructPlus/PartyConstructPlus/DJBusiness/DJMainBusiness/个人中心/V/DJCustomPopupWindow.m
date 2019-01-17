//
//  DJCustomPopupWindow.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/30.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJCustomPopupWindow.h"

@interface DJCustomPopupWindow  ()

/**
 取消按钮
 */
@property (nonatomic, strong)UIButton *cancelBtn;
/**
 *
 */
@property (nonatomic, strong) UIButton *photoAlbumBtn;
/**
 *
 */
@property (nonatomic, strong) UIButton *cameraBtn;
@end

@implementation DJCustomPopupWindow

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
//        234 点击颜色
//        34 X的bottom
//        7 默认bottom
        UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        cancelBtn.backgroundColor = kColorRGB(249, 249, 249, 1);
        [cancelBtn setTitleColor:kColorRGB(0, 100, 255, 1) forState:(UIControlStateNormal)];
        cancelBtn.layer.cornerRadius = kFit(10);
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(18)];
        cancelBtn.tag = 102;
        [cancelBtn setTitleColor:kColorRGB(0, 100, 255, 1) forState:(UIControlStateHighlighted)];
        self.cancelBtn = cancelBtn;
        [self addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(handleClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cancelBtn.sd_layout.leftSpaceToView(self, kFit(10)).rightSpaceToView(self, kFit(10)).heightIs(kFit(57)).bottomSpaceToView(self,0);
        
        UIView *backgroundView = [UIView new];
        backgroundView.backgroundColor = kColorRGB(249, 249, 249, 1);
        backgroundView.layer.cornerRadius = kFit(10);
        backgroundView.layer.masksToBounds = YES;
        [self addSubview:backgroundView];
        backgroundView.sd_layout.leftSpaceToView(self, kFit(10)).rightSpaceToView(self, kFit(10)).heightIs(kFit(115)).bottomSpaceToView(cancelBtn, kFit(7));
        
        UIButton * photoAlbumBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [photoAlbumBtn setTitleColor:kColorRGB(0, 98, 255, 1) forState:(UIControlStateNormal)];
        [photoAlbumBtn setTitle:@"" forState:(UIControlStateNormal)];
        [photoAlbumBtn setTitleColor:kColorRGB(0, 98, 255, 1) forState:(UIControlStateHighlighted)];
        photoAlbumBtn.titleLabel.font = MFont(kFit(20));
        photoAlbumBtn.backgroundColor = kColorRGB(249, 249, 249, 1);
        photoAlbumBtn.tag = 100;
        self.photoAlbumBtn = photoAlbumBtn;
        [backgroundView addSubview:photoAlbumBtn];
        [photoAlbumBtn addTarget:self action:@selector(handleClick:) forControlEvents:(UIControlEventTouchUpInside)];
        photoAlbumBtn.sd_layout.leftSpaceToView(backgroundView, 0).topSpaceToView(backgroundView, 0).rightSpaceToView(backgroundView, 0).heightIs(kFit(57));
        
        UILabel *_dividerLabel = [UILabel new];
        _dividerLabel.backgroundColor = kCellColorDivider;
        [backgroundView addSubview:_dividerLabel];
        _dividerLabel.sd_layout.leftSpaceToView(backgroundView, 0).topSpaceToView(photoAlbumBtn, 0).heightIs(kCellDividerHeight).rightSpaceToView(backgroundView, 0);
        
        UIButton * cameraBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [cameraBtn setTitleColor:kColorRGB(255, 0, 0, 1) forState:(UIControlStateNormal)];
        [cameraBtn setTitle:@"" forState:(UIControlStateNormal)];
        [cameraBtn setTitleColor:kColorRGB(255, 0, 0, 1) forState:(UIControlStateHighlighted)];
        cameraBtn.titleLabel.font = MFont(kFit(20));
        cameraBtn.backgroundColor = kColorRGB(249, 249, 249, 1);
        cameraBtn.tag = 101;
        [cameraBtn addTarget:self action:@selector(handleClick:) forControlEvents:(UIControlEventTouchUpInside)];
        self.cameraBtn = cameraBtn;
        [backgroundView addSubview:cameraBtn];
        cameraBtn.sd_layout.leftSpaceToView(backgroundView, 0).topSpaceToView(_dividerLabel, 0).rightSpaceToView(backgroundView, 0).heightIs(kFit(57));
    }
    return self;
}

- (void)handleClick:(UIButton *)sender {
    
    self.chooseBlock(sender.tag - 100);
    
}

- (void)actionWithTitles:(NSArray *)titles {
    
    if (titles.count <3) {
        NSLog(@"DJCustomPopupWindow *** 传入的数组必须等于三位");
        return;
    }
    [self.photoAlbumBtn setTitle:titles[0] forState:(UIControlStateNormal)];
    [self.cameraBtn setTitle:titles[1] forState:(UIControlStateNormal)];
    [self.cancelBtn setTitle:titles[2] forState:(UIControlStateNormal)];
    
}

@end
