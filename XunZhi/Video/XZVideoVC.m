//
//  XZVideoVC.m
//  XunZhi
//
//  Created by user on 16/5/23.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZVideoVC.h"

#import "XZNaviV.h"
#import "XZVideoCVCell.h"
#import "XZVideoNaviModel.h"
#import "XZVideoSubVC.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "XZVideoTVModel.h"
#import "XZSearchVC.h"

#define naviHeight 44.0f

@interface XZVideoVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, XZVideoCVCellDelegate>

@property (nonatomic, retain) XZNaviV *naviV;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *mArrNavi_net;

@end

@implementation XZVideoVC

- (void)viewWillAppear:(BOOL)animated {
    /** 从网络下载导航条的数据内容 */
    if (!_mArrNavi_net) {
        self.mArrNavi_net = [NSMutableArray array];
        [self downloadNaviItems];
    }
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /** collectionView的设置 */
    self.collectionView.pagingEnabled = YES;
    [_collectionView registerClass:[XZVideoCVCell class] forCellWithReuseIdentifier:@"CVCellID"];
    // >设置_collectionView滚动到边缘是没有弹动事件, (如果弹动, 并且弹动没有恢复就有滑动的话, 这时XZNaviV中的titleLabl的设置会报错, 程序会炸)
    _collectionView.bounces = NO;
}

#pragma mark - 自定义函数
/**
 *  创建这个控制器的导航条
 */
- (void)createNavi {
    /** 处理Navi上显示的数据 */
    NSMutableArray *mArrNaviName = [NSMutableArray array];
    for (int i=0; i<_mArrNavi_net.count; i++) {
        XZVideoNaviModel *videoNaviModel = _mArrNavi_net[i];
        [mArrNaviName addObject:videoNaviModel.tname];
    }
    __weak typeof(self) weakSelf = self;
    /** 给当前页面(首页添加导航栏) */
    self.naviV = [[XZNaviV alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, naviHeight) ItemArray:mArrNaviName itemClickBlock:^(NSInteger tag)  {
        weakSelf.collectionView.contentOffset = CGPointMake(_collectionView.frame.size.width * (tag-1), 0);
        /** 重新加载collection, 与下载数据中的刷新不冲突 */
        [weakSelf.collectionView reloadData];
    } btnRightBlock:^(UIButton *btnRight) { // >右侧搜索按钮事件
        XZSearchVC *searchVC = [[XZSearchVC alloc] init];
        [weakSelf.navigationController pushViewController:searchVC animated:YES];
    }];
    self.navigationItem.titleView = _naviV;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mArrNavi_net.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XZVideoCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CVCellID" forIndexPath:indexPath];
    
    XZVideoNaviModel *videoNaviModel = _mArrNavi_net[indexPath.item];
    [cell refreshTableViewByDownloadDataWithTid:videoNaviModel.tid];
    cell.delegate = self;
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - UICollectionViewDelegateFlowLayout

#pragma mark - UICollectionView继承UIScrollView, 以下是UIScrollView的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_naviV scrollWithTag:scrollView.contentOffset.x/_collectionView.frame.size.width + 1];
}
#pragma mark - XZVideoCVCellDelegate
- (void)pushVCFromVideoVCWithVideoTVModel:(XZVideoTVModel *)videoTVModel {
    XZVideoSubVC *videoSubVC = [[XZVideoSubVC alloc] init];
    videoSubVC.videoTVModel = videoTVModel;
    [self.navigationController pushViewController:videoSubVC animated:YES];
}


#pragma mark - 网络数据
// >http://c.m.163.com/nc/video/topiclist.html
- (void)downloadNaviItems {
    NSString *strUrl = @"http://c.m.163.com/nc/video/topiclist.html";
    __weak typeof(self) weakSelf = self;
    [NetRequest postDataWithURL:strUrl dic:@{} success:^(id responseObject) {
        NSArray *arrDown = (NSArray *)responseObject;
        for (int i=0; i<arrDown.count; i++) {
            NSDictionary *mainDict = arrDown[i];
            XZVideoNaviModel *videoNaviModel = [XZVideoNaviModel videoNaviModelWithDict:mainDict];
            [_mArrNavi_net addObject:videoNaviModel];
        }
        /** 根据数据刷新页面 */
        [weakSelf createNavi];
        if (nil==weakSelf.collectionView.dataSource && nil==weakSelf.collectionView.delegate) {
            weakSelf.collectionView.delegate = self;
            weakSelf.collectionView.dataSource = self;
        }
        /** 重新加载collection, 与navi的点击block块中的刷新不冲突 */
        [weakSelf.collectionView reloadData];
    } filed:^(NSError *error) {
        
    }];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}





@end







