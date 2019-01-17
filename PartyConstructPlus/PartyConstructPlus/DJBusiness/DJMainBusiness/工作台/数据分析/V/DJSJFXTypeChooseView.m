//
//  DJSJFXTypeChooseView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/9/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJSJFXTypeChooseView.h"

@interface DJSJFXTypeChooseView ()

@property (assign, nonatomic) BOOL dd;
@property (assign, nonatomic) NSInteger btntag;
@property (assign, nonatomic) BOOL isFirstIndex;

@end

@implementation DJSJFXTypeChooseView

{
    
    NSString *defaultType;
    
}
- (instancetype)initWithFrame:(CGRect)frame buttonData:(NSArray *)data withType:(NSString *)type{
    if (self = [super initWithFrame:frame]){
        
        
        
        self.backgroundColor = [UIColor whiteColor];
        self.data = data;//
        defaultType = type;
        [self createUIView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewHidden:) name:@"viewHidden" object:nil];
        
    }
    return self;
}

- (void) createUIView{
    
    CGFloat btnWidth = kScreenWidth/self.data.count;
    CGFloat btnHeight = self.frame.size.height;
    
    for(int i=0; i<self.data.count; i++){
        AddAttButton *btn = [[AddAttButton alloc] initWithFrame:CGRectMake(btnWidth*i, 0, btnWidth, self.frame.size.height)];
        btn.tag = 100+i;
        btn.adjustsImageWhenHighlighted = NO;
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:self.data[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        btn.titleLabel.numberOfLines = 0;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:kColorRGB(253, 115, 77, 1) forState:UIControlStateSelected];
        [btn setTitleColor:kColorRGB(51, 51, 51, 1) forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"DJMenuExpand"] forState:(UIControlStateNormal)];
        
        if ([defaultType isEqualToString:self.data[i]]) {
            
            btn.selected = YES;
            
        }
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        NSDictionary *dict=@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        NSString *str = [NSString stringWithString:self.data[i]];
        str = self.data[i] ;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
        CGFloat titleWidth=[str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.width;
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth+3, 0, -titleWidth-3);
        if (i != self.data.count-1){
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(btnWidth*(i+1), 5, 1, self.frame.size.height-10)];
            line.backgroundColor = kColorRGB(231, 231, 231, 1);
            [self addSubview:line];
        }
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, btnHeight-1, kScreenWidth, 1)];
    line.backgroundColor = kColorRGB(231, 231, 231, 1);
    [self addSubview:line];
    
    self.dividerLabel = [UILabel new];
    _dividerLabel.backgroundColor = kCellColorDivider;
    _dividerLabel.hidden = YES;
    [self addSubview:_dividerLabel];
    _dividerLabel.sd_layout.leftSpaceToView(self, kFit(0)).topSpaceToView(self, 0).heightIs(kCellDividerHeight).rightSpaceToView(self, 0);
}
//下拉菜单隐藏了  吧该界面的AddAttButton按钮的ClickClicking状态还原成没有选中状态 也就是下拉菜单没有出现的意思
- (void)viewHidden:(NSNotification *)info {
    [self.delegate ChooseDataType:2];
}

- (void) btnClick:(AddAttButton *)sender{
    
    for (int i  = 0; i < self.data.count; i ++) {
        AddAttButton *btn = [self viewWithTag:100 +i];
        if (sender.tag == btn.tag) {
            sender.selected = YES;
        }else {
            btn.selected = NO;
        }
    }
    if ([_delegate respondsToSelector:@selector(ChooseDataType:)]){
        [self.delegate ChooseDataType:sender.tag-100+1];
    }
}


- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"viewHidden" object:nil];
}

@end
