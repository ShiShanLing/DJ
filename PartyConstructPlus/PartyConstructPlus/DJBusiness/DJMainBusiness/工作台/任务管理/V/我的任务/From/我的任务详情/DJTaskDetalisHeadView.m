//
//  DJTaskDetalisHeadView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/18.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskDetalisHeadView.h"

@implementation DJTaskDetalisHeadView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35-16, 120, 16)];
        _titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:kFit(16)];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textColor = kColorRGB(136, 136, 136, 1);
        [self.contentView addSubview:_titleLabel];
        self.commentsBtn  = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _commentsBtn.frame = CGRectMake(kScreenWidth - 110, 35-16, 110, 16);
        [_commentsBtn setTitle:@"我要评论" forState:(UIControlStateNormal)];
        [_commentsBtn setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
        _commentsBtn.titleLabel.font = MFont(kFit(14));
        [_commentsBtn setImage:[UIImage imageNamed:@"DJ_myTask_taskComments"] forState:(UIControlStateNormal)];
        [_commentsBtn addTarget:self action:@selector(handleIComments) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:_commentsBtn];
    }
    return self;
}


- (void)handleIComments {
    if ([_delegate respondsToSelector:@selector(toCommentTask)]) {
        [_delegate toCommentTask];
    }
}

@end
