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
/**  */
@property (nonatomic, retain) AVPlayerItem *playerItem;
/**  */
@property (nonatomic, assign) CMTime currentTime;

@end
