//
//  DJStarsCommentsView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJStarsCommentsView.h"

@interface DJStarsCommentsView ()
/**
 *
 */
@property (nonatomic, strong)UIImageView * starsOneImage;
/**
 *
 */
@property (nonatomic, strong)UIImageView * starsTwoImage;
/**
 *
 */
@property (nonatomic, strong)UIImageView * starsThreeImage;
/**
 *
 */
@property (nonatomic, strong)UIImageView * starsFourImage;
/**
 *
 */
@property (nonatomic, strong)UIImageView * starsFiveImage;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * tempArray;
@end

@implementation DJStarsCommentsView

-(instancetype)initStarsViewWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < 5; i++) {
            UIImageView *imagView = [UIImageView new];
            imagView.tag = 100+i;
            imagView.image = [UIImage imageNamed:@"DJ_star_no"];
            [self addSubview:imagView];
            switch (i) {
                case 0:
                    self.starsOneImage = imagView;
                    [temp addObject:self.starsOneImage];
                    break;
                case 1:
                    self.starsTwoImage = imagView;
                    [temp addObject:self.starsTwoImage];
                    break;
                case 2:
                    self.starsThreeImage = imagView;
                    [temp addObject:self.starsThreeImage];
                    break;
                case 3:
                    self.starsFourImage = imagView;
                    [temp addObject:self.starsFourImage];
                    break;
                case 4:
                    self.starsFiveImage = imagView;
                    [temp addObject:self.starsFiveImage];
                    break;
                    
                default:
                    break;
            }
            imagView.sd_layout.autoHeightRatio(1);
            
        }
        self.tempArray = [NSMutableArray array];
        self.tempArray = [NSMutableArray arrayWithArray:temp];
        // 关键步骤：设置类似collectionView的展示效果
        
        [self setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:self.tempArray.count verticalMargin:0 horizontalMargin:((self.width - self.height * 5)/4) verticalEdgeInset:0 horizontalEdgeInset:0];
    }
    return self;
}

- (void)setUserGestureInteractionEnabled:(BOOL)userGestureInteractionEnabled {
    _userGestureInteractionEnabled = userGestureInteractionEnabled;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if((point.x>0 && point.x<self.width)&&(point.y>0 && point.y<self.height)){
        self.userGestureInteractionEnabled = YES;
        [self changeStarForegroundViewWithPoint:point];
        
    }else{
        self.userGestureInteractionEnabled = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(self.userGestureInteractionEnabled){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        [self changeStarForegroundViewWithPoint:point];
        
    }
    
    
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.userGestureInteractionEnabled){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        [self changeStarForegroundViewWithPoint:point];
        
    }
    
    self.userGestureInteractionEnabled = NO;
    
    return;
}

-(void)changeStarForegroundViewWithPoint:(CGPoint)point{

    NSInteger count = 0;
    count = count + [self changeImg:point.x image:self.starsOneImage];
    count = count + [self changeImg:point.x image:self.starsTwoImage];
    count = count + [self changeImg:point.x image:self.starsThreeImage];
    count = count + [self changeImg:point.x image:self.starsFourImage];
    count = count + [self changeImg:point.x image:self.starsFiveImage];
    if(count==0){
        count = 1;
        [self.starsOneImage setImage:[UIImage imageNamed:@"DJ_star_yes"]];
    }
    [self checkCount:count];
    //在这里返回星级
    if ([_delegate respondsToSelector:@selector(UserschangeCheck:)]) {
        [_delegate UserschangeCheck:count];
    }
}

- (void)checkCount:(NSInteger)count {
    
    for (int i = 0; i < count; i ++) {
       UIImageView *imagView = self.tempArray[i];
        imagView.image = [UIImage imageNamed:@"DJ_star_yes"];
    }
}

-(NSInteger)changeImg:(float)x image:(UIImageView*)img{
    if(x> img.frame.origin.x){
        [img setImage:[UIImage imageNamed:@"DJ_star_yes"]];
        return 1;
    }else{
        [img setImage:[UIImage imageNamed:@"DJ_star_no"]];
        return 0;
    }
}
-(void)setImageAnimation:(UIView *)v{
    CGRect rec = v.frame;
    [UIView animateWithDuration:0.1 animations:^{
        v.frame = CGRectMake(v.frame.origin.x, v.frame.origin.y -3, v.frame.size.width, v.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            v.frame = rec;
        } completion:^(BOOL finished) {
            v.frame = rec;
        }];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
