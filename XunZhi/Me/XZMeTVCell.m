//
//  XZMeLabelTVCell.m
//  XunZhi
//
//  Created by 李雷 on 16/5/31.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZMeTVCell.h"

#import "XZMeTVModel.h"

#define cellHeight 44.0f

@interface XZMeTVCell ()

@property (nonatomic, retain) UIImageView *imgV_left;
@property (nonatomic, retain) UILabel *lbl_center;
@property (nonatomic, retain) UISwitch *switch_right;
@property (nonatomic, retain) UILabel *lbl_right;

@end

@implementation XZMeTVCell

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
        self.imgV_left = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgV_left];
        self.lbl_center = [[UILabel alloc] init];
        [self.contentView addSubview:_lbl_center];
        self.switch_right = [[UISwitch alloc] init];
        [self.contentView addSubview:_switch_right];
        self.lbl_right = [[UILabel alloc] init];
        [self.contentView addSubview:_lbl_right];
    }
    return self;
}

/**
 *  自定义cell上控件的布局, 要先布局原有的三个(图片, 标题, 右侧提示)
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    _imgV_left.frame = CGRectMake(cellHeight/2, cellHeight/4, cellHeight/2, cellHeight/2);
    _imgV_left.image = [UIImage imageNamed:_meTVModel.icon];
    _lbl_center.text = _meTVModel.title;
    _lbl_center.frame = CGRectMake(60, 0, 100, cellHeight);
    _lbl_center.nightTextColor = [UIColor whiteColor];
    // >判断右侧控件类型
    if ([_meTVModel.type isEqualToString:@"switch"]) {
        _switch_right.frame = CGRectMake(SCREENWIDTH - 10 - 50, 0, 50, cellHeight);
        [_switch_right addTarget:self action:@selector(switch_rightAction:) forControlEvents:UIControlEventValueChanged];
    } else {
        _switch_right.hidden = YES;
    }
    if ([_meTVModel.type isEqualToString:@"label"]) {
        _lbl_right.frame = CGRectMake(SCREENWIDTH - 10 - 100, 0, 100, cellHeight);
        _lbl_right.nightTextColor = UIColorFromRGB(0xffffff);
        _lbl_right.textAlignment = NSTextAlignmentRight;
        _lbl_right.text = [NSString stringWithFormat:@"%.2fM", [self filePath]];
    } else {
        _lbl_right.hidden = YES;
    }
}
/**
 *  switch_right按钮的点击事件, 实现夜间模式和日间模式的切换
 *
 *  @param switch_right switch_right
 */
- (void)switch_rightAction:(UISwitch *)switch_right {
    if (switch_right.on) {
        [DKNightVersionManager nightFalling];
    } else {
        [DKNightVersionManager dawnComing];
    }
}


#pragma mark - 获得缓存大小
- (float)filePath {
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//    XZLog(@"cachPath=%@", cachPath);
    return [self folderSizeAtPath:cachPath];
}
- (float)folderSizeAtPath:(NSString *)folderPath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize / (1024.0*1024.0);
}
- (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0 ;
}









- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end









