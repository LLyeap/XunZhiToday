//
//  XZPictureCVCell.m
//  XunZhi
//
//  Created by 王旭 on 16/5/25.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZPictureCVCell.h"

#import "XZPictureTVModel.h"
#import "XZPictureTVCell.h"

@interface XZPictureCVCell () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *mArrTableView_net;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, copy) NSString *max_behot_time;
/** 判断tableView是不是下拉刷新 */
@property (nonatomic, assign) BOOL isHeaderRefresh;

@end

@implementation XZPictureCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.mArrTableView_net = [NSMutableArray array];
        [self createTableView];
    }
    return self;
}

#pragma mark - 自定义函数
/**
 *  创建CVCell上的tableView
 */
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:_tableViewStyle];
    [self.contentView addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        // >设置刷新形式是下拉刷新, 在网络下载数据成功后清空数组
        self.isHeaderRefresh = YES;
        
        self.max_behot_time = nil;
        [self downloadData];
    }];
//    //> 设置普通状态的动画图片
//    [gifHeader setImages:idleImages forState:MJRefreshStateIdle];
//    //> 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    [gifHeader setImages:pullingImages forState:MJRefreshStatePulling];
//    //> 设置正在刷新状态的动画图片
//    [gifHeader setImages:refreshingImages forState:MJRefreshStateRefreshing];
// > 设置header
    _tableView.mj_header = gifHeader;
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        /** 获得数据的最后一个的behot_time最为参数max_behot_time传给后台获得旧数据来加载 */
        if (0 != _mArrTableView_net.count) {
            XZPictureTVModel *pictureTVModel = _mArrTableView_net[_mArrTableView_net.count-1];
            self.max_behot_time = pictureTVModel.behot_time;
            [self downloadData];
        } else {
            [MBProgressHUD showMessage:@"v_v请下拉刷新"];
            // >如果没有数据, 延迟1.5秒后停止刷新
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [_tableView.mj_footer endRefreshing];
            });
        }
    }];
    _tableView.backgroundColor = UIColorFromRGB(0xffffff);
    _tableView.nightBackgroundColor = UIColorFromRGB(0x343434);
}
/**
 *  当XZPictureVC操作CVCell滑动时, 对滑动后的CVCell上的tableView数据进行刷新
 *
 *  @param category 根据类型进行网络数据下载
 */
- (void)refreshTableViewByDownloadDataWithCategory:(NSString *)category {
    /** 因为在导航条改变条目时, 如果没有网络, 数据则不会改变, 显示之前的内容, 同时, 下一步清空了数组, 这时会发生数组越界 */
    _tableView.hidden = YES;
    /** 导航条改变时, 清空原有数据 */
    [_mArrTableView_net removeAllObjects];
    
    [MBProgressHUD showMessage:@"加载中" toView:self];
    
    self.category = category;
    [self downloadData];
}
/**
 *  文字高度适配
 *
 *  @param text 文字内容
 *
 *  @return 文字所占高度
 */
+ (CGFloat)heigthForText:(NSString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(300, 0)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:titleFont}
                                     context:nil];
    CGFloat textH = rect.size.height;
    return textH;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mArrTableView_net.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZPictureTVModel *pictureTVModel = _mArrTableView_net[indexPath.row];
    
    static NSString *pictureTVCellID = @"pictureTVCellID";
    XZPictureTVCell *cell = [tableView dequeueReusableCellWithIdentifier:pictureTVCellID];
    if (!cell) {
        cell = [[XZPictureTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pictureTVCellID];
    }
    
    cell.pictureTVModel = pictureTVModel;
    
    cell.backgroundColor = UIColorFromRGB(0xffffff);
    cell.nightBackgroundColor = UIColorFromRGB(0x343434);
    cell.textLabel.textColor = UIColorFromRGB(0x000000);
    cell.textLabel.nightTextColor = UIColorFromRGB(0xffffff);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XZPictureTVModel *pictureTVModel = _mArrTableView_net[indexPath.row];
    [self.delegate pushVCFromVideoVCWithWebViewStrUrl:pictureTVModel.share_url];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat top = 10.0f;
    CGFloat bottom = 10.0f;
    CGFloat space = 5.0f;
    CGFloat bottomView = 25.0f;
    XZPictureTVModel *pictureTVModel = _mArrTableView_net[indexPath.row];
    NSDictionary *Dic_middle_image = pictureTVModel.middle_image;
    CGFloat imageHeight =[[Dic_middle_image objectForKey:@"height"] floatValue] * (SCREENWIDTH - 20.0f) / [[Dic_middle_image objectForKey:@"width"] floatValue];
    /** 以上信息即是cell中控件的高度 */
    return top + [[self class] heigthForText:pictureTVModel.content] + imageHeight + bottomView + bottom + space*2;
}

#pragma mark - 网络数据
// >http://ic.snssdk.com/2/article/v35/stream/?iid=4315625960&category=image_funny&count=20
- (void)downloadData {
    NSString *strUrl = @"http://ic.snssdk.com/2/article/v35/stream/";
    NSMutableDictionary *dic = @{@"iid":@"4315625960",
                          @"category":_category,
                          @"count":@"20"}.mutableCopy;
    if (_max_behot_time) {
        [dic setValue:_max_behot_time forKey:@"max_behot_time"];
    }
    __weak typeof(self) weakSelf = self;
    [NetRequest postDataWithURL:strUrl dic:dic success:^(id responseObject) {
        /** 如果是下拉刷新, 则清空数组原有数据 */
        if (_isHeaderRefresh) {
            [_mArrTableView_net removeAllObjects];
            _isHeaderRefresh = NO;
        }
        NSDictionary *dictDown = (NSDictionary *)responseObject;
        NSArray *mainDataArr = [dictDown objectForKey:@"data"];
        for (int i=0; i<mainDataArr.count; i++) {
            NSDictionary *mainDict = mainDataArr[i];
            XZPictureTVModel *pictureTVModel = [XZPictureTVModel pictureTVModelWithDict:mainDict];
            [_mArrTableView_net addObject:pictureTVModel];
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




@end
