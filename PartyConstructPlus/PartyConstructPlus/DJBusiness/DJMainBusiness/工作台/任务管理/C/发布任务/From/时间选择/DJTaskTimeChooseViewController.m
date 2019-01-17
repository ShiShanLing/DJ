//
//  DJTaskTimeChooseViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/28.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskTimeChooseViewController.h"
#import "GFCalendar.h"
#import "DJTaskReleaseCalendarSelectView.h"
#import "DJCalendarTimeShowHeadView.h"

@interface DJTaskTimeChooseViewController () <DJCalendarTimeShowHeadViewDelegate>
@property (nonatomic, strong)CAGradientLayer *gradientLayer;
/**
 *
 */
@property (nonatomic, strong)DJCalendarTimeShowHeadView *headView;
/**
 *
 */
@property (nonatomic, strong)DJTaskReleaseCalendarSelectView *calendar;
/**
 *开始时间和结束时间展示并选择的label
 */
@property (nonatomic, strong)UILabel * hoursShowLabel;
/**
 *显示用户选择时间的类型
 */
@property (nonatomic, strong)UILabel * timeTypeShowLabel;

@end

@implementation DJTaskTimeChooseViewController {
    
    
    CGFloat  naVigationHeight;
    NSInteger  editState;//记录编辑时间的状态  是 0 编辑开始时间 startTime  1 为编辑结束时间endTime
    //后台需要的数据
    NSString *startDate;//任务开始日期 格式 yyyy-MM-dd
    NSString *endDate;//任务结束日期 格式 yyyy-MM-dd
    NSString *startTime;//任务开始时间 格式 HH:mm:ss
    NSString *endTime;//任务结束时间 格式 HH:mm:ss
    //界面需要的数据
    NSString *viewStartDate;//任务开始日期 格式 yyyy-MM-dd
    NSString *viewEndDate;//任务结束日期 格式 yyyy-MM-dd
    NSString *viewStartTime;//任务开始时间 格式 HH:mm:ss
    NSString *viewEndTime;//任务结束时间 格式 HH:mm:ss
}

