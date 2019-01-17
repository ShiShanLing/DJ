//
//  DJMyTaskProgressTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/9.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMyTaskProgressTableViewCell.h"
#import "DJStarsCommentsView.h"
#import "UserData.h"
@interface DJMyTaskProgressTableViewCell ()<UIScrollViewDelegate, DJStarsCommentsViewDelegate>
/**
 *
 */
@property (nonatomic, strong)UIView *ScrollContentView;

@property(nonatomic, strong)UIScrollView *scrollView;
/**
 *
 */
@property (nonatomic, strong)UILabel * lastRightLine;
/**
 *任务状态
 */
@property (nonatomic, strong)UILabel * taskStateLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel * taskTime;
/**
 *任务执行按钮
 */
@property (nonatomic, strong)UIButton * taskPerformBtn;
/**
 *任务请假按钮
 */
@property (nonatomic, strong)UIButton * taskAskLeaveBtn;
/**
 *
 */
@property (nonatomic, strong)UILabel * taskStateDescribeLabel;
/**
 *节点展示
 */
@property (nonatomic, strong)UILabel * nodeLabel;
/**
 *连接线
 */
@property (nonatomic, strong)UILabel * cableLabel;
/**
 *评论的星级view
 */
@property (nonatomic, strong)DJStarsCommentsView * starsView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * imageViewArray;
@end

@implementation DJMyTaskProgressTableViewCell {
    
    NSInteger cellRow;
    
}

- (NSMutableArray *)imageViewArray {
    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
  
        self.nodeLabel = [UILabel new];
        _nodeLabel.backgroundColor = kColorRGB(251, 85, 64, 1);
        _nodeLabel.layer.cornerRadius = 2.5;
        _nodeLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_nodeLabel];
        _nodeLabel.sd_layout.leftSpaceToView(self.contentView, 23).widthIs(5).heightIs(5).topSpaceToView(self.contentView, kFit(24.5));
        
        self.cableLabel = [UILabel new];
        _cableLabel.backgroundColor = kCellColorDivider;
        [self.contentView addSubview:_cableLabel];
        _cableLabel.sd_layout.topSpaceToView(_nodeLabel, 5).bottomSpaceToView(self.contentView, 0).widthIs(kCellDividerHeight).centerXEqualToView(_nodeLabel);
        
        self.taskStateLabel = [UILabel new];
        _taskStateLabel.text = @"已完成";
        _taskStateLabel.textColor = kColorRGB(251, 85, 64, 1);
        _taskStateLabel.font = MFont(kFit(14));
        [self.contentView addSubview:_taskStateLabel];
        _taskStateLabel.sd_layout.leftSpaceToView(_nodeLabel, 11).topSpaceToView(self.contentView, kFit(20)).rightSpaceToView(self.contentView, 20).heightIs(kFit(14));
        
        self.taskTime = [UILabel new];
        _taskTime.textColor = kColorRGB(136, 136, 136, 1);
        _taskTime.text = @"";
        _taskTime.font = MFont(kFit(14));
        [self.contentView addSubview:_taskTime];
        _taskTime.sd_layout.leftSpaceToView(_nodeLabel, 11).topSpaceToView(_taskStateLabel, kFit(10)).heightIs(kFit(14)).rightSpaceToView(self.contentView, 20);
      
        self.taskPerformBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_taskPerformBtn setTitle:@"执行" forState:(UIControlStateNormal)];
        _taskPerformBtn.titleLabel.font = MFont(kFit(12));
        [_taskPerformBtn setTitleColor:kColorRGB(251, 85, 64, 1) forState:(UIControlStateNormal)];
        _taskPerformBtn.layer.cornerRadius = 2;
        _taskPerformBtn.layer.masksToBounds = YES;
        _taskPerformBtn.layer.borderWidth = 0.5;
        _taskPerformBtn.layer.borderColor = kColorRGB(251, 85, 64, 1).CGColor;
        [_taskPerformBtn addTarget:self action:@selector(handleTaskPerformBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:_taskPerformBtn];
        _taskPerformBtn.sd_layout.leftSpaceToView(_nodeLabel, 11).topSpaceToView(_taskTime, kFit(11)).widthIs(kFit(75)).heightIs(kFit(25));
        
        self.taskAskLeaveBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_taskAskLeaveBtn setTitle:@"请假" forState:(UIControlStateNormal)];
        _taskAskLeaveBtn.titleLabel.font = MFont(kFit(12));
        [_taskAskLeaveBtn setTitleColor:kColorRGB(251, 85, 64, 1) forState:(UIControlStateNormal)];
        _taskAskLeaveBtn.layer.cornerRadius = 2;
        _taskAskLeaveBtn.layer.masksToBounds = YES;
        _taskAskLeaveBtn.layer.borderWidth = 0.5;
        _taskAskLeaveBtn.layer.borderColor = kColorRGB(251, 85, 64, 1).CGColor;
        [_taskAskLeaveBtn addTarget:self action:@selector(handleTaskAskLeaveBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:_taskAskLeaveBtn];
        _taskAskLeaveBtn.sd_layout.leftSpaceToView(_taskPerformBtn, 11).topSpaceToView(_taskTime, kFit(11)).widthIs(kFit(75)).heightIs(kFit(25));
        
        self.taskStateDescribeLabel = [UILabel new];
        _taskStateDescribeLabel.textColor = kColorRGB(51, 51,51 , 1);
        _taskStateDescribeLabel.text = @"";
        _taskStateDescribeLabel.font= MFont(kFit(14));
        _taskStateDescribeLabel.numberOfLines = 0;
        [self.contentView addSubview:_taskStateDescribeLabel];
        _taskStateDescribeLabel.sd_layout.leftSpaceToView(_nodeLabel, 11).topSpaceToView(_taskTime, kFit(10)).rightSpaceToView(self.contentView, kFit(24.5)).autoHeightRatio(0);
        
        self.starsView = [[DJStarsCommentsView alloc] initStarsViewWithFrame:CGRectMake(0, 0, 95, 15)];
        _starsView.delegate = self;
        _starsView.hidden = YES;
        _starsView.userInteractionEnabled = NO;
        [self.contentView addSubview:_starsView];
        
        _starsView.sd_layout.leftEqualToView(_taskStateDescribeLabel).topSpaceToView(_taskStateDescribeLabel, kFit(10)).widthIs(95).heightIs(15);
        
        self.scrollView = [UIScrollView new];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.userInteractionEnabled = YES;
        _scrollView.delegate = self;
        [self.contentView addSubview:_scrollView];
        _scrollView.sd_layout.topSpaceToView(_taskStateDescribeLabel, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        
        
        
        
    }
    return self;
}

