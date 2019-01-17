//
//  DJSJFXRankingTableViewCell.m
//  数据分析实现
//
//  Created by 石山岭 on 2018/9/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJSJFXRankingTableViewCell.h"

@implementation DJSJFXRankingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *backgroundView = [UIView new];
        [self.contentView addSubview:backgroundView];
        backgroundView.backgroundColor = [UIColor whiteColor];
        backgroundView.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(self.contentView, kFit(15)).rightSpaceToView(self.contentView, kFit(15)).bottomSpaceToView(self.contentView, kFit(5));
        
        UILabel *titleOneLabel = [UILabel new];
        titleOneLabel.text = @"  完成任务数";
        titleOneLabel.textColor = kColorRGB(136, 136, 136, 1);
        
        titleOneLabel.font = MFont(kFit(13));
        [backgroundView addSubview:titleOneLabel];
        titleOneLabel.sd_layout.leftSpaceToView(backgroundView, 0.4).topSpaceToView(backgroundView, 0).rightSpaceToView(backgroundView, 0.4).heightIs(kFit(40));
        titleOneLabel.layer.borderWidth = 0.4;
        titleOneLabel.layer.borderColor = kColorRGB(136, 136, 13.6, 1).CGColor;
        
        UILabel *titleTwoLabel = [UILabel new];
        titleTwoLabel.text = @"  补办任务数";
        titleTwoLabel.textColor = kColorRGB(136, 136, 136, 1);
        titleTwoLabel.font = MFont(kFit(13));
        
        [backgroundView addSubview:titleTwoLabel];
        titleTwoLabel.sd_layout.leftSpaceToView(backgroundView, 0.4).topSpaceToView(titleOneLabel, -0.4).rightSpaceToView(backgroundView, 0.4).heightIs(kFit(40));
        titleTwoLabel.layer.borderWidth = 0.4;
        titleTwoLabel.layer.borderColor = kColorRGB(136, 136, 13.6, 1).CGColor;
        
        UILabel *titleThreeLabel = [UILabel new];
        titleThreeLabel.text = @"  成绩单积分";
        titleThreeLabel.textColor = kColorRGB(136, 136, 136, 1);
        
        titleThreeLabel.font = MFont(kFit(13));
        [backgroundView addSubview:titleThreeLabel];
        titleThreeLabel.sd_layout.leftSpaceToView(backgroundView, 0.4).topSpaceToView(titleTwoLabel, -0.4).rightSpaceToView(backgroundView, 0.4).heightIs(kFit(40));
        titleThreeLabel.layer.borderWidth = 0.4;
        titleThreeLabel.layer.borderColor = kColorRGB(136, 136, 13.6, 1).CGColor;
        
        self.completeTaskNum = [UILabel new];
        _completeTaskNum.text = @"排名 : --";
        _completeTaskNum.textColor = kColorRGB(136, 136, 136, 1);
//        _completeTaskNum.textAlignment = 2;
        _completeTaskNum.font = MFont(kFit(13));
        [backgroundView addSubview:_completeTaskNum];
        
        _completeTaskNum.sd_layout.rightSpaceToView(backgroundView, kFit(5)).centerYEqualToView(titleOneLabel).widthIs(kFit(100)).heightIs(kFit(14));
        
        self.fillDoTaskNum = [UILabel new];
        _fillDoTaskNum.text = @"排名 : --";
        _fillDoTaskNum.textColor = kColorRGB(136, 136, 136, 1);
        _fillDoTaskNum.font = MFont(kFit(13));
//        _fillDoTaskNum.textAlignment = 2;
        [backgroundView addSubview:_fillDoTaskNum];
        _fillDoTaskNum.sd_layout.rightSpaceToView(backgroundView, kFit(5)).centerYEqualToView(titleTwoLabel).widthIs(kFit(100)).heightIs(kFit(14));
        self.transcriptIntegral = [UILabel new];
        _transcriptIntegral.text = @"排名 : --";
        
        _transcriptIntegral.textColor = kColorRGB(136, 136, 136, 1);
        _transcriptIntegral.font = MFont(kFit(13));
//        _transcriptIntegral.textAlignment = 2;
        [backgroundView addSubview:_transcriptIntegral];
        _transcriptIntegral.sd_layout.rightSpaceToView(backgroundView, kFit(5)).centerYEqualToView(titleThreeLabel).widthIs(kFit(100)).heightIs(kFit(14));
    }
    return self;
}

@end
