//
//  XZCollectionViewCell.m
//  XunZhi
//
//  Created by 李雷 on 16/5/20.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZIndexCVCell.h"

#import "XZIndexTVModel.h"
#import "XZIndexNonePicTVCell.h"
#import "XZIndexOnePicMiddleTVCell.h"
#import "XZIndexOnePicLargeTVCell.h"
#import "XZIndexThreePicTVCell.h"
#import "XZIndexVideoTVCell.h"
#import "XZIndexTVCellBottomView.h"
#import "XZDBSet.h"
#import "XZIndexSqliteModel.h"

@interface XZIndexCVCell () <UITableViewDataSource, UITableViewDelegate, XZIndexTVCellBottomViewDelegate>

/** 从方法refreshTableViewByDownloadDataWithCategory传来的值, 用于下载网络数据 */
@property (nonatomic, copy) NSString *category;
/** 用于上来刷新, 值是XZIndexTVModel数据中获得的 */
@property (nonatomic, copy) NSString *max_behot_time;
/** 判断tableView是不是下拉刷新 */
@property (nonatomic, assign) BOOL isHeaderRefresh;
/**  */
@property (nonatomic, retain) NSMutableArray *mArrPublishTime_DB;

@end

@implementation XZIndexCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        /** 记得初始化mArrTableView_net数组, 给个地址 */
        self.mArrTableView_net = [NSMutableArray array];
        self.mArrPublishTime_DB = [NSMutableArray array];
        [self createTableView];
    }
    return self;
}

