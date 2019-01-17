//
//  DJNoOrgTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/9.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJNoOrgTableViewCell.h"

@implementation DJNoOrgTableViewCell

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
  
        UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(132))];
        promptLabel.textColor =  kColorRGB(173, 173, 173, 1);
        promptLabel.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:promptLabel];
        promptLabel.numberOfLines = 0;
        promptLabel.font =MFont(17);
        NSString *prompStr = @"向组织管理员要取邀请码, \n加入新的组织以更好地使用杭州党建\napp的各项功能哦!";
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:prompStr];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [prompStr length])];
        [promptLabel setAttributedText:attributedString1];
        promptLabel.textAlignment = 1;
        
        
    }
    return self;
}
@end
