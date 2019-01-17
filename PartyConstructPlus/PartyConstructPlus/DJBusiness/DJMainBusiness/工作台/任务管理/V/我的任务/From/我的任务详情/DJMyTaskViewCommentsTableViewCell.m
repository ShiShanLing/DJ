//
//  DJMyTaskViewCommentsTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/9.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMyTaskViewCommentsTableViewCell.h"
#import "TaskCommentsModel+CoreDataProperties.h"
@interface DJMyTaskViewCommentsTableViewCell ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIImageView *headPortraitImage;
/**
 *
 */
@property (nonatomic, strong)UILabel * nameLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel * timeLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel* contentLabel;





/**
 *
 */
@property (nonatomic, strong)UIView *ScrollContentView;

@property(nonatomic, strong)UIScrollView *scrollView;
/**
 *UIScrollView最右边的视图 用来做自适应宽度
 */
@property (nonatomic, strong)UILabel * lastRightLine;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * imageViewArray;
@end

@implementation DJMyTaskViewCommentsTableViewCell


- (NSMutableArray *)imageViewArray {
    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dividerLabel = [UILabel new];
        _dividerLabel.backgroundColor = kCellColorDivider;
        [self.contentView addSubview:_dividerLabel];
        _dividerLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(self.contentView, 0).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
        
        self.headPortraitImage = [UIImageView new];
        _headPortraitImage.image = [UIImage imageNamed:@""];
        _headPortraitImage.layer.cornerRadius = 3;
        
        [self.contentView addSubview:_headPortraitImage];
        _headPortraitImage.sd_layout.leftSpaceToView(self.contentView, kFit(13.5)).topSpaceToView(self.contentView, kFit(20)).widthIs(kFit(34)).heightIs(kFit(34));
        
        [_headPortraitImage updateLayout];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_headPortraitImage.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:_headPortraitImage.bounds.size];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        //设置大小
        maskLayer.frame = _headPortraitImage.bounds;
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        _headPortraitImage.layer.mask = maskLayer;
        
        self.nameLabel = [UILabel new];
        _nameLabel.text = @"";
        _nameLabel.textColor = kColorRGB(0, 0, 0, 1);
        _nameLabel.font = MFont(kFit(14));
        [self.contentView addSubview:_nameLabel];
        _nameLabel.sd_layout.leftSpaceToView(_headPortraitImage, kFit(10)).topSpaceToView(self.contentView, kFit(22)).rightSpaceToView(self.contentView, 20).heightIs(kFit(14));
        
        self.timeLabel = [UILabel new];
        _timeLabel.text = @"";
        _timeLabel.textColor = kColorRGB(136, 136, 136, 1);
        _timeLabel.font = MFont(kFit(14));
        [self.contentView addSubview:_timeLabel];
        _timeLabel.sd_layout.leftSpaceToView(_headPortraitImage, kFit(10)).topSpaceToView(_nameLabel, kFit(4)).rightSpaceToView(self.contentView, 20).heightIs(kFit(14));
     
        self.contentLabel = [UILabel new];
        _contentLabel.text = @"";
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = MFont(kFit(14));
        [self.contentView addSubview:_contentLabel];
        _contentLabel.sd_layout.leftSpaceToView(self.contentView, kFit(17)).topSpaceToView(_headPortraitImage, kFit(14.5)).rightSpaceToView(self.contentView, kFit(20)).autoHeightRatio(0);

        
        
        self.scrollView = [UIScrollView new];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.userInteractionEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.hidden = YES;
        [self.contentView addSubview:_scrollView];
        _scrollView.sd_layout.topSpaceToView(_contentLabel, 10).heightIs(90).leftEqualToView(self.contentView).rightSpaceToView(self.contentView, 0);
        
        
        self.emptyImageView = [UIImageView new];
        _emptyImageView.image = [UIImage imageNamed:@"DJEmptyComment"];
        _emptyImageView.hidden = YES;
        [self.contentView addSubview:_emptyImageView];
        _emptyImageView.sd_layout.widthIs((kScreenWidth - 60)).heightIs(kFit(190)).centerXEqualToView(self.contentView).topSpaceToView(self.contentView, -30);
        self.promptLabel = [UILabel new];
        _promptLabel.textColor = kColorRGB(136, 136, 136, 1);
        _promptLabel.text = @"当前没有人评论呢~";
        _promptLabel.textAlignment = 1;
        _promptLabel.hidden = YES;
        _promptLabel.font = MFont(kFit(15));
        [self.contentView addSubview:_promptLabel];
        _promptLabel.sd_layout.leftSpaceToView(self.contentView, 30).rightSpaceToView(self.contentView, 30).heightIs(kFit(15)).bottomSpaceToView(self.contentView, 45);
        
    }
    return self;
}

