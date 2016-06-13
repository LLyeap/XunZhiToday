//
//  XZPictureTVCell.h
//  XunZhi
//
//  Created by 李雷 on 16/5/25.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZPictureTVModel;

@interface XZPictureTVCell : UITableViewCell

/** tableView初始化需要的XZPictureTVModel模型数据 */
@property (nonatomic, retain) XZPictureTVModel *pictureTVModel;
/**
 *  根据标题的高度和图片的高度计算当前cell的高度
 *
 *  @return TVCell的高度值
 */
- (CGFloat)getCellHeight;

@end