- (void)handleTaskPerformBtn {
    if ([_delegate respondsToSelector:@selector(TaskPerformBtn)]) {
        [_delegate TaskPerformBtn];
    }
    
}

- (void)handleTaskAskLeaveBtn {
    if ([_delegate respondsToSelector:@selector(TaskAskLeaveBtn)]) {
        [_delegate TaskAskLeaveBtn];
    }
}
- (void)configControls:(NSIndexPath *)indexPath  modelArray:(NSArray *)array {
//    NSLog(@"array%@", array);

    if (indexPath.row == 0) {
        _taskStateLabel.textColor  = kColorRGB(251, 85, 64, 1);
        _nodeLabel.backgroundColor = kColorRGB(251, 85, 64, 1);
        _cableLabel.sd_layout.topSpaceToView(_nodeLabel, 5).bottomSpaceToView(self.contentView, 0).widthIs(kCellDividerHeight).centerXEqualToView(_nodeLabel);
        [_cableLabel updateLayout];
    }else if(indexPath.row == array.count -1){
        
           _cableLabel.sd_layout.bottomSpaceToView(_nodeLabel, 5).topSpaceToView(self.contentView, 0).widthIs(kCellDividerHeight).centerXEqualToView(_nodeLabel);
            _taskStateLabel.textColor  = kColorRGB(51, 51, 51, 1);
            _nodeLabel.backgroundColor = kColorRGB(204, 204, 204, 1);
        [_cableLabel updateLayout];
    }else {
        _cableLabel.sd_layout.bottomSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).widthIs(kCellDividerHeight).centerXEqualToView(_nodeLabel);
        _taskStateLabel.textColor  = kColorRGB(51, 51, 51, 1);
        _nodeLabel.backgroundColor = kColorRGB(204, 204, 204, 1);
        [_cableLabel updateLayout];
        
    }
}

