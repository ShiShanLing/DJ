//
//  DJLearningTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJLearningTableViewCell.h"
#import "DJLearningView.h"

@interface DJLearningTableViewCell ()<DJLearningViewDelegete>
@property(nonatomic, strong)UILabel * titleLabel;

@end

@implementation DJLearningTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel =[[UILabel alloc] init];
        _titleLabel.text = @"党建应用";
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(17)];
        _titleLabel.textColor =kColorRGB(51, 51, 51, 1);
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(self.contentView, kFit(20)).topSpaceToView(self.contentView, kFit(25)).widthIs(kFit(120)).heightIs(kFit(17));
        [_titleLabel updateLayout];
        
        UIView *bottomView = [[UIView alloc] init];
        //bottomView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:bottomView];
        bottomView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(_titleLabel,0).rightSpaceToView(self.contentView, 0).heightIs(kFit(205));
        //@[@{@"icon":@"DJ_dfjs", @"title":@"党费计算"},@{@"icon":@"DJ_cdyy", @"title":@"场地预约"}, @{@"icon":@"DJ_zmxf", @"title":@"最美先锋"},];
        NSArray *dataArray =@[@"DJ_dfjs",@"DJ_cdyy",@"DJ_zmxf" ];
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < 3; i++) {
            UIImageView *imageView = [UIImageView new];
            imageView.userInteractionEnabled = YES;
            imageView.tag = 100+i;
            imageView.image = [UIImage imageNamed:dataArray[i]];
            [bottomView addSubview:imageView];
            imageView.sd_layout.autoHeightRatio(kFit(83)/kFit(123));
            UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(handleSingleFingerEvent:)];
            singleFingerOne.numberOfTouchesRequired = 1; //手指数
            singleFingerOne.numberOfTapsRequired = 1; //tap次数
            singleFingerOne.delegate = self;
            [imageView addGestureRecognizer:singleFingerOne];
            
            [temp addObject:imageView];
        }
        
        // 关键步骤：设置类似collectionView的展示效果
        [bottomView setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:3 verticalMargin:kFit(12) horizontalMargin:kFit(-8) verticalEdgeInset:kFit(12) horizontalEdgeInset:kFit(12)];
        
        
    }
    return self;
}

- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(ClickLearningModule:)]) {
        [_delegate ClickLearningModule:tap.view.tag - 100];
    }
    
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
