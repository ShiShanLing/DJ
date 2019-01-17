//
//  DJMyTaskInfoTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/9.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMyTaskInfoTableViewCell.h"
#import "DJTaskImageShowView.h"


@interface DJMyTaskInfoTableViewCell ()<UIScrollViewDelegate, DJTaskImageShowViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic, strong)UIScrollView *scrollView;
/**
 *
 */
@property (nonatomic, strong)UILabel * lastRightLine;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * viewArray;
@property(nonatomic, strong)UICollectionView *collectionView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * datArray;
/**
 *
 */
@property (nonatomic, strong)UIImageView *timeImageView;
/**
 *
 */
@property (nonatomic, strong)UIImageView *tagImageView;
/**
 *
 */
@property (nonatomic, strong)UIImageView *contentImageView;
@end
@implementation DJMyTaskInfoTableViewCell
- (NSMutableArray *)datArray {
    if (!_datArray) {
        _datArray = [NSMutableArray array];
    }
    return _datArray;
}
- (NSMutableArray *)viewArray {
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    return _viewArray;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.taskNameLabel = [UILabel new];
        _taskNameLabel.text = @"";
        //        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:kFit(16)];
        //        _titleLabel.font =   [UIFont boldSystemFontOfSize:20];
        _taskNameLabel.font =[UIFont fontWithName:@"Helvetica-Bold"  size:kFit(16)];
        _taskNameLabel.textColor = kColorRGB(51, 51, 51, 1);
        _taskNameLabel.numberOfLines = 0;
        [self.contentView addSubview:_taskNameLabel];
        _taskNameLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(self.contentView, kFit(15)).rightSpaceToView(self.contentView, kFit(25)).autoHeightRatio(0);
        [_taskNameLabel updateLayout];
        
        self.timeImageView = [[UIImageView alloc] init];
        _timeImageView.image = [UIImage imageNamed:@"DJ_myTask_taskTime"];
        _timeImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_timeImageView];
        
        self.timeImageView.sd_layout.leftSpaceToView(self.contentView, kFit(15.5)).topSpaceToView(_taskNameLabel, kFit(15)).widthIs(kFit(14)).heightIs(kFit(14 + 5.6));
        self.taskTimeLabel = [UILabel new];
        _taskTimeLabel.text = @"";
        _taskTimeLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(14)];
        _taskTimeLabel.numberOfLines = 0;
        _taskTimeLabel.textColor =  kColorRGB(51, 51, 51, 1);
        [self.contentView addSubview:_taskTimeLabel];
        _taskTimeLabel.sd_layout.leftSpaceToView(_timeImageView, 6).topSpaceToView(_taskNameLabel, kFit(15)).rightSpaceToView(self.contentView, kFit(25)).autoHeightRatio(0);

       
        self.tagImageView = [[UIImageView alloc] init];
        _tagImageView.image = [UIImage imageNamed:@"DJ_myTask_taskTag"];
        _tagImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_tagImageView];
        _tagImageView.sd_layout.leftSpaceToView(self.contentView, kFit(15.5)).topSpaceToView(_taskTimeLabel, kFit(15)).widthIs(kFit(14)).heightIs(kFit(14+ 5.6));
        self.taskTagLabel = [[UILabel alloc] init];
        _taskTagLabel.text = @"周任务";
        _taskTagLabel.numberOfLines = 0;
        _taskTagLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(14)];
        _taskTagLabel.textColor =  kColorRGB(51, 51, 51, 1);
        [self.contentView addSubview:_taskTagLabel];
        _taskTagLabel.sd_layout.leftSpaceToView(_tagImageView, 6).topSpaceToView(_taskTimeLabel, kFit(15)).rightSpaceToView(self.contentView, kFit(25)).autoHeightRatio(0);

        self.contentImageView = [[UIImageView alloc] init];
        _contentImageView.image = [UIImage imageNamed:@"DJ_myTask_taskContent"];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_contentImageView];
        _contentImageView.sd_layout.leftSpaceToView(self.contentView, kFit(15.5)).topSpaceToView(_taskTagLabel, kFit(15)).widthIs(kFit(14)).heightIs(kFit(14+ 5.6));

        self.taskContentLabel = [UILabel new];
        _taskContentLabel.textColor = kColorRGB(51, 51, 51, 1);
        _taskContentLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(14)];
        _taskContentLabel.numberOfLines = 0;
        _taskContentLabel.text = @"";
        [self.contentView addSubview:_taskContentLabel];
        _taskContentLabel.sd_layout.leftSpaceToView(_contentImageView, 6).topSpaceToView(_taskTagLabel, kFit(15)).rightSpaceToView(self.contentView, kFit(25)).autoHeightRatio(0);

        
        [self setCollectionView];
    }
    return self;
}
- (void)setImageMArray:(NSMutableArray *)imageMArray {
    
 
    
}

-(NSString *)calulateImageFileSize:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        data = UIImageJPEGRepresentation(image, 1.0);//
    }
    double dataLength = [data length] * 1.0;
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    return [NSString stringWithFormat:@"%.3f %@", dataLength, typeArray[index]];
}