-(void)setModel:(TaskStepModel *)model {
//待完成..待审批(请假和申诉) 待补办
//    NSLog(@"TaskStepModel%@" ,model);
    _model = model;
    _starsView.hidden = YES;
    _taskTime.hidden = NO;
    __weak  typeof(self) weakSelf =  self;
    if ([model.status isEqualToString:@"default"]) {//默认状态
        [weakSelf defaultState:model];
    }else  if ([model.status isEqualToString:@"default_no"]) {//不展示所有按钮的默认状态
        [weakSelf default_noState:model];
    }else if ([model.status isEqualToString:@"undo"]) {//待完成
        [weakSelf undoState:model];
    }else  if ([model.status isEqualToString:@"complete"]) {//已完成
        [weakSelf completeState:model];
    }else  if ([model.status isEqualToString:@"time_out"]) {//已超期
        [weakSelf time_outState:model];
    }else  if ([model.status isEqualToString:@"leaveing"]) {//请假待审批
        [weakSelf leaveingState:model];
    }else  if ([model.status isEqualToString:@"leave_yes"]) {//请假通过
        [weakSelf leave_yesState:model];
    }else if ([model.status isEqualToString:@"leave_no"]) {//请假不通过
        [weakSelf leave_noState:model];
    }else if ([model.status isEqualToString:@"appealing"]) {//申诉待审批
        [weakSelf appealingState:model];
    }else if ([model.status isEqualToString:@"appeal_yes"]) {//申诉通过
        [weakSelf appeal_yesState:model];
    }else if ([model.status isEqualToString:@"appeal_no"]) {//申诉不通过
        [weakSelf appeal_noState:model];
    }else if ([model.status isEqualToString:@"timeout_complete"]) {//超期完成
        [weakSelf timeout_complete:model];
    }else if ([model.status isEqualToString:@"eva"]) {//评论
        weakSelf.starsView.hidden = NO;
        [weakSelf evaState:model];
    }else  if ([model.status isEqualToString:@"waiting_fill_do"]) {// 已经超时 申诉未通过后的 待补办
        weakSelf.taskTime.hidden = YES;
        [weakSelf waiting_fill_doState:model];
    }else if ([model.status isEqualToString:@"secondUndo"]) {// 已经请假但是未通过后的 待完成
        weakSelf.taskTime.hidden = YES;
        weakSelf.taskContentLabel.hidden = YES;
        [weakSelf secondUndoState:model];
    }else  if ([model.status isEqualToString:@"undo_no"]) {//未完成但是不展示按钮
        [weakSelf undo_noState:model];
    }else  if ([model.status isEqualToString:@"time_out_no"]) {//已超期 但是不显示按钮
        [weakSelf time_out_noState:model];
    }else if ([model.status isEqualToString:@"leaveing_show"]) {//请假待审批最后一个展示的cell
        [weakSelf leaveing_showState:model];
    }else if ([model.status isEqualToString:@"appealing_show"]) {//申诉待审批最后一个展示的cell
        [weakSelf appealing_showState:model];
    }else if ([model.status isEqualToString:@"secondUndo_no"]) {//已经请假但是 不显示按钮 未通过后的 待完成
        weakSelf.taskTime.hidden = YES;
        weakSelf.taskContentLabel.hidden = YES;
        [weakSelf secondUndo_noState:model];
    }else  if ([model.status isEqualToString:@"waiting_fill_do_no"]) {// 已经超时 申诉未通过后的 待补办 而且不显示按钮
        weakSelf.taskTime.hidden = YES;
        [weakSelf waiting_fill_do_noState:model];
    }else{
        
    }
}

//默认状态
- (void)defaultState:(TaskStepModel *)model {
    
    _taskStateLabel.text = [NSString stringWithFormat:@"%@发起任务", model.content];
    _taskTime.text = model.createTime;

    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
    _scrollView.hidden = YES;
    _taskStateDescribeLabel.hidden = YES;
    [self setupAutoHeightWithBottomView:_taskTime bottomMargin:kFit(18)];
}
//查看我的交办任务 里面使用的默认状态
- (void)default_noState:(TaskStepModel *)model {
    
    _taskStateLabel.text = [NSString stringWithFormat:@"%@发起任务", model.content];
    _taskTime.text = model.createTime;

    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
    _scrollView.hidden = YES;
    _taskStateDescribeLabel.hidden = YES;
    [self setupAutoHeightWithBottomView:_taskTime bottomMargin:kFit(18)];
}

