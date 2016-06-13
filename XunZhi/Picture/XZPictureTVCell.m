//
//  XZPictureTVCell.m
//  XunZhi
//
//  Created by 李雷 on 16/5/25.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZPictureTVCell.h"

#import "XZPictureTVModel.h"
#import "XZPictureTVCellBottomView.h"

/** 控件距离屏幕左侧的距离 */
#define startX 10.0f
/** 控件距离cell顶部的距离 */
#define Y 10.0f
/** 控件与控件之间的间距 */
#define space 5.0f

@interface XZPictureTVCell ()

/** 图片的标题 */
@property (nonatomic, retain) UILabel *lblContent;
/** 图片 */
@property (nonatomic, retain) UIImageView *imgV;
/** 图片上的gif按钮 */
@property (nonatomic, retain) UIButton *btnImgV_gif;
/** 图片底部评论, 浏览什么的 */
@property (nonatomic, retain) XZPictureTVCellBottomView *bottomView;

@end

@implementation XZPictureTVCell

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
        self.lblContent = [[UILabel alloc] init];
        [self.contentView addSubview:_lblContent];
        _lblContent.numberOfLines = 0;
        self.imgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgV];
        self.btnImgV_gif = [[UIButton alloc] init];
        [self.contentView addSubview:_btnImgV_gif];
        self.bottomView = [[XZPictureTVCellBottomView alloc] init];
        [self.contentView addSubview:_bottomView];
    }
    return self;
}

/**
 *  自定义cell上控件的布局, 要先布局原有的三个(图片, 标题, 右侧提示)
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    _lblContent.frame = CGRectMake(startX, Y, SCREENWIDTH - startX*2, [[self class] heigthForText:_pictureTVModel.content]);
    _lblContent.text = _pictureTVModel.content;
    _lblContent.font = titleFont;
    _lblContent.nightTextColor = [UIColor whiteColor];
    
    NSDictionary *Dic_middle_image = _pictureTVModel.middle_image;
    CGFloat imageHeight =[[Dic_middle_image objectForKey:@"height"] floatValue] * (SCREENWIDTH - startX*2) / [[Dic_middle_image objectForKey:@"width"] floatValue];
    _imgV.frame = CGRectMake(startX,  _lblContent.frame.origin.y + _lblContent.frame.size.height + space, SCREENWIDTH - startX*2, imageHeight);
    NSURL *url = [NSURL URLWithString:[[[Dic_middle_image objectForKey:@"url_list"] firstObject] objectForKey:@"url"]];
    [_imgV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"sourceHeader"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    /** 数字是_btnImageV_gif的高宽 */
    _btnImgV_gif.frame = CGRectMake(_imgV.frame.size.width/2 - 20, Y + [[self class] heigthForText:_pictureTVModel.content] + _imgV.frame.size.height/2 - 10, 40, 20);
    [_btnImgV_gif setTitle:_pictureTVModel.label forState:UIControlStateNormal];
    [_btnImgV_gif addTarget:self action:@selector(btnImageV_gifAction:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 数字25是给定的固定高度 */
    _bottomView.frame = CGRectMake(startX, _imgV.frame.origin.y + _imgV.frame.size.height + space, _lblContent.frame.size.width, 25);
    [_bottomView initViewWithIndexTVModel:_pictureTVModel];
    
}
/**
 *  gif按钮点击事件
 *
 *  @param btnImageV_gif gif按钮
 */
- (void)btnImageV_gifAction:(UIButton *)btnImageV_gif {
    NSURL *url = [NSURL URLWithString:[[[_pictureTVModel.large_image objectForKey:@"url_list"] firstObject] objectForKey:@"url"]];
    [_imgV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"sourceHeader"] options:SDWebImageRetryFailed | SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
//            >btnImageV_gif.hidden = YES;
        }
    }];
}
/**
 *  根据标题的高度和图片的高度计算当前cell的高度
 *
 *  @return TVCell的高度值
 */
- (CGFloat)getCellHeight {
    return _bottomView.frame.origin.y + _bottomView.frame.size.height;
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







