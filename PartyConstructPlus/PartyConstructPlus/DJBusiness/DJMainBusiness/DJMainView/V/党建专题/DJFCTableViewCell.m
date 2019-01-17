//
//  DJFCTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJFCTableViewCell.h"
#import "DJFCModuleCollectionViewCell.h"

@interface DJFCTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;
/**
 *可变数组
 */
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation DJFCTableViewCell
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSArray *tempArray = @[
  @{@"icon":@"DJ_main_thematicPartyDay",@"title":@"主题党日",@"subtitle":@"我是一个副标题"},
  @{@"icon":@"2Learn1do",@"title":@"两学一做",@"subtitle":@"我是一个副标题"},
  @{@"icon":@"3meeting1courses",@"title":@"三会一课",@"subtitle":@"我是一个副标题"},
  ];
        self.dataArray = [NSMutableArray arrayWithArray:tempArray];
        [self setCollectionView];
    }
    return self;
}


- (void)setCollectionView {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"党建专题";
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(17)];
    titleLabel.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    [self.contentView addSubview:titleLabel];
    titleLabel.sd_layout.leftSpaceToView(self.contentView, 10+kFit(10)).topSpaceToView(self.contentView, kFit(25)).widthIs(100).heightIs(kFit(17));
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //添加页眉

    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = kFit(10);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
 
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView .dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[DJFCModuleCollectionViewCell class] forCellWithReuseIdentifier:@"DJFCModuleCollectionViewCell"];
    [self.contentView addSubview:_collectionView];
    _collectionView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(titleLabel, kFit(15                                      )).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, kFit(4));
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DJFCModuleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DJFCModuleCollectionViewCell" forIndexPath:indexPath];
    cell.dataDic = self.dataArray[indexPath.row];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(ClickGracefulBearingModule:)]) {
        [_delegate ClickGracefulBearingModule:indexPath.row];
    }
}
//返回每个cell的布局左右上下间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return  UIEdgeInsetsMake(0, 14, 0, 14);
    
}
//单独返回每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
        return CGSizeMake(kFit(155), kFit(83));
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