- (void)undo_noState:(TaskStepModel *)model  {
//    _taskTime.text = model.createTime;
    _taskStateLabel.text = @"待完成";
    _scrollView.hidden = YES;
    _taskStateDescribeLabel.hidden = YES;
    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
    [self setupAutoHeightWithBottomView:_taskStateLabel bottomMargin:kFit(5)];
}
//未完成状态
- (void)undoState:(TaskStepModel *)model {

    _taskTime.hidden = YES;
    _taskStateLabel.text = @"待完成";
    _scrollView.hidden = YES;
    _taskStateDescribeLabel.hidden = YES;
    _taskPerformBtn.hidden = NO;
    _taskAskLeaveBtn.hidden = NO;
    _taskPerformBtn.sd_layout.leftSpaceToView(_nodeLabel, 11).topSpaceToView(_taskStateLabel, kFit(11)).widthIs(kFit(75)).heightIs(kFit(25));
    _taskAskLeaveBtn.sd_layout.leftSpaceToView(_taskPerformBtn, 11).topSpaceToView(_taskStateLabel, kFit(11)).widthIs(kFit(75)).heightIs(kFit(25));
    [self setupAutoHeightWithBottomView:_taskPerformBtn bottomMargin:kFit(5)];
    [_taskPerformBtn updateLayout];
    [_taskAskLeaveBtn updateLayout];
    
}
//完成状态
- (void)completeState:(TaskStepModel *)model {
    _taskStateLabel.text = @"已完成";
    _taskTime.text = model.createTime;
    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;

    NSString *imageStr = model.img;
    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    for (int i = 0; i < imageArray.count; i ++) {
        NSString  *url = imageArray[i];
        if (url.length == 0 || url == nil || url == NULL) {
            [imageArray removeObjectAtIndex:i];
        }
    }
    if (model.content.length == 0) {
        _taskStateDescribeLabel.text = @"";
        _taskStateDescribeLabel.hidden= YES;
        _scrollView.sd_layout.topSpaceToView(_taskTime, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskTime bottomMargin:kFit(5)];
        }
    }else {
        _taskStateDescribeLabel.text = model.content;
        _taskStateDescribeLabel.hidden= NO;
        _scrollView.sd_layout.topSpaceToView(_taskStateDescribeLabel, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskStateDescribeLabel bottomMargin:kFit(5)];
        }
    }
}

//超时状态
- (void)time_outState:(TaskStepModel *)model {
    _scrollView.hidden = YES;
    _taskStateDescribeLabel.hidden = YES;
    _taskTime.text = model.createTime;
    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
//    NSLog(@"_indexPath.row%d", _indexPath.row);
    if (_indexPath.row != 0) {
        _taskStateLabel.textColor  = kColorRGB(51, 51, 51, 1);
        _nodeLabel.backgroundColor = kColorRGB(204, 204, 204, 1);
        [self setupAutoHeightWithBottomView:_taskTime bottomMargin:kFit(5)];
        
    }else {
        _taskPerformBtn.hidden = NO;
        _taskAskLeaveBtn.hidden = NO;
        _taskStateLabel.textColor  = kColorRGB(251, 85, 64, 1);
        _nodeLabel.backgroundColor = kColorRGB(251, 85, 64, 1);
        [_taskPerformBtn setTitle:@"补办" forState:(UIControlStateNormal)];
        [_taskAskLeaveBtn setTitle:@"申诉" forState:(UIControlStateNormal)];
        _taskPerformBtn.sd_layout.leftSpaceToView(_nodeLabel, 11).topSpaceToView(_taskTime, kFit(11)).widthIs(kFit(75)).heightIs(kFit(25));
        _taskAskLeaveBtn.sd_layout.leftSpaceToView(_taskPerformBtn, 11).topSpaceToView(_taskTime, kFit(11)).widthIs(kFit(75)).heightIs(kFit(25));
        [self setupAutoHeightWithBottomView:_taskPerformBtn bottomMargin:kFit(5)];
    }
    _taskStateLabel.text = @"任务超期";
}

