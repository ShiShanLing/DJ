//
//  DJTaskReleaseCalendarSelectView.m
//  GFCalendarDemo
//
//  Created by 石山岭 on 2018/5/25.
//  Copyright © 2018年 Mercy. All rights reserved.
//

#import "DJTaskReleaseCalendarSelectView.h"
#import "GFCalendarScrollView.h"
#import "NSDate+GFCalendar.h"
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width//屏幕宽度
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height//屏幕高度
#define kCalendarBasicColor [UIColor colorWithRed:231.0 / 255.0 green:85.0 / 255.0 blue:85.0 / 255.0 alpha:1.0]
#define kColorRGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]//RGB颜色
@interface DJTaskReleaseCalendarSelectView()

@property (nonatomic, strong) UIButton *calendarHeaderButton;
@property (nonatomic, strong) UIView *weekHeaderView;
@property (nonatomic, strong) GFCalendarScrollView *calendarScrollView;

/**
 *
 */
@property (nonatomic, strong)UIButton * todayBtn;

@end

@implementation DJTaskReleaseCalendarSelectView

#pragma mark - Initialization

- (instancetype)initWithFrameOrigin:(CGPoint)origin width:(CGFloat)width {

// 根据宽度计算 calender 主体部分的高度
int weekLineHight = 48;
int monthHeight = (int)(6 * weekLineHight);


// 星期头部栏高度
    CGFloat weekHeaderHeight = 0.8 * weekLineHight;
// calendar 头部栏高度
    CGFloat calendarHeaderHeight = 0.0;
    if (kScreenHeight == 568.0) {
       calendarHeaderHeight = kFit(55);
    }else {
        calendarHeaderHeight = kFit(65);
    }
 
// 最后得到整个 calender 控件的高度
    _calendarHeight = calendarHeaderHeight + weekHeaderHeight + monthHeight;

if (self = [super initWithFrame:CGRectMake(origin.x, origin.y, width, _calendarHeight)]) {
    self.backgroundColor = [UIColor whiteColor];
    _calendarHeaderButton = [self setupCalendarHeaderButtonWithFrame:CGRectMake(20, 0.0, kFit(120), calendarHeaderHeight)];
    _weekHeaderView = [self setupWeekHeadViewWithFrame:CGRectMake(0.0, calendarHeaderHeight, width, weekHeaderHeight)];
    _calendarScrollView = [self setupCalendarScrollViewWithFrame:CGRectMake(0.0, calendarHeaderHeight + weekHeaderHeight, width, monthHeight)];
    _todayBtn = [self setupCalendarTodayButtonWithFrame:CGRectMake(kScreenWidth-60, 0, 72, calendarHeaderHeight)];
    [self addSubview:_calendarHeaderButton];
    [self addSubview:_weekHeaderView];
    [self addSubview:_calendarScrollView];
    [self addSubview:_todayBtn];
    
   
    // 注册 Notification 监听
    [self addNotificationObserver];
}
    return self;
}

- (void)dealloc {
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIButton *)setupCalendarTodayButtonWithFrame:(CGRect)frame {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:@"DJ_calendar_today"] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(handleBackToday) forControlEvents:(UIControlEventTouchUpInside)];
    return button;
}
- (void)handleBackToday {
    
    NSInteger year = [[NSDate date] dateYear];
    NSInteger month = [[NSDate date] dateMonth];
    NSString *title;
    if (month < 10) {
      title =   [NSString stringWithFormat:@"%ld年0%ld月", year, month];
    }else {
        title =   [NSString stringWithFormat:@"%ld年%ld月", year, month];
    }
    NSLog(@"title%@", title);
    [_calendarScrollView refreshToCurrentMonth];
    [_calendarHeaderButton setTitle:title forState:UIControlStateNormal];
}

- (UIButton *)setupCalendarHeaderButtonWithFrame:(CGRect)frame {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor redColor];
    button.frame = frame;
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(16)];
    [button setImage:[UIImage imageNamed:@"DJMenuExpand"] forState:(UIControlStateNormal)];
//    [button setImage:[UIImage imageNamed:@"DJMenuClose"] forState:(UIControlStateSelected)];
    NSDictionary *dict=@{NSFontAttributeName:[UIFont systemFontOfSize:kFit(16)]};
    NSString *str = @"2018年07月";
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    CGFloat titleWidth=[str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.width;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth + 5, 0, 0);
    [button setTitleColor:kColorRGB(51, 51, 51, 1) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:kFit(16)];
    [button addTarget:self action:@selector(refreshToCurrentMonthAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIView *)setupWeekHeadViewWithFrame:(CGRect)frame {
    
    CGFloat height = frame.size.height;
    CGFloat width = frame.size.width / 7.0;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    NSArray *weekArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (int i = 0; i < 7; ++i) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * width, 0.0, width, height)];
        label.backgroundColor = [UIColor clearColor];
        label.text = weekArray[i];
        label.textColor = kColorRGB(51, 51, 51, 1);
        label.font = [UIFont systemFontOfSize:13.5];
        label.textAlignment = NSTextAlignmentCenter;
        
        [view addSubview:label];
    }
    return view;
}

