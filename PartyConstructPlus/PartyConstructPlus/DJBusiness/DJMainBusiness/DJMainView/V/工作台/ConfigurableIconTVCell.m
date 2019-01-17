//
//  ConfigurableIconTVCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "ConfigurableIconTVCell.h"
#import "ConfigurableIconVIew.h"

@interface ConfigurableIconTVCell()  <ConfigurableIconVIewDelegate>

@property (nonatomic, strong)NSMutableArray<ConfigurableIconVIew *> *tempArray;

/**
 *
 */
@property (nonatomic, strong)UIView *bottomView;

@end

@implementation ConfigurableIconTVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"工作台";
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(17)];
        titleLabel.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [self.contentView addSubview:titleLabel];
        titleLabel.sd_layout.leftSpaceToView(self.contentView, 10+kFit(10)).topSpaceToView(self.contentView, kFit(25)).widthIs(100).heightIs(kFit(17));
        
        self.bottomView = [[UIView alloc] init];
//        _bottomView.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_bottomView];
        _bottomView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(titleLabel, kFit(15)).rightSpaceToView(self.contentView, 0);
        
//     X +1 =  (n-1)/4
        
        [_bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSArray *tempArray = @[@"", @"", @"", @"",@"",@"", @"", @"",@"",@"", @"", @""];
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < tempArray.count; i++) {
            ConfigurableIconVIew *view = [ConfigurableIconVIew new];
//            view.backgroundColor = [UIColor redColor];
            view.hidden = YES;
            view.tag = 100+i;
            view.titleLabel.text = tempArray[i];
            view.delegate = self;
            [_bottomView addSubview:view];
            view.sd_layout.autoHeightRatio(1.36);
            [temp addObject:view];
      
        }
        self.tempArray = [NSMutableArray arrayWithArray:temp];
        // 关键步骤：设置类似collectionView的展示效果
        
        [_bottomView setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:4 verticalMargin:0 horizontalMargin:kFit(31) verticalEdgeInset:0 horizontalEdgeInset:11];
        [_bottomView updateLayout];
    }
    return self;
}

- (void)ClickConfigurableIcon:(ConfigurableIconVIew *)view {
    
    if ([_delegate respondsToSelector:@selector(ClickFunctionModuleIndex:)]) {
        [_delegate ClickFunctionModuleIndex:view.tag-100];
    }
}

- (void)setModelArray:(NSArray *)modelArray {
//    NSLog(@"modelArray%@", modelArray);
    if (modelArray.count == 0) {
        return;
    }
//    _bottomView.sd_layout.bottomSpaceToView(self.contentView, 0);
    for (int  i = 0; i < self.tempArray.count-1; i ++) {
        ConfigurableIconVIew *view = self.tempArray[i];
        if (i <= modelArray.count-1) {
                ConfigModuleModel *model = modelArray[i];
                view.hidden = NO;
                view.userInteractionEnabled = YES;
                view.titleLabel.text = model.moduleName;
                if ([model.moduleImage isURL]) {
                    
                    [view.iconImage sd_setImageWithURL:[NSURL URLWithString:model.moduleImage] placeholderImage:[UIImage imageNamed:@"DJAllModule"]];
                }else {
                    [view.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", model.dfsUrl, model.moduleImage]] placeholderImage:[UIImage imageNamed:@"DJAllModule"]];
                }
        }else if(i ==modelArray.count){
            view.hidden = NO;
            view.userInteractionEnabled = YES;
            view.iconImage.image = [UIImage imageNamed:@"DJAllModule"];
            view.titleLabel.text= @"全部";
        }else{
            view.hidden = YES;
        }
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