- (void)handleRightConfirmBtn {
    
    if (startDate.length == 0 || startDate == NULL) {
        [self ShowWarningHud:@"请先选择任务开始时间"];
        return;
    }
    if (endDate.length == 0 || startDate == NULL) {
        [self ShowWarningHud:@"请选择任务结束时间"];
        return;
    }
    NSLog(@"开始时间%@ 结束时间%@", [NSString stringWithFormat:@"%@ %@", startDate, startTime], [NSString stringWithFormat:@"%@ %@", endDate, endTime]);
    
    self.returnTime([NSString stringWithFormat:@"%@ %@", startDate, startTime], [NSString stringWithFormat:@"%@ %@", endDate, endTime]);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = kColorRGB(246, 246, 246, 1);

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UIButton *leftSidebarBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [leftSidebarBtn setImage:[UIImage imageNamed:@"DJWhiteReturn"] forState:(UIControlStateNormal)];
        [leftSidebarBtn addTarget:self action:@selector(handleLeftSidebarBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:leftSidebarBtn];
    leftSidebarBtn.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 20+naVigationHeight).heightIs(43).widthIs(43);
    
    UIButton *rightConfirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [rightConfirmBtn setTitle:@"确认" forState:(UIControlStateNormal)];
    [rightConfirmBtn  setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    rightConfirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightConfirmBtn addTarget:self action:@selector(handleRightConfirmBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rightConfirmBtn];
    rightConfirmBtn.sd_layout.rightSpaceToView(self.view, 8).topSpaceToView(self.view, 20+naVigationHeight).heightIs(43).widthIs(43);
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"选择时间";
    titleLabel.textAlignment = 1;
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [self.view addSubview:titleLabel];
    titleLabel.sd_layout.widthIs(200).heightIs(17).topSpaceToView(self.view, 32+naVigationHeight).centerXEqualToView(self.view);
}
- (void)handleLeftSidebarBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    naVigationHeight =  kXNavigationBarExtraHeight;
    // Do any additional setup after loading the view.
    self.title = @"选择时间";
    NSLog(@"kScreenHeight%f", kScreenHeight);
    self.headView = [[DJCalendarTimeShowHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (130+naVigationHeight))];
    

    _headView.delegate = self;
    [self.view addSubview:_headView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupDJCalendar];
    
    UIView *hoursChooseView = [[UIView alloc] initWithFrame:CGRectMake(0, [_calendar getCalendarViewHeight] + 130+naVigationHeight + 5, kScreenWidth, 50)];
    hoursChooseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:hoursChooseView];
    
    UIButton *pointToBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    pointToBtn.userInteractionEnabled = NO;
    [pointToBtn setImage:[UIImage imageNamed:@"DJRegistrationRight"] forState:(UIControlStateNormal)];
    [hoursChooseView addSubview:pointToBtn];
    pointToBtn.sd_layout.rightSpaceToView(hoursChooseView, 0).topSpaceToView(hoursChooseView, 0).bottomSpaceToView(hoursChooseView, 0).widthIs(40);
    
    self.timeTypeShowLabel = [UILabel new];
    _timeTypeShowLabel.textColor = kColorRGB(51, 51, 51, 1);
    _timeTypeShowLabel.text = @"时间";
    _timeTypeShowLabel.userInteractionEnabled = YES;
    _timeTypeShowLabel.textAlignment = 0;
    _timeTypeShowLabel.font = MFont(kFit(16));
    [hoursChooseView addSubview:_timeTypeShowLabel];
    _timeTypeShowLabel.sd_layout.leftSpaceToView(hoursChooseView, 15).topSpaceToView(hoursChooseView, 0).bottomSpaceToView(hoursChooseView, 0).widthIs(kFit(85));
    
    self.hoursShowLabel = [UILabel new];
    _hoursShowLabel.textColor = kColorRGB(51, 51, 51, 1);
    _hoursShowLabel.text = @"";
    _hoursShowLabel.userInteractionEnabled = YES;
    _hoursShowLabel.textAlignment = 2;
    _hoursShowLabel.font = MFont(kFit(16));
    [hoursChooseView addSubview:_hoursShowLabel];
    _hoursShowLabel.sd_layout.rightSpaceToView(pointToBtn, 5).topSpaceToView(hoursChooseView, 0).bottomSpaceToView(hoursChooseView, 0).leftSpaceToView(_timeTypeShowLabel, 0);
    
    
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleFingerEvent)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    
    
    [hoursChooseView addGestureRecognizer:singleFingerOne];

    

    
    viewStartDate = @"";
    viewStartTime = @"";
    viewEndDate = @"";
    viewEndTime = @"";
    editState =100;
    if (self.startDefaultDate != nil) {
        [self.headView show];
        startDate = [NSDate dateString:self.startDefaultDate format:@"yyyy-MM-dd"];
        endDate=[NSDate dateString:self.endDefaultDate format:@"yyyy-MM-dd"];
        startTime = [NSDate dateString:self.startDefaultDate format:@"HH:mm:ss"];
        endTime=[NSDate dateString:self.endDefaultDate format:@"HH:mm:ss"];
        
        viewStartDate = [NSDate dateString:self.startDefaultDate format:@"MM月dd日"];//界面使用的时间字符串
        viewEndDate=[NSDate dateString:self.endDefaultDate format:@"MM月dd日"];//界面使用的时间字符串
        viewStartTime = [NSDate dateString:self.startDefaultDate format:@"HH:mm"];//界面使用的时间字符串
        viewEndTime=[NSDate dateString:self.endDefaultDate format:@"HH:mm"];//界面使用的时间字符串
        editState = 0;
        [self refreshViewData];
    }else {
        startDate = @"";
        endDate = @"";
        startTime = @"";
        endTime = @"";
    }

}

