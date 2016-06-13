//
//  XZIndexBottomView.m
//  XunZhi
//
//  Created by 李雷 on 16/5/24.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZIndexTVCellBottomView.h"

#import "XZIndexTVModel.h"
#import "XZDBSet.h"
#import "XZIndexSqliteModel.h"

/** 每个控件距离顶部的Y值 */
#define Y 5.0f
/** 每个控件的高度 */
#define Height 15.0f
/** 控件上文字的font */
#define myFont [UIFont systemFontOfSize:11.0f]

@interface XZIndexTVCellBottomView () <UMSocialUIDelegate>

/** 暂存模型数据 */
@property (nonatomic, retain) XZIndexTVModel *indexTVModel;
/** 新闻来源的头像 */
@property (nonatomic, retain) UIImageView *sourceImgV;
/** 新闻来源的名称 */
@property (nonatomic, retain) UILabel *sourceName;
/** 点赞次数 */
@property (nonatomic, retain) UILabel *likeCount;
/** 评论次数 */
@property (nonatomic, retain) UILabel *commentCount;
/** 热点时间 */
@property (nonatomic, retain) UILabel *behotTime;
/** 特殊标记(置顶, 图片, 视频) */
@property (nonatomic, retain) UILabel *markName;
/** 收藏按钮 */
@property (nonatomic, retain) UIButton *favorite;
/** 不喜欢(屏蔽此类按钮) */
@property (nonatomic, retain) UIButton *btnShare;

@end

@implementation XZIndexTVCellBottomView

/**
 *  初始化方法
 *
 *  @param frame View的frame
 *
 *  @return XZIndexTVCellBottomView
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.sourceImgV = [[UIImageView alloc] init];
        [self addSubview:_sourceImgV];
        self.sourceName = [[UILabel alloc] init];
        [self addSubview:_sourceName];
        self.likeCount = [[UILabel alloc] init];
        [self addSubview:_likeCount];
        self.commentCount = [[UILabel alloc] init];
        [self addSubview:_commentCount];
        self.behotTime = [[UILabel alloc] init];
        [self addSubview:_behotTime];
        self.markName = [[UILabel alloc] init];
        [self addSubview:_markName];
        self.favorite = [[UIButton alloc] init];
        [self addSubview:_favorite];
        self.btnShare = [[UIButton alloc] init];
        [self addSubview:_btnShare];
    }
    return self;
}

#pragma mark - 自定义函数
/**
 *  初始化View上的控件的方法
 *
 *  @param indexTVModel 参数模型数据, 用来给View上控件赋值
 */
