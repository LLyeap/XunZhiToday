//
//  XZVideoSubTVCell.m
//  XunZhi
//
//  Created by 李雷 on 16/6/6.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZVideoSubTVCell.h"

#import "XZVideoTVModel.h"

/** 控件距离cell(屏幕)左侧的距离 */
#define startX 10.0f
/** 控件距离cell顶部的距离 */
#define Y 5.0f
/** cell的高度 */
#define cellHeight 44.0f

@interface XZVideoSubTVCell ()

/** 新闻图片 */
@property (nonatomic, retain) UIImageView *imgVCover;
/** 新闻的标题 */
@property (nonatomic, retain) UILabel *lblTitle;

@end

@implementation XZVideoSubTVCell

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
        self.lblTitle = [[UILabel alloc] init];
        [self.contentView addSubview:_lblTitle];
        _lblTitle.numberOfLines = 0;
    }
    return self;
}

/**
 *  自定义cell上控件的布局, 要先布局原有的三个(图片, 标题, 右侧提示)
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    _imgVCover.frame = CGRectMake(startX, Y, cellHeight-2*Y, cellHeight-2*Y);
    [_imgVCover sd_setImageWithURL:[NSURL URLWithString:_videoTVModel.cover] placeholderImage:[UIImage imageNamed:@"sourceHeader"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    _lblTitle.frame = CGRectMake(_imgVCover.frame.origin.x + _imgVCover.frame.size.width + startX, Y, SCREENWIDTH-3*startX-_imgVCover.frame.size.width, cellHeight-2*Y);
    _lblTitle.text = _videoTVModel.title;
    _lblTitle.nightTextColor = [UIColor whiteColor];
}









- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end