- (void)setModel:(IReceivedTaskModel *)model {
    _model = model;
    _taskNameLabel.text = model.taskName;
    _taskTimeLabel.text = [NSString stringWithFormat:@"%@—%@", model.startDate, model.endDate];
    _taskTagLabel.text = model.tags;
    _taskContentLabel.text = model.taskContent;
    NSString *imageStr = model.taskImg;
    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < imageArray.count; i ++) {
        NSString  *url = imageArray[i];
        if (url.length == 0 || url == nil || url == NULL) {
            
        }else {
            [tempArray addObject:url];
        }
    }
    __weak typeof(self) weakSelf = self;
    if ([_taskTagLabel.text isEmpty]) {//标签为空
        _tagImageView.alpha = 0.0;
        if (tempArray.count == 0) {//图片为空
            _contentImageView.sd_layout.leftSpaceToView(self.contentView, kFit(15.5)).topSpaceToView(_taskTimeLabel, kFit(15)).widthIs(kFit(14)).heightIs(kFit(14+ 5.6));
            _taskContentLabel.sd_layout.leftSpaceToView(_contentImageView, 6).topSpaceToView(_taskTimeLabel, kFit(15)).rightSpaceToView(self.contentView, kFit(25)).autoHeightRatio(0);
            [weakSelf setupAutoHeightWithBottomView:_taskContentLabel bottomMargin:kFit(15)];
            _collectionView.alpha = 0.0;
        }else {
            _contentImageView.sd_layout.leftSpaceToView(self.contentView, kFit(15.5)).topSpaceToView(_taskTimeLabel, kFit(15)).widthIs(kFit(14)).heightIs(kFit(14+ 5.6));
            _taskContentLabel.sd_layout.leftSpaceToView(_contentImageView, 6).topSpaceToView(_taskTimeLabel, kFit(15)).rightSpaceToView(self.contentView, kFit(25)).autoHeightRatio(0);
            [weakSelf setupAutoHeightWithBottomView:_collectionView bottomMargin:kFit(15)];
            _collectionView.alpha = 1.0;
        }
    }else {
        if (![[CommonUtil taskTagsHanziWithLetter:model.tags] isEmpty]) {
            _taskTagLabel.text = [CommonUtil taskTagsHanziWithLetter:model.tags];
        }
        if (tempArray.count == 0) {//图片为空
            [weakSelf setupAutoHeightWithBottomView:_taskContentLabel bottomMargin:kFit(15)];
            _collectionView.alpha = 0.0;
        }else {
            _taskContentLabel.sd_layout.leftSpaceToView(_contentImageView, 6).topSpaceToView(_taskTagLabel, kFit(15)).rightSpaceToView(self.contentView, kFit(25)).autoHeightRatio(0);
            [weakSelf setupAutoHeightWithBottomView:_collectionView bottomMargin:kFit(15)];
            _collectionView.alpha = 1.0;
        }
    }
    
    if (_datArray.count != 0) {
        
    }else {
        [_viewArray removeAllObjects];
        weakSelf.datArray = tempArray;
        
        for (int i = 0; i <_datArray.count; i ++) {
            NSString  * imageURL;
            if ([self.datArray[i] isURL]) {
                imageURL=[NSString stringWithFormat:@"%@",_datArray[i]];
            }else {
                imageURL=[NSString stringWithFormat:@"%@%@",_model.dfsUrl,_datArray[i]];
            }
            LBPhotoWebItem *item = [[LBPhotoWebItem alloc]initWithURLString:imageURL frame:self.frame];
            item.placeholdImage = [UIImage imageNamed:@"DJ_Load_network_image_default"];
            [self.viewArray addObject:item];
        }
         [_collectionView reloadData];
    }

}


//点击图片
- (void)handleImageClick:(UITapGestureRecognizer *)tap {
    

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (void)setCollectionView {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //添加页眉
    // [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置页眉的高度
    layout.minimumInteritemSpacing = kFit(10);
    layout.minimumLineSpacing = kFit(10);
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView .dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.contentView addSubview:_collectionView];
    _collectionView.sd_layout.topSpaceToView(_taskContentLabel, 0).heightIs(120).leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *imageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 105, 105)];
    imageVIew.contentMode = UIViewContentModeScaleAspectFill;
    imageVIew.clipsToBounds = YES;
    
    NSString  * imageURL;
            if ([self.datArray[indexPath.row] isURL]) {
                imageURL=[NSString stringWithFormat:@"%@",self.datArray[indexPath.row]];
            }else {
                imageURL=[NSString stringWithFormat:@"%@%@",_model.dfsUrl,self.datArray[indexPath.row]];
            }    
    [imageVIew sd_setImageWithURL: [NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"DJ_Load_network_image_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:0.1 animations:^{
            
        }];
    }];
    [cell.contentView addSubview:imageVIew];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"self.viewArray%@", self.viewArray);
        [[LBPhotoBrowserManager.defaultManager showImageWithWebItems:self.viewArray selectedIndex:indexPath.row fromImageViewSuperView:_collectionView] addCollectionViewLinkageStyle:UICollectionViewScrollPositionCenteredHorizontally cellReuseIdentifier:@"UICollectionViewCell"];
}
//返回每个cell的布局左右上下间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(0, kFit(15), 0, kFit(15));
}
//单独返回每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(105,105);
}


-(void)dealloc {
    
    NSLog(@"DJMyTaskInfoTableViewCell dealloc");
    
}

@end