//超时但是不显示按钮状态
-(void)time_out_noState:(TaskStepModel *)model {
    _scrollView.hidden = YES;
    _taskStateDescribeLabel.hidden = YES;
    _taskTime.text = model.createTime;
        _taskPerformBtn.hidden = YES;
        _taskAskLeaveBtn.hidden = YES;
//        _taskStateLabel.textColor  = kColorRGB(51, 51, 51, 1);
//        _nodeLabel.backgroundColor = kColorRGB(204, 204, 204, 1);
        [self setupAutoHeightWithBottomView:_taskTime bottomMargin:kFit(5)];
    _taskStateLabel.text = @"任务超期";
}

//请假待审批状态
- (void)leaveingState:(TaskStepModel *)model {
    _taskStateLabel.text = @"申请请假";
    _taskTime.text = model.createTime;
    
    
    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
    _scrollView.hidden = YES;
    _taskStateDescribeLabel.hidden = YES;

    NSString *imageStr = model.img;
    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    for (int i = 0; i < imageArray.count; i ++) {
        NSString  *url = imageArray[i];
        if (url.length == 0 || url == nil || url == NULL) {
            [imageArray removeObjectAtIndex:i];
        }
    }
    if (model.content.length == 0) {
        _taskStateDescribeLabel.text = @"";
        _taskStateDescribeLabel.hidden= YES;
        _scrollView.sd_layout.topSpaceToView(_taskTime, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskTime bottomMargin:kFit(5)];
        }
    }else {
        _taskStateDescribeLabel.hidden= NO;
        _taskStateDescribeLabel.text = model.content;
        _scrollView.sd_layout.topSpaceToView(_taskStateDescribeLabel, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskStateDescribeLabel bottomMargin:kFit(5)];
        }
    }
}
//请假通过状态
- (void)leave_yesState:(TaskStepModel *)model {
    if (self.sendUserName.length == 0 || self.sendUserName == nil || self.sendUserName == NULL) {
        
        _taskStateLabel.text = [NSString stringWithFormat:@"%@已同意申请", [DJUserTool getUserInfo].name];
    }else {
        _taskStateLabel.text = [NSString stringWithFormat:@"%@已同意申请", self.sendUserName];
    }
    
    _taskTime.text = model.createTime;
    
    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
    
    NSString *imageStr = model.img;
    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    for (int i = 0; i < imageArray.count; i ++) {
        NSString  *url = imageArray[i];
        if (url.length == 0 || url == nil || url == NULL) {
            [imageArray removeObjectAtIndex:i];
        }
    }
    if (model.content.length == 0) {
        _taskStateDescribeLabel.hidden= YES;
        _scrollView.sd_layout.topSpaceToView(_taskTime, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskTime bottomMargin:kFit(5)];
        }
    }else {
        _taskStateDescribeLabel.hidden= NO;
        _taskStateDescribeLabel.text = model.content;
        _scrollView.sd_layout.topSpaceToView(_taskStateDescribeLabel, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskStateDescribeLabel bottomMargin:kFit(5)];
        }
    }
}
//请假不通过状态
- (void)leave_noState:(TaskStepModel *)model {
   
    
    if (self.sendUserName.length == 0 || self.sendUserName == nil || self.sendUserName == NULL) {
        _taskStateLabel.text = [NSString stringWithFormat:@"%@不同意申请", [DJUserTool getUserInfo].name];
        
    }else {
        
        
        
        _taskStateLabel.text = [NSString stringWithFormat:@"%@不同意申请", self.sendUserName];
    }
    
    
    _taskTime.text = model.createTime;
    _taskStateDescribeLabel.text = model.content;
    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
    
    NSString *imageStr = model.img;
    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    for (int i = 0; i < imageArray.count; i ++) {
        NSString  *url = imageArray[i];
        if (url.length == 0 || url == nil || url == NULL) {
            [imageArray removeObjectAtIndex:i];
        }
    }
    if (model.content.length == 0) {
        _taskStateDescribeLabel.text = @"";
        _taskStateDescribeLabel.hidden= YES;
        _scrollView.sd_layout.topSpaceToView(_taskTime, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskTime bottomMargin:kFit(5)];
        }
    }else {
        _taskStateDescribeLabel.hidden= NO;
        _taskStateDescribeLabel.text = model.content;
        _scrollView.sd_layout.topSpaceToView(_taskStateDescribeLabel, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskStateDescribeLabel bottomMargin:kFit(5)];
        }
    }
    
}

