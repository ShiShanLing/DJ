//
//  DJAllModuleShowViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/30.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJAllModuleShowViewController.h"
#import "DJCoreDataManager.h"
#import "ShowcaseModel+CoreDataProperties.h"
#import "DJButton.h"
#import "DJCustomModuleShowCVCell.h"
#import "DJCustomModuleCollectionReusableView.h"
#import "DJCustomModuleNavigationBarView.h"
#define kCellLeft_RightSpacing 7.5  //第一个cell和最后一个cell距离view的距离
#define kCellW  (kScreenWidth -kCellLeft_RightSpacing*2) /4
#define kCellH  (kCellW / 9 *10)
static BOOL  isEditor;
@interface DJAllModuleShowViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, DJCustomModuleShowCVCellDelegate>

@property (nonatomic, strong)UICollectionView *SelectedCollectionView;
@property (nonatomic, strong)UICollectionView *AllCollectionView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *cellAttributesArray;
/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
/**
 *编辑状态导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView * editorNavigationBarView;

@end

@implementation DJAllModuleShowViewController{
    NSIndexPath *_originalIndexPath;
    NSIndexPath *_moveIndexPath;
    
    UIView *_snapshotView;
    
}

- (NSMutableArray *)cellAttributesArray{
    if (!_cellAttributesArray) {
        self.cellAttributesArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _cellAttributesArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ShowcaseModel *showcaseModelOne = [NSEntityDescription insertNewObjectForEntityForName:@"ShowcaseModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
    showcaseModelOne.title = @"已选";
    
    NSMutableArray *selectedTempArray = [NSMutableArray array];
    
    for (int i = 0; i <self.selectedArray.count ; i ++) {
        ConfigModuleModel *tempModel = self.selectedArray[i];
        ConfigModuleModel * newModel = [NSEntityDescription insertNewObjectForEntityForName:@"ConfigModuleModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        
        newModel.moduleId =tempModel.moduleId;
        newModel.moduleName = tempModel.moduleName;
        newModel.moduleImage = tempModel.moduleImage;
        newModel.state = tempModel.state;
        newModel.turn = tempModel.turn;
        newModel.url = tempModel.url;
        newModel.dfsUrl = tempModel.dfsUrl;
        newModel.isDefault = tempModel.isDefault;
        [selectedTempArray addObject:newModel ];
    }
    NSMutableArray *AllTempArray = [NSMutableArray array];
    for (int i = 0; i <self.AllArray.count ; i ++) {
        ConfigModuleModel *tempModel = self.AllArray[i];
        ConfigModuleModel * newModel = [NSEntityDescription insertNewObjectForEntityForName:@"ConfigModuleModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        
        newModel.moduleId =tempModel.moduleId;
        newModel.moduleName = tempModel.moduleName;
        newModel.moduleImage = tempModel.moduleImage;
        newModel.state = tempModel.state;
        newModel.turn = tempModel.turn;
        newModel.url = tempModel.url;
        newModel.dfsUrl = tempModel.dfsUrl;
        newModel.isDefault = tempModel.isDefault;
        [AllTempArray addObject:newModel];
    }
    
    
    NSLog(@"self.AllArray%@AllTempArray%@", self.AllArray , AllTempArray);
    for (int i = 0 ;i < self.AllArray.count; i ++) {
        ConfigModuleModel *tempModel = self.AllArray[i];
        NSLog(@" tempModel.dfsUrl  %@%@", tempModel.dfsUrl, tempModel.moduleImage);
    }
    showcaseModelOne.itemArray = [selectedTempArray mutableCopy];
    ShowcaseModel *showcaseModelTwo = [NSEntityDescription insertNewObjectForEntityForName:@"ShowcaseModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
    showcaseModelTwo.title = @"全部";
    showcaseModelTwo.itemArray = AllTempArray;
    [self.dataArray addObject:showcaseModelOne];

    [self.dataArray addObject:showcaseModelTwo];
    isEditor = YES;//默认为YES
    [self.SelectedCollectionView reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollectionView];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorRGB(246, 246, 246, 1);
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.rightBtn addTarget:self action:@selector(handleStartEditing:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    
    
    self.editorNavigationBarView =  [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.editorNavigationBarView.leftBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [self.editorNavigationBarView.leftBtn addTarget:self action:@selector(handleEditorCancel) forControlEvents:(UIControlEventTouchUpInside)];
    //    self.editorNavigationBarView.hidden = YES;
    self.editorNavigationBarView.alpha = 0.0;
    [self.editorNavigationBarView.rightBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    self.editorNavigationBarView.titleLabel.text = @"编辑";
    [self.editorNavigationBarView.rightBtn addTarget:self action:@selector(editComplete:) forControlEvents:(UIControlEventTouchUpInside)];
    self.editorNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.editorNavigationBarView];
    
    
    [self.SelectedCollectionView reloadData];
}

- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (NSMutableArray *)AllArray {
    if (!_AllArray) {
        _AllArray = [NSMutableArray array];
    }
    return _AllArray;
}
//取消编辑
- (void)handleEditorCancel {
    isEditor = YES;
    CGRect frame = _AllCollectionView.frame;
    frame.origin.y = kStatusBarAndNavigationBarHeight-kFit(46);
    __weak __typeof(self) weakself= self;
    [UIView animateWithDuration:0.5 animations:^{
        [weakself.AllCollectionView reloadData];
        weakself.SelectedCollectionView.alpha = 0.0;
        weakself.editorNavigationBarView.alpha = 0.0;
        weakself.defaultNavigationBarView.alpha = 1;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 animations:^{
            weakself.AllCollectionView.frame = frame;
        }];
    }];
    
    NSMutableArray *selectedTempArray = [NSMutableArray array];
    
    for (int i = 0; i <self.selectedArray.count ; i ++) {
        ConfigModuleModel *tempModel = self.selectedArray[i];
        ConfigModuleModel * newModel = [NSEntityDescription insertNewObjectForEntityForName:@"ConfigModuleModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        
        newModel.moduleId =tempModel.moduleId;
        newModel.moduleName = tempModel.moduleName;
        newModel.moduleImage = tempModel.moduleImage;
        newModel.state = tempModel.state;
        newModel.turn = tempModel.turn;
        newModel.url = tempModel.url;
        newModel.dfsUrl = tempModel.dfsUrl;
        newModel.isDefault = tempModel.isDefault;
        [selectedTempArray addObject:newModel ];
    }
    NSMutableArray *AllTempArray = [NSMutableArray array];
    for (int i = 0; i <self.AllArray.count ; i ++) {
        ConfigModuleModel *tempModel = self.AllArray[i];
        ConfigModuleModel * newModel = [NSEntityDescription insertNewObjectForEntityForName:@"ConfigModuleModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        
        newModel.moduleId =tempModel.moduleId;
        newModel.moduleName = tempModel.moduleName;
        newModel.moduleImage = tempModel.moduleImage;
        newModel.state = tempModel.state;
        newModel.turn = tempModel.turn;
        newModel.url = tempModel.url;
        newModel.dfsUrl = tempModel.dfsUrl;
        newModel.isDefault = tempModel.isDefault;
        [AllTempArray addObject:newModel ];
    }
    
    
    ShowcaseModel *showcaseModelOne = [NSEntityDescription insertNewObjectForEntityForName:@"ShowcaseModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
    showcaseModelOne.title = @"已选";
    showcaseModelOne.itemArray = selectedTempArray;
    ShowcaseModel *showcaseModelTwo = [NSEntityDescription insertNewObjectForEntityForName:@"ShowcaseModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
    showcaseModelTwo.title = @"全部";
    showcaseModelTwo.itemArray =  AllTempArray;
    
    
    self.dataArray[0] = showcaseModelOne;
    self.dataArray[1] = showcaseModelTwo;
    isEditor = YES;//默认为YES
    [self.SelectedCollectionView reloadData];
    self.AllCollectionView.frame = frame;
    
}
//完成编辑
- (void)editComplete:(UIButton *)sender {
    isEditor = YES;
    CGRect frame = _AllCollectionView.frame;
    frame.origin.y = kStatusBarAndNavigationBarHeight -kFit(46);
    __weak __typeof(self) weakself= self;
    [UIView animateWithDuration:0.5 animations:^{
        [weakself.SelectedCollectionView reloadData];
        [weakself.AllCollectionView reloadData];
        weakself.SelectedCollectionView.alpha = 0.0;
        weakself.editorNavigationBarView.alpha = 0.0;
        weakself.defaultNavigationBarView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            weakself.AllCollectionView.frame = frame;
        }];
    }];
    
    if (isEditor) {
        ShowcaseModel *defaultModel = self.dataArray[0];//获取默认展示的model
        NSMutableArray  *tempArray = [NSMutableArray arrayWithArray:(NSMutableArray *)defaultModel.itemArray];
        NSString *defaultModuleId = @"";
        for ( int i = 0; i < tempArray.count; i ++) {
            ConfigModuleModel *tempItmeModel = tempArray[i];
            defaultModuleId = [NSString stringWithFormat:@"%@,%@", defaultModuleId, tempItmeModel.moduleId];
        }
        [DJUserTool setUserCustomModule:defaultModuleId];
    }
    
    [self.SelectedCollectionView reloadData];
    [self.AllCollectionView reloadData];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleStartEditing:(UIButton *)sender {
    isEditor = NO;
    CGRect frame = _AllCollectionView.frame;
    if (self.selectedArray.count/4.0 >1) {
        frame.origin.y = kStatusBarAndNavigationBarHeight + kFit(165) + 10 +kCellH+10;
    }else {
        frame.origin.y = kStatusBarAndNavigationBarHeight + kFit(165) + 10;
    }
    [self.SelectedCollectionView reloadData];
    [self.AllCollectionView reloadData];
    __weak __typeof(self) weakself= self;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.AllCollectionView.frame = frame;
        weakself.editorNavigationBarView.alpha = 1;
        weakself.defaultNavigationBarView.alpha = 0.0;
        weakself.SelectedCollectionView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        
    }];
    
}

- (void)handleReturnBtn:(UIButton *)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setCollectionView {
    
    UICollectionViewFlowLayout *Selectedlayout = [[UICollectionViewFlowLayout alloc] init];
    Selectedlayout.itemSize = CGSizeMake(kCellW, kCellH);
    Selectedlayout.minimumLineSpacing = 0.0;
    Selectedlayout.minimumInteritemSpacing = 0.0;
    Selectedlayout.headerReferenceSize = CGSizeMake(kScreenWidth, kFit(46));
    CGFloat differenceY = 0;
    if (!kiPhoneX) {
        differenceY = 20;
    }else {
        differenceY  = 0;
    }
    
    CGFloat  selectedTableViewHeight;
    if (self.selectedArray.count/4.0 >1) {
        selectedTableViewHeight =  kFit(165)+differenceY+kCellH+10;
    }else {
        selectedTableViewHeight = kFit(165)+differenceY;
    }
    
    self.SelectedCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight-differenceY, kScreenWidth, selectedTableViewHeight) collectionViewLayout:Selectedlayout];
    
    _SelectedCollectionView .dataSource = self;
    _SelectedCollectionView.delegate = self;
    _SelectedCollectionView.bounces = NO;
    
    _SelectedCollectionView.alpha = 0.0;
    _SelectedCollectionView.scrollEnabled = NO;
    _SelectedCollectionView.showsVerticalScrollIndicator = NO;
    self.SelectedCollectionView.backgroundColor = [UIColor whiteColor];
    [_SelectedCollectionView registerClass:[DJCustomModuleShowCVCell class] forCellWithReuseIdentifier:@"DJCustomModuleShowCVCell"];
    
    [_SelectedCollectionView registerClass:[DJCustomModuleCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DJCustomModuleCollectionReusableView"];
    [self.view addSubview:_SelectedCollectionView];
    
    
    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kCellW, kCellH);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, kFit(46));
    layout.footerReferenceSize = CGSizeMake(kScreenWidth, kScreenHeight-276);
    
    self.AllCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,  kStatusBarAndNavigationBarHeight-kFit(46), kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    _AllCollectionView .dataSource = self;
    _AllCollectionView.delegate = self;
    _AllCollectionView.scrollEnabled = NO;
    
    _AllCollectionView.showsVerticalScrollIndicator = NO;
    _AllCollectionView.backgroundColor = [UIColor whiteColor];
    [_AllCollectionView registerClass:[DJCustomModuleShowCVCell class] forCellWithReuseIdentifier:@"DJCustomModuleShowCVCell"];
    [_AllCollectionView registerClass:[DJCustomModuleCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DJCustomModuleCollectionReusableView"];
    [_AllCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"];
    [self.view addSubview:_AllCollectionView];
    
    
    UILongPressGestureRecognizer *longPressSelected = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelectedLPGR:)];
    [_SelectedCollectionView addGestureRecognizer:longPressSelected];
    UILongPressGestureRecognizer *longPressAll = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelectedLPGR:)];
    [_AllCollectionView addGestureRecognizer:longPressAll];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == self.SelectedCollectionView ) {
        ShowcaseModel *tempModel = self.dataArray[0];
        NSArray *tempArray = (NSArray *)tempModel.itemArray;
        if (tempArray.count <self.AllArray.count) {
            return tempArray.count +1;
        }else {
            return tempArray.count;
        }
    }else {
        ShowcaseModel *tempModel = self.dataArray[1];
        NSArray *tempArray = (NSArray *)tempModel.itemArray;
        return tempArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath.row%d", indexPath.row);
    DJCustomModuleShowCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DJCustomModuleShowCVCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.editorStateBtn.hidden = isEditor;
    cell.editorColorView.hidden = isEditor;
    
    if (collectionView == self.SelectedCollectionView ) {
        
        ShowcaseModel *tempModel = self.dataArray[0];
        NSArray *tempArray = (NSArray *)tempModel.itemArray;
        if (indexPath.row == tempArray.count && !isEditor) {
            cell.defaultImageView.hidden = NO;
        }else {
            cell.defaultImageView.hidden = YES;
        }
        [cell assignmentModel:tempModel indexPath:indexPath];
        return cell;
    }else {
        ShowcaseModel *tempModel = self.dataArray[1];
        cell.defaultImageView.hidden = YES;
        NSArray *tempArray = (NSArray *)tempModel.itemArray;
        [cell assignmentModel:tempModel indexPath:indexPath];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![DJUserTool userIsLogin]) {
        [self userLogIn];
        return;
    }
    if (collectionView == self.AllCollectionView && isEditor == YES) {
        ShowcaseModel *tempModel = self.dataArray[1];
        NSArray *tempArray = (NSArray *)tempModel.itemArray;
        ConfigModuleModel  * model = tempArray[indexPath.row];
        [self pushViewControllerAccordingUrl:model.url];
    }
    
}
//返回每个cell的布局左右上下间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, kCellLeft_RightSpacing, 10, kCellLeft_RightSpacing);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind ==UICollectionElementKindSectionHeader) {
        DJCustomModuleCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DJCustomModuleCollectionReusableView" forIndexPath:indexPath];
        if (collectionView == self.SelectedCollectionView) {
            headView.titleLabel.text =@"我的党建工作";
            
        }else {
            if (!isEditor) {
                
                headView.titleLabel.text =@"全部模块";
            }else {
                
                headView.titleLabel.text =@"";
            }
            
        }
        return headView;
    }else {
        if (collectionView == self.SelectedCollectionView) {
            return nil;
        }else {
            UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
            footerView.backgroundColor= kColorRGB(246, 246, 246, 1);
            return footerView;
        }
    }
}
#pragma  mark   ShowcaseCVCellDelegate   该表cell数据
- (void)operationItmeIndexPath:(NSIndexPath *)indexPath  cell:(DJCustomModuleShowCVCell *)cell{
    __weak __typeof(self) weakself= self;
    
    UICollectionView *tempCollectionView  = (UICollectionView *)cell.superview ;
    if (tempCollectionView == self.SelectedCollectionView) {//如果点击的是已选项那么就是删除
        ShowcaseModel *showcaseModel = self.dataArray[0];//某个分组
        NSMutableArray  *itmeArray = [NSMutableArray arrayWithArray:(NSMutableArray *)showcaseModel.itemArray];
        ConfigModuleModel *itmeModel = itmeArray[indexPath.row];//所点击的这个cell对应的数据
        
        [itmeArray removeObjectAtIndex:indexPath.row];
        showcaseModel.itemArray = itmeArray;
        //改变全部数组里面的改数据的状态
        //更改全部item里面的改选项状态
        ShowcaseModel *tempModel = self.dataArray[1];//所有的数据model
        NSMutableArray  *tempArray = [NSMutableArray arrayWithArray:(NSMutableArray *)tempModel.itemArray];//所有的数据
        for (int i = 0; i <tempArray.count ; i ++) {
            ConfigModuleModel *tempItmeModel = tempArray[i];
            if ([tempItmeModel.moduleId isEqualToString:itmeModel.moduleId]) {//如果这个 moduleId = 所点击的这个 moduleId
                //那么就把这个 选中状态置未 0 并刷新数据
                tempItmeModel.isDefault = @"0";
                tempArray[indexPath.row] = tempItmeModel;
            }
        }
        NSLog(@"itmeArray%@", itmeArray);
        if (itmeArray.count >= 4) {
            [self refreshPageHeight:0];
        }else {
            [self refreshPageHeight:1];
        }
            [weakself.SelectedCollectionView reloadData];
            [weakself.AllCollectionView reloadData];
    }else {//否者就是点击的全部选项里面的按钮
        //没有被选了就做响应
        ShowcaseModel *showcaseModel = self.dataArray[1];//某个分组
        NSMutableArray  *itmeArray = [NSMutableArray arrayWithArray:(NSMutableArray *)showcaseModel.itemArray];
        
        ConfigModuleModel *itmeModel = itmeArray[indexPath.row];//所点击的这个cell对应的数据
        if (![itmeModel.isDefault isEqualToString:@"1"]) {
            ShowcaseModel *tempModel = self.dataArray[0];
            NSMutableArray  *tempArray = [NSMutableArray arrayWithArray:(NSMutableArray *)tempModel.itemArray];

            itmeModel.isDefault = @"1";
            [tempArray addObject:itmeModel];
            tempModel.itemArray = tempArray;
            //动画实现
            if (tempArray.count >= 4) {
                [self refreshPageHeight:0];
            }else {
                [self refreshPageHeight:1];
            }
            [self.SelectedCollectionView layoutIfNeeded];//刷新布局
                [weakself.SelectedCollectionView reloadData];//刷新界面
                [weakself.AllCollectionView reloadData];
            
        }else {
            
            ShowcaseModel *defaultModel = self.dataArray[0];//获取默认展示的model
            ShowcaseModel *AllModel = self.dataArray[1];//获取默认展示的model
            
            NSMutableArray  *defaultItmeArray = [NSMutableArray arrayWithArray:(NSMutableArray *)defaultModel.itemArray];
            NSMutableArray  *AllItmeArray = [NSMutableArray arrayWithArray:(NSMutableArray *)AllModel.itemArray];
            
            for (int i = 0; i <AllItmeArray.count ; i ++) {
                ConfigModuleModel *tempItmeModel = AllItmeArray[i];
                if ([tempItmeModel.moduleId isEqualToString:itmeModel.moduleId]) {//如果这个 moduleId = 所点击的这个 moduleId
                    //那么就把这个 选中状态置未 0 并刷新数据
                    tempItmeModel.isDefault = @"0";
                    AllItmeArray[indexPath.row] = tempItmeModel;
                    break;
                }
            }
            
            NSInteger deleteCellIndex = 0;
            for (int i = 0; i  < defaultItmeArray.count; i ++) {
                ConfigModuleModel *tempItmeModel = defaultItmeArray[i];
                if ([tempItmeModel.moduleId isEqualToString:itmeModel.moduleId]) {//如果这个 moduleId = 所点击的这个 moduleId
                    deleteCellIndex = i;
                    //那么就把这个 选中状态置未 0 并刷新数据
                    [defaultItmeArray removeObjectAtIndex:i];
                    defaultModel.itemArray = defaultItmeArray;
                    self.dataArray[0] =defaultModel;
                    break;
                }
            }

            if (defaultItmeArray.count <= 3) {
                [self refreshPageHeight:1];
            }else {
                [self refreshPageHeight:0];
            }
           
                [weakself.SelectedCollectionView reloadData];
                [weakself.AllCollectionView reloadData];
        }
    }
    
    ShowcaseModel *showcaseModel = self.dataArray[0];//某个分组
    NSMutableArray  *defaultItmeArray = [NSMutableArray arrayWithArray:(NSMutableArray *)showcaseModel.itemArray];
    if (defaultItmeArray.count == 0) {
        [self.editorNavigationBarView.rightBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        self.editorNavigationBarView.rightBtn.userInteractionEnabled = NO;
    }else {
        [self.editorNavigationBarView.rightBtn setTitleColor:kColorRGB(30, 139, 223, 1) forState:(UIControlStateNormal)];
        self.editorNavigationBarView.rightBtn.userInteractionEnabled = YES;
    }
    
}
#pragma mark - 长按手势  cell换位置 --- 暂时没有用
- (void)handleSelectedLPGR:(UILongPressGestureRecognizer *)recognizer {
    
    CGPoint touchPoint = [recognizer locationInView:self.SelectedCollectionView];
    _moveIndexPath = [self.SelectedCollectionView indexPathForItemAtPoint:touchPoint];//根据当前手指位置判断所长按的cell位置
    
    switch (recognizer.state) {
            
        case UIGestureRecognizerStateBegan: {
            
            if (isEditor == YES) {
                isEditor = NO;
                [self.SelectedCollectionView reloadData];
                [self.SelectedCollectionView layoutIfNeeded];
            }
            
            if (recognizer.view == self.SelectedCollectionView){
                
                DJCustomModuleShowCVCell *selectedItemCell = (DJCustomModuleShowCVCell *)[self.SelectedCollectionView cellForItemAtIndexPath:_moveIndexPath];
                _originalIndexPath = [self.SelectedCollectionView indexPathForItemAtPoint:touchPoint];
                if (!_originalIndexPath) {
                    return;
                }
                _snapshotView = [selectedItemCell.contentView snapshotViewAfterScreenUpdates:YES];
                _snapshotView.center = [recognizer locationInView:self.SelectedCollectionView];
                [self.SelectedCollectionView addSubview:_snapshotView];
                selectedItemCell.hidden = YES;//隐藏cell
                [UIView animateWithDuration:0.2 animations:^{ //_snapshotView模拟cell的移动
                    _snapshotView.transform = CGAffineTransformMakeScale(1.03, 1.03);
                    _snapshotView.alpha = 0.98;
                }];
            }
            
        } break;
        case UIGestureRecognizerStateChanged: {//位置发生改变
            
            _snapshotView.center = [recognizer locationInView:self.SelectedCollectionView];
            
            if (recognizer.view == self.SelectedCollectionView) {//只让编辑第一个cell
                
                if (_moveIndexPath && ![_moveIndexPath isEqual:_originalIndexPath] && _moveIndexPath.section == _originalIndexPath.section) {
                    
                    ShowcaseModel *showcaseModel = self.dataArray[0];//某个分组
                    NSMutableArray  *itmeArray = [NSMutableArray arrayWithArray:(NSMutableArray *)showcaseModel.itemArray];
                    NSInteger fromIndex = _originalIndexPath.item;
                    NSInteger toIndex = _moveIndexPath.item;
                    if (fromIndex < toIndex) {
                        for (NSInteger i = fromIndex; i < toIndex; i++) {
                            if (i == itmeArray.count-1) {
                                return;
                            }else {
                                [itmeArray exchangeObjectAtIndex:i withObjectAtIndex:i + 1];//交换两个数组下标的数据
                            }
                            
                        }
                    }else{
                        for (NSInteger i = fromIndex; i > toIndex; i--) {
                            if (i == itmeArray.count) {
                                return;
                            }else {
                                [itmeArray exchangeObjectAtIndex:i withObjectAtIndex:i - 1];//交换两个数组下标的数据
                            }
                        }
                    }
                    
                    showcaseModel.itemArray = itmeArray;
                    self.dataArray[0] = showcaseModel;
                    [self.SelectedCollectionView moveItemAtIndexPath:_originalIndexPath toIndexPath:_moveIndexPath];//交换两个cell位置
                    _originalIndexPath = _moveIndexPath;
                }
            }
        } break;
        case UIGestureRecognizerStateEnded: {
            DJCustomModuleShowCVCell *cell = (DJCustomModuleShowCVCell *)[self.SelectedCollectionView cellForItemAtIndexPath:_originalIndexPath] ;
            NSLog(@"_originalIndexPath%d, _originalIndexPath%d", _originalIndexPath.row, _originalIndexPath.section);
            cell.hidden = NO;
            [_snapshotView removeFromSuperview];
        } break;
            
        default: break;
    }
}

/**
 根据用户选择的模块改变布局

 @param state 0  和 1
 */
- (void)refreshPageHeight:(NSInteger)state{
    
   
    
    CGRect frame = _AllCollectionView.frame;
    CGRect seleFrame = _SelectedCollectionView.frame;
    
    CGFloat differenceY = 0;
    if (!kiPhoneX) {
        differenceY = 20;
    }else {
        differenceY  = 0;
    }


    if (state == 0) {
        frame.origin.y = kStatusBarAndNavigationBarHeight + kFit(165) + 10 +kCellH+10;
        seleFrame.size.height =  kFit(165)+differenceY+kCellH+10;
    }else {
        frame.origin.y = kStatusBarAndNavigationBarHeight + kFit(165) + 10;
        seleFrame.size.height = kFit(165)+differenceY;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.AllCollectionView.frame = frame;
        self.SelectedCollectionView.frame = seleFrame;
    } completion:^(BOOL finished) {
        
        
    }];
    
}

-(void)dealloc {
    
    
}

@end
