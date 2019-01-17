//
//  SMKPickerView.m
//  PartyConstruct
//
//  Created by 廖锦锐 on 16/7/20.
//  Copyright © 2016年 廖锦锐. All rights reserved.
//

#import "SMKPickerView.h"
#import "NSDate+GFCalendar.h"

@interface SMKPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>{
    
    
    
}

@property (weak,nonatomic)UIView *bgView;    //屏幕下方看不到的view
@property (weak,nonatomic)UILabel *titleLabel; //中间显示的标题lab
@property (weak, nonatomic) UIPickerView *pickerView;
@property (weak,nonatomic)UIButton *cancelButton;
@property (weak,nonatomic)UIButton *doneButton;
@property (strong,nonatomic)NSArray *dataArray;   // 用来记录传递过来的数组数据
@property (strong,nonatomic)NSString *headTitle;  //传递过来的标题头字符串
@property (strong,nonatomic)NSString *backString; //回调的字符串
@property (strong,nonatomic)NSString *backStringTwo; //回调的字符串
/**
 *默认展示第几个
 */
@property (nonatomic, assign)NSInteger  defaultIndex;

@end

@implementation SMKPickerView

+ (instancetype)SMKPickerWithArray:(NSArray *)titleArray withHeadTitle:(NSString *)headTitle defaultIndex:(NSInteger)index withCall:(SMKPickerViewBlock)callBack {
    
    SMKPickerView *pickerView = [[SMKPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds  andTitle:titleArray andHeadTitle:headTitle defaultIndex:index];
    pickerView.callBack = callBack;
    return pickerView;
}

+ (instancetype)SMKPickerMoreComponent:(NSArray *)MoreArray  withHeadTitle:(NSString *)headTitle defaultIndex:(NSArray *)indexArray withCall:(PickerViewOptions)callBack {
    
    SMKPickerView *pickerView = [[SMKPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds  andMoreTitle:MoreArray andHeadTitle:headTitle defaultMoreIndex:indexArray];
    pickerView.selectedStr = callBack;
    return pickerView;
}
/*
 多个选项的init方法
 */
- (instancetype)initWithFrame:(CGRect)frame andMoreTitle:(NSArray*)titleArray andHeadTitle:(NSString *)headTitle defaultMoreIndex:(NSArray *)indexArray {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isMore = YES;
        self.dataArray = titleArray;
        _headTitle = headTitle;
        for (int i = 0; i < self.dataArray.count; i ++) {
            if (i == 0) {
                _backString = self.dataArray[i][0];
            }else {
                _backString = [NSString stringWithFormat:@"%@,%@", _backString, self.dataArray[i][0]];
            }
        }
        [self  createMorePickerDefaultIndex:indexArray];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSArray*)titleArray andHeadTitle:(NSString *)headTitle defaultIndex:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isMore = NO;
        self.dataArray = titleArray;
        _headTitle = headTitle;
        self.defaultIndex = index;
        for (int i = 0; i < self.dataArray.count; i ++) {
            if (i == 0) {
                _backString = self.dataArray[i][0];
            }else {
            _backString = [NSString stringWithFormat:@"%@%@", _backString, self.dataArray[i][0]];
            }
        }
        [self createUI];
    }
    return self;
}
- (void)createMorePickerDefaultIndex:(NSArray *)indexArray {
    //首先创建一个位于屏幕下方看不到的view
    UIView* bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
    //    bgView.backgroundColor = [UIColor redColor];
    bgView.alpha = 0.0f;
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [bgView addGestureRecognizer:g];
    [[[[UIApplication sharedApplication] delegate] window]  addSubview:bgView];
    self.bgView = bgView;
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(2, 1, kScreenWidth*0.2, 43);
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"取消" attributes:
                                      @{ NSForegroundColorAttributeName: [UIColor blackColor] ,
                                         NSFontAttributeName :[UIFont systemFontOfSize:17],
                                         NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone) }];
    [cancelButton setAttributedTitle:attrString forState:UIControlStateNormal];
    cancelButton.adjustsImageWhenHighlighted = NO;
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    self.cancelButton = cancelButton;
    
    //确定按钮
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(kScreenWidth-kScreenWidth*0.2-2, 1, kScreenWidth*0.2, 43);
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@"确定" attributes:
                                       @{ NSForegroundColorAttributeName:kColorRGB(19, 78, 198, 1),
                                          NSFontAttributeName :           [UIFont systemFontOfSize:17],
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone) }];
    [doneButton setAttributedTitle:attrString2 forState:UIControlStateNormal];
    doneButton.adjustsImageWhenHighlighted = NO;
    doneButton.backgroundColor = [UIColor clearColor];
    [doneButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneButton];
    self.doneButton = doneButton;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(doneButton.frame)+1, kScreenWidth, 0.5)];
    line.backgroundColor = kColorRGB(231, 231, 231, 1);
    [self addSubview:line];
    
    //选择器
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(5,CGRectGetMaxY(line.frame), kScreenWidth-10, 230)];
    [pickerView setShowsSelectionIndicator:YES];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [self addSubview:pickerView];
    self.pickerView = pickerView;
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    //self
    self.backgroundColor = [UIColor whiteColor];
    [self setFrame:CGRectMake(0, kScreenHeight-300, kScreenWidth , 300)];
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [self setFrame: CGRectMake(0, kScreenHeight,kScreenWidth , 250)];
    
    for (int i = 0; i < self.dataArray.count; i ++) {
        NSString *indexStr  = indexArray[i];
        if (i == 0) {
            _backString = self.dataArray[i][indexStr.integerValue];
        }else {
            _backString = [NSString stringWithFormat:@"%@,%@", _backString, self.dataArray[i][indexStr.integerValue]];
        }
    }
    for (int i = 0; i <indexArray.count; i ++) {
        NSString *indexStr  = indexArray[i];
        [self.pickerView selectRow:indexStr.intValue inComponent:i animated:YES];
    }
}
- (void)createUI
{
    //首先创建一个位于屏幕下方看不到的view
    UIView* bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
//    bgView.backgroundColor = [UIColor redColor];
    bgView.alpha = 0.0f;
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [bgView addGestureRecognizer:g];
    [[[[UIApplication sharedApplication] delegate] window]  addSubview:bgView];
    self.bgView = bgView;

    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(2, 1, kScreenWidth*0.2, 43);
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"取消" attributes:
                                      @{ NSForegroundColorAttributeName: [UIColor blackColor] ,
                                         NSFontAttributeName :[UIFont systemFontOfSize:17],
                                         NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone) }];
    [cancelButton setAttributedTitle:attrString forState:UIControlStateNormal];
    cancelButton.adjustsImageWhenHighlighted = NO;
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    self.cancelButton = cancelButton;
    
    //确定按钮
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(kScreenWidth-kScreenWidth*0.2-2, 1, kScreenWidth*0.2, 43);
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@"确定" attributes:
                                       @{ NSForegroundColorAttributeName:kColorRGB(19, 78, 198, 1),
                                          NSFontAttributeName :[UIFont systemFontOfSize:17],
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone) }];
    [doneButton setAttributedTitle:attrString2 forState:UIControlStateNormal];
    doneButton.adjustsImageWhenHighlighted = NO;
    doneButton.backgroundColor = [UIColor clearColor];
    [doneButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneButton];
    self.doneButton = doneButton;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(doneButton.frame)+1, kScreenWidth, 0.5)];
    line.backgroundColor = kColorRGB(231, 231, 231, 1);
    [self addSubview:line];

    //选择器
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(5,CGRectGetMaxY(line.frame), kScreenWidth-10, 230)];
    [pickerView setShowsSelectionIndicator:YES];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [self addSubview:pickerView];
    self.pickerView = pickerView;
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    //self
    self.backgroundColor = [UIColor whiteColor];
    [self setFrame:CGRectMake(0, kScreenHeight-300, kScreenWidth , 300)];
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [self setFrame: CGRectMake(0, kScreenHeight,kScreenWidth , 250)];

    if (![_headTitle isEqualToString:@""] && _headTitle != nil) {
        NSInteger selInteger = [_headTitle integerValue] - 1 ;
        [self.pickerView selectRow:selInteger inComponent:0 animated:YES];
        for (int i = 0; i < self.dataArray.count; i ++) {
            if (i == 0) {
                _backString = self.dataArray[i][0];
            }else {
                _backString = [NSString stringWithFormat:@"%@%@", _backString, self.dataArray[i][0]];
            }
        }


    }

    _backString =  self.dataArray[0][_defaultIndex];
    [self.pickerView selectRow:_defaultIndex inComponent:0 animated:YES];

}