#pragma mark - 自定义函数
/**
 *  创建CVCell上的tableView
 */
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    [self.contentView addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    XZRefreshGifHeader *gifHeader = [XZRefreshGifHeader headerWithRefreshingBlock:^{
        // >设置刷新形式是下拉刷新, 在网络下载数据成功后清空数组
        self.isHeaderRefresh = YES;
        self.max_behot_time = nil;
        [self downloadData];
    }];
    //> 设置header
    _tableView.mj_header = gifHeader;
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        /** 获得数据的最后一个的behot_time最为参数max_behot_time传给后台获得旧数据来加载 */
        if (_mArrTableView_net.count != 0) {
            XZIndexTVModel *indexTVModel = _mArrTableView_net[_mArrTableView_net.count-1];
            self.max_behot_time = indexTVModel.behot_time;
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
 *  当XZIndexVC操作CVCell滑动时, 对滑动后的CVCell上的tableView数据进行刷新
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
    XZIndexTVModel *indexTVModel = _mArrTableView_net[indexPath.row];
    
    if (indexTVModel.gallary_image_count<3 && indexTVModel.large_image_list.count==0 && indexTVModel.middle_image.count!=0) { // >有一张小图片的cell
        static NSString *indexOnePicMiddleTVCellID = @"indexOnePicMiddleTVCellID";
        XZIndexOnePicMiddleTVCell *cell = [tableView dequeueReusableCellWithIdentifier:indexOnePicMiddleTVCellID];
        if (!cell) {
            cell = [[XZIndexOnePicMiddleTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indexOnePicMiddleTVCellID];
        }
        cell.indexTVModel = indexTVModel;
        // >接着两条传值是为了收藏使用, 在XZIndexTVCellBottomView中细说
        cell.target = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        /**   UIForceTouchCapability 检测是否支持3D Touch */
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) { // >支持3D Touch
            //系统所有cell可实现预览（peek）
            [self.target registerForPreviewingWithDelegate:self.target sourceView:cell]; // >注册cell
        }
        cell.backgroundColor = UIColorFromRGB(0xffffff);
        cell.nightBackgroundColor = UIColorFromRGB(0x343434);
        cell.textLabel.textColor = UIColorFromRGB(0x000000);
        cell.textLabel.nightTextColor = UIColorFromRGB(0xffffff);
        
        return cell;
    } else if (indexTVModel.gallary_image_count<3 && indexTVModel.large_image_list.count!=0 ) { // >有一张大图片的cell
        if (indexTVModel.has_video) { // >视频
            static NSString *indexVideoTVCellID = @"indexVideoTVCellID";
            XZIndexVideoTVCell *cell = [tableView dequeueReusableCellWithIdentifier:indexVideoTVCellID];
            if (!cell) {
                cell = [[XZIndexVideoTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indexVideoTVCellID];
            }
            cell.indexTVModel = indexTVModel;
            // >接着两条传值是为了收藏使用, 在XZIndexTVCellBottomView中细说
            cell.target = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            /**   UIForceTouchCapability 检测是否支持3D Touch */
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) { // >支持3D Touch
                //系统所有cell可实现预览（peek）
                [self.target registerForPreviewingWithDelegate:self.target sourceView:cell]; // >注册cell
            }
            cell.backgroundColor = UIColorFromRGB(0xffffff);
            cell.nightBackgroundColor = UIColorFromRGB(0x343434);
            cell.textLabel.textColor = UIColorFromRGB(0x000000);
            cell.textLabel.nightTextColor = UIColorFromRGB(0xffffff);
            
            return cell;
        } else {
            static NSString *indexOnePicLargeTVCellID = @"indexOnePicLargeTVCellID";
            XZIndexOnePicLargeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:indexOnePicLargeTVCellID];
            if (!cell) {
                cell = [[XZIndexOnePicLargeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indexOnePicLargeTVCellID];
            }
            cell.indexTVModel = indexTVModel;
            // >接着两条传值是为了收藏使用, 在XZIndexTVCellBottomView中细说
            cell.target = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            /**   UIForceTouchCapability 检测是否支持3D Touch */
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) { // >支持3D Touch
                //系统所有cell可实现预览（peek）
                [self.target registerForPreviewingWithDelegate:self.target sourceView:cell]; // >注册cell
            }
            cell.backgroundColor = UIColorFromRGB(0xffffff);
            cell.nightBackgroundColor = UIColorFromRGB(0x343434);
            cell.textLabel.textColor = UIColorFromRGB(0x000000);
            cell.textLabel.nightTextColor = UIColorFromRGB(0xffffff);
            
            return cell;
        }
    } else if (indexTVModel.gallary_image_count>=3 && indexTVModel.image_list.count>=3) { // >有三张小图片的cell
        static NSString *indexndexThreePicTVCellID = @"indexndexThreePicTVCellID";
        XZIndexThreePicTVCell *cell = [tableView dequeueReusableCellWithIdentifier:indexndexThreePicTVCellID];
        if (!cell) {
            cell = [[XZIndexThreePicTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indexndexThreePicTVCellID];
        }
        cell.indexTVModel = indexTVModel;
        // >接着两条传值是为了收藏使用, 在XZIndexTVCellBottomView中细说
        cell.target = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        /**   UIForceTouchCapability 检测是否支持3D Touch */
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) { // >支持3D Touch
            //系统所有cell可实现预览（peek）
            [self.target registerForPreviewingWithDelegate:self.target sourceView:cell]; // >注册cell
        }
        cell.backgroundColor = UIColorFromRGB(0xffffff);
        cell.nightBackgroundColor = UIColorFromRGB(0x343434);
        cell.textLabel.textColor = UIColorFromRGB(0x000000);
        cell.textLabel.nightTextColor = UIColorFromRGB(0xffffff);
        
        return cell;
    } else { // >没有图片的纯文字cell
        static NSString *indexNonePicTVCellID = @"indexNonePicTVCellID";
        XZIndexNonePicTVCell *cell = [tableView dequeueReusableCellWithIdentifier:indexNonePicTVCellID];
        if (!cell) {
            cell = [[XZIndexNonePicTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indexNonePicTVCellID];
        }
        cell.indexTVModel = indexTVModel;
        // >接着两条传值是为了收藏使用, 在XZIndexTVCellBottomView中细说
        cell.target = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        /**   UIForceTouchCapability 检测是否支持3D Touch */
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) { // >支持3D Touch
            //系统所有cell可实现预览（peek）
            [self.target registerForPreviewingWithDelegate:self.target sourceView:cell]; // >注册cell
        }
        cell.backgroundColor = UIColorFromRGB(0xffffff);
        cell.nightBackgroundColor = UIColorFromRGB(0x343434);
        cell.textLabel.textColor = UIColorFromRGB(0x000000);
        cell.textLabel.nightTextColor = UIColorFromRGB(0xffffff);
        
        return cell;
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    这种方式加载的网页内容有缺陷
//    XZIndexTVModel *indexTVModel = _mArrTableView_net[indexPath.row];
//    NSRange range = NSMakeRange(indexTVModel.share_url.length - 52, 19);
//    //XZLog(@"http://a3.pstatp.com/article/content/11/4/%@/%ld/1/", [indexTVModel.share_url substringWithRange:range], indexTVModel.item_id);
//    NSString *webViewStrUrl = [NSString stringWithFormat:@"http://a3.pstatp.com/article/content/11/4/%@/%ld/1/", [indexTVModel.share_url substringWithRange:range], indexTVModel.item_id];
//    [self.delegate pushVCFromIndexVCWithWebViewStrUrl:webViewStrUrl];
    
    XZIndexTVModel *indexTVModel = _mArrTableView_net[indexPath.row];
    [self.delegate pushVCFromIndexVCWithWebViewStrUrl:indexTVModel.share_url];
}
// >heightForRowAtIndexPath这个方法在cellForRowAtIndexPath之前运行
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZIndexTVModel *indexTVModel = _mArrTableView_net[indexPath.row];
    CGFloat top = 10.0f;
    CGFloat bottom = 10.0f;
    CGFloat space = 5.0f;
    CGFloat bottomView = 25.0f;
    if (indexTVModel.gallary_image_count<3 && indexTVModel.large_image_list.count==0 && indexTVModel.middle_image.count!=0) { // >有一张小图片的cell
        return top + [[self class] heigthForText:indexTVModel.title] + bottomView + bottom + space;///////////////////
    } else if (indexTVModel.gallary_image_count<3 && indexTVModel.large_image_list.count!=0 ) { // >有一张大图片的cell
        if (indexTVModel.has_video) { // >视频
            return top + [[self class] heigthForText:indexTVModel.title] + (SCREENWIDTH - 10.0f*2)/2 + bottomView + bottom + space*2;
        } else { // >只是大图
            return top + [[self class] heigthForText:indexTVModel.title] + (SCREENWIDTH - 10.0f*2)/2 + bottomView + bottom + space*2;
        }
    } else if (indexTVModel.gallary_image_count>=3 && indexTVModel.image_list.count>=3) { // >有三张小图片的cell
        return top + [[self class] heigthForText:indexTVModel.title] + (SCREENWIDTH - 10.0f*4)/6 + bottomView + bottom + space*2;
    } else { // >没有图片的纯文字cell
        return top + [[self class] heigthForText:indexTVModel.title] + bottomView + bottom + space;
    }
}

