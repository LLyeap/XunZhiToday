//
//  XZPictureTVCellBottomView.m
//  XunZhi
//
//  Created by 李雷 on 16/5/25.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZPictureTVCellBottomView.h"

#import "XZPictureTVModel.h"

/** 每个控件距离顶部的Y值 */
#define Y 5.0f
/** 每个控件的高度 */
#define Height 15.0f
/** 控件上文字的font */
#define myFont [UIFont systemFontOfSize:11.0f]

@interface XZPictureTVCellBottomView ()

/** 点赞次数 */
@property (nonatomic, retain) UILabel *digg_count;
/** 差评次数 */
@property (nonatomic, retain) UILabel *bury_count;
/** 评论次数 */
@property (nonatomic, retain) UILabel *comment_count;

@end

@implementation XZPictureTVCellBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.digg_count = [[UILabel alloc] init];
        [self addSubview:_digg_count];
        self.bury_count = [[UILabel alloc] init];
        [self addSubview:_bury_count];
        self.comment_count = [[UILabel alloc] init];
        [self addSubview:_comment_count];
    }
    return self;
}

#pragma mark - 自定义函数
/**
 *  初始化View上的控件的方法
 *
 *  @param pictureTVModel 参数模型数据, 用来给View上控件赋值
 */
- (void)initViewWithIndexTVModel:(XZPictureTVModel *)pictureTVModel {
    NSString *strDiggCount = [NSString stringWithFormat:@"%ld赞", pictureTVModel.digg_count];
    _digg_count.frame = CGRectMake(0, Y, [[self class] widthForText:strDiggCount], Height);
    _digg_count.text = strDiggCount;
    _digg_count.font = myFont;
    _digg_count.nightTextColor = UIColorFromRGB(0xffffff);
    
    /** View总高度是25, 数字Height(15)是其高度, 与顶部空Y(5), 与底部空5, 每两个控件之间隔5 */
    NSString *strBuryCount = [NSString stringWithFormat:@"%ld差", pictureTVModel.bury_count];
    _bury_count.frame = CGRectMake(_digg_count.frame.origin.x + _digg_count.frame.size.width + 5, Y, [[self class] widthForText:strBuryCount], Height);
    _bury_count.text = strBuryCount;
    _bury_count.font = myFont;
    _bury_count.nightTextColor = UIColorFromRGB(0xffffff);
    
    NSString *strCommentCount = [NSString stringWithFormat:@"%ld评论", pictureTVModel.comment_count];
    _comment_count.frame = CGRectMake(_bury_count.frame.origin.x + _bury_count.frame.size.width + 5, Y, [[self class] widthForText:strCommentCount], Height);
    _comment_count.text = strCommentCount;
    _comment_count.font = myFont;
    _comment_count.nightTextColor = UIColorFromRGB(0xffffff);
    
    /************/
    
}
/**
 *  文字宽度适配
 *
 *  @param text 文字内容
 *
 *  @return 文字所占宽度
 */
+ (CGFloat)widthForText:(NSString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(300, 0)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:myFont}
                                     context:nil];
    CGFloat textW = rect.size.width;
    return textW;
}






@end










