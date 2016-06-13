//
//  XZVideoTVCell.m
//  XunZhi
//
//  Created by 李雷 on 16/5/27.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZVideoTVCell.h"

#import "XZVideoTVModel.h"
#import <AVFoundation/AVFoundation.h>

/** 控件距离屏幕左侧的距离 */
#define startX 10.0f
/** 控件距离cell顶部的距离 */
#define Y 10.0f

@interface XZVideoTVCell ()

/** 视频的播放宣传图片 */
@property (nonatomic, retain) UIImageView *imgVCover;
/** 视频标题的背景view, 实现颜色渐变 */
@property (nonatomic, retain) UIView *bgView;
/** 控制背景的渐变 */
@property (nonatomic, retain) CAGradientLayer *gradientLayer;
/** 视频的标题 */
@property (nonatomic, retain) UILabel *lblTitle;
/**  */
@property (nonatomic, retain) AVPlayer *avPlayer;
/**  */
@property (nonatomic, retain) AVPlayerLayer *playerLayer;
/**  */
@property (nonatomic, assign) BOOL playing;

@end

@implementation XZVideoTVCell

#pragma mark - 懒加载
- (AVPlayer *)avPlayer {
    if (_avPlayer) {
        _avPlayer = nil;
    }
    AVPlayer *avPlayer = [AVPlayer playerWithURL:[NSURL URLWithString:_videoTVModel.mp4_url]];
    return avPlayer;
}
- (AVPlayerLayer *)playerLayer {
    if (_playerLayer) {
        _playerLayer = nil;
    }
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    return playerLayer;
}
/**
 *  cell初始化函数
 *
 *  @param style           cell的类型
 *  @param reuseIdentifier cell的重用ID
 *
 *  @return 返回自定义的cell
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nightBackgroundColor = [UIColor grayColor];
        self.imgVCover = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVCover];
        self.bgView = [[UIView alloc] init];
        [self.contentView addSubview:_bgView];
        self.lblTitle = [[UILabel alloc] init];
        [self.contentView addSubview:_lblTitle];
        _lblTitle.numberOfLines = 0;
        self.imgVPlay = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVPlay];
        _imgVPlay.userInteractionEnabled = YES;
        _imgVPlay.contentMode = UIViewContentModeScaleAspectFill;
        self.tapPlay = [[UITapGestureRecognizer alloc] init];
        [_imgVPlay addGestureRecognizer:_tapPlay];
    }
    return self;
}
#pragma mark - 自定义函数
/**
 *  自定义cell上控件的布局, 要先布局原有的三个(图片, 标题, 右侧提示)
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    _imgVCover.frame = CGRectMake(startX, Y, SCREENWIDTH - startX*2, (SCREENWIDTH - startX*2)/2);
    [_imgVCover sd_setImageWithURL:[NSURL URLWithString:_videoTVModel.cover] placeholderImage:[UIImage imageNamed:@"sourceHeader"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    /** 添加一个渐变背景 */
    _bgView.frame = CGRectMake(startX, _imgVCover.frame.origin.y, SCREENWIDTH - startX*2, [[self class] heigthForText:_videoTVModel.title]);
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.bounds = _bgView.bounds;
    _gradientLayer.borderWidth = 0;
    _gradientLayer.frame = _bgView.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor grayColor] CGColor],
                             (id)[[UIColor clearColor] CGColor], nil];
    _gradientLayer.startPoint = CGPointMake(0.5, 0.5);
    _gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    [_bgView.layer insertSublayer:_gradientLayer atIndex:0];
    
    _lblTitle.frame = CGRectMake(startX*2, _imgVCover.frame.origin.y, SCREENWIDTH - startX*4, [[self class] heigthForText:_videoTVModel.title]);
    _lblTitle.text = _videoTVModel.title;
    _lblTitle.font = titleFont;
    _lblTitle.textColor = [UIColor whiteColor];
    
    
    _imgVPlay.frame = CGRectMake(_imgVCover.frame.size.width/2 - 30, _imgVCover.frame.size.height/2 - 30, 50, 50);
    _imgVPlay.image = [UIImage imageNamed:@"videoPlay"];
    
}
/**
 *  文字高度适配
 *
 *  @param text 文字内容
 *
 *  @return 文字所占高度
 */
+ (CGFloat)heigthForText:(NSString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(300, 0)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:titleFont}
                                     context:nil];
    CGFloat textH = rect.size.height;
    return textH;
}










- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end