#pragma mark - UIScrollViewDelegate

#pragma mark - XZIndexTVCellBottomViewDelegate
/**
 *  修改数组指定位置的模型的isFavorite的值, 从而修改收藏状态
 *
 *  @param indexPath indexPath确定修改数组的具体下标
 */
- (void)changeFavoriteStatusInArrayWithIndexPath:(NSIndexPath *)indexPath {
    XZIndexTVModel *indexTVModel = _mArrTableView_net[indexPath.row];
    if ([indexTVModel.isFavorite isEqualToString:@"T"]) {
        indexTVModel.isFavorite = @"F";
    } else {
        indexTVModel.isFavorite = @"T";
    }
    [_mArrTableView_net replaceObjectAtIndex:indexPath.row withObject:indexTVModel];
}
- (void)shareWithIndexPath:(NSIndexPath *)indexPath {
    XZIndexTVModel *indexTVModel = _mArrTableView_net[indexPath.row];
    /** 简单的传到XZIndexVC */
    [self.delegate shareWithIndexPath:indexTVModel];
}

#pragma mark - 网络数据
// >http://ic.snssdk.com/2/article/v35/stream/?iid=4315625960&category=news_hot&count=20
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
        [weakSelf selectDataFromDB];
        /** 如果是下拉刷新, 则清空数组原有数据 */
        if (_isHeaderRefresh) {
            [_mArrTableView_net removeAllObjects];
            _isHeaderRefresh = NO;
        }
        NSDictionary *dictDown = (NSDictionary *)responseObject;
        NSArray *mainDataArr = [dictDown objectForKey:@"data"];
        for (int i=0; i<mainDataArr.count; i++) {
            NSDictionary *mainDict = mainDataArr[i];
            XZIndexTVModel *indexTVModel = [XZIndexTVModel indexTVModelWithDict:mainDict];
            // >判断新下载的数据是否有收藏里的, 如果有, 修改其收藏状态
            for (int j=0; j<_mArrPublishTime_DB.count; j++) {
                if ([indexTVModel.Publish_Time isEqualToString:_mArrPublishTime_DB[j]]) {
                    indexTVModel.isFavorite = @"T";
                }
            }
            [_mArrTableView_net addObject:indexTVModel];
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
#pragma mark - 本地数据库
/**
 *  查询数据, 找出收藏的新闻内容, 取出其发布时间(ID)
 */
- (void)selectDataFromDB {
    //查询数据
    FMDTSelectCommand *cmd = [[XZDBSet shared].indexSqliteModel createSelectCommand];
    
    //获取前10条
    //SQL:select * from Users limit 10
    [cmd setLimit:10];
    [cmd fetchArray];
    
    [cmd fetchArrayInBackground:^(NSArray *result) {
        for (XZIndexSqliteModel *index in result) {
//            XZLog(@"%@, %@", index.publish_time, index.title);
            [_mArrPublishTime_DB addObject:index.Publish_Time];
        }
    }];
}







@end















