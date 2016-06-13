//
//  XZIndexNonePicTVCell.h
//  XunZhi
//
//  Created by 李雷 on 16/5/24.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZIndexTVModel;

@interface XZIndexNonePicTVCell : UITableViewCell

/** tableView初始化需要的XZIndexTVModel模型数据 */
@property (nonatomic, retain) XZIndexTVModel *indexTVModel;

/** target作为中间桥梁, 将XZIndexCVCell设置成为XZIndexTVCellBottomView的代理 */
@property (nonatomic, assign) id target;
/** indexPath在这个文件中没有使用, 主要是传到XZIndexTVCellBottomView作为代理方法传回XZIndexCVCell中修改数组的元素 */
@property (nonatomic, retain) NSIndexPath *indexPath;

@end
