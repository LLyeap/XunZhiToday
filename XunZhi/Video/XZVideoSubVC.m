//
//  XZVideoSubVC.m
//  XunZhi
//
//  Created by 李雷 on 16/5/25.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZVideoSubVC.h"

#import "XZVideoTVModel.h"
#import "XZVideoHeader.h"
#import "XZVideoSubTVCell.h"

@interface XZVideoSubVC () <UITableViewDataSource, UITableViewDelegate>

/** 网络数据, 元素是XZVideoTVModel类型, 用于放在视频播放的XZVideoHeader的下方 */
@property (nonatomic, retain) NSMutableArray *mArrTableView_net;
/**  */
@property (nonatomic, retain) AVPlayerViewController *playerController;
/** 显示mArrTableView_net的数据, 好比类似此类视频的推荐 */
@property (nonatomic, retain) UITableView *tableView;

@end

@implementation XZVideoSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mArrTableView_net = [NSMutableArray array];
    [self downloadData];
    [self createTableView];
}

#pragma mark - 自定义函数
/**
 *  创建tableView, 其头部是XZVideoHeader
 */
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIBARHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVIBARHEIGHT - TABBARHEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mArrTableView_net.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZVideoTVModel *vTVModel = [_mArrTableView_net objectAtIndex:indexPath.row];
    
    static NSString *videoSubTVCelID = @"videoSubTVCelID";
    XZVideoSubTVCell *cell = [tableView dequeueReusableCellWithIdentifier:videoSubTVCelID];
    if (!cell) {
        cell = [[XZVideoSubTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoSubTVCelID];
    }
    
    cell.videoTVModel = vTVModel;
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        XZVideoHeader *videoHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
        if (!videoHeader) {
            videoHeader = [[XZVideoHeader alloc] initWithReuseIdentifier:@"header"];
        }
        videoHeader.selectVideoTVModel = _selectVideoTVModel;
        return videoHeader;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        /** 给视频播放的XZVideoHeader一个固定高度 */
        return 44 * 5;
    }
    return 44;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XZVideoTVModel *vTVModel = [_mArrTableView_net objectAtIndex:indexPath.row];
    
    XZVideoSubVC *videoSubVC = [[XZVideoSubVC alloc] init];
    videoSubVC.selectVideoTVModel = vTVModel;
    [self.navigationController pushViewController:videoSubVC animated:YES];
    
    _playerController.player = nil;
}


#pragma mark - 网络数据
//  >http://c.m.163.com/nc/video/detail/VBNAFSBH9.html
- (void)downloadData {
    // >三目运算符判断
    NSString *strUrl = [NSString stringWithFormat:@"http://c.m.163.com/nc/video/detail/%@.html", (nil != _selectVideoTVModel)?_selectVideoTVModel.vid:_videoTVModel.vid];
    __weak typeof(self) weakSelf = self;
    [NetRequest getDataWithURL:strUrl dic:nil success:^(id responseObject) {
        NSArray *mainDataArr = [responseObject objectForKey:@"recommend"];
        for (int i=0; i<mainDataArr.count; i++) {
            XZVideoTVModel *vTVModel = [XZVideoTVModel videoTVModelWithDict:mainDataArr[i]];
            [_mArrTableView_net addObject:vTVModel];
        }
        [weakSelf.tableView reloadData];
    } filed:^(NSError *error) {
        
    }];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





@end









