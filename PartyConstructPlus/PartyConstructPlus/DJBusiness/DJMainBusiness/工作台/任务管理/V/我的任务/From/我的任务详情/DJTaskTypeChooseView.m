//
//  DJTaskTypeChooseView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/7.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskTypeChooseView.h"

@interface DJTaskTypeChooseView ()<DJTaskTypeViewDelegate>



@end

@implementation DJTaskTypeChooseView



-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        NSArray *iconArray = @[@"DJ_myTask_All", @"DJ_myTask_pending", @"DJ_myTask_finish", @"DJ_myTask_WaitReplace", @"DJ_myTask_appealing",@"DJ_myTask_leaveing", @"DJ_myTask_faskLeavePass", @"DJ_myTask_haveFill", @"DJ_myTask_complaintPass"];
        NSArray *titleArray = @[@"全部", @"待完成", @"已完成", @"待补办", @"申诉待审批",@"请假待审批", @"请假通过", @"已补办", @"申诉通过"];
        NSMutableArray *tempArray = [NSMutableArray array];
        UIView *bottomView = [[UIView alloc] init];
        [self addSubview:bottomView];
        bottomView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 22).rightSpaceToView(self, 0);
        for (int i= 0; i<iconArray.count; i++) {
            DJTaskTypeView *view = [DJTaskTypeView new];
            view.delegate = self;
            view.tag = 1000+i;
            view.backgroundColor = [UIColor whiteColor];
            view.titleLabel.text = titleArray[i];
            [view.iconBtn setImage:[UIImage imageNamed:iconArray[i]] forState:(UIControlStateNormal)];
            [bottomView addSubview:view];
            view.sd_layout.autoHeightRatio(0.73);
            [tempArray addObject:view];
        }
        NSLog(@"tempArray%@", tempArray);
        [bottomView setupAutoWidthFlowItems:[tempArray copy] withPerRowItemsCount:3 verticalMargin:0 horizontalMargin:0 verticalEdgeInset:0 horizontalEdgeInset:0];
        [bottomView updateLayout];
    }
    return self;
}

#pragma mark DJTaskTypeViewDelegate

- (void)ClickTaskType:(DJTaskTypeView *)view {
    if ([_delegate respondsToSelector:@selector(taskTypeSelection:)]) {
        [_delegate taskTypeSelection:view.tag - 1000];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
