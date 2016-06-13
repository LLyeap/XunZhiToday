//
//  XZPictureTVCellBottomView.h
//  XunZhi
//
//  Created by 李雷 on 16/5/25.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZPictureTVModel;

@interface XZPictureTVCellBottomView : UIView

/**
 *  初始化View上的控件的方法
 *
 *  @param pictureTVModel 参数模型数据, 用来给View上控件赋值
 */
- (void)initViewWithIndexTVModel:(XZPictureTVModel *)pictureTVModel;

@end
