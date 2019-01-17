//
//  GFCalendarScrollView.m
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import "GFCalendarScrollView.h"
#import "GFCalendarCell.h"
#import "GFCalendarMonth.h"
#import "NSDate+GFCalendar.h"
#import "DJDisposeCollectionViewSpacingFlowLayout.h"
#import "DJBaseViewController.h"

@interface GFCalendarScrollView() <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionViewL;
@property (nonatomic, strong) UICollectionView *collectionViewM;
@property (nonatomic, strong) UICollectionView *collectionViewR;
/**
 *
 */
@property (nonatomic, strong)NSDate *previousMonthDate;

/**
 
 */
@property (nonatomic, strong) NSDate *currentMonthDate;
/**
 *
 */
@property (nonatomic, strong)NSDate *nextMonthDate;

@property (nonatomic, strong) NSMutableArray *monthArray;

/**
 *开始时间
 */
@property (nonatomic, strong)NSDate *startDate;
/**
 *结束时间
 */
@property (nonatomic, strong)NSDate * endDate;
@end

@implementation GFCalendarScrollView

#define kCalendarBasicColor [UIColor colorWithRed:231.0 / 255.0 green:85.0 / 255.0 blue:85.0 / 255.0 alpha:1.0]
//#define kCalendarBasicColor [UIColor colorWithRed:252.0 / 255.0 green:60.0 / 255.0 blue:60.0 / 255.0 alpha:1.0]

static NSString *const kCellIdentifier = @"cell";

#pragma mark - Initialiaztion

- (instancetype)initWithFrame:(CGRect)frame {
 self  =  [super initWithFrame:frame];
    if (self) {
        
        self.startDate = self.startDefaultDate;
        self.endDate = self.startDefaultDate;
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.delegate = self;
        
        self.contentSize = CGSizeMake(3 * self.bounds.size.width, self.bounds.size.height);
        [self setContentOffset:CGPointMake(self.bounds.size.width, 0.0) animated:NO];
        
        self.currentMonthDate = [NSDate date];
        self.previousMonthDate = [_currentMonthDate previousMonthDate];
        self.nextMonthDate = [_currentMonthDate nextMonthDate];
        [self setupCollectionViews];
        
    }
    
    return self;
    
}

- (NSMutableArray *)monthArray {
    if (_monthArray == nil) {
        _monthArray = [NSMutableArray arrayWithCapacity:4];
        
        NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];
        NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];
        _previousMonthDate = [_currentMonthDate previousMonthDate];
        _nextMonthDate = [_currentMonthDate nextMonthDate];
        [_monthArray addObject:[[GFCalendarMonth alloc] initWithDate:previousMonthDate]];
        [_monthArray addObject:[[GFCalendarMonth alloc] initWithDate:_currentMonthDate]];
        [_monthArray addObject:[[GFCalendarMonth alloc] initWithDate:nextMonthDate]];
        [_monthArray addObject:[self previousMonthDaysForPreviousDate:previousMonthDate]]; //存储左边的月份的前一个月份的天数，用来填充左边月份的首部
        // 发通知，更改当前月份标题
        [self notifyToChangeCalendarHeader];
    }
    return _monthArray;
}

- (NSNumber *)previousMonthDaysForPreviousDate:(NSDate *)date {
    return [[NSNumber alloc] initWithInteger:[[date previousMonthDate] totalDaysInMonth]];
}

