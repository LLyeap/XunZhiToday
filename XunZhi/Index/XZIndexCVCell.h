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

/** XZIndexVC中决定CVCell上tablev类型的属性 */
@property (nonatomic, assign) UITableViewStyle tableViewStyle;
/** XZIndexCVCellDelegate代理属性 */
@property (nonatomic, weak) id<XZIndexCVCellDelegate>delegate;

/**
 *  当XZIndexVC操作CVCell滑动时, 对滑动后的CVCell上的tableView数据进行刷新
 *
 *  @param category 根据类型进行网络数据下载
 */
- (void)refreshTableViewByDownloadDataWithCategory:(NSString *)category;

@end