- (void)handleSingleFingerEvent {
    
    if (startTime.length == 0) {
        [self  ShowWarningHud:@"请先选择日期"];
        return;
    }
    
    NSString *chooseBeforeHourStr=@"";
    NSString *chooseBeforeMinuteStr=@"";
    
    switch (editState) {
        case 0: {
            NSArray *timeArray = [startTime componentsSeparatedByString:@":"];
            chooseBeforeHourStr = timeArray[0];
            chooseBeforeMinuteStr = timeArray[1];
        }
            break;
        case 1:{
            NSArray *timeArray = [endTime componentsSeparatedByString:@":"];
            chooseBeforeHourStr = timeArray[0];
            chooseBeforeMinuteStr = timeArray[1];
        }
            break;
        default:
            break;
    }
    
    
    
    NSArray *totalTimeArray = @[@[@"00",@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",],@[@"00",@"10", @"20", @"30", @"40",  @"50", ],];
    NSString *hourIndex=@"";
    NSString *minuteIndex=@"";

    for (int i= 0; i<totalTimeArray.count; i++) {
        NSArray *tempArray= totalTimeArray[i];
        for (int j= 0; j < tempArray.count; j++) {
            NSString *tempStr = tempArray[j];
            if (i == 0) {
                if ([chooseBeforeHourStr isEqualToString:tempStr]) {
                    hourIndex = [NSString stringWithFormat:@"%d", j];
                }
            }
            if (i == 1) {
                if ([chooseBeforeMinuteStr isEqualToString:tempStr]) {
                    minuteIndex = [NSString stringWithFormat:@"%d", j];
                }
            }
        }
    }
    __weak DJTaskTimeChooseViewController *selfWeak = self;
    NSLog(@"hourIndex%@ minuteIndex%@", hourIndex, minuteIndex);
    __block  SMKPickerView *smkPickerView = [SMKPickerView SMKPickerMoreComponent:totalTimeArray withHeadTitle:@"calendar" defaultIndex:@[hourIndex, minuteIndex] withCall:^(NSString *choiceString) {
        
        NSLog(@"choiceString%@", choiceString);
        //界面需要的time字符串
        NSString *viewTimeStr;
        
        NSString *choiceAfterHourStr;
        NSString *choiceAfterMinuteStr;
        switch (editState) {
            case 0: {
                NSArray *timeArray = [choiceString componentsSeparatedByString:@","];
                choiceAfterHourStr = timeArray[0];
                choiceAfterMinuteStr = timeArray[1];
                
                NSString *start = [NSString stringWithFormat:@"%@ %@:%@", startDate, choiceAfterHourStr, choiceAfterMinuteStr];
                NSDate *tempDate = [NSDate stringToDate:start format:@"yyyy-MM-dd HH:mm"];
                NSString *starttime = [NSDate dateString:tempDate format:@"yyyyMMddHHmm"];
                NSString *currenttime = [NSDate dateString:[NSDate date] format:@"yyyyMMddHHmm"];
                if ([starttime integerValue] < [currenttime integerValue]) {
                     [self ShowWarningHudMid:@"任务开始时间不能早于当前时间!"];
                    return ;
                }
                
                NSString *endStr = [NSString stringWithFormat:@"%@ %@", endDate, endTime];
                NSDate * endTempDate = [NSDate stringToDate:endStr format:@"yyyy-MM-dd HH:mm:ss"];
                NSString *endTempTime = [NSDate dateString:endTempDate format:@"yyyyMMddHHmm"];
                if ([starttime integerValue] > [endTempTime integerValue] && ![endTime isEmpty]) {
                    NSLog(@"starttime%@endTime%@endStr%@", starttime, endTime, endStr);
                    [self ShowWarningHudMid:@"任务截止时间不能早于开始时间!"];
                    return;
                }
                
                startTime = [NSString  stringWithFormat:@"%@:%@:00", choiceAfterHourStr, choiceAfterMinuteStr];
                viewStartTime = [NSString  stringWithFormat:@"%@:%@", choiceAfterHourStr, choiceAfterMinuteStr];
            }
                break;
            case 1:{
                NSArray *timeArray = [choiceString componentsSeparatedByString:@","];
                choiceAfterHourStr = timeArray[0];
                choiceAfterMinuteStr = timeArray[1];
                NSString *startStr = [NSString stringWithFormat:@"%@ %@", startDate, startTime];
                NSDate *tempStartDate = [NSDate stringToDate:startStr format:@"yyyy-MM-dd HH:mm:ss"];
                NSString *startTempTime = [NSDate dateString:tempStartDate format:@"yyyyMMddHHmm"];
                NSString *endStr = [NSString stringWithFormat:@"%@ %@:%@",endDate, choiceAfterHourStr, choiceAfterMinuteStr];
                NSDate *tempEndDate = [NSDate stringToDate:endStr format:@"yyyy-MM-dd HH:mm"];
                NSString *endTempTime = [NSDate dateString:tempEndDate format:@"yyyyMMddHHmm"];
                NSLog(@"startTime %@ endTime %@", startTime, endTime);
                if ([startTempTime integerValue] > [endTempTime integerValue]) {
                    
                    [self ShowWarningHudMid:@"任务截止时间不能早于开始时间!"];
                    return ;
                }
                endTime = [NSString  stringWithFormat:@"%@:%@:00", choiceAfterHourStr, choiceAfterMinuteStr];
                
                viewEndTime = [NSString  stringWithFormat:@"%@:%@", choiceAfterHourStr, choiceAfterMinuteStr];
                NSLog(@"啦啦啦啦啦啦啦啦endTime%@ viewEndTime%@", endTime, viewEndTime);
            }
                break;
            default:
                break;
        }
        [selfWeak refreshViewData];
        [smkPickerView dismissPicker];
    }];
    [smkPickerView show];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupDJCalendar {
    
    //当前时间 时分
    NSInteger hour= [NSDate getCurrentHour];
    if (hour == 23) {
        
    }else {
        hour+=1;
    }
    NSString *taskDefaultHour;
    if (hour < 10) {
        taskDefaultHour = [NSString stringWithFormat:@"0%ld:00", hour];
    }else {
        taskDefaultHour = [NSString stringWithFormat:@"%ld:00", hour];
    }
    
    NSInteger width = self.view.bounds.size.width+5;
    CGPoint origin = CGPointMake(0, 130+naVigationHeight);
    
    self.calendar =[[DJTaskReleaseCalendarSelectView alloc] initWithFrameOrigin:origin width:width];
    self.calendar.startDefaultDate = self.startDefaultDate;
    self.calendar.endDefaultDate = self.endDefaultDate;
    NSLog(@"_calendar.startDefaultDate%@ self.startDefaultDate%@", _calendar.startDefaultDate, self.startDefaultDate);
    
    
    
    // 点击某一天的回调
    __weak  DJTaskTimeChooseViewController *selfWeak =self;
    _calendar.didSelectDayHandler = ^(NSDate *chooseDate) {
        NSString *tempTimeStr = [NSDate dateString:chooseDate format:@"yyyy-MM-dd"];//传给后台时需要的时间字符串
        
        NSString *timeStr = [NSDate dateString:chooseDate format:@"MM月dd日"];//界面使用的时间字符串
        [selfWeak.headView show];//把时间显示控件显示出来
        if (startDate.length == 0) {//如果开始时间为空
            editState = 0;

            startDate = tempTimeStr;
            startTime = [NSString stringWithFormat:@"%@:00", taskDefaultHour];
            viewStartDate = timeStr;
            viewStartTime = taskDefaultHour;
            
        }else if(startDate.length !=0 && endDate.length == 0) {
            endTime = @"23:50:00";
            endDate = tempTimeStr;
            viewEndDate = timeStr;
            viewEndTime = @"23:50";
            NSLog(@"endTime%@endDate%@ viewEndDate%@", endTime, endDate, viewEndDate);
            NSString *startStr = [startDate stringByReplacingOccurrencesOfString:@"-" withString:@""];//开始时间
            NSString *endStr = [endDate stringByReplacingOccurrencesOfString:@"-" withString:@""];//结束时间
            if ([startStr intValue] > [endStr intValue]) {
                editState = 0;
                
                startTime = [NSString stringWithFormat:@"%@:00", taskDefaultHour];
                startDate = tempTimeStr;
                viewStartDate = timeStr;
                viewStartTime = taskDefaultHour;
                endDate = @"";
                endTime = @"";
                viewEndDate = @"";
                viewEndTime = @"";
            }else {
                editState = 1;
            }
        }else if (startDate.length !=0 && endDate.length != 0) {
            startTime = [NSString stringWithFormat:@"%@:00", taskDefaultHour];
            startDate = tempTimeStr;
            viewStartDate = timeStr;
            viewStartTime = taskDefaultHour;
            endDate = @"";
            endTime = @"";
            viewEndDate = @"";
            viewEndTime = @"";
            editState = 0;
         
        }
        [selfWeak  refreshViewData];
    
    };
    
    [self.view addSubview:_calendar];
    [self refreshViewData];
}


- (void)refreshViewData {
    
    switch (editState) {
        case 0: {
            _timeTypeShowLabel.text =@"开始时间";
            self.hoursShowLabel.text = [NSString stringWithFormat:@"%@ %@", viewStartDate, viewStartTime];
        }
            break;
        case 1:{
            _timeTypeShowLabel.text =@"结束时间";
          self.hoursShowLabel.text = [NSString stringWithFormat:@"%@ %@", viewEndDate, viewEndTime];
        }
            break;
        default:
            break;
    }
    self.headView.startTimeShowLabel.text = [NSString stringWithFormat:@"%@ %@", viewStartDate, viewStartTime];
    self.headView.endTimeShowLabel.text = [NSString stringWithFormat:@"%@ %@", viewEndDate, viewEndTime];;
}

#pragma mark   DJCalendarTimeShowHeadViewDelegate

- (void)timeChoose:(NSInteger )index {
    
    if (startDate.length == 0 || endDate.length == 0) {
        return;
    }
    editState = index;
    [self  refreshViewData];
}

- (void)setStartDefaultDate:(NSDate *)startDefaultDate {
    
    _startDefaultDate = startDefaultDate;
    
}
-(void)setEndDefaultDate:(NSDate *)endDefaultDate {
    
    _endDefaultDate = endDefaultDate;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