- (void)setupCollectionViews {
    int weekLineHight = 48;
    DJDisposeCollectionViewSpacingFlowLayout *flowLayout = [[DJDisposeCollectionViewSpacingFlowLayout alloc] init];
    
    CGFloat  self_width = self.bounds.size.width;
    CGFloat  itemW  = self_width/7.0;
    NSLog(@"DJDisposeCollectionViewSpacingFlowLayout%f", itemW);
    flowLayout.itemSize = CGSizeMake(itemW, weekLineHight);
      
    flowLayout.minimumLineSpacing =0;
    flowLayout.minimumInteritemSpacing = 12;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    CGFloat selfHeight = self.bounds.size.height;
    CGFloat selfWidth = self.bounds.size.width+0.9;
    _collectionViewL = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, selfWidth, selfHeight) collectionViewLayout:flowLayout];
    _collectionViewL.dataSource = self;
    _collectionViewL.delegate = self;
    _collectionViewL.backgroundColor = [UIColor clearColor];
    [_collectionViewL registerClass:[GFCalendarCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self addSubview:_collectionViewL];
    
    _collectionViewM = [[UICollectionView alloc] initWithFrame:CGRectMake(selfWidth, 0.0, selfWidth, selfHeight) collectionViewLayout:flowLayout];
    _collectionViewM.dataSource = self;
    _collectionViewM.delegate = self;
    _collectionViewM.backgroundColor = [UIColor clearColor];
    [_collectionViewM registerClass:[GFCalendarCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self addSubview:_collectionViewM];
    _collectionViewR = [[UICollectionView alloc] initWithFrame:CGRectMake(2 * selfWidth, 0.0, selfWidth, selfHeight) collectionViewLayout:flowLayout];
    _collectionViewR.dataSource = self;
    _collectionViewR.delegate = self;
    _collectionViewR.backgroundColor = [UIColor clearColor];
    [_collectionViewR registerClass:[GFCalendarCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self addSubview:_collectionViewR];
}
#pragma mark -

- (void)notifyToChangeCalendarHeader {
    
    GFCalendarMonth *currentMonthInfo = self.monthArray[1];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [userInfo setObject:[[NSNumber alloc] initWithInteger:currentMonthInfo.year] forKey:@"year"];
    [userInfo setObject:[[NSNumber alloc] initWithInteger:currentMonthInfo.month] forKey:@"month"];
    
    NSNotification *notify = [[NSNotification alloc] initWithName:@"ChangeCalendarHeaderNotification" object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
}

- (void)refreshToCurrentMonth {
    NSLog(@"[[NSDate date] dateMonth]%d", [[NSDate date] dateMonth]);
    // 如果现在就在当前月份，则不执行操作
    GFCalendarMonth *currentMonthInfo = self.monthArray[1];
    if ((currentMonthInfo.month == [[NSDate date] dateMonth]) && (currentMonthInfo.year == [[NSDate date] dateYear])) {
        return;
    }
    _currentMonthDate = [NSDate date];
    
    NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];
    NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];
    _previousMonthDate = [_currentMonthDate previousMonthDate];
    _nextMonthDate = [_currentMonthDate nextMonthDate];
    [self.monthArray removeAllObjects];
    [self.monthArray addObject:[[GFCalendarMonth alloc] initWithDate:previousMonthDate]];
    [self.monthArray addObject:[[GFCalendarMonth alloc] initWithDate:_currentMonthDate]];
    [self.monthArray addObject:[[GFCalendarMonth alloc] initWithDate:nextMonthDate]];
    [self.monthArray addObject:[self previousMonthDaysForPreviousDate:previousMonthDate]];
    // 刷新数据
    [_collectionViewM reloadData];
    [_collectionViewL reloadData];
    [_collectionViewR reloadData];
    
}
- (void)JumpToMonth:(NSDate *)date {
    // 如果现在就在当前月份，则不执行操作
    GFCalendarMonth *currentMonthInfo = self.monthArray[1];
    if ((currentMonthInfo.month == [date dateMonth]) && (currentMonthInfo.year == [date dateYear])) {
        return;
    }
    _currentMonthDate = date;
    
    NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];
    NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];
    _previousMonthDate = [_currentMonthDate previousMonthDate];
    _nextMonthDate = [_currentMonthDate nextMonthDate];
    [self.monthArray removeAllObjects];
    [self.monthArray addObject:[[GFCalendarMonth alloc] initWithDate:previousMonthDate]];
    [self.monthArray addObject:[[GFCalendarMonth alloc] initWithDate:_currentMonthDate]];
    [self.monthArray addObject:[[GFCalendarMonth alloc] initWithDate:nextMonthDate]];
    [self.monthArray addObject:[self previousMonthDaysForPreviousDate:previousMonthDate]];
    [self notifyToChangeCalendarHeader];
    // 刷新数据
    [_collectionViewM reloadData];
    [_collectionViewL reloadData];
    [_collectionViewR reloadData];
    
}

#pragma mark - UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 42; // 7 * 6
}

