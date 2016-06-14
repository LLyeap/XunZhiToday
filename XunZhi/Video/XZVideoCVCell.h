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
 */
- (void)pushVCFromVideoVCWithVideoTVModel:(XZVideoTVModel *)videoTVModel;

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
