//
//  DJDisposeCollectionViewSpacingFlowLayout.m
//  GFCalendarDemo
//
//  Created by 石山岭 on 2018/4/28.
//  Copyright © 2018年 Mercy. All rights reserved.
//

#import "DJDisposeCollectionViewSpacingFlowLayout.h"

@implementation DJDisposeCollectionViewSpacingFlowLayout

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    [super layoutAttributesForElementsInRect:rect];
    NSMutableArray * answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    /* 处理左右间距 */
    for(int i = 1; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
        NSInteger maximumSpacing = 0;
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return answer;
    
}



@end