- (void)editorCell:(UICollectionViewCell *)cell data:(GFCalendarMonth *)monthInfo  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    GFCalendarCell *tempCell = (GFCalendarCell *)cell;
    NSInteger firstWeekday = monthInfo.firstWeekday;//第一天周几
    NSInteger totalDays = monthInfo.totalDays;//一个月多少天
    NSDate  *currentDate = monthInfo.monthDate;
    
    NSInteger cellDay = 0;
    NSString *currentStr = @"";
    // 当前月
    if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
         cellDay =  indexPath.row - firstWeekday + 1;
        currentStr   = [NSDate dateString:currentDate format:@"yyyyMM"];
    }else if (indexPath.row < firstWeekday) {//周3 置灰

        cellDay = 0;
        currentStr =  @"";
    }else {

        cellDay = 0;
        currentStr =  @"";
    }
    
    
    
    NSLog(@"cellDay%ld currentDate%@", cellDay, currentDate);
    if (cellDay <10) {
        currentStr = [NSString stringWithFormat:@"%@0%ld", currentStr, cellDay];
    }else {
        currentStr = [NSString stringWithFormat:@"%@%ld", currentStr, cellDay];
    }
    NSDate *cellDate = [NSDate stringToDate:currentStr format:@"yyyyMMdd"];
    NSString * cellDateStr = [NSDate dateString:cellDate format:@"yyyyMMdd"];
    NSLog(@"cellForItemAtIndexPath  cellDay=%d   indexPath=%ld cellDateStr=%@ currentStr%@", cellDay, indexPath.row, cellDateStr, currentStr);
    NSString *startStr = [NSDate dateString:_startDate format:@"yyyyMMdd"];//开始时间
    NSString *endStr = [NSDate dateString:_endDate format:@"yyyyMMdd"];//结束时间
    
    //NSLog(@" \ncurrentStr%@  \n_startDate%@",currentStr, [NSDate dateString:_startDate format:@"yyyyMMdd"]);
    if (_startDate != nil && _endDate == nil) {//如果开始结束时间都是空
        tempCell.todayLabel.textColor = [UIColor blackColor];
        tempCell.repeatLabel.hidden = YES;
        tempCell.rightColorView.hidden  = YES;
        tempCell.leftColorView.hidden  = YES;
        NSLog(@"_startDate%@", _startDate);
        if ([cellDateStr intValue] == [startStr intValue]) {//如果cell上的时间和选中的时间一样 就设置选中样式
            tempCell.selectedBtn.hidden = NO;
            tempCell.todayLabel.textColor = [UIColor whiteColor];
        }else {//不一样
            tempCell.selectedBtn.hidden = YES;
            tempCell.todayLabel.backgroundColor = [UIColor clearColor];
        }
    }else if (_startDate != nil && _endDate != nil) {//如果开始时间和结束时间都不是空
        
        tempCell.todayLabel.textColor = [UIColor blackColor];
        tempCell.repeatLabel.hidden = YES;
        if (cellDate == _endDate) {//如果=结束时间
            tempCell.selectedBtn.hidden = NO;
            tempCell.todayLabel.textColor = kColorRGB(51, 51, 51, 1);
        }else {
            tempCell.selectedBtn.hidden = YES;
            tempCell.todayLabel.backgroundColor = [UIColor clearColor];
        }
        if ([cellDateStr intValue] >= [startStr intValue] && [cellDateStr intValue] <= [endStr intValue]) {
            if ([cellDateStr intValue] == [startStr intValue] ||  [cellDateStr intValue] == [endStr intValue]) {
                tempCell.selectedBtn.hidden = NO;
                tempCell.todayLabel.textColor = [UIColor whiteColor];
            }else {
                tempCell.selectedBtn.hidden = YES;
            }
            if ([cellDateStr intValue] == [startStr intValue] &&  [cellDateStr intValue] == [endStr intValue]) {
                tempCell.selectedBtn.hidden = NO;
                tempCell.todayLabel.textColor =  [UIColor whiteColor];;
                tempCell.leftColorView.hidden  = YES;
                tempCell.rightColorView.hidden  = YES;
                tempCell.repeatLabel.hidden = NO;
            }else if ([cellDateStr intValue] == [startStr intValue]) {
                tempCell.rightColorView.hidden  = NO;
                tempCell.leftColorView.hidden  = YES;
            }else if( [cellDateStr intValue] == [endStr intValue]) {
                tempCell.leftColorView.hidden  = NO;
                tempCell.rightColorView.hidden  = YES;
            }else {
                tempCell.rightColorView.hidden  = NO;
                tempCell.leftColorView.hidden  = NO;
            }
        }else {
            
            tempCell.rightColorView.hidden  = YES;
            tempCell.leftColorView.hidden  = YES;
            tempCell.todayLabel.backgroundColor = [UIColor clearColor];
        }
    }else {
        tempCell.repeatLabel.hidden = YES;
        tempCell.selectedBtn.hidden = YES;
        tempCell.rightColorView.hidden  = YES;
        tempCell.leftColorView.hidden  = YES;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GFCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (collectionView == _collectionViewL) {
        
        GFCalendarMonth *monthInfo = self.monthArray[0];
        [self editorCell:cell data:monthInfo cellForItemAtIndexPath:indexPath];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {

            NSString * dayStr = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday + 1];
            cell.todayLabel.text =dayStr;
            NSString *currentTimeStr = [NSDate dateString:[NSDate date] format:@"yyyyMMdd"];//当前时间
            NSString *chooseTimeStr = [NSDate dateString:monthInfo.monthDate format:@"yyyyMM" ];
            if (dayStr.integerValue <10) {
                chooseTimeStr = [NSString stringWithFormat:@"%@0%@", chooseTimeStr,dayStr];
            }else {
                chooseTimeStr = [NSString stringWithFormat:@"%@%@", chooseTimeStr,dayStr];
            }
            NSLog(@"currentTimeStr%@chooseTimeStr%@", currentTimeStr, chooseTimeStr);
            if (currentTimeStr.integerValue > chooseTimeStr.integerValue) {
                cell.todayLabel.textColor = kColorRGB(134, 134, 134, 1);
            }else {
                
            }
            
        // 补上前后月的日期，淡色显示
        } else if (indexPath.row < firstWeekday) {//周3 置灰

            cell.todayLabel.text = @"";
        } else if (indexPath.row >= firstWeekday + totalDays) {

            cell.todayLabel.text = @"";
        }

    }
    else if (collectionView == _collectionViewM) {
        
        GFCalendarMonth *monthInfo = self.monthArray[1];
//        NSLog(@"_collectionViewM%@", monthInfo.monthDate);
        [self editorCell:cell data:monthInfo cellForItemAtIndexPath:indexPath];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            
            NSString * dayStr = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday + 1];
            cell.todayLabel.text = dayStr;
            
            NSString *currentTimeStr = [NSDate dateString:[NSDate date] format:@"yyyyMMdd"];//当前时间
            NSString *chooseTimeStr = [NSDate dateString:monthInfo.monthDate format:@"yyyyMM" ];
            if (dayStr.integerValue <10) {
                chooseTimeStr = [NSString stringWithFormat:@"%@0%@", chooseTimeStr,dayStr];
            }else {
                chooseTimeStr = [NSString stringWithFormat:@"%@%@", chooseTimeStr,dayStr];
            }
            NSLog(@"currentTimeStr%@chooseTimeStr%@", currentTimeStr, chooseTimeStr);
            if (currentTimeStr.integerValue > chooseTimeStr.integerValue) {
                cell.todayLabel.textColor = kColorRGB(134, 134, 134, 1);
            }else {
                
            }
            cell.userInteractionEnabled = YES;
        }
        // 补上前后月的日期，淡色显示
        else if (indexPath.row < firstWeekday) {
            cell.todayLabel.text = @"";
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.todayLabel.text = @"";
        }
        
    }
    else if (collectionView == _collectionViewR) {
        
        GFCalendarMonth *monthInfo = self.monthArray[2];

        [self editorCell:cell data:monthInfo cellForItemAtIndexPath:indexPath];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            NSString * dayStr =  [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday + 1];
            cell.todayLabel.text =dayStr;
            NSString *currentTimeStr = [NSDate dateString:[NSDate date] format:@"yyyyMMdd"];//当前时间
            NSString *chooseTimeStr = [NSDate dateString:monthInfo.monthDate format:@"yyyyMM" ];
            if (dayStr.integerValue <10) {
                chooseTimeStr = [NSString stringWithFormat:@"%@0%@", chooseTimeStr,dayStr];
            }else {
                chooseTimeStr = [NSString stringWithFormat:@"%@%@", chooseTimeStr,dayStr];
            }
            NSLog(@"currentTimeStr%@chooseTimeStr%@", currentTimeStr, chooseTimeStr);
            if (currentTimeStr.integerValue > chooseTimeStr.integerValue) {
                cell.todayLabel.textColor = kColorRGB(134, 134, 134, 1);
            }else {
                
            }
        }
        // 补上前后月的日期，淡色显示
        else if (indexPath.row < firstWeekday) {
            cell.todayLabel.text = @"";
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.todayLabel.text = @"";

        }
    }
    
    return cell;
    
}