- (void)clicked:(UIButton *)sender {
    
    if ([sender isEqual:self.cancelButton]) {
        [self dismissPicker];
    }else{
        if (self.isMore) {
            if (self.selectedStr) {
                self.selectedStr(_backString);
            }
            
        }else {
            if (self.callBack) {
                self.callBack(self,_backString);
            }
            [self dismissPicker];
        }
        
    }
    
}


#pragma mark 该控件包含多少列UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.dataArray.count;
}

#pragma mark - 该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *dataArray = self.dataArray[component];
    return dataArray.count;
}

#pragma mark - 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //获取pickerView中第1列的选中值，分情况得到值
    for (int i = 0; i<self.dataArray.count; i++) {
        NSArray *dataArray = self.dataArray[i];
        NSInteger row2=[self.pickerView selectedRowInComponent:i];
        if (i == 0) {
            _backString = dataArray[row2];
        }else {
                _backString =[NSString stringWithFormat:@"%@,%@",_backString,  dataArray[row2]];
        }
    }

}


- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel* label = [[UILabel alloc] init];
    label.textColor = self.textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:kFit(20)];
    label.numberOfLines = 1;
    label.lineBreakMode = NSLineBreakByTruncatingMiddle;
    NSArray *dataArray = self.dataArray[component];
    NSInteger Month = [[NSDate date] dateMonth];
    NSInteger Year = [[NSDate date] dateYear];
    label.text = [NSString stringWithFormat:@"%@", dataArray[row]];
    
    return label;
}


- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}

- (void)tap
{
    [self dismissPicker];
}
- (void)show
{
    __weak __typeof(self) weakself= self;
    [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
        weakself.bgView.alpha = 1.0;
        
        weakself.frame = CGRectMake(0, kScreenHeight-250-kTabbarSafeBottomMargin, kScreenWidth, 250+kTabbarSafeBottomMargin);
    } completion:NULL];
}

- (void)dismissPicker
{
    __weak __typeof(self) weakself= self;
    [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        weakself.bgView.alpha = 0.0;
        weakself.frame = CGRectMake(0, kScreenHeight,kScreenWidth , 250);
        
    } completion:^(BOOL finished) {
        [weakself.bgView removeFromSuperview];
        [weakself removeFromSuperview];
        
    }];
}


@end
