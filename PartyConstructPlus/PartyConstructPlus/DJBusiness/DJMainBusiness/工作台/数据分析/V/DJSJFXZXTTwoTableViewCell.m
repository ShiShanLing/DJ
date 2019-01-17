//
//  DJSJFXZXTTwoTableViewCell.m
//  数据分析实现
//
//  Created by 石山岭 on 2018/9/12.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJSJFXZXTTwoTableViewCell.h"
#import "AAChartKit.h"

@interface DJSJFXZXTTwoTableViewCell ( )<AAChartViewDidFinishLoadDelegate>

@property (nonatomic, strong) AAChartModel *aaChartModel;
@property (nonatomic, strong) AAChartView  *aaChartView;


@end
@implementation DJSJFXZXTTwoTableViewCell

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
        self.aaChartView = [[AAChartView alloc]init];
        self.aaChartView.frame = CGRectMake(0, 0, kScreenWidth, 230);
        self.aaChartView.delegate = self;
        self.aaChartView.scrollEnabled = NO;//禁用 AAChartView 滚动效果
        [self.contentView addSubview:self.aaChartView];
    }
    return self;
}
- (void)ChartColor:(NSArray *)colors title:(BOOL)isShow dataType:(NSInteger)dataType dataArray:(NSArray *)dataArray {
    UIView *view = [self viewWithTag:101];
    view.backgroundColor = [self colorWithHexString:colors[0]];
    AAChartType chartType = AAChartTypeArea;
    [self setUpTheAAChartViewWithChartType:chartType Color:colors title:isShow dataType:dataType dataArray:dataArray];
}
- (void)setUpTheAAChartViewWithChartType:(AAChartType)chartType Color:(NSArray *)colors title:(BOOL)isShow  dataType:(NSInteger)dataType dataArray:(NSArray *)dataArray{
    
    NSString *nameStr;
    NSMutableArray *tempArray = [NSMutableArray array];//已完成
    NSString *timeStr ;
    NSDictionary *tempDic;
    if (dataArray.count !=0) {
        tempDic = dataArray[0];
        timeStr  = [[NSString stringWithFormat:@"%@", tempDic[@"day"]] substringFromIndex:5];
    }else {
        timeStr = @"12";
    }
    
    NSLog(@"timeStr%@", timeStr);
    for (int i =  0; i < timeStr.intValue-1; i ++) {
        [tempArray addObject:@0];
    }
    for (int i = 0 ; i < dataArray.count; i ++) {
        NSDictionary *dataDic = dataArray[i];
        NSString  * tempNum;
        
        if (dataType == 4) {
            nameStr = @"平均完成时间";
            tempNum = [NSString stringWithFormat:@"%@", dataDic[@"averageCompleteTime"]] ;
            if ([tempNum isEmpty]) {
                tempNum = [NSString stringWithFormat:@"%@", dataDic[@"averageTime"]] ;
            }
            NSLog(@"tempNum%@", tempNum);
        }else {
            nameStr = @"平均积分";
            tempNum = [NSString stringWithFormat:@"%@", dataDic[@"score"]];
            
        }
        
        if (tempNum.floatValue < 0) {
            tempNum = @"0";
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        [tempArray addObject:[formatter numberFromString:tempNum]];
        
    }
    
    for (int i = 0; i < 13-tempArray.count+1; i ++) {
        [tempArray addObject:[NSNumber numberWithFloat:0]];
    }
    
    //设置 AAChartView 的背景色是否为透明
    self.aaChartView.isClearBackgroundColor = YES;
    self.aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(chartType)//图表类型
    .titleSet(@"")//图表主标题
    .subtitleSet(@"")//图表副标题
    .yAxisLineWidthSet(@1)//Y轴轴线线宽为0即是隐藏Y轴轴线
    .colorsThemeSet(colors)//设置主体颜色数组
    .yAxisTitleSet(@"")//设置 Y 轴标题
    .tooltipValueSuffixSet(@"")//设置浮动提示框单位后缀
    .backgroundColorSet(@"#4b2b7f")
    .yAxisGridLineWidthSet(@0.5)//y轴横向分割线宽度为0(即是隐藏分割线)
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(nameStr)
                 .dataSet(tempArray),
                 ]
               ).categoriesSet(@[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"]).xAxisGridLineWidthSet(@0.5);
    
    _aaChartModel.symbolStyle = AAChartSymbolStyleTypeBorderBlank;//设置折线连接点样式为:边缘白色
    _aaChartModel.xAxisCrosshairWidth = @1;//Zero width to disable crosshair by default
    _aaChartModel.xAxisCrosshairColor = @"#778899";//浅石板灰准星线
    _aaChartModel.xAxisCrosshairDashStyleType = AALineDashSyleTypeLongDashDotDot;
    _aaChartModel.legendEnabled = NO;
    _aaChartModel.dataLabelEnabled = YES;
    _aaChartModel.symbol = AAChartSymbolTypeCircle;//转接点
    [self.aaChartView aa_drawChartWithChartModel:_aaChartModel];

}
#pragma mark -- AAChartView delegate
- (void)AAChartViewDidFinishLoad {
    NSLog(@"🔥🔥🔥🔥🔥 AAChartView content did finish load!!!");
}


- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
