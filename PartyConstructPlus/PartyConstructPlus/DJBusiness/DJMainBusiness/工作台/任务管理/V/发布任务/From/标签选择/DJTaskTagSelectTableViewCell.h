//
//  DJTaskTagSelectTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/25.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJTaskTagSelectTableViewCell : UITableViewCell

/**
 *
 */
@property (nonatomic, strong)NSIndexPath *indexPath;
/**
 *
 */
@property (nonatomic, strong)NSDictionary * dataDic;
/**
 *cell分割线
 */
@property (nonatomic, strong)UILabel *dividerLabel ;
@end
