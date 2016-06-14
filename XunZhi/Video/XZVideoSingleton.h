//
//  XZVideoSingleton.h
//  XunZhi
//
//  Created by 李雷 on 16/6/13.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface XZVideoSingleton : NSObject

/** 视频播放控制器, 它上面有视频播放控件 */
@property (nonatomic, retain) AVPlayer *player;

+ (XZVideoSingleton *)defaultVideoSingleton;

@end
