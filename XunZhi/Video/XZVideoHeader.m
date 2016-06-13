//
//  XZVideoHeader.m
//  XunZhi
//
//  Created by 李雷 on 16/5/27.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZVideoHeader.h"

#import "XZVideoTVModel.h"
#import "XZVideoSingleton.h"

@interface XZVideoHeader ()

@property (nonatomic, retain) XZVideoTVModel *videoTVModel;
@property (nonatomic, assign) CMTime currentTime;
@property (nonatomic, retain) AVPlayerViewController *playerController;

@end

@implementation XZVideoHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.playerController = [[AVPlayerViewController alloc] init];
//        XZVideoSingleton *videoSingleton = [XZVideoSingleton defaultVideoSingleton];
//        self.playerController = videoSingleton.playerController;
        _playerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return self;
}
/**
 *  点击视频进入到子页面(XZVideoSubVC)播放时, 顶部的视频播放View
 *
 *  @param videoTVModel 参数设置需要的XZVideoTVModel模型数据
 *  @param currentTime  视频从当前时间开始播放(可能在主页面时已经播放过)
 */
- (void)setVideoTimeData:(XZVideoTVModel *)videoTVModel currentTime:(CMTime)currentTime {
    self.videoTVModel = videoTVModel;
    self.currentTime = currentTime;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _playerController.player = [AVPlayer playerWithURL:[NSURL URLWithString:_videoTVModel.mp4_url]];
    _playerController.view.frame = CGRectMake(0, 0, self.frame.size.width, 44.0 * 5);
    [self addSubview:_playerController.view];
    if (_currentTime.value != 0) {
        [_playerController.player seekToTime:_currentTime];
    }
    [_playerController.player play];
//    XZLog(@"%lf", (CGFloat)_currentTime.value / _currentTime.timescale);
}






@end








