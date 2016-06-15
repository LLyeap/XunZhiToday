//
//  XZCollectionViewCell.h
//  XunZhi
//
//  Created by 李雷 on 16/5/20.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@class XZIndexTVModel;

@protocol XZIndexCVCellDelegate <NSObject>

/**
 *  代理方法, 因为CVCell无法push下一页, 所以通过此方法让其代理(XZIndexVC)push出子页面
 *
 *  @param webViewStrUrl 推出的子页是个网页, 参数为网页的URL
 */
- (void)pushVCFromIndexVCWithWebViewStrUrl:(NSString *)webViewStrUrl;
/**
 *  代理方法, 因为CVCell无法push下一页, 所以通过此方法让其代理(XZIndexVC)push出子页面
 *
 *  @param webViewStrUrl 推出的子页是个网页, 参数为网页的URL
 */
- (void)shareWithIndexPath:(XZIndexTVModel *)indexTVModel;;


@end

@interface XZIndexCVCell : UICollectionViewCell

/** 这里为了使用3D Touch的peek&pop, 所以将tableView和mArrTableView_net暴露在.h文件中 */
@property (nonatomic, retain) UITableView *tableView;
/** 网络数据, 元素是XZIndexTVModel类型, 用于显示在tableView上 */
@property (nonatomic, retain) NSMutableArray *mArrTableView_net;
/** XZIndexCVCellDelegate代理属性 */
@property (nonatomic, weak) id<XZIndexCVCellDelegate>delegate;
/** target作为中间桥梁, 将XZIndexVC设置成为UIViewControllerPreviewingDelegate的代理 */
@property (nonatomic, assign) id target;
/**
 *  当XZIndexVC操作CVCell滑动时, 对滑动后的CVCell上的tableView数据进行刷新
 *
 *  @param category 根据类型进行网络数据下载
 */
- (void)refreshTableViewByDownloadDataWithCategory:(NSString *)category;

@end
