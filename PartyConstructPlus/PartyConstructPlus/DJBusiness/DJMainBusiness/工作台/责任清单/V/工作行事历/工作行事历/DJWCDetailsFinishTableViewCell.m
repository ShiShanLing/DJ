//
//  DJWCDetailsFinishTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/15.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJWCDetailsFinishTableViewCell.h"

@interface DJWCDetailsFinishTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

/**
 *
 */
@property (nonatomic, strong)UICollectionView * collectionView;

/**
 *
 */
@property (nonatomic, strong)NSMutableArray *ImageMArray;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * imageURLArray;
@end

@implementation DJWCDetailsFinishTableViewCell

- (NSMutableArray *)imageURLArray {
    if (!_imageURLArray) {
        _imageURLArray = [NSMutableArray array];
    }
    return _imageURLArray;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentLabel = [UILabel new];
        _contentLabel.textColor = kColorRGB(51, 51, 51, 1);
        _contentLabel.font = MFont(kFit(14));
        _contentLabel.text = @"执行情况说明执行情况说明执行情况说明执行情况说明执行情况说明执行情况说明执行情况说明执行情况说明说明执行情况说明";
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        _contentLabel.sd_layout.leftSpaceToView(self.contentView, kFit(20)).topSpaceToView(self.contentView, kFit(13)).rightSpaceToView(self.contentView, kFit(20)).autoHeightRatio(0);
        
        self.timeLabel =[UILabel new];
        _timeLabel.textColor = kColorRGB(136, 136, 136, 1);
        _timeLabel.text = @"2018.10.01—2018.12.31";
        _timeLabel.font = MFont(kFit(14));
        [self.contentView addSubview:_timeLabel];
        _timeLabel.sd_layout.leftEqualToView(_contentLabel).topSpaceToView(_contentLabel, kFit(10)).rightSpaceToView(self.contentView, kFit(20)).heightIs(kFit(14));
        
        self.imageShowView  =[UIView new];
        _imageShowView.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_imageShowView];
        _imageShowView.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).topSpaceToView(_timeLabel, kFit(15)).heightIs(kFit(105));

        UILabel *dividerLabel = [UILabel new];
        dividerLabel.backgroundColor = kCellColorDivider;
        [self.contentView addSubview:dividerLabel];
        dividerLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).bottomSpaceToView(self.contentView, 0).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
        [self setCollectionView];
        
        [self setupAutoHeightWithBottomView:_imageShowView bottomMargin:kFit(15)];
    }
    return self;
}

- (void)setModel:(AgendaWorkingCalendarListModel *)model {
    _contentLabel.text =model.doMsg;
    _timeLabel.text = [NSString stringWithFormat:@"%@—%@", model.beginTime, model.endTime];
    _model = model;
    NSString *imageStr  =_model.doImg;
    NSArray *imageArray = [CommonUtil segmentationStr:imageStr keyword:@","];
    _ImageMArray = [NSMutableArray arrayWithArray:imageArray];
    NSLog(@"清除之前_ImageMArray%@", _ImageMArray);
    for (int i = 0 ; i <  _ImageMArray.count; i ++) {
        NSString *imageStr =  _ImageMArray[i];
        NSLog(@"_ImageMArray[i]%@", _ImageMArray[i]);
        if (imageStr.length == 0 || imageStr == nil || imageStr == NULL) {
            [_ImageMArray removeObjectAtIndex:i];
        }
    }
    NSLog(@"清除之后_ImageMArray%@imageStr>%@model.doMsg%@>", _ImageMArray, imageStr, model.doMsg);
    if (_ImageMArray.count == 0) {
        if (_contentLabel.text.length == 0) {
            _contentLabel.text = @"已完成";
        }
        _imageShowView.hidden = YES;
        [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:kFit(15)];
    }else {
        _imageShowView.hidden = NO;
        [self setupAutoHeightWithBottomView:_imageShowView bottomMargin:kFit(15)];
        [self.imageURLArray removeAllObjects];
        [_collectionView reloadData];
    }
    
    
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
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//横向
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = kFit(10);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(105)) collectionViewLayout:layout];
    _collectionView .dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.imageShowView addSubview:_collectionView];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.ImageMArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode  = UIViewContentModeScaleAspectFill;
    NSString *imageURLStr= self.ImageMArray[indexPath.row];
    if ([imageURLStr isURL]) {
        
    }else {
        imageURLStr = [NSString stringWithFormat:@"%@%@", self.model.dfsUrl, imageURLStr];
    }
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageURLStr] placeholderImage:[UIImage imageNamed:@"DJ_imageLoadFailed"]];
    imageView.frame = CGRectMake(0, 0, cell.width, cell.height);
    [cell addSubview:imageView];
    
    LBPhotoWebItem *item = [[LBPhotoWebItem alloc]initWithURLString:imageURLStr frame:imageView.frame];
    item.placeholdImage = [UIImage imageNamed:@"DJ_Load_network_image_default"];
    [self.imageURLArray addObject:item];
    NSLog(@"cell的frame%f", imageView.height);

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
       [LBPhotoBrowserManager.defaultManager showImageWithWebItems:self.imageURLArray selectedIndex:indexPath.row fromImageViewSuperView:cell].lowGifMemory = YES;
//    if ([_delegate respondsToSelector:@selector(ClickImageIndex:cell:)]) {
//        [_delegate ClickImageIndex:indexPath.row cell:self];
//    }
}
//返回每个cell的布局左右上下间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return  UIEdgeInsetsMake(0, 10, 0, 12);
    
}
//单独返回每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(kFit(105), kFit(105));
    
}


@end
