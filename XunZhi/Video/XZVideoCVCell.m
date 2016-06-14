//
//  XZVideoCVCell.m
//  XunZhi
//
//  Created by 李雷 on 16/5/25.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZVideoCVCell.h"

#import "XZVideoTVModel.h"
#import "XZVideoTVCell.h"
#import "XZVideoSubVC.h"
#import "XZVideoVC.h"
#import "XZVideoSingleton.h"

#define VideoPlayerHeight 10.0f + SCREENWIDTH/2 + 10.0f

@interface XZVideoCVCell () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
/** 获取用于放在tableView上的数据, 内容是XZVideoTVModel */
@property (nonatomic, retain) NSMutableArray *mArrTableView_net;
/** 保存从refreshTableViewByDownloadDataWithTid函数传过来的tid值 */
@property (nonatomic, retain) NSString *tid;
/** 视频播放控制器, 它上面有视频播放控件 */
@property (nonatomic, retain) AVPlayerViewController *playerController;
/** 用于判断当前播放的视频的位置, 判断是否需要继续播放(移出屏幕停止播放) */
@property (nonatomic, assign) NSInteger index;
/** 请求网络数据的URL一部分, 用于刷新&加载更多时使用 */
@property (nonatomic, assign) NSInteger webPage;
/** 判断tableView是不是下拉刷新 */
@property (nonatomic, assign) BOOL isHeaderRefresh;


@end

@implementation XZVideoCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.webPage = 0;
        self.mArrTableView_net = [NSMutableArray array];
        [self createTableView];
    }
    return self;
}
#pragma mark - 自定义方法
/**
 *  创建CVCell上的tableView
 */
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    [self.contentView addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    /** 下拉刷新, GIF图尚未完成 */
    XZRefreshGifHeader *gifHeader = [XZRefreshGifHeader headerWithRefreshingBlock:^{
        // >设置刷新形式是下拉刷新, 在网络下载数据成功后清空数组
        self.isHeaderRefresh = YES;
        _webPage = 0;
        [self downloadData];
    }];
    // > 设置header
    _tableView.mj_header = gifHeader;
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _webPage++;
        [self downloadData];
    }];
    /** 设置夜间模式 */
    _tableView.backgroundColor = UIColorFromRGB(0xffffff);
    _tableView.nightBackgroundColor = UIColorFromRGB(0x343434);
}
/**
 *  当XZVideoVC里CVCcell改变时刷新tableView的数据
 *
 *  @param tid 向后台请求的ID值, 是对应于导航条名字的
 */