#pragma mark - UICollectionViewDeleagateX
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    GFCalendarMonth *monthInfo = self.monthArray[1];
    NSInteger firstWeekday = monthInfo.firstWeekday;//第一天周几
    NSInteger totalDays = monthInfo.totalDays;//一个月多少天
    NSDate  *currentDate = monthInfo.monthDate;
    
    NSInteger chooseDay = 0;//点击的日期
    NSInteger chooseDayMonth = 0;
    NSInteger chooseYears = 0;
//    NSString *currentStr = @"";//点击的年

    // 当前月
    if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
        chooseDay =  indexPath.row - firstWeekday + 1;
        chooseDayMonth   = [NSDate dateString:currentDate format:@"MM"].integerValue;
        chooseYears = [NSDate dateString:currentDate format:@"yyyy"].integerValue;
    }else if (indexPath.row < firstWeekday) {//周3 置灰

        return;
    }else {

        return;
    }
    
    
    
    if (self.didSelectDayHandler != nil) {

        NSInteger year =  chooseYears;
        NSInteger month = chooseDayMonth;
        NSInteger day = chooseDay;
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day];
        NSDate *chooseDate = [NSDate stringToDate:dateStr format:@"yyyy-MM-dd"];
         NSLog(@"chooseDate%@", dateStr);
        NSLog(@"chooseDate%@ 当前时间%@", chooseDate,  [NSDate dateString:[NSDate date] format:@"yyyyMMdd"]);
        
        if (self.startDate == nil && self.endDate == nil) {
            NSString *tempStartTimeStr = [NSDate dateString:chooseDate format:@"yyyyMMdd"];//开始时间
            NSString *tempCurrentTimeStr = [NSDate dateString:[NSDate date] format:@"yyyyMMdd"];//当前时间
            if ([tempStartTimeStr intValue] < [tempCurrentTimeStr intValue]) {
                DJBaseViewController *VC  =[[DJBaseViewController alloc] init];
                [VC ShowWarningHudMid:@"任务开始时间不能早于当前时间!"];
                return;
            }
            self.startDate = chooseDate;
        }else if (self.startDate != nil && self.endDate == nil) {
            self.endDate = chooseDate;
            NSString *startStr = [NSDate dateString:_startDate format:@"yyyyMMdd"];//开始时间
            NSString *endStr = [NSDate dateString:_endDate format:@"yyyyMMdd"];//结束时间
            if ([startStr intValue] > [endStr intValue]) {
                self.endDate = nil;
                NSString *tempStartTimeStr = [NSDate dateString:chooseDate format:@"yyyyMMdd"];//开始时间
                NSString *tempCurrentTimeStr = [NSDate dateString:[NSDate date] format:@"yyyyMMdd"];//当前时间
                if ([tempStartTimeStr intValue] < [tempCurrentTimeStr intValue]) {
                    DJBaseViewController *VC  =[[DJBaseViewController alloc] init];
                    [VC ShowWarningHudMid:@"任务开始时间不能早于当前时间!"];
                    return;
                }
                self.startDate = chooseDate;
            }
        }else {
            NSString *tempStartTimeStr = [NSDate dateString:chooseDate format:@"yyyyMMdd"];//开始时间
            NSString *tempCurrentTimeStr = [NSDate dateString:[NSDate date] format:@"yyyyMMdd"];//当前时间
            if ([tempStartTimeStr intValue] < [tempCurrentTimeStr intValue]) {
                DJBaseViewController *VC  =[[DJBaseViewController alloc] init];
                [VC ShowWarningHudMid:@"任务开始时间不能早于当前时间!"];
                return;
            }
            
            self.startDate = chooseDate;
            self.endDate = nil;
        }
        [_collectionViewM reloadData]; // 中间的 collectionView 先刷新数据
        self.didSelectDayHandler(chooseDate); // 执行回调
    }
    
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    int weekLineHight = 48;
    CGFloat  self_width = self.bounds.size.width;
    CGFloat  itemW  = self_width/7.0;
    return  CGSizeMake(itemW, weekLineHight);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
