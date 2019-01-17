//
//  DJTaskImageShowView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/6.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskImageShowView.h"

@interface DJTaskImageShowView ()
/**
 *任务上传状态
 */
@property (nonatomic, strong)UIImageView *stateImageView;
/**
 *
 */
@property (nonatomic, strong)UILabel  *stateLabel;

@end

@implementation DJTaskImageShowView

- (instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.showImageView  =  [[UIImageView alloc] init];
        _showImageView.image = [UIImage imageNamed:@"DJ_fbrw_AddImage"];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showImageView.userInteractionEnabled = YES;
        _showImageView.clipsToBounds = YES;
        _showImageView.backgroundColor = kColorRGB(237, 237, 237, 1);
        [self addSubview:_showImageView];
        _showImageView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, kFit(15)).rightSpaceToView(self, kFit(15)).heightEqualToWidth();
        
        self.imageNameLabel = [UILabel new];
        _imageNameLabel.backgroundColor  = [UIColor clearColor];
//        _imageNameLabel.text = @"IMG001";
        _imageNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(12)];
        _imageNameLabel.textColor = kColorRGB(51, 51, 51, 1);
        [self addSubview:_imageNameLabel];
        _imageNameLabel.sd_layout.leftEqualToView(_showImageView).topSpaceToView(_showImageView, kFit(10)).rightEqualToView(_showImageView).heightIs(kFit(13));
        
        self.imageSizeLabel = [UILabel new];
//        _imageSizeLabel.text = @"1.23M";
        _imageSizeLabel.backgroundColor = [UIColor clearColor];
        _imageSizeLabel.textColor = kColorRGB(173, 173, 173, 1);
        _imageSizeLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(12)];
        [self addSubview:_imageSizeLabel];
    _imageSizeLabel.sd_layout.leftEqualToView(_showImageView).rightEqualToView(_showImageView).topSpaceToView(_imageNameLabel, kFit(5)).heightIs(kFit(13));
        
        self.deleteBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_deleteBtn setImage:[UIImage imageNamed:@"DJ_delete"] forState:(UIControlStateNormal)];
        _deleteBtn.hidden = YES;
        [_deleteBtn addTarget:self action:@selector(handleSeleteBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_deleteBtn];
        _deleteBtn.sd_layout.rightSpaceToView(self, 0).topSpaceToView(self, 0).widthIs(34).heightIs(34);
        
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleSingleFingerEvent)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        
        [self addGestureRecognizer:singleFingerOne];
        
        self.stateImageView = [UIImageView new];
        [_showImageView addSubview:_stateImageView];
        
        _stateImageView.sd_layout.leftSpaceToView(_showImageView, 0).topSpaceToView(_showImageView, 0).rightSpaceToView(_showImageView, 0).bottomSpaceToView(_showImageView, 0);
        self.stateLabel = [UILabel new];
        _stateLabel.textColor = kColorRGB(255, 255, 255, 1);
        _stateLabel.font = MFont(kFit(15));
        _stateLabel.textAlignment = 1;
        
        [_showImageView addSubview:_stateLabel];
        _stateLabel.sd_layout.leftSpaceToView(_showImageView, 0).topSpaceToView(_showImageView, 0).rightSpaceToView(_showImageView, 0).bottomSpaceToView(_showImageView, 0);
    }
    return self;
}

- (void)handleSeleteBtn  {
    
    if ([_delegate respondsToSelector:@selector(deletelImage:)]) {
        [_delegate deletelImage:self];
    }
}
- (void)handleSingleFingerEvent {
    
    if ([_delegate respondsToSelector:@selector(ClickSelf:)]) {
        [_delegate ClickSelf:self];
    }
}

- (void)setState:(DJTaskImagShowType)state {
    switch (state) {
        case DJTaskImagShowAreUploading:
            _stateImageView.backgroundColor = [UIColor blackColor];
            _stateImageView.alpha = 0.6;
            _stateLabel.text = @"正在上传";
            break;
        case DJTaskImagShowUploadSucce:
            _stateImageView.hidden = YES;
            _stateLabel.hidden = YES;
            break;
        case DJTaskImagShowUploadFailed:
            _stateImageView.image = [UIImage imageNamed:@"DJ_image_upload_failed"];
            _stateImageView.alpha = 1.0;
            _stateLabel.text = @"";
            break;
        case DJTaskImagShowNoImage:
            _stateImageView.hidden = YES;
            _stateLabel.hidden = YES;
          
            break;
            
        default:
            break;
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
