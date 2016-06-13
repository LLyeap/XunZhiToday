//
//  XZVideoCVCell.h
//  XunZhi
//
//  Created by 李雷 on 16/5/25.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@class XZVideoTVModel;

@protocol XZVideoCVCellDelegate <NSObject>

/**
 *  代理方法, 当CVC里的tableView的点击事件点击时, 使其代理(XZVideoVC)推出子页面
 *
 *  @param videoTVModel 需要传入子页面的videoTVModel
 *  @param isNeed       判断是否需要传player(主页面视频已播放时需要)
 *  @param player       主页面视频播放的player(要这个player的一些值)
 */
- (void)pushVCFromVideoVCWithVideoTVModel:(XZVideoTVModel *)videoTVModel isNeed:(BOOL)isNeed Player:(AVPlayer *)player;

@end

@interface XZVideoCVCell : UICollectionViewCell

/** XZVideoCVCellDelegate代理属性 */
@property (nonatomic, weak) id<XZVideoCVCellDelegate>delegate;
/**
 *  当XZVideoVC里CVCcell改变时刷新tableView的数据
 *
 *  @param tid 向后台请求的ID值, 是对应于导航条名字的
 */
- (void)refreshTableViewByDownloadDataWithTid:(NSString *)tid;


@end