#pragma mark - UIScrollViewDelegate

//停止滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != self) {
        return;
    }
 // 向右滑动
    if (scrollView.contentOffset.x < self.bounds.size.width) {
        _currentMonthDate = [_currentMonthDate previousMonthDate];
        _previousMonthDate = [_currentMonthDate previousMonthDate];
        _nextMonthDate = [_currentMonthDate nextMonthDate];
        // 刷新月份数据
        NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];//上个月
        GFCalendarMonth *previousMonthInfo =    [[GFCalendarMonth alloc] initWithDate:previousMonthDate];//上个月
        NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];//下个月
        GFCalendarMonth *nextMonthInfo = [[GFCalendarMonth alloc] initWithDate:nextMonthDate];//下个月
        GFCalendarMonth *currentMothInfo = [[GFCalendarMonth alloc] initWithDate:_currentMonthDate];//本月
        
        NSNumber *prePreviousMonthDays = [self previousMonthDaysForPreviousDate:[_currentMonthDate previousMonthDate]];
        
        [self.monthArray removeAllObjects];
        [self.monthArray addObject:previousMonthInfo];
        [self.monthArray addObject:currentMothInfo];
        [self.monthArray addObject:nextMonthInfo];
        [self.monthArray addObject:prePreviousMonthDays];
        
    }
    // 向左滑动
    else if (scrollView.contentOffset.x > self.bounds.size.width) {
        _currentMonthDate = [_currentMonthDate nextMonthDate];
        _previousMonthDate = [_currentMonthDate previousMonthDate];
        _nextMonthDate = [_currentMonthDate nextMonthDate];
        // 刷新月份数据
        NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];//上个月
        GFCalendarMonth *previousMonthInfo =    [[GFCalendarMonth alloc] initWithDate:previousMonthDate];//上个月
        NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];//下个月
        GFCalendarMonth *nextMonthInfo = [[GFCalendarMonth alloc] initWithDate:nextMonthDate];//下个月
        GFCalendarMonth *currentMothInfo = [[GFCalendarMonth alloc] initWithDate:_currentMonthDate];//本月
        
        NSNumber *prePreviousMonthDays = [self previousMonthDaysForPreviousDate:[_currentMonthDate previousMonthDate]];
        
        [self.monthArray removeAllObjects];
        [self.monthArray addObject:previousMonthInfo];
        [self.monthArray addObject:currentMothInfo];
        [self.monthArray addObject:nextMonthInfo];
        [self.monthArray addObject:prePreviousMonthDays];
        
    }
    
    [_collectionViewM reloadData]; // 中间的 collectionView 先刷新数据
    [scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0.0) animated:NO]; // 然后变换位置
    [_collectionViewL reloadData]; // 最后两边的 collectionView 也刷新数据
    [_collectionViewR reloadData];
    
    // 发通知，更改当前月份标题
    [self notifyToChangeCalendarHeader];
    
    
    
    for (int i = 0; i < 3; i ++) {
        
    }
}

- (void)setStartDefaultDate:(NSDate *)startDefaultDate {
    
    _startDate = startDefaultDate;
    [_collectionViewL reloadData];
    [_collectionViewM reloadData];
    [_collectionViewR reloadData];
}

-(void)setEndDefaultDate:(NSDate *)endDefaultDate {
    _endDate = endDefaultDate;
    [_collectionViewL reloadData];
    [_collectionViewM reloadData];
    [_collectionViewR reloadData];
}


@end