//申诉审核待状态
- (void)appealingState:(TaskStepModel *)model {
    _taskStateLabel.text = @"发起申诉";
    _taskTime.text = model.createTime;
    _taskStateDescribeLabel.text = model.content;
    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
    _scrollView.hidden = YES;
    _taskStateDescribeLabel.hidden = YES;
    NSString *imageStr = model.img;
    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    for (int i = 0; i < imageArray.count; i ++) {
        NSString  *url = imageArray[i];
        if (url.length == 0 || url == nil || url == NULL) {
            [imageArray removeObjectAtIndex:i];
        }
    }
    if (model.content.length == 0) {
        _taskStateDescribeLabel.text = @"";
        _taskStateDescribeLabel.hidden= YES;
        _scrollView.sd_layout.topSpaceToView(_taskTime, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskTime bottomMargin:kFit(5)];
        }
    }else {
        _taskStateDescribeLabel.hidden= NO;
        _taskStateDescribeLabel.text = model.content;
        _scrollView.sd_layout.topSpaceToView(_taskStateDescribeLabel, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskStateDescribeLabel bottomMargin:kFit(5)];
        }
    }
    
}
- (void)timeout_complete:(TaskStepModel *)model{
    
    _taskStateLabel.text = @"已完成补办";
    _taskTime.text = model.createTime;
    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
    
    NSString *imageStr = model.img;
    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    for (int i = 0; i < imageArray.count; i ++) {
        NSString  *url = imageArray[i];
        if (url.length == 0 || url == nil || url == NULL) {
            [imageArray removeObjectAtIndex:i];
        }
    }
    if (model.content.length == 0) {
        _taskStateDescribeLabel.text = @"";
        _taskStateDescribeLabel.hidden= YES;
        _scrollView.sd_layout.topSpaceToView(_taskTime, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskTime bottomMargin:kFit(5)];
        }
    }else {
        _taskStateDescribeLabel.hidden= NO;
        _taskStateDescribeLabel.text = model.content;
        _scrollView.sd_layout.topSpaceToView(_taskStateDescribeLabel, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskStateDescribeLabel bottomMargin:kFit(5)];
        }
    }
}
//申诉通过状态
- (void)appeal_yesState:(TaskStepModel *)model {

    
    if (self.sendUserName.length == 0 || self.sendUserName == nil || self.sendUserName == NULL) {
        
        _taskStateLabel.text = [NSString stringWithFormat:@"%@已通过申诉", [DJUserTool getUserInfo].name];
    }else {
        _taskStateLabel.text = [NSString stringWithFormat:@"%@已通过申诉", self.sendUserName];
    }
    _taskTime.text = model.createTime;
    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;

    
    NSString *imageStr = model.img;
    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    for (int i = 0; i < imageArray.count; i ++) {
        NSString  *url = imageArray[i];
        if (url.length == 0 || url == nil || url == NULL) {
            [imageArray removeObjectAtIndex:i];
        }
    }
    
    if (model.content.length == 0) {
        _taskStateDescribeLabel.text = @"";
        _taskStateDescribeLabel.hidden= YES;
        _scrollView.sd_layout.topSpaceToView(_taskTime, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskTime bottomMargin:kFit(5)];
        }
    }else {
        _taskStateDescribeLabel.hidden= NO;
        _taskStateDescribeLabel.text = model.content;
        _scrollView.sd_layout.topSpaceToView(_taskStateDescribeLabel, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskStateDescribeLabel bottomMargin:kFit(5)];
        }
    }
}
//申诉未通过状态
- (void)appeal_noState:(TaskStepModel *)model {
    if (self.sendUserName.length == 0 || self.sendUserName == nil || self.sendUserName == NULL) {
        
        _taskStateLabel.text = [NSString stringWithFormat:@"%@未通过申诉", [DJUserTool getUserInfo].name];
    }else {
        _taskStateLabel.text = [NSString stringWithFormat:@"%@未通过申诉", self.sendUserName];
    }
    
    _taskTime.text = model.createTime;
    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
//    _taskTime.hidden = YES;

    NSString *imageStr = model.img;
    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    for (int i = 0; i < imageArray.count; i ++) {
        NSString  *url = imageArray[i];
        if (url.length == 0 || url == nil || url == NULL) {
            [imageArray removeObjectAtIndex:i];
        }
    }
    if (model.content.length == 0) {
        _taskStateDescribeLabel.hidden= YES;
        _taskStateDescribeLabel.text = @"";
        _scrollView.sd_layout.topSpaceToView(_taskStateLabel, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskTime bottomMargin:kFit(5)];
        }
    }else {
        _taskStateDescribeLabel.hidden= NO;
        _taskStateDescribeLabel.text = model.content;
        _scrollView.sd_layout.topSpaceToView(_taskStateDescribeLabel, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskStateDescribeLabel bottomMargin:kFit(5)];
        }
    }
    
}

