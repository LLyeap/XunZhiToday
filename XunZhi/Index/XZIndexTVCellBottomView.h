//
//  XZIndexBottomView.h
//  XunZhi
//
//  Created by 李雷 on 16/5/24.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZIndexTVModel;

@protocol XZIndexTVCellBottomViewDelegate <NSObject>

/**
 *  设定代理方法, 以致在tableView中修改数组的isFavorite的属性, 需要传值
 *
 *  @param indexPath 传递的indexPath的row即是要修改的数组的下标
 */
- (void)changeFavoriteStatusInArrayWithIndexPath:(NSIndexPath *)indexPath;
/**
 *  设定代理方法, 以致在XZIndexVC中进行分享, 需要传值
 *
 *  @param indexPath 传递的indexPath的row即是要修改的数组的下标
 */
- (void)shareWithIndexPath:(NSIndexPath *)indexPath;


@end

@interface XZIndexTVCellBottomView : UIView

/** 代理属性, 需要跨页面传值, 所以在各个自定义Cell中都设置了target属性, 来指定到XZIndexCVCell */
@property (nonatomic, assign) id<XZIndexTVCellBottomViewDelegate> delegate;
/** 从XZIndexCVCell经过各个自定义Cell传过来 */
@property (nonatomic, retain) NSIndexPath *indexPath;

/**
 *  初始化View上的控件的方法
 *
 *  @param indexTVModel 参数模型数据, 用来给View上控件赋值
 */
- (void)initViewWithIndexTVModel:(XZIndexTVModel *)indexTVModel;


@end






