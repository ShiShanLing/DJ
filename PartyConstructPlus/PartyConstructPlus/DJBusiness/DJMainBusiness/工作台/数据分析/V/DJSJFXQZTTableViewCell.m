//
//  DJSJFXQZTTableViewCell.m
//  数据分析实现
//
//  Created by 石山岭 on 2018/9/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJSJFXQZTTableViewCell.h"

@interface DJSJFXQZTTableViewCell ()
/**
 行事历
 */
@property (nonatomic, strong)YTLPieView *XSLPieView;
/**
 交办
 */
@property (nonatomic, strong)YTLPieView *JBPieView;

@end

@implementation DJSJFXQZTTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
//        UILabel * titleLabel = [UILabel new];
//        titleLabel.text = @"单位 ( 个 )";
//        titleLabel.font = MFont(kFit(14));
//
//        titleLabel.textColor = kColorRGB(136, 136, 136, 1);
//        [self.contentView addSubview:titleLabel];
//        titleLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).rightSpaceToView(self.contentView, kFit(15)).heightIs(kFit(15)).topSpaceToView(self.contentView, 0);
        
        UILabel *fiveLabel = [UILabel new];
        fiveLabel.text = @"未完成";
        fiveLabel.textColor = kColorRGB(136, 136, 136, 1);
        fiveLabel.font = MFont(kFit(13));
        [self.contentView addSubview:fiveLabel];
        fiveLabel.sd_layout.rightSpaceToView(self.contentView, kFit(15)).topSpaceToView(self.contentView, 0).heightIs(kFit(15)).widthIs(kFit(50));
        
        UILabel *sixLabel = [UILabel new];
        sixLabel.backgroundColor = kColorRGB(30,139,223, 1);
        [self.contentView addSubview:sixLabel];
        sixLabel.sd_layout.rightSpaceToView(fiveLabel, kFit(5)).topSpaceToView(self.contentView, 0).widthIs(kFit(15)).heightIs(kFit(15));
        
        UILabel *oneLabel = [UILabel new];
        oneLabel.text = @"补办完成";
        oneLabel.textColor = kColorRGB(136, 136, 136, 1);
        oneLabel.font = MFont(kFit(13));
        [self.contentView addSubview:oneLabel];
        oneLabel.sd_layout.rightSpaceToView(sixLabel, kFit(10)).topSpaceToView(self.contentView, 0).heightIs(kFit(15)).widthIs(kFit(55));
        
        UILabel *twoLabel = [UILabel new];
        twoLabel.backgroundColor = kColorRGB(248, 229, 138, 1);
        [self.contentView addSubview:twoLabel];
        twoLabel.sd_layout.rightSpaceToView(oneLabel, kFit(5)).topSpaceToView(self.contentView, 0).widthIs(kFit(15)).heightIs(kFit(15));
        
        UILabel *threeLabel = [UILabel new];
        threeLabel.text = @"准时完成";
        threeLabel.textColor = kColorRGB(136, 136, 136, 1);
        threeLabel.font = MFont(kFit(13));
        [self.contentView addSubview:threeLabel];
        threeLabel.sd_layout.rightSpaceToView(twoLabel, kFit(10)).topSpaceToView(self.contentView, 0).heightIs(kFit(15)).widthIs(kFit(65));
        
        UILabel *fourLabel = [UILabel new];
        fourLabel.backgroundColor = kColorRGB(0, 231, 179, 1);
        [self.contentView addSubview:fourLabel];
        fourLabel.sd_layout.rightSpaceToView(threeLabel, kFit(5)).topSpaceToView(self.contentView, 0).widthIs(kFit(15)).heightIs(kFit(15));
        

        
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    

    
    NSString * XSLCompleteNum = [NSString stringWithFormat:@"%@", dataDic[@"implCompleteNum"]];
    NSString * XSLOutNum = [NSString stringWithFormat:@"%@", dataDic[@"implOutNum"]];
    NSString * XSLUndoNum = [NSString stringWithFormat:@"%@", dataDic[@"implUndoNum"]];
    NSMutableArray *XSLPercentageArray = [NSMutableArray array];//行事历百分比数组
    NSMutableArray *XSLColorArray = [NSMutableArray array];//行事历颜色数组
    NSMutableArray *XSLDataArray = [NSMutableArray array];//行事历展示数据数组
    NSString * XSLTitle;
    
    if ([XSLCompleteNum isEqualToString:@"0"]&&[XSLOutNum isEqualToString:@"0"]&&[XSLUndoNum isEqualToString:@"0"]) {
        [XSLPercentageArray addObject:@1];
        [XSLColorArray addObject:kColorRGB(177, 177, 177, 1)];
        [XSLDataArray addObject:@"隐藏"];
        XSLTitle = @"无行事历任务";
    }else {
        XSLTitle = @"行事历任务";
        if (![XSLOutNum isEqualToString:@"0"]) {
            [XSLPercentageArray addObject:@([XSLOutNum integerValue])];
            [XSLColorArray addObject: kColorRGB(248, 229, 138, 1)];
            [XSLDataArray addObject:XSLOutNum];
        }
        if (![XSLCompleteNum isEqualToString:@"0"]) {
            [XSLPercentageArray addObject:@([XSLCompleteNum integerValue])];
            [XSLColorArray addObject:kColorRGB(0, 231, 179, 1)];
            [XSLDataArray addObject:XSLCompleteNum];
        }
        
        if (![XSLUndoNum isEqualToString:@"0"]) {
            [XSLPercentageArray addObject:@([XSLUndoNum integerValue])];
            [XSLColorArray addObject:kColorRGB(30,139,223, 1)];
            [XSLDataArray addObject:XSLUndoNum];
        }
    }
    

    
    
    self.XSLPieView = [[YTLPieView alloc] initWithFrame:CGRectMake(1, 15, [UIScreen mainScreen].bounds.size.width/2-1.5, [UIScreen mainScreen].bounds.size.width/2-1.5)
                                              dataItems:XSLPercentageArray
                                             colorItems:XSLColorArray
                                            upTextItems:XSLDataArray
                                          downTextItems:nil];
    
    self.XSLPieView.titleStr = XSLTitle;
    if (self.XSLPieView) {
        _XSLPieView.isHiddenAnimation = YES;
    }else {
        _XSLPieView.isHiddenAnimation = NO;
    }
    [self.contentView addSubview:self.XSLPieView];
    
    
    NSString * JBCompleteNum = [NSString stringWithFormat:@"%@", dataDic[@"receiveCompleteNum"]];
    NSString * JBOutNum = [NSString stringWithFormat:@"%@", dataDic[@"receiveOutNum"]];
    NSString * JBUndoNum = [NSString stringWithFormat:@"%@", dataDic[@"receiveUndoNum"]];
    
    NSMutableArray *JBPercentageArray = [NSMutableArray array];//行事历百分比数组
    NSMutableArray *JBColorArray = [NSMutableArray array];//行事历颜色数组
    NSMutableArray *JBDataArray = [NSMutableArray array];//行事历展示数据数组
    NSString * JBTitle;
    if ([JBCompleteNum isEqualToString:@"0"]&&[JBOutNum isEqualToString:@"0"]&&[JBUndoNum isEqualToString:@"0"]) {
        [JBPercentageArray addObject:@1];
        [JBColorArray addObject:kColorRGB(177, 177, 177, 1)];
        [JBDataArray addObject:@"隐藏"];
        JBTitle = @"无交办任务";
    }else {
        JBTitle = @"交办任务";
        
        if (![JBOutNum isEqualToString:@"0"]) {
            [JBPercentageArray addObject:@([JBOutNum integerValue])];
            [JBColorArray addObject: kColorRGB(248, 229, 138, 1)];
            [JBDataArray addObject:JBOutNum];
        }
        
        if (![JBCompleteNum isEqualToString:@"0"]) {
            [JBPercentageArray addObject:@([JBCompleteNum integerValue])];
            [JBColorArray addObject:kColorRGB(0, 231, 179, 1)];
            [JBDataArray addObject:JBCompleteNum];
        }

        if (![JBUndoNum isEqualToString:@"0"]) {
            [JBPercentageArray addObject:@([JBUndoNum integerValue])];
            [JBColorArray addObject:kColorRGB(30,139,223, 1)];
            [JBDataArray addObject:JBUndoNum];
        }
    }
    
    self.JBPieView = [[YTLPieView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-1.5, 15, [UIScreen mainScreen].bounds.size.width/2-1.5, [UIScreen mainScreen].bounds.size.width/2-1.5)
                                             dataItems:JBPercentageArray
                                            colorItems:JBColorArray
                                           upTextItems:JBDataArray
                                         downTextItems:nil];
    self.JBPieView.titleStr = JBTitle;
    if (self.JBPieView) {
        _JBPieView.isHiddenAnimation = YES;
    }else {
        _JBPieView.isHiddenAnimation = NO;
    }
    [self.contentView addSubview:self.JBPieView];
    
  

    
}


@end
