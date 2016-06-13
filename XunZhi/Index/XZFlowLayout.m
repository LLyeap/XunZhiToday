//
//  XZIndexFL.m
//  XunZhi
//
//  Created by 李雷 on 16/5/20.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZFlowLayout.h"

#define collectionViewWidth self.collectionView.frame.size.width
#define collectionViewHeight self.collectionView.frame.size.height

@interface XZFlowLayout ()

@property (nonatomic, retain) NSMutableArray *mArrAttribute;

@end

@implementation XZFlowLayout

/**
 *  相当于 viewController 的 viewDidLoad
 */
- (void)prepareLayout {
    self.mArrAttribute = [NSMutableArray array];
    
    /** 一般只有一个section, 所以 section 的值为 0 */
    NSInteger num = [self.collectionView numberOfItemsInSection:0];
    for (int i=0; i<num; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [_mArrAttribute addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}

/**
 *  返回的是每一个 item 的属性
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _mArrAttribute;
//    方式二
//    NSMutableArray *currentArray = [NSMutableArray array];
//    for (UICollectionViewLayoutAttributes *att in _mArrAttribute) {
//        if (CGRectIntersectsRect(att.frame, rect) || CGRectContainsRect(att.frame, rect)) {
//            [currentArray addObject:att];
//        }
//    }
//    return currentArray;
}

/**
 *  返回的是某个 item 的属性, (*这个方法需要手动调用, 在本文件的32行进行调用)
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    /** 设置collectionView里每一个元素的属性, 这里设置了frame */
    attribute.frame = CGRectMake(collectionViewWidth * indexPath.item, 0, collectionViewWidth, collectionViewHeight);
    return attribute;
}
/**
 *  放回这个collectionView的滚动范围, (横向滚动屏幕宽度*元素个数, 竖直不滚动)
 */
- (CGSize)collectionViewContentSize {
    return CGSizeMake(collectionViewWidth * _mArrAttribute.count, collectionViewHeight);
}






@end





