//
//  DJUserDataShowTVCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/8.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJUserDataShowTVCell.h"

@interface DJUserDataShowTVCell ()

@property(nonatomic, strong)UILabel *titleLabel;

@property(nonatomic, strong)UILabel *dataLabel;

@end


@implementation DJUserDataShowTVCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel =[[UILabel alloc] init];
        _titleLabel.textColor = kColorRGB(136, 136, 136, 1);
        _titleLabel.font = MFont(kFit(16));
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).heightIs(kFit(15)).centerYEqualToView(self.contentView).widthIs(kFit(61));
        
        self.dataLabel = [[UILabel alloc] init];
        _dataLabel.textColor = kColorRGB(51, 51, 51, 1);
        _dataLabel.font = MFont(kFit(16));
        [self.contentView addSubview:_dataLabel];
        _dataLabel.sd_layout.leftSpaceToView(_titleLabel, 0).heightIs(kFit(15)).centerYEqualToView(self.contentView).rightSpaceToView(self.contentView, kFit(15));
        
        self.segmentationLabel = [[UILabel alloc]init];
        _segmentationLabel.backgroundColor = kCellColorDivider;
        [self.contentView addSubview:_segmentationLabel];
        _segmentationLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).bottomSpaceToView(self.contentView, 0).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic {
    _titleLabel.text = dataDic[@"title"];
    _dataLabel.text = dataDic[@"data"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
