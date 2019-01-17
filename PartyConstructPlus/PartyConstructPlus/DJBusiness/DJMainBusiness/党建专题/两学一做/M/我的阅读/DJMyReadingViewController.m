//
//  DJMyReadingViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/29.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMyReadingViewController.h"
#import "DJLearnSpeechCollectionViewCell.h"
#import "DJWebPDFViewController.h"
@interface DJMyReadingViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic, strong)UICollectionView *collectionView;
/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * dataArray;
@end

@implementation DJMyReadingViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    _defaultNavigationBarView.titleLabel.text = @"我的阅读";
    self.defaultNavigationBarView.rightBtn.hidden= YES;
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    
    NSArray * tempArray = @[
  @{@"title":@"习近平谈治国理政", @"image":@"http://djzr.hzdj.gov.cn/group1/M00/00/CA/CoYRplpa-W6AZdSDAAHwk7OOT1M334.jpg", @"content":@"http://djzr.hzdj.gov.cn/group1/M00/00/CA/CoYRplpa-gSAZN3VABPPYR4eH3o353.pdf"},
  @{@"title":@"习近平系列重要讲话读本重要讲", @"image":@"http://djzr.hzdj.gov.cn/group1/M00/00/CA/CoYRplpa-qGAbfjPAAAjsG34OxA203.jpg", @"content":@"http://djzr.hzdj.gov.cn/group1/M00/00/CA/CoYRplpa-syAVuiQAA-M1-RlsYg625.pdf"},
  @{@"title":@"之江新语", @"image":@"http://djzr.hzdj.gov.cn/group1/M00/00/CA/CoYRplpa-wWAeKeqAABBKLhX3vU950.jpg", @"content":@"http://djzr.hzdj.gov.cn/group1/M00/00/CA/CoYRplpa-0eACOtrAAYz8sTSxPM287.pdf"}
                            ];
    self.dataArray = [NSMutableArray arrayWithArray:tempArray];
    [self setCollectionView];
}

- (void)handleReturnBtn {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)setCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //添加页眉
    // [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.sectionInset = UIEdgeInsetsMake(-20, 10, 0, 10);//设置页眉的高度
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 15);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) collectionViewLayout:layout];
    _collectionView .dataSource = self;
    _collectionView.delegate = self;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, kTabbarSafeBottomMargin, 0);
    _collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[DJLearnSpeechCollectionViewCell class] forCellWithReuseIdentifier:@"DJLearnSpeechCollectionViewCell"];
    [self.view addSubview:_collectionView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DJLearnSpeechCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DJLearnSpeechCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *tempDic = self.dataArray[indexPath.row];
    [cell.showImageView sd_setImageWithURL:tempDic[@"image"]];
    cell.titleLabel.text =  tempDic[@"title"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *taskDic = self.dataArray[indexPath.section];
    DJWebPDFViewController *webPDFVC= [[DJWebPDFViewController alloc] init];
    webPDFVC.url = taskDic[@"content"];
    webPDFVC.title = taskDic[@"title"];
    [self.navigationController pushViewController:webPDFVC animated:YES];
}
//返回每个cell的布局左右上下间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(0, kFit(25), 0, kFit(25));
}
//单独返回每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth-kFit(100))/3, kFit(190));
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
