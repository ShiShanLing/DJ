//
//  DJSJFXZTDRCYLTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/9/28.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJSJFXZTDRCYLTableViewCell.h"
#import "AAChartKit.h"

@interface DJSJFXZTDRCYLTableViewCell ( )<AAChartViewDidFinishLoadDelegate>

@property (nonatomic, strong) AAChartModel *aaChartModel;
@property (nonatomic, strong) AAChartView  *aaChartView;


@end
@implementation DJSJFXZTDRCYLTableViewCell

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
//        UILabel *unitLabel = [UILabel new];
//        unitLabel.text = @"单位 ( % )";
//        unitLabel.textColor = kColorRGB(69, 69, 69, 1);
//        unitLabel.font = MFont(kFit(13));
//        [self.contentView addSubview:unitLabel];
//        unitLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(self.contentView, kFit(15)).widthIs(kFit(100)).heightIs(kFit(15));
        self.aaChartView = [[AAChartView alloc]init];
        self.aaChartView.frame = CGRectMake(0, 70, kScreenWidth, 230);
        self.aaChartView.delegate = self;
        self.aaChartView.scrollEnabled = NO;//禁用 AAChartView 滚动效果
        
        [self.contentView addSubview:self.aaChartView];
        
    }
    return self;
}
- (void)setChartType:(DJSJFXZTDRCYLTableViewCellChartType)chartType {
    AAChartType tempChartType;
    switch (chartType) {
        case 0:
            tempChartType = AAChartTypeColumn;
            break;
        case 1:
            tempChartType = AAChartTypeBar;
            break;
        case 2:
            tempChartType = AAChartTypeArea;
            break;
        case 3:
            tempChartType = AAChartTypeAreaspline;
            break;
        case 4:
            tempChartType = AAChartTypeLine;
            break;
        case 5:
            tempChartType = AAChartTypeSpline;
            break;
        case 6:
            tempChartType = AAChartTypeLine;
            break;
        case 7:
            tempChartType = AAChartTypeArea;
            break;
        case 8:
            tempChartType = AAChartTypeScatter;
            break;
        default:
            break;
    }
    _aaChartModel.chartType = tempChartType;
    
}
- (void)setUpTheAAChartViewWithChartType:(AAChartType)chartType dataType:(NSInteger)dataType dataArray:(NSArray *)dataArray{
    NSLog(@"self.dataArray%@", dataArray);
    
    NSMutableArray *completeArray = [NSMutableArray array];//已完成
    NSDictionary *tempDic;
    NSString *timeStr;
    if (dataArray.count !=0) {
        tempDic = dataArray[0];
        timeStr = [[NSString stringWithFormat:@"%@", tempDic[@"day"]] substringFromIndex:5];
    }else {
        timeStr = @"12";
    }
    NSLog(@"timeStr%@", timeStr);
    for (int i =  0; i < timeStr.intValue-1; i ++) {
        [completeArray addObject:@0];

    }
    for (int i = 0 ; i < dataArray.count; i ++) {
        NSDictionary *dataDic = dataArray[i];
        CGFloat CompleteNum;

        CompleteNum = [[NSString stringWithFormat:@"%@", dataDic[@"joinRate"]] floatValue];
        [completeArray addObject:[NSNumber numberWithFloat:CompleteNum*100]];
    }
    
    for (int i = 0; i < 13 - completeArray.count; i ++) {
        [completeArray addObject:@0];
    }
    
    //设置 AAChartView 的背景色是否为透明
    self.aaChartView.isClearBackgroundColor = YES;
    
    self.aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(chartType)//图表类型
    .titleSet(@"")//图表主标题
    .subtitleSet(@"")//图表副标题
    .yAxisLineWidthSet(@1)//Y轴轴线线宽为0即是隐藏Y轴轴线
    .colorsThemeSet(@[@"#58D6B4",@"#FFB35E",@"#1E8BDF"])//设置主体颜色数组
    .yAxisTitleSet(@"")//设置 Y 轴标题
    .tooltipValueSuffixSet(@"")//设置浮动提示框单位后缀
    .backgroundColorSet(@"#4b2b7f")
    .yAxisGridLineWidthSet(@0.5)//y轴横向分割线宽度为0(即是隐藏分割线)
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(@"主题党日月参与率")
                 .dataSet(completeArray),
                 ]
               ).categoriesSet(@[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"]).xAxisGridLineWidthSet(@0.5);
    _aaChartModel.symbolStyle = AAChartSymbolStyleTypeBorderBlank;//设置折线连接点样式为:边缘白色
    _aaChartModel.xAxisCrosshairWidth = @1;//Zero width to disable crosshair by default
    _aaChartModel.xAxisCrosshairColor = @"#778899";//浅石板灰准星线
    _aaChartModel.xAxisCrosshairDashStyleType = AALineDashSyleTypeLongDashDotDot;
    //    _aaChartModel.markerRadius = @0;//是否有转接点
    _aaChartModel.legendEnabled = NO;
    _aaChartModel.dataLabelEnabled = YES;
    
    _aaChartModel.symbol = AAChartSymbolTypeCircle;//转接点
    [self.aaChartView aa_drawChartWithChartModel:_aaChartModel];
}
#pragma mark -- AAChartView delegate
- (void)AAChartViewDidFinishLoad {
    NSLog(@"🔥🔥🔥🔥🔥 AAChartView content did finish load!!!");
}

- (void)createChartviewDataType:(NSInteger)dataType dataArray:(NSArray *)dataArray {
    
    AAChartType chartType = AAChartTypeLine;
    [self setUpTheAAChartViewWithChartType:chartType dataType:dataType dataArray:dataArray];
    
}


@end
