//
//  DJCustomModuleShowCVCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/30.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJCustomModuleShowCVCell.h"

@interface DJCustomModuleShowCVCell ()

/**
 图标
 */
@property(nonatomic, strong)UIImageView *iconImage;
/**
 *标题
 */
@property (nonatomic, strong)UILabel * titleLabel;


@end

@implementation DJCustomModuleShowCVCell


-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
  
        self.editorColorView = [[UIView alloc]init];
        _editorColorView.backgroundColor =kColorRGB(246, 246, 246, 1);
        [self.contentView addSubview:_editorColorView];
        _editorColorView.sd_layout.leftSpaceToView(self.contentView, kFit(7.5)).rightSpaceToView(self.contentView, kFit(7.5)).topSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 0);
        
        self.defaultImageView = [[UIImageView alloc] init];
        _defaultImageView.image = [UIImage imageNamed:@"DJ_module_emptyChoose"];
        [self.contentView addSubview:self.defaultImageView];
         self.defaultImageView.sd_layout.leftSpaceToView(self.contentView, kFit(7.5)).rightSpaceToView(self.contentView, kFit(7.5)).topSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 0);
        
        self.iconImage = [[UIImageView alloc] init];
        _iconImage.image = [UIImage imageNamed:@"DJAllModule"];
        
        [self.contentView addSubview:self.iconImage];
        _iconImage.sd_layout.leftSpaceToView(self.contentView, kFit(13.5)).topSpaceToView(self.contentView, kFit(19)).rightSpaceToView(self.contentView, kFit(13.5)).heightEqualToWidth();
        
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = 1;
        self.titleLabel.text = @"全部";
        _titleLabel.font = MFont(11.5);
        [self.contentView addSubview:self.titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(self.contentView, kFit(7.5)).rightSpaceToView(self.contentView, kFit(7.5)).bottomSpaceToView(self.contentView, kFit(12)).heightIs(kFit(12));
        
        
        self.editorStateBtn = [DJButton buttonWithType:(UIButtonTypeCustom)];
        [_editorStateBtn setImage:[UIImage imageNamed:@"DJ_module_add"] forState:(UIControlStateNormal)];
        [_editorStateBtn addTarget:self action:@selector(handleEditorStateBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:_editorStateBtn];
        _editorStateBtn.sd_layout.rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).widthIs(22).heightIs(27);
    }
    return self;
}

- (void)assignmentModel:(ShowcaseModel *)model indexPath:(NSIndexPath *)indexPath{
    self.editorStateBtn.indexPath = indexPath;
    
    NSArray *tempArray = (NSArray *)model.itemArray;
    
    if (indexPath.row == tempArray.count) {
        _editorColorView.hidden = YES;
        _iconImage.image = nil;
        _titleLabel.text = @"";
        _editorStateBtn.hidden = YES;
    }else {
        ConfigModuleModel *itmeModel = tempArray[indexPath.row];
        if (indexPath.row == 1) {
                NSLog(@"itmeModel%@", itmeModel);
        }
        
        self.itmeModel = itmeModel;
        self.titleLabel.text = itmeModel.moduleName;
        self.iconImage.backgroundColor = [UIColor clearColor];
        
        
        UIImageView *tempImage = [UIImageView new];
                    __weak __typeof(self) weakself= self;
        
        if ([itmeModel.moduleImage isURL]) {
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:itmeModel.moduleImage]  placeholderImage:[UIImage imageNamed:@"DJAllModule"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [UIView animateWithDuration:.5 animations:^{
                    
                }];
            }];
        }else {
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", itmeModel.dfsUrl, itmeModel.moduleImage]]  placeholderImage:[UIImage imageNamed:@"DJAllModule"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [UIView animateWithDuration:.5 animations:^{
                    
                }];
            }];
        }
        
      
        
        if ([itmeModel.isDefault isEqualToString:@"1"]) {
            [self.editorStateBtn setImage:[UIImage imageNamed:@"DJ_module_delete"] forState:(UIControlStateNormal)];
        }else {
            [self.editorStateBtn setImage:[UIImage imageNamed:@"DJ_module_add"] forState:(UIControlStateNormal)];
        }
    }
    
    
}

- (void)handleEditorStateBtn:(DJButton *)sender {
    if ([_delegate respondsToSelector:@selector(operationItmeIndexPath:cell:)]) {
        [_delegate operationItmeIndexPath:sender.indexPath cell:self];
    }
    
}

@end
