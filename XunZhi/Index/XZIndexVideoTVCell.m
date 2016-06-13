//
//  XZIndexVideoTVCell.m
//  XunZhi
//
//  Created by 李雷 on 16/5/30.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZIndexVideoTVCell.h"

#import "XZIndexTVModel.h"
#import "XZIndexTVCellBottomView.h"

/** 控件距离屏幕左侧的距离 */
#define startX 10.0f
/** 控件距离cell顶部的距离 */
#define Y 10.0f
/** 控件与控件之间的间距 */
#define space 5.0f

@interface XZIndexVideoTVCell ()

/** 视频的标题 */
@property (nonatomic, retain) UILabel *lblTitle;
/** 视频的播放宣传图片 */
@property (nonatomic, retain) UIImageView *imgVCover;
/** 图片中间的播放图片 */
@property (nonatomic, retain) UIImageView *imgVPlay;
/** 视频的长度 */
@property (nonatomic, retain) UILabel *lblTime;
/** 新闻主要内容底部的一些信息(来源, 赞, 评论...) */
@property (nonatomic, retain) XZIndexTVCellBottomView *bottomView;

@end

@implementation XZIndexVideoTVCell

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
        self.lblTitle = [[UILabel alloc] init];
        [self.contentView addSubview:_lblTitle];
        _lblTitle.numberOfLines = 0;
        self.imgVCover = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVCover];
        self.imgVPlay = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVPlay];
        _imgVPlay.userInteractionEnabled = YES;
        _imgVPlay.contentMode = UIViewContentModeScaleAspectFill;
        self.lblTime = [[UILabel alloc] init];
        [self.contentView addSubview:_lblTime];
        self.bottomView = [[XZIndexTVCellBottomView alloc] init];
        [self.contentView addSubview:_bottomView];
    }
    return self;
}
#pragma mark - 自定义函数
/**
 *  自定义cell上控件的布局, 要先布局原有的三个(图片, 标题, 右侧提示)
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    _lblTitle.frame = CGRectMake(startX, Y, SCREENWIDTH - startX*2, [[self class] heigthForText:_indexTVModel.title]);
    _lblTitle.text = _indexTVModel.title;
    _lblTitle.font = titleFont;
    _lblTitle.nightTextColor = [UIColor whiteColor];
    
    _imgVCover.frame = CGRectMake(startX, _lblTitle.frame.origin.y + _lblTitle.frame.size.height + space, SCREENWIDTH - startX*2, (SCREENWIDTH - startX*2)/2);
    [_imgVCover sd_setImageWithURL:[NSURL URLWithString:[_indexTVModel.large_image_list[0] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"sourceHeader"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _imgVPlay.frame = CGRectMake(_imgVCover.frame.size.width/2 - 30,Y + [[self class] heigthForText:_indexTVModel.title] + _imgVCover.frame.size.height/2, 50, 50);
    _imgVPlay.image = [UIImage imageNamed:@"videoPlay"];
    _lblTime.frame = CGRectMake(_imgVCover.frame.origin.x + _imgVCover.frame.size.width - 50, Y + [[self class] heigthForText:_indexTVModel.title] + _imgVCover.frame.size.height - 25, 40, 20);
    _lblTime.text = [NSString stringWithFormat:@"%ld秒", (long)_indexTVModel.video_duration];
    _lblTime.font = [UIFont systemFontOfSize:11.0f];
    _lblTime.textAlignment = NSTextAlignmentCenter;
    _lblTime.textColor = UIColorFromRGB(0x000000);
    _lblTime.backgroundColor = UIColorFromRGB(0x8E8E8E);
    _lblTime.layer.masksToBounds =YES;
    _lblTime.layer.cornerRadius = 10.0f;
    
    /** 数字25是给定的固定高度 */
    _bottomView.frame = CGRectMake(startX, _imgVCover.frame.origin.y + _imgVCover.frame.size.height + space, _lblTitle.frame.size.width, 25);
    [_bottomView initViewWithIndexTVModel:_indexTVModel];
    
    // >将XZIndexTVCellBottomView代理传回XZIndexCVCell需要的值传过去
    _bottomView.delegate = self.target;
    _bottomView.indexPath = _indexPath;
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








