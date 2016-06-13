//
//  XZVideoTVCell.h
//  XunZhi
//
//  Created by 李雷 on 16/5/27.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZVideoTVModel;

@interface XZVideoTVCell : UITableViewCell

/** 图片中间的播放图片 */
@property (nonatomic, retain) UIImageView *imgVPlay;
/** 图片点击手势, 点击后播放视频 */
@property (nonatomic, retain) UITapGestureRecognizer *tapPlay;
/** 初始化所需要的XZVideoTVModel类型的模型数据 */
@property (nonatomic, retain) XZVideoTVModel *videoTVModel;

@end
