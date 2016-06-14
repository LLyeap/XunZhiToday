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
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface XZVideoHeader ()

@property (nonatomic, retain) AVPlayerViewController *playerController;

@end

@implementation XZVideoHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.playerController = [[AVPlayerViewController alloc] init];
        _playerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (nil != _selectVideoTVModel) {
        _playerController.player = [AVPlayer playerWithURL:[NSURL URLWithString:_selectVideoTVModel.mp4_url]];
    } else {
        XZVideoSingleton *videoSingleton = [XZVideoSingleton defaultVideoSingleton];
        self.playerController.player = videoSingleton.player;
    }
    _playerController.view.frame = CGRectMake(0, 0, self.frame.size.width, 44.0 * 5);
    [self addSubview:_playerController.view];
    [_playerController.player play];
}






@end