//超期完成
- (void)timeout_completeState:(TaskStepModel *)model {
    _taskStateLabel.text = @"已完成";
    
    _taskTime.text = model.createTime;
    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;

    
    NSString *imageStr = model.img;
    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    for (int i = 0; i < imageArray.count; i ++) {
        NSString  *url = imageArray[i];
        if (url.length == 0 || url == nil || url == NULL) {
            [imageArray removeObjectAtIndex:i];
        }
    }
    if (model.content.length == 0) {
        _taskStateDescribeLabel.text = @"";
        _taskStateDescribeLabel.hidden= YES;
        _scrollView.sd_layout.topSpaceToView(_taskTime, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskTime bottomMargin:kFit(5)];
        }
    }else {
        _taskStateDescribeLabel.hidden= NO;
        _taskStateDescribeLabel.text = model.content;
        _scrollView.sd_layout.topSpaceToView(_taskStateDescribeLabel, kFit(10)).heightIs(90).leftSpaceToView(_nodeLabel, 11).rightSpaceToView(self.contentView, 0);
        if (imageArray.count != 0) {
            _scrollView.hidden = NO;
            [self showImageView:imageArray];
            [self setupAutoHeightWithBottomView:_scrollView bottomMargin:kFit(15)];
        }else {
            _scrollView.hidden = YES;
            [self setupAutoHeightWithBottomView:_taskStateDescribeLabel bottomMargin:kFit(5)];
        }
    }
}
//评论状态
- (void)evaState:(TaskStepModel *)model {
    if (self.sendUserName.length == 0 || self.sendUserName == nil || self.sendUserName == NULL) {
        
        _taskStateLabel.text = [NSString stringWithFormat:@"%@评价", [DJUserTool getUserInfo].name];
    }else {
        _taskStateLabel.text = [NSString stringWithFormat:@"%@评价", self.sendUserName];
    }
    
    _taskTime.text = model.createTime;
    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
    [_starsView checkCount:model.evaRank.intValue];
    NSString *imageStr = model.img;
    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    for (int i = 0; i < imageArray.count; i ++) {
        NSString  *url = imageArray[i];
        if (url.length == 0 || url == nil || url == NULL) {
            [imageArray removeObjectAtIndex:i];
        }
    }
    _scrollView.hidden = YES;
    if (model.content.length == 0) {
        _taskStateDescribeLabel.text = @"";
        _taskStateDescribeLabel.hidden= YES;
        _starsView.sd_layout.leftEqualToView(_taskStateDescribeLabel).topSpaceToView(_taskTime, kFit(10)).widthIs(95).heightIs(15);
    }else {
        _taskStateDescribeLabel.hidden= NO;
        _taskStateDescribeLabel.text = model.content;
        _starsView.sd_layout.leftEqualToView(_taskStateDescribeLabel).topSpaceToView(_taskStateDescribeLabel, kFit(10)).widthIs(95).heightIs(15);
    }
    [self setupAutoHeightWithBottomView:_starsView bottomMargin:kFit(5)];
}
//待补办状态
- (void)waiting_fill_doState:(TaskStepModel *)model {
    [_taskPerformBtn setTitle:@"补办" forState:(UIControlStateNormal)];
    _taskStateLabel.text = @"待补办";
    _taskTime.text = model.createTime;
    _taskTime.hidden = NO;
    _scrollView.hidden = YES;
    _taskStateDescribeLabel.hidden = YES;
    _taskPerformBtn.hidden = NO;
    _taskAskLeaveBtn.hidden = YES;
    _taskPerformBtn.sd_layout.leftSpaceToView(_nodeLabel, 11).topSpaceToView(_taskStateLabel, kFit(11)).widthIs(kFit(75)).heightIs(kFit(25));
    [self setupAutoHeightWithBottomView:_taskPerformBtn bottomMargin:kFit(5)];
}
//二次待完成状态 (请假未通过)
- (void)secondUndoState:(TaskStepModel *)model {
    
    
    _taskTime.text = model.createTime;
    [_taskPerformBtn setTitle:@"执行" forState:(UIControlStateNormal)];
    _taskStateLabel.text = @"待完成";
    _scrollView.hidden = YES;
    _taskStateDescribeLabel.hidden = YES;
    _taskPerformBtn.hidden = NO;
    _taskAskLeaveBtn.hidden = YES;
    _taskPerformBtn.sd_layout.leftSpaceToView(_nodeLabel, 11).topSpaceToView(_taskStateLabel, kFit(11)).widthIs(kFit(75)).heightIs(kFit(25));
    [self setupAutoHeightWithBottomView:_taskPerformBtn bottomMargin:kFit(5)];

}

