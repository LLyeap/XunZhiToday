//
//  XZIndexThreePicTVCell.m
//  XunZhi
//
//  Created by 李雷 on 16/5/29.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZIndexThreePicTVCell.h"

#import "XZIndexTVModel.h"
#import "XZIndexTVCellBottomView.h"

/** 控件距离屏幕左侧的距离 */
#define startX 10.0f
/** 控件距离cell顶部的距离 */
#define Y 10.0f
/** 控件与控件之间的间距 */
#define space 5.0f

@interface XZIndexThreePicTVCell ()

/** 新闻的标题 */
@property (nonatomic, retain) UILabel *lblTitle;
/** cell上的图片(左侧) */
@property (nonatomic, retain) UIImageView *imgVLeft;
/** cell上的图片(中间) */
@property (nonatomic, retain) UIImageView *imgVCenter;
/** cell上的图片(右侧) */
@property (nonatomic, retain) UIImageView *imgVRight;
/** 新闻主要内容底部的一些信息(来源, 赞, 评论...) */
@property (nonatomic, retain) XZIndexTVCellBottomView *bottomView;

@end

@implementation XZIndexThreePicTVCell

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
        self.imgVLeft = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVLeft];
        self.imgVCenter = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVCenter];
        self.imgVRight = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVRight];
        self.bottomView = [[XZIndexTVCellBottomView alloc] init];
        [self.contentView addSubview:_bottomView];
    }
    return self;
}

/**
 *  自定义cell上控件的布局, 要先布局原有的三个(图片, 标题, 右侧提示)
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    _lblTitle.frame = CGRectMake(startX, Y, SCREENWIDTH - startX*2, [[self class] heigthForText:_indexTVModel.title]);
    _lblTitle.text = _indexTVModel.title;
    _lblTitle.font = titleFont;
    _lblTitle.nightTextColor = [UIColor whiteColor];
    
    _imgVLeft.frame = CGRectMake(startX,  _lblTitle.frame.origin.y + _lblTitle.frame.size.height + space, (SCREENWIDTH - startX*4)/3, (SCREENWIDTH - startX*4)/6);
    [_imgVLeft sd_setImageWithURL:[NSURL URLWithString:[_indexTVModel.image_list[0] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"sourceHeader"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    _imgVCenter.frame = CGRectMake(_imgVLeft.frame.origin.x + _imgVLeft.frame.size.width + startX, _imgVLeft.frame.origin.y, _imgVLeft.frame.size.width, _imgVLeft.frame.size.height);
    [_imgVCenter sd_setImageWithURL:[NSURL URLWithString:[_indexTVModel.image_list[1] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"sourceHeader"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    _imgVRight.frame = CGRectMake(_imgVCenter.frame.origin.x + _imgVCenter.frame.size.width + startX, _imgVLeft.frame.origin.y, _imgVLeft.frame.size.width, _imgVLeft.frame.size.height);
    [_imgVRight sd_setImageWithURL:[NSURL URLWithString:[_indexTVModel.image_list[2] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"sourceHeader"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    /** 数字25是给定的固定高度 */
    _bottomView.frame = CGRectMake(startX, _imgVLeft.frame.origin.y + _imgVLeft.frame.size.height + space, _lblTitle.frame.size.width, 25);
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
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end