- (void)refreshTableViewByDownloadDataWithTid:(NSString *)tid {
    /** 因为在导航条改变条目时, 如果没有网络, 数据则不会改变, 显示之前的内容, 同时, 下一步清空了数组, 这时会发生数组越界 */
    _tableView.hidden = YES;
    /** 更换导航条目时, 关闭当前播放 */
    [_playerController.player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
    _playerController.player = nil;
    [_playerController.view removeFromSuperview];
    /**  清空前一目录原有数据, 待重新加载 */
    [_mArrTableView_net removeAllObjects];
    
    [MBProgressHUD showMessage:@"加载中" toView:self];
    
    self.tid = tid;
    /** 下载网络数据 */
    [self downloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mArrTableView_net.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZVideoTVModel *videoTVModel = _mArrTableView_net[indexPath.row];
    
    static NSString *videoTVCellID = @"videoTVCellID";
    XZVideoTVCell *cell = [tableView dequeueReusableCellWithIdentifier:videoTVCellID];
    if (!cell) {
        cell = [[XZVideoTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoTVCellID];
    }
    
    cell.videoTVModel = videoTVModel;
    cell.imgVPlay.tag = indexPath.row + 1;
    [cell.tapPlay addTarget:self action:@selector(tapPlayAction:)];
    
    cell.backgroundColor = UIColorFromRGB(0xffffff);
    cell.nightBackgroundColor = UIColorFromRGB(0x343434);
    cell.textLabel.textColor = UIColorFromRGB(0x000000);
    cell.textLabel.nightTextColor = UIColorFromRGB(0xffffff);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XZVideoTVModel *videoTVModel = _mArrTableView_net[indexPath.row];
    BOOL isNeed = false;
    //_playerController.player.currentItem有值并且点击的是正在播放的视频时，要传值playItem，currentTime
    if (_playerController.player.currentItem && _index == indexPath.row + 1) {
        isNeed = true;
    }
    // >设置视频单例
    XZVideoSingleton *videoSingleton = [XZVideoSingleton defaultVideoSingleton];
    videoSingleton.player = _playerController.player;
    
    [self.delegate pushVCFromVideoVCWithVideoTVModel:videoTVModel];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return VideoPlayerHeight;
}

#pragma mark - 网络数据
// >http://c.m.163.com/nc/video/Tlist/T1457069041911/0-20.html
- (void)downloadData {
    /** _tid决定是下载何种类型的视频数据, _webPage*20用于下拉刷新和上来加载 */
    NSString *strUrl = [NSString stringWithFormat:@"http://c.m.163.com/nc/video/Tlist/%@/%ld-20.html", _tid, _webPage*20];
    __weak typeof(self) weakSelf = self;
    [NetRequest postDataWithURL:strUrl dic:@{} success:^(id responseObject) {
        /** 如果是下拉刷新, 则清空数组原有数据 */
        if (_isHeaderRefresh) {
            [_mArrTableView_net removeAllObjects];
            _isHeaderRefresh = NO;
        }
        NSDictionary *dictDown = (NSDictionary *)responseObject;
        NSArray *mainDataArr = [dictDown objectForKey:_tid];
        for (int i=0; i<mainDataArr.count; i++) {
            NSDictionary *mainDict = mainDataArr[i];
            XZVideoTVModel *videoTVModel = [XZVideoTVModel videoTVModelWithDict:mainDict];
            [_mArrTableView_net addObject:videoTVModel];
        }
        // >网络数据下载结束, 隐藏"加载中"提示
        [MBProgressHUD hideHUDForView:self animated:YES];
        if (0 != _mArrTableView_net.count) { // >如果网络有数据, 则刷新tableView显示
            weakSelf.tableView.hidden = NO;
            [weakSelf.tableView reloadData];
        } else { // >如果网络没有数据, 则提示用户
            [MBProgressHUD showSuccess:@"v_v暂无数据"];
        }
        /** 因为_tableView有使用刷新, 这里数据加载完成后结束_tableView的刷新状态 */
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    } filed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        [MBProgressHUD showError:@"网络异常"];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}


#pragma - mark 视频播放控制部分
- (void)tapPlayAction:(UITapGestureRecognizer *)tapPlay {
    // rate = 1表示正在播放，rate = 0表示暂停，表示当前有视频在播放
    if (_playerController.player.rate == 1 || _playerController.player.rate == 0) {
        // 移动 playerItem 的观察者
        [_playerController.player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
        // 移除 _playerController.view 视图
        [_playerController.view removeFromSuperview];
        // _playerController.player 置空
        _playerController.player = nil;
        // >同步设置视频单例
        XZVideoSingleton *videoSingleton = [XZVideoSingleton defaultVideoSingleton];
        videoSingleton.player = _playerController.player;
    }
    XZVideoTVModel *videoTVModel = [_mArrTableView_net objectAtIndex:tapPlay.view.tag - 1];
    
    // 创建 AVPlayerViewController 对象
    if (!_playerController) {
        self.playerController = [[AVPlayerViewController alloc] init];
        _playerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    _playerController.showsPlaybackControls = YES;
    _playerController.player = [AVPlayer playerWithURL:[NSURL URLWithString:videoTVModel.mp4_url]];
    // >每个player距离cell顶部都有一定距离
    CGFloat top = 10.0f;
    _playerController.view.frame = CGRectMake(10.0f, top + (tapPlay.view.tag - 1)*(VideoPlayerHeight), SCREENWIDTH - 20.0f, (SCREENWIDTH - 20.0f)/2);
    // 保存点击的内容的索引值
    _index = tapPlay.view.tag;
    [self.tableView addSubview:_playerController.view];
//    NSLog(@"%ld", _playerController.player.status);
    
    
    // 给 _playerController.player.currentItem 添加观察者，确保可以正常播放
    [_playerController.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    // 给 tableView 添加观察者，监视tableView的 contentOffset 的偏移量
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    // 通知中心，监听播放是否结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerController.player.currentItem];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    //    NSLog(@"%@ %@ %@", keyPath, object, change);
    
    // 监听 playerItem 的状态
    if ([keyPath isEqualToString:@"status"]) {
        //如果 playerItem 的状态为 AVPlayerItemStatusReadyToPlay 则开始播放
        if ([[change objectForKey:@"new"] integerValue] == AVPlayerItemStatusReadyToPlay) {
            [_playerController.player play];
        } else {
            XZLog(@"播放错误");
        }
        
    }
    
    // 监听 tableView 的偏移量
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSInteger y = (NSInteger)[[change objectForKey:@"new"] CGPointValue].y;
        /** 当播放内容移出界面，则移除观察者，_playerController.player 置空，移除 _playerController.view */
        if (_index*(VideoPlayerHeight) < y || (_index>3 && y<0 + (_index - 4)*(VideoPlayerHeight))) {
            [_playerController.player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
            _playerController.player = nil;
            // >同步设置视频单例
            XZVideoSingleton *videoSingleton = [XZVideoSingleton defaultVideoSingleton];
            videoSingleton.player = _playerController.player;
            
            [_playerController.view removeFromSuperview];
        }
    }
}
// 播放结束
- (void)playEnd:(id)sender {
    [_playerController.player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
    _playerController.player = nil;
    // >同步设置视频单例
    XZVideoSingleton *videoSingleton = [XZVideoSingleton defaultVideoSingleton];
    videoSingleton.player = _playerController.player;
    
    [_playerController.view removeFromSuperview];
    _playerController.showsPlaybackControls = NO;
}







@end