- (GFCalendarScrollView *)setupCalendarScrollViewWithFrame:(CGRect)frame {
    GFCalendarScrollView *scrollView = [[GFCalendarScrollView alloc] initWithFrame:frame];

    scrollView.startDefaultDate = self.startDefaultDate;
    scrollView.endDefaultDate = self.endDefaultDate;
    return scrollView;
}

- (void)setDidSelectDayHandler:(DidSelectDayHandler)didSelectDayHandler {
    _didSelectDayHandler = didSelectDayHandler;
    if (_calendarScrollView != nil) {
        _calendarScrollView.didSelectDayHandler = _didSelectDayHandler; // 传递 block
    }
}

- (void)addNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCalendarHeaderAction:) name:@"ChangeCalendarHeaderNotification" object:nil];
}


#pragma mark - Actions

- (void)refreshToCurrentMonthAction:(UIButton *)sender {
    
    NSString *timeStr = _calendarHeaderButton.titleLabel.text;
    
    NSString *tempStr = [timeStr substringToIndex:7];
    
    NSArray *timeArray = [tempStr componentsSeparatedByString:@"年"];
    
    NSString *yearsStr = timeArray[0];
    NSString *monthStr = timeArray[1];
    NSArray *yearsArray = @[@"2018", @"2019"];
    NSArray *monthArray = @[@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12"];
    
    NSInteger yearsIn = [yearsArray indexOfObject:yearsStr];
    NSInteger monthIn =  [monthArray indexOfObject:monthStr];
    NSString *yearsIndex = [NSString stringWithFormat:@"%ld", yearsIn];
    NSString *monthIndex = [NSString stringWithFormat:@"%ld", monthIn];
  __block  SMKPickerView *smkPickerView = [SMKPickerView SMKPickerMoreComponent:@[yearsArray,monthArray,]  withHeadTitle:@"calendar" defaultIndex:@[yearsIndex, monthIndex] withCall:^(NSString *choiceString) {
        [smkPickerView dismissPicker];
      
      NSString *dateStr;
      NSString *titleStr;
      NSArray *strArray = [choiceString componentsSeparatedByString:@","];
      
      for (int i = 0; i < [strArray count]; i++) {
          if (i == 0) {
              dateStr = strArray[i];
              titleStr = strArray[i];
          }else {
              dateStr = [NSString stringWithFormat:@"%@-%@", dateStr, strArray[i]];
              titleStr = [NSString stringWithFormat:@"%@年%@月", titleStr, strArray[i]];
          }
      }
      dateStr = [NSString stringWithFormat:@"%@-01", dateStr];
      NSDate *tempDate = [NSDate  stringToDate:dateStr format:@"yyyy-MM-dd"];
    
      
      [_calendarScrollView JumpToMonth:tempDate];
      [_calendarHeaderButton setTitle:titleStr forState:UIControlStateNormal];
      [smkPickerView dismissPicker];
    }];
    [smkPickerView show];
}

- (void)changeCalendarHeaderAction:(NSNotification *)sender {
    NSDictionary *dic = sender.userInfo;
    
    NSNumber *year = dic[@"year"];
    NSNumber *month = dic[@"month"];
    
    NSString *title;
    if (month.intValue < 10) {
        title =   [NSString stringWithFormat:@"%@年0%@月", year, month];
    }else {
        title =   [NSString stringWithFormat:@"%@年%@月", year, month];
    }
    NSLog(@"changeCalendarHeaderAction%@ dic%@", title, dic);
    [_calendarHeaderButton setTitle:title forState:UIControlStateNormal];
}

- (CGFloat)getCalendarViewHeight {
    
    return _calendarHeight;
    
}

- (void)setStartDefaultDate:(NSDate *)startDefaultDate {
    _startDefaultDate = startDefaultDate;
    if (startDefaultDate != nil ) {
        _calendarScrollView.startDefaultDate = startDefaultDate;
        [_calendarScrollView JumpToMonth:startDefaultDate];
    }
    
}
-(void)setEndDefaultDate:(NSDate *)endDefaultDate {
    _endDefaultDate =endDefaultDate;
    _calendarScrollView.endDefaultDate = endDefaultDate;
    
}
@end