- (void)noData {
    _promptLabel.hidden = NO;
    _emptyImageView.hidden = NO;
}
- (void)showImageView:(NSArray *)imageArray {
    [self.imageViewArray removeAllObjects];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.ScrollContentView = [UIView new];
    _scrollView.hidden = NO;
    _ScrollContentView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.ScrollContentView];
    [self.scrollView setupAutoContentSizeWithRightView:_ScrollContentView rightMargin:0];
    //    154  120
    CGFloat X = kFit(13.5);
    for (int i = 0; i < imageArray.count; i ++) {
        UIImageView *view  = [[UIImageView alloc] initWithFrame:CGRectMake(X, 0, 90, 90)];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 3;
        view.contentMode =  UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        view.image = nil;
        view.tag = 1000+i;
        NSString  * imageURL;
        if ([imageArray[i] isURL]) {
            imageURL=[NSString stringWithFormat:@"%@",imageArray[i]];
        }else {
            imageURL=[NSString stringWithFormat:@"%@%@",_model.dfsUrl,imageArray[i]];
        }
        
        [view sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"DJ_Load_network_image_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

            
        }];
        [self.ScrollContentView addSubview:view];
        view.sd_layout.leftSpaceToView(self.ScrollContentView, X).topSpaceToView(self.ScrollContentView, 0).bottomSpaceToView(self.ScrollContentView, 0).widthIs(90);
       

        X += 100;
        [view updateLayout];
        view.userInteractionEnabled = YES;
        LBPhotoWebItem *item = [[LBPhotoWebItem alloc]initWithURLString:imageURL frame:view.frame];
        item.placeholdImage = [UIImage imageNamed:@"DJ_Load_network_image_default"];
        [self.imageViewArray addObject:item];
        if (i == imageArray.count - 1) {
            self.lastRightLine = [UILabel new];
            [self.ScrollContentView addSubview:self.lastRightLine];
            self.lastRightLine.sd_layout.leftSpaceToView(view, 0).topSpaceToView(self.ScrollContentView, 0).bottomSpaceToView(self.ScrollContentView, 0).widthIs(1);
        }
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleImageTap:)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        singleFingerOne.delegate = self;
        
        [view addGestureRecognizer:singleFingerOne];
        
    }
    self.ScrollContentView.sd_layout.
    leftEqualToView(self.scrollView)
    .bottomEqualToView(self.scrollView)
    .topEqualToView(self.scrollView);
    [self.ScrollContentView setupAutoWidthWithRightView:self.lastRightLine rightMargin:0];
}

- (void)handleImageTap:(UITapGestureRecognizer *)tap {
    
    
    [LBPhotoBrowserManager.defaultManager showImageWithWebItems:self.imageViewArray selectedIndex:tap.view.tag-1000 fromImageViewSuperView:self.scrollView].lowGifMemory = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TaskCommentsModel *)model {
//    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
    _scrollView.hidden = YES;
    _model = model;
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if ([model.userHeadUrl isURL]) {
            
        [_headPortraitImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.userHeadUrl]] placeholderImage:[UIImage imageNamed:@"DJUserDefaultHead"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            NSLog(@"imageURL%@", imageURL);
            
        }];
            
    }else {
        
        [_headPortraitImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.dfsUrl,model.userHeadUrl]] placeholderImage:[UIImage imageNamed:@"DJUserDefaultHead"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];

    }
    _nameLabel.text = model.userName;
    _timeLabel.text = model.createTime;
    NSLog(@"model.evaContent%@", model.evaContent);
    if (![model.evaContent isEmpty]) {
            _contentLabel.text = model.evaContent;
    }else {
        _contentLabel.text = @"";
    }
    
    NSString *imageStr = model.evaImg;
    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    
    for (int i = 0; i < imageArray.count; i ++) {
        NSString  *url = imageArray[i];
        if (url.length == 0 || url == nil || url == NULL) {
            [imageArray removeObjectAtIndex:i];
        }
    }
    __weak DJMyTaskViewCommentsTableViewCell *selfWeak = self;
    
    if (imageArray.count == 0) {
        
        [selfWeak setupAutoHeightWithBottomView:_contentLabel bottomMargin:kFit(15)];
    }else {
//        NSLog(@"imageArray%@", imageArray);

        [selfWeak showImageView:imageArray];
        [selfWeak setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
    }
    [_contentLabel updateLayout];
    [_scrollView updateLayout];
    
}
-(void)dealloc {
    
    NSLog(@"DJMyTaskViewCommentsTableViewCell dealloc");
    
}

@end
