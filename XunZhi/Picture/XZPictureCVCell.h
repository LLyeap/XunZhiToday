//
//  XZPictureCVCell.h
//  XunZhi
//
//  Created by 王旭 on 16/5/25.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XZPictureCVCellDelegate <NSObject>

/**
 *  代理方法, 因为CVCell无法push下一页, 所以通过此方法让其代理(XZPictureVC)push出子页面
 *
 *  @param webViewStrUrl 推出的子页是个网页, 参数为网页的URL
 */
- (void)pushVCFromVideoVCWithWebViewStrUrl:(NSString *)webViewStrUrl;

@end

@interface XZPictureCVCell : UICollectionViewCell

/** 这里为了使用3D Touch的peek&pop, 所以将tableView和mArrTableView_net暴露在.h文件中 */
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *mArrTableView_net;
/** XZPictureCVCellDelegate代理属性 */
@property (nonatomic, weak) id<XZPictureCVCellDelegate>delegate;
/** target作为中间桥梁, 将XZPictureVC设置成为UIViewControllerPreviewingDelegate的代理 */
@property (nonatomic, assign) id target;
/**
 *  当XZPictureVC操作CVCell滑动时, 对滑动后的CVCell上的tableView数据进行刷新
 *
 *  @param category 根据类型进行网络数据下载
 */
- (void)refreshTableViewByDownloadDataWithCategory:(NSString *)category;


@end
