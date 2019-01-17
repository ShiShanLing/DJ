//
//  DJmitationWeChatSearchBoxVIew.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/6.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJmitationWeChatSearchBoxVIew.h"
#import "DJBaseViewController.h"
@implementation DJmitationWeChatSearchBoxVIew 

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth-30, 25)];
        _backgroundView.backgroundColor = kColorRGB(239, 239, 239, 1);
        _backgroundView.layer.cornerRadius= 4 ;
        _backgroundView.layer.masksToBounds = YES;
        [self  addSubview:_backgroundView];
        
        self.defaultStateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_defaultStateBtn setTitle:@"  搜索" forState:(UIControlStateNormal)];
        _defaultStateBtn.titleLabel.font = MFont(13);
        [_defaultStateBtn setTitleColor:kColorRGB(173, 173, 173, 1) forState:(UIControlStateNormal)];
        [_defaultStateBtn setImage:[UIImage imageNamed:@"DJ_lzsms_search"] forState:(UIControlStateNormal)];
        [_defaultStateBtn addTarget:self action:@selector(handleSearch) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_defaultStateBtn];
        _defaultStateBtn.frame = CGRectMake(15, 5, kScreenWidth-30, 25);
        
        self.cancelBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        _cancelBtn.frame = CGRectMake(kScreenWidth, 5, 60, 25);
        [_cancelBtn setTitleColor:kColorRGB(30, 139, 223, 1) forState:(UIControlStateNormal)];
        [_cancelBtn addTarget:self action:@selector(handleCancel) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_cancelBtn];
        
        self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(43, 5, kScreenWidth - 50-43, 25)];
        _searchTF.alpha = 0.0;
        _searchTF.font = MFont(13);
        _searchTF.delegate = self;
        _searchTF.returnKeyType = UIReturnKeySearch;
        _searchTF.placeholder = @"输入搜索关键字";
        [self addSubview:_searchTF];
    }
    return self;
}
#pragma mark  UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // 不让输入表情
    if ([textField isFirstResponder]) {
        NSLog(@"text%@", string);
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            return NO;
        }
        //判断键盘是不是九宫格键盘
        if ([NSString isNineKeyBoard:string] ){
            return YES;
        }else{
            if ([NSString hasEmoji:string] || [NSString stringContainsEmoji:string]){
                return NO;
            }
        }
    }
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length == 0) {
        DJBaseViewController *VC = [[DJBaseViewController alloc] init];
        [VC ShowWarningHudMid:@"请输入关键字"];
    }else {
        
        [self userDataManipulationType:self.searchType InData:self.searchTF.text];
        if ([_delegate respondsToSelector:@selector(searchNetworkRequest)]) {
            [_delegate searchNetworkRequest];
        }
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)handleSearch {
    [self.searchTF becomeFirstResponder];
    _defaultStateBtn.userInteractionEnabled = NO;
    if ([_delegate respondsToSelector:@selector(BeginYourSearch)]) {
        [_delegate BeginYourSearch];
    }
    
    CGRect frame1 = _defaultStateBtn.frame;
    frame1.size.width = 70;
    CGRect frame2 = _cancelBtn.frame;
    frame2.origin.x = kScreenWidth- 60;
    
    CGRect frame3 = _backgroundView.frame;
    frame3.size.width -= 45;
    _defaultStateBtn.frame = frame1;
    [_defaultStateBtn setTitle:@"        " forState:(UIControlStateNormal)];
    _searchTF.alpha = 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        _cancelBtn.frame = frame2;
        _backgroundView.frame = frame3;
    } completion:^(BOOL finished) {
        
        
    }];
    
}
- (void)handleCancel {
    [self.searchTF resignFirstResponder];
    _defaultStateBtn.userInteractionEnabled = YES;
    if ([_delegate respondsToSelector:@selector(endSearch)]) {
        [_delegate endSearch];
    }
//    [self.searchTF resignFirstResponder];
    CGRect frame1 = _defaultStateBtn.frame;
    frame1.size.width = 40;
    CGRect frame2 = _cancelBtn.frame;
    frame2.origin.x = kScreenWidth- 60;
    _searchTF.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        [_defaultStateBtn setTitle:@"  搜索" forState:(UIControlStateNormal)];
        _defaultStateBtn.frame = CGRectMake(15, 5, kScreenWidth-30, 25);
        _cancelBtn.frame = CGRectMake(kScreenWidth, 5, 60, 25);
        _backgroundView.frame = CGRectMake(15, 5, kScreenWidth-30, 25);
    } completion:^(BOOL finished) {
        
    }];
    
}

//插入一条数据
- (void)userDataManipulationType:(NSInteger )type  InData:(NSString *)insertData{
    
    NSString *key = @"";
    switch (type) {
        case 0:
            key = @"user";
            break;
        case 1:
            key = @"org";
            break;
        case 2:
            key = @"re";
            break;
        case 3:
            key = @"rd";
            break;
        default:
            break;
    }
    
    
    

    
    NSArray *sandboxpath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [sandboxpath objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"searchOrgAndUserRecord.plist"];
    
    

    
    //存储根数据
    NSMutableDictionary *rootDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    

    NSMutableArray *tempArrray = [NSMutableArray arrayWithArray:rootDic[key]];

    [tempArrray insertObject:insertData atIndex:0];//插入一条数据
    
    
//    tempArrray = [NSMutableArray arrayWithArray:[tempArrray valueForKeyPath:@"@distinctUnionOfObjects.self"]];
    
//    tempArrray  =   [NSMutableArray arrayWithArray:[[tempArrray reverseObjectEnumerator] allObjects]];
    
    
    NSMutableArray *dataArray = [NSMutableArray array];


    
    for (int i = 0; i < tempArrray.count; i ++) {
        NSString *str = tempArrray[i];
        if (![dataArray containsObject:str] && dataArray.count <3) {
            [dataArray addObject:str];
        }
    }
    
    NSLog(@"tempArrray%@ dataArray%@rootDic%@", tempArrray, dataArray, rootDic);
//  dataArray  =   [NSMutableArray arrayWithArray:[[dataArray reverseObjectEnumerator] allObjects]];

    if (rootDic == NULL) {
        rootDic = [NSMutableDictionary dictionaryWithDictionary:@{key:dataArray}];
    }else {
        [rootDic setObject:dataArray forKey:key];
    }
    
        //写入文件
        BOOL  isSucce  = [rootDic writeToFile:plistPath atomically:YES];
        NSLog(@"%@",NSHomeDirectory());
        NSLog(@"写入%@ key%@ dataArray%@rootDic%@", isSucce?@"成功":@"失败", key, dataArray, rootDic);
    //重新获取数据 看是否有变动（虚拟机上会有变动，但是真机上不会）
    NSMutableDictionary *newDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSLog(@"new %@",newDataDic);//打印新数据
}




@end
