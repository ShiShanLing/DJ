//
//  DownChildMenuView.m
//  PartyConstruct
//
//  Created by 石山岭 on 2018/5/14.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DownChildMenuView.h"

@interface DownChildMenuView ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableview;

@end

@implementation DownChildMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self createUIView];
    }
    return self;
}

- (void) createUIView{
 
    self.backgroundColor = [UIColor clearColor];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-40)];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.0;
    [self addSubview:self.backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapclick)];
    [self.backView addGestureRecognizer:tap];
    
    self.tableBack = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    self.tableBack.bounces = NO;
    [self addSubview:self.tableBack];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1) style:UITableViewStylePlain];
//    self.tableview.backgroundColor = [UIColor blueColor];
    self.tableview.delegate = self;
    self.tableview.bounces = NO;
    self.tableview.dataSource = self;
    self.tableview.rowHeight = 50;
    //    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableBack addSubview:self.tableview];
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    self.tableview.frame = CGRectMake(0, 0, kScreenWidth, 50*dataArr.count);
    [self.tableview reloadData];
    CGRect frame = self.tableBack.frame;
//    frame.origin.y = -50*dataArr.count;
//    frame.size.height = 50*dataArr.count;
    frame.origin.y = -50*dataArr.count;
    frame.size.height = 50*dataArr.count > kScreenHeight*0.4 ?kScreenHeight*0.4 : 50*dataArr.count ;
//    DebugLog(@"%f___%u____%f",frame.size.height,50*(dataArr.count),kScreenHeight*0.4);
    self.tableBack.frame = frame;
    self.tableBack.contentSize = CGSizeMake(kScreenWidth/3, 50*dataArr.count);
    
        self.backView.alpha = 0.35;
        CGRect frame1 = self.tableBack.frame;
        frame1.origin.y = 0;
        self.tableBack.frame = frame1;
    self.alpha = 1;

}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.textLabel.font = MFont(kFit(15));
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *str = self.dataArr[indexPath.row];
    UIView *fatherView = self;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSement" object:nil userInfo:@{@"title":str, @"fatherView":fatherView}];
    //这个方法只是为了告诉使用它的界面我的视图隐藏了,,视图用它干嘛了 去问视图
    [[NSNotificationCenter defaultCenter] postNotificationName:@"viewHidden" object:nil userInfo:nil];
    self.isConceal = NO;
    if ([_Delegate respondsToSelector:@selector(DownChildMenuViewSelectedWithIndex:)]) {
        [self.Delegate DownChildMenuViewSelectedWithIndex:indexPath.row];
    }

    
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.alpha = 0.0;
        CGRect frame = self.tableBack.frame;
        frame.origin.y = -50*self.dataArr.count;
        self.tableBack.frame = frame;
        
    } completion:^(BOOL finished) {
        
        
  
    }];
}

- (void)dismiss
{
    [self tapclick];
}

- (void)tapclick
{
    self.isConceal = NO;
    self.backView.alpha = 0.5;
    self.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = self.tableBack.frame;
        frame.origin.y = -50*self.dataArr.count;
        self.tableBack.frame = frame;
        
        
    }];
    //这个方法只是为了告诉使用它的界面我的视图隐藏了,,视图用它干嘛了 去问视图
    [[NSNotificationCenter defaultCenter] postNotificationName:@"viewHidden" object:nil userInfo:nil];
}




@end