- (void)initViewWithIndexTVModel:(XZIndexTVModel *)indexTVModel {
    self.indexTVModel = indexTVModel;
    
    _sourceImgV.frame = CGRectMake(0, Y, Height, Height);
    [_sourceImgV sd_setImageWithURL:[NSURL URLWithString:indexTVModel.source_avatar] placeholderImage:[UIImage imageNamed:@"sourceHeader"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _sourceImgV.layer.masksToBounds =YES;
    _sourceImgV.layer.cornerRadius = _sourceImgV.frame.size.width / 2;
    
    /** View总高度是25, 数字Height(15)是其高度, 与顶部空Y(5), 与底部空5, 每两个控件之间隔5 */
    _sourceName.frame = CGRectMake(_sourceImgV.frame.origin.x + _sourceImgV.frame.size.width + 5, Y, [[self class] widthForText:indexTVModel.source], Height);
    _sourceName.text = indexTVModel.source;
    _sourceName.font = myFont;
    _sourceName.textColor = UIColorFromRGB(0x575757);
    _sourceName.nightTextColor = UIColorFromRGB(0x8A8A8A);
    
    NSString *strLikeCout = [NSString stringWithFormat:@"%ld赞", (long)indexTVModel.like_count];
    _likeCount.frame = CGRectMake(_sourceName.frame.origin.x + _sourceName.frame.size.width + 5, Y, [[self class] widthForText:strLikeCout], Height);
    _likeCount.text = strLikeCout;
    _likeCount.font = myFont;
    _likeCount.textColor = UIColorFromRGB(0x575757);
    _likeCount.nightTextColor = UIColorFromRGB(0x8A8A8A);
    
    NSString *strCommentCount = [NSString stringWithFormat:@"%ld评论", (long)indexTVModel.comment_count];
    _commentCount.frame = CGRectMake(_likeCount.frame.origin.x + _likeCount.frame.size.width + 5, Y, [[self class] widthForText:strCommentCount], Height);
    _commentCount.text = strCommentCount;
    _commentCount.font = myFont;
    _commentCount.textColor = UIColorFromRGB(0x575757);
    _commentCount.nightTextColor = UIColorFromRGB(0x8A8A8A);
    
    /*********/
    
    _markName.frame = CGRectMake(_commentCount.frame.origin.x + _commentCount.frame.size.width + 5, Y, [[self class] widthForText:indexTVModel.label], Height);
    _markName.text = indexTVModel.label;
    _markName.font = myFont;
    _markName.textColor = UIColorFromRGB(0xCC3333);
    _markName.nightTextColor = UIColorFromRGB(0xCC3333);
    _markName.layer.borderColor = UIColorFromRGB(0xCC3333).CGColor;
    _markName.layer.borderWidth = 1.0f;
    _markName.layer.cornerRadius = 2.0f;
    
    _favorite.frame = CGRectMake(self.frame.size.width - Height*3.5, Y, Height*1.4, Height*1.4);
    [_favorite setImage:[UIImage imageNamed:@"favoriteNormal"] forState:UIControlStateNormal];
    [_favorite setImage:[UIImage imageNamed:@"favoriteSelected"] forState:UIControlStateSelected];
    [_favorite addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
    // >设置是否收藏
    if ([indexTVModel.isFavorite isEqualToString:@"T"]) {
        _favorite.selected = YES;
    } else {
        _favorite.selected = NO;
    }
    
    _btnShare.frame = CGRectMake(self.frame.size.width - Height*1.4, Y, Height*1.4, Height*1.4);
    [_btnShare setImage:[UIImage imageNamed:@"btnShare"] forState:UIControlStateNormal];
    [_btnShare addTarget:self action:@selector(btnShareAction:) forControlEvents:UIControlEventTouchUpInside];
//    _btnShare.layer.borderColor = UIColorFromRGB(0x778899).CGColor;
//    _btnShare.layer.borderWidth = 1.0f;
//    _btnShare.layer.cornerRadius = 5.0f;
    
}
/**
 *  收藏按钮点击事件
 *
 *  @param favorite 收藏按钮
 */
- (void)favoriteAction:(UIButton *)favorite {
    // >放大后缩小动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.1),@(1.0),@(1.5)];
    animation.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    animation.calculationMode = kCAAnimationLinear;
    [favorite.layer addAnimation:animation forKey:@"show"];
    favorite.selected = !favorite.selected;
//    XZLog(@"%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    if (favorite.selected) { // 收藏情况下点击, 则取消收藏
        
        [self insertData];
        [MBProgressHUD showSuccess:@"收藏成功"];
    } else { // 未收藏情况下点击, 进行收藏
        
        [self deleteData];
        [MBProgressHUD showSuccess:@"已取消收藏"];
    }
    // >让代理XZIndexCVCell执行方法, 在方法中修改数组指定位置的模型数据的isFavorite的属性值
    [self.delegate changeFavoriteStatusInArrayWithIndexPath:_indexPath];
}
/**
 *  分享按钮的点击事件
 *
 *  @param btnShare 分享按钮
 */
- (void)btnShareAction:(UIButton *)btnShare {
//    XZLog(@"分享");
    /** 代理方法实现分享 */
    [self.delegate shareWithIndexPath:_indexPath];
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
#pragma mark - 收藏数据库操作
/**
 *  向收藏数据库批量添加数据(就添加一条)
 */
- (void)insertData {
    NSMutableArray *userArray = [NSMutableArray new];
    XZIndexSqliteModel *indexSqliteModel = [XZIndexSqliteModel new];
    
    indexSqliteModel.Publish_Time = _indexTVModel.Publish_Time;
    indexSqliteModel.title = _indexTVModel.title;
    indexSqliteModel.source = _indexTVModel.source;
    indexSqliteModel.source_avatar = _indexTVModel.source_avatar;
    indexSqliteModel.like_count = _indexTVModel.like_count;
    indexSqliteModel.comment_count = _indexTVModel.comment_count;
    indexSqliteModel.label = _indexTVModel.label;
    indexSqliteModel.behot_time = _indexTVModel.behot_time;
    indexSqliteModel.share_url = _indexTVModel.share_url;
    indexSqliteModel.has_video = _indexTVModel.has_video;
    indexSqliteModel.video_detail_info = _indexTVModel.video_detail_info;
    indexSqliteModel.video_duration = _indexTVModel.video_duration;
    indexSqliteModel.gallary_image_count = _indexTVModel.gallary_image_count;
    indexSqliteModel.image_list = _indexTVModel.image_list;
    indexSqliteModel.large_image_list = _indexTVModel.large_image_list;
    indexSqliteModel.middle_image = _indexTVModel.middle_image;
    indexSqliteModel.isFavorite = @"T";
    
    [userArray addObject:indexSqliteModel];
    
    //创建插入对象
    FMDTInsertCommand *icmd = [[XZDBSet shared].indexSqliteModel createInsertCommand];
    //添加要插入的对象集合
    [icmd addWithArray:userArray];
    //设置添加操作是否使用replace语句
    [icmd setRelpace:YES];
    //执行插入操作
    [icmd saveChangesInBackground:^{
//        XZLog(@"批量数据提交完成");
    }];
}
/**
 *  点击已收藏的新闻, 取消收藏, 在数据库中将其移除
 */
- (void)deleteData {
    FMDTDeleteCommand *dcmd = FMDT_DELETE([XZDBSet shared].indexSqliteModel);
    //设置条件
    [dcmd where:@"publish_time" equalTo:_indexTVModel.Publish_Time];
    //执行删除操作
    [dcmd saveChanges];
}









@end










