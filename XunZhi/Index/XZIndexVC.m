//
//  XZIndexVC.m
//  XunZhi
//
//  Created by 李雷 on 16/5/15.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZIndexVC.h"

#import "XZNaviV.h"
#import "XZIndexCVCell.h"
#import "XZIndexNaviModel.h"
#import "XZIndexSubVC.h"
#import "XZSearchVC.h"
#import "XZIndexTVModel.h"

#define naviHeight 44.0f

@interface XZIndexVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, XZIndexCVCellDelegate, UMSocialUIDelegate, UIViewControllerPreviewingDelegate>

/** 自定义的导航条目, 放在NaviBar的titleView上 */
@property (nonatomic, retain) XZNaviV *naviV;
/** 控制器上的collectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 网络数据, 元素是XZIndexNaviModel类型, 用于创建XZNaviV */
@property (nonatomic, retain) NSMutableArray *mArrNavi_net;
/** 为了通过它来获得它上面的tableView */
@property (nonatomic, retain) XZIndexCVCell *currentCell;

@end

@implementation XZIndexVC

- (void)viewWillAppear:(BOOL)animated {
    /** 从网络下载导航条的数据内容 */
    if (!_mArrNavi_net) {
        self.mArrNavi_net = [NSMutableArray array];
        /** 之所以先定义一个推荐导航条目, 是因为网络数据中没有这项, 而应用中有 */
        XZIndexNaviModel *indexNaviModel = [XZIndexNaviModel indexNaviModelWithDict:@{@"category":@"",
                                                                                      @"name":@"推荐",
                                                                                      @"tip_new":@0}];
        [_mArrNavi_net addObject:indexNaviModel];
        [self downloadNaviItems];
    }
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /** collectionView的设置 */
    self.collectionView.pagingEnabled = YES;
    [_collectionView registerClass:[XZIndexCVCell class] forCellWithReuseIdentifier:@"CVCellID"];
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
        XZIndexNaviModel *indexNaviModel = _mArrNavi_net[i];
        [mArrNaviName addObject:indexNaviModel.name];
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
    XZIndexCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CVCellID" forIndexPath:indexPath];
    
    XZIndexNaviModel *indexNaviModel = _mArrNavi_net[indexPath.item];
    [cell refreshTableViewByDownloadDataWithCategory:indexNaviModel.category];
    cell.delegate = self;
    cell.target = self;
    
    // >将当前XZIndexCVCell设置为_currentCell, 以便3D Touch等获得必要的数据
    _currentCell = cell;
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - UICollectionViewDelegateFlowLayout

#pragma mark - UICollectionView继承UIScrollView, 以下是UIScrollView的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x/_collectionView.frame.size.width;
    // >设置导航条的变化
    [_naviV scrollWithTag:offset + 1];
    
//    // >为了获得当前的XZIndexCVCell上的tableView
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:offset inSection:0];
//    _currentCell = (XZIndexCVCell *)[_collectionView cellForItemAtIndexPath:indexPath];
}
#pragma mark - XZIndexCVCellDelegate
- (void)pushVCFromIndexVCWithWebViewStrUrl:(NSString *)webViewStrUrl {
    XZIndexSubVC *indexSubVC = [[XZIndexSubVC alloc] init];
    indexSubVC.webViewStrUrl = webViewStrUrl;
    [self.navigationController pushViewController:indexSubVC animated:YES];
}
- (void)shareWithIndexPath:(XZIndexTVModel *)indexTVModel {
    if (indexTVModel.image_list.count != 0) { // >分享的内容有图片
        UIImageView *imgV = [[UIImageView alloc] init];
        [imgV sd_setImageWithURL:[NSURL URLWithString:[indexTVModel.image_list[0] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"sourceHeader"] options:SDWebImageRetryFailed | SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UMSocialData defaultData].extConfig.title = @"分享的title";
            [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://baidu.com";
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"507fcab25270157b37000010"
                                              shareText:[NSString stringWithFormat:@"%@\n%@", indexTVModel.title, indexTVModel.share_url]
                                             shareImage:image//[UIImage imageNamed:@"icon"]
                                        shareToSnsNames:@[UMShareToWechatSession,
                                                          UMShareToWechatTimeline]
                                               delegate:self];
            
            
            [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
        }];
    } else { // >分享的内容无图片
        [UMSocialData defaultData].extConfig.title = @"分享的title";
        [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://baidu.com";
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"507fcab25270157b37000010"
                                          shareText:[NSString stringWithFormat:@"%@\n%@", indexTVModel.title, indexTVModel.share_url]
                                         shareImage:[UIImage imageNamed:@"AppIcon"]
                                    shareToSnsNames:@[UMShareToWechatSession,
                                                      UMShareToWechatTimeline]
                                           delegate:self];
        
        
        [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
    }
}
#pragma mark - UMSocialUIDelegate
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess) {
        //得到分享到的平台名
        XZLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
#pragma mark - UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    XZIndexSubVC *indexSubVC = [[XZIndexSubVC alloc] init];
    // >转化坐标
    location = [_currentCell.tableView convertPoint:location fromView:[previewingContext sourceView]];
    // >根据locaton获取位置
    NSIndexPath *indexPath = [_currentCell.tableView indexPathForRowAtPoint:location];
    
    //    XZLog(@"_currentCell.tableView%@, %ld", _currentCell.tableView, (long)indexPath.row);
    // >取得对应位置的数据, 这地方需要用到模型, 控制器接触到更多数据, 有瑕疵!!!
    XZIndexTVModel *indexTVModel = (XZIndexTVModel *)[_currentCell.mArrTableView_net objectAtIndex:indexPath.row];
    
    // >根据位置获取图片网址数据传入控制器
    indexSubVC.webViewStrUrl = indexTVModel.share_url;
    
    return indexSubVC;
}
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    viewControllerToCommit.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}





#pragma mark - 网络数据
// >http://ic.snssdk.com/article/category/get_subscribed/v1/?iid=4315625960
- (void)downloadNaviItems {
    NSString *strUrl = @"http://ic.snssdk.com/article/category/get_subscribed/v1/";
    NSDictionary *dic = @{@"iid":@"4315625960"};
    __weak typeof(self) weakSelf = self;
    [NetRequest postDataWithURL:strUrl dic:dic success:^(id responseObject) {
        NSDictionary *dictDown = (NSDictionary *)responseObject;
        NSArray *mainDataArr = [[dictDown objectForKey:@"data"] objectForKey:@"data"];
        for (int i=0; i<mainDataArr.count; i++) {
            NSDictionary *mainDict = mainDataArr[i];
            XZIndexNaviModel *indexNaviModel = [XZIndexNaviModel indexNaviModelWithDict:mainDict];
            if ([indexNaviModel.name isEqualToString:@"四平"] || [indexNaviModel.name isEqualToString:@"订阅"] || [indexNaviModel.name isEqualToString:@"段子"] || [indexNaviModel.name isEqualToString:@"趣图"] || [indexNaviModel.name isEqualToString:@"美女"]) {
                continue;
            }
            [_mArrNavi_net addObject:indexNaviModel];
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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [DKNightVersionManager dawnComing];
}



@end








