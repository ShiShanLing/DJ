//
//  DJLogoShowTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/22.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJLogoShowTableViewCell.h"

@implementation DJLogoShowTableViewCell

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
        UIImageView *logoShowImageView = [UIImageView new];
        logoShowImageView.image = [UIImage imageNamed:@"DJ_showLogo"];
        logoShowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:logoShowImageView];
        logoShowImageView.sd_layout.widthIs(kFit(225)).heightIs(kFit(130)).topSpaceToView(self.contentView, kFit(10)).centerXEqualToView(self.contentView);
        
        UILabel *AppNameAndVersion = [UILabel new];
        AppNameAndVersion.text = @"杭州党建责任V2.0.0";
        AppNameAndVersion.textAlignment = 1;
        AppNameAndVersion.textColor = kColorRGB(251, 89, 68, 1);
        AppNameAndVersion.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        [self.contentView addSubview:AppNameAndVersion];
        AppNameAndVersion.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).topSpaceToView(logoShowImageView, 3).heightIs(kFit(18));
        
        
    }
    return self;
}

@end
