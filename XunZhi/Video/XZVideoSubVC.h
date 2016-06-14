//
//  XZVideoSubVC.h
//  XunZhi
//
//  Created by 李雷 on 16/5/25.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@class XZVideoTVModel;

@interface XZVideoSubVC : UIViewController

/** 设置子页面时需要的XZVideoTVModel类型的模型数据 */
@property (nonatomic, retain) XZVideoTVModel *videoTVModel;

/** 子页面点击跳入下一页后播放的内容 */
@property (nonatomic, retain) XZVideoTVModel *selectVideoTVModel;

@end
