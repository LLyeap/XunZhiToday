//
//  XZMeSwitchTVCell.m
//  XunZhi
//
//  Created by 李雷 on 16/5/28.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZMeSwitchTVCell.h"

@interface XZMeSwitchTVCell ()

@property (nonatomic, retain) UIImageView *imgV_left;
@property (nonatomic, retain) UILabel *lbl_center;
@property (nonatomic, retain) UISwitch *switch_right;

@end

@implementation XZMeSwitchTVCell
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
    }
    return self;
}

/**
 *  自定义cell上控件的布局, 要先布局原有的三个(图片, 标题, 右侧提示)
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    _imgV_left.frame = CGRectMake(10, 0, 44, 44);
    _imgV_left.image = [UIImage imageNamed:@"night"];
    _lbl_center.text = @"夜间";
    _lbl_center.frame = CGRectMake(60, 0, 100, 44);
    _switch_right.frame = CGRectMake(SCREENWIDTH - 10 - 60, 0, 60, 44);
    [_switch_right addTarget:self action:@selector(switch_rightAction:) forControlEvents:UIControlEventValueChanged];
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





- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
