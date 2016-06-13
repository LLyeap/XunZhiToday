//
//  XZVideoHeader.h
//  XunZhi
//
//  Created by 李雷 on 16/5/27.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@class XZVideoTVModel;

@interface XZVideoHeader : UITableViewHeaderFooterView

/**
 *  点击视频进入到子页面(XZVideoSubVC)播放时, 顶部的视频播放View
 *
 *  @param videoTVModel 参数设置需要的XZVideoTVModel模型数据
 *  @param currentTime  视频从当前时间开始播放(可能在主页面时已经播放过)
 */
- (void)setVideoTimeData:(XZVideoTVModel *)videoTVModel currentTime:(CMTime)currentTime;

@end
