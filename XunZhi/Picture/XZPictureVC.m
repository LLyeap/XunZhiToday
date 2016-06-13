//
//  XZPictureVC.m
//  XunZhi
//
//  Created by user on 16/5/23.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZPictureVC.h"

#import "XZNaviV.h"
#import "XZPictureCVCell.h"
#import "XZIndexNaviModel.h"
#import "XZPictureSubVC.h"
#import "XZSearchVC.h"

#define naviHeight 44.0f

@interface XZPictureVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, XZPictureCVCellDelegate>

/** 自定义的导航条目, 放在NaviBar的titleView上 */
@property (nonatomic, retain) XZNaviV *naviV;
/** 控制器上的collectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 网络数据, 元素是XZIndexNaviModel类型, 用于创建XZNaviV */
@property (nonatomic, retain) NSMutableArray *mArrNavi_net;

@end

@implementation XZPictureVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // >创建导航条
    [self createNavi];
    
    /** collectionView的设置 */
    self.collectionView.pagingEnabled = YES;
    [_collectionView registerClass:[XZPictureCVCell class] forCellWithReuseIdentifier:@"CVCellID"];
    // >设置_collectionView滚动到边缘是没有弹动事件, (如果弹动, 并且弹动没有恢复就有滑动的话, 这时XZNaviV中的titleLabl的设置会报错, 程序会炸)
    _collectionView.bounces = NO;
}

#pragma mark - 自定义函数
/**
 *  创建这个控制器的导航条
 */
- (void)createNavi {
    /** 这里没有找到从网络下载类型的连接, 所以自己根据请求连接自己写了 */
    self.mArrNavi_net = [NSMutableArray array];
    XZIndexNaviModel *naviModel1 = [XZIndexNaviModel indexNaviModelWithDict:@{@"category":@"image_funny",
                                                               @"name":@"趣图",
                                                               @"tip_new":@0}];
    XZIndexNaviModel *naviModel2 = [XZIndexNaviModel indexNaviModelWithDict:@{@"category":@"image_ppmm",
                                                               @"name":@"美女",
                                                               @"tip_new":@0}];
//    XZIndexNaviModel *naviModel3 = [XZIndexNaviModel indexNaviModelWithDict:@{@"category":@"image_wonderful",
//                                                               @"name":@"美图",
//                                                               @"tip_new":@0}];
    [_mArrNavi_net addObject:naviModel1];
    [_mArrNavi_net addObject:naviModel2];
//    [_mArrNavi_net addObject:naviModel3];
    
    /** 处理Navi上显示的数据 */
    NSMutableArray *mArrNaviName = [NSMutableArray array];
    for (int i=0; i<_mArrNavi_net.count; i++) {
        XZIndexNaviModel *naviModel = _mArrNavi_net[i];
        [mArrNaviName addObject:naviModel.name];
    }
    __weak typeof(self) weakSelf = self;
    /** 给当前页面(首页添加导航栏) */
    self.naviV = [[XZNaviV alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, naviHeight) ItemArray:mArrNaviName itemClickBlock:^(NSInteger tag)  {
        weakSelf.collectionView.contentOffset = CGPointMake(_collectionView.frame.size.width * (tag-1), 0);
//        // >为了保持和Index&Video一样而这么写
//        if (nil==weakSelf.collectionView.dataSource && nil==weakSelf.collectionView.delegate) {
//            weakSelf.collectionView.delegate = self;
//            weakSelf.collectionView.dataSource = self;
//        }
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
    XZPictureCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CVCellID" forIndexPath:indexPath];
    
    cell.tableViewStyle = UITableViewStylePlain;
    XZIndexNaviModel *naviModel = _mArrNavi_net[indexPath.item];
    [cell refreshTableViewByDownloadDataWithCategory:naviModel.category];
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
#pragma mark - XZPictureCVCellDelegate
- (void)pushVCFromVideoVCWithWebViewStrUrl:(NSString *)webViewStrUrl {
    XZPictureSubVC *pictureSubVC = [[XZPictureSubVC alloc] init];
    pictureSubVC.webViewStrUrl = webViewStrUrl;
    [self.navigationController pushViewController:pictureSubVC animated:YES];
}

#pragma mark - 网络数据









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}








@end