- (void)secondUndo_noState:(TaskStepModel *)model {
//    _taskTime.text = model.createTime;
    _taskStateLabel.text = @"待完成";
    _scrollView.hidden = YES;
    _taskStateDescribeLabel.hidden = YES;
    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
    [self setupAutoHeightWithBottomView:_taskStateLabel bottomMargin:kFit(5)];
}
- (void)appealing_showState:(TaskStepModel *)model {
    _taskStateLabel.text = @"待审批";
    _taskTime.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
    _scrollView.hidden = YES;
    _taskStateDescribeLabel.hidden = YES;
    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
    [self setupAutoHeightWithBottomView:_taskStateLabel bottomMargin:kFit(5)];
}

- (void)leaveing_showState:(TaskStepModel *)model {
    _taskStateLabel.text = @"待审批";
    _taskTime.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
    _scrollView.hidden = YES;
    _taskStateDescribeLabel.hidden = YES;
    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
    [self setupAutoHeightWithBottomView:_taskStateLabel bottomMargin:kFit(5)];
}
//待补办状态
- (void)waiting_fill_do_noState:(TaskStepModel *)model {
    _taskStateLabel.text = @"待补办";
    _taskTime.text = model.createTime;
    _taskTime.hidden = YES;
    _scrollView.hidden = YES;
    _taskStateDescribeLabel.hidden = YES;
    _taskPerformBtn.hidden = YES;
    _taskAskLeaveBtn.hidden = YES;
    
    [self setupAutoHeightWithBottomView:_taskStateLabel bottomMargin:kFit(5)];
}

- (void)showImageView:(NSArray *)imageArray {
    
    [self.imageViewArray removeAllObjects];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.ScrollContentView = [UIView new];
    
    _ScrollContentView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.ScrollContentView];
    [self.scrollView setupAutoContentSizeWithRightView:_ScrollContentView rightMargin:0];
    //    154  120
    CGFloat X = 0;
    for (int i = 0; i < imageArray.count; i ++) {
        UIImageView *view  = [[UIImageView alloc] initWithFrame:CGRectMake(X, 0, 90, 90)];
        view.image = [UIImage imageNamed:@"DJ_Load_network_image_default"];
        view.tag = 1000+i;
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
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
        
        LBPhotoWebItem *item = [[LBPhotoWebItem alloc]initWithURLString:imageURL frame:view.frame];
        item.placeholdImage = [UIImage imageNamed:@"DJ_Load_network_image_default"];
        [self.imageViewArray addObject:item];
        if (i == imageArray.count - 1) {
            self.lastRightLine = [UILabel new];
            [self.ScrollContentView addSubview:self.lastRightLine];
            self.lastRightLine.sd_layout.leftSpaceToView(view, 0).topSpaceToView(self.ScrollContentView, 0).bottomSpaceToView(self.ScrollContentView, 0).widthIs(1);
        }
        view.userInteractionEnabled = YES;
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



- (void)setIndexPath:(NSIndexPath *)indexPath {
    
    _indexPath = indexPath;
    
}

- (void)handleImageTap:(UITapGestureRecognizer *)tap {
    
    
        [LBPhotoBrowserManager.defaultManager showImageWithWebItems:self.imageViewArray selectedIndex:tap.view.tag-1000 fromImageViewSuperView:self.ScrollContentView].lowGifMemory = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc {
    

    NSLog(@"DJMyTaskProgressTableViewCell dealloc");
    
}
@end
