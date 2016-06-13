//
//  XZMeFavoriteVC.m
//  XunZhi
//
//  Created by 李雷 on 16/6/1.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZMeFavoriteVC.h"

#import "XZDBSet.h"
#import "XZIndexSqliteModel.h"
#import "XZIndexTVModel.h"
#import "XZIndexNonePicTVCell.h"
#import "XZIndexOnePicMiddleTVCell.h"
#import "XZIndexOnePicLargeTVCell.h"
#import "XZIndexThreePicTVCell.h"
#import "XZIndexVideoTVCell.h"
#import "XZIndexSubVC.h"
#import "XZIndexTVCellBottomView.h"

@interface XZMeFavoriteVC () <UITableViewDataSource, UITableViewDelegate, XZIndexTVCellBottomViewDelegate, UMSocialUIDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *mArrTableView_DB;

@end

@implementation XZMeFavoriteVC

- (void)viewWillAppear:(BOOL)animated {
    // >清除原有收藏, 重新加载收藏数据
    [_mArrTableView_DB removeAllObjects];
    [self selectDataFromDB];
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"收藏";
    self.mArrTableView_DB = [NSMutableArray array];
    [self createView];
}

#pragma mark - 自定义函数
/**
 *  创建CVCell上的tableView
 */
- (void)createView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIBARHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVIBARHEIGHT-TABBARHEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
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
    return _mArrTableView_DB.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZIndexTVModel *indexTVModel = _mArrTableView_DB[indexPath.row];
    
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
        cell.backgroundColor = UIColorFromRGB(0xffffff);
        cell.nightBackgroundColor = UIColorFromRGB(0x343434);
        cell.textLabel.textColor = UIColorFromRGB(0x000000);
        cell.textLabel.nightTextColor = UIColorFromRGB(0xffffff);
        
        return cell;
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XZIndexTVModel *indexTVModel = _mArrTableView_DB[indexPath.row];
    XZIndexSubVC *indexSubVC = [[XZIndexSubVC alloc] init];
    indexSubVC.webViewStrUrl = indexTVModel.share_url;
    [self.navigationController pushViewController:indexSubVC animated:YES];
}
// >heightForRowAtIndexPath这个方法在cellForRowAtIndexPath之前运行
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZIndexTVModel *indexTVModel = _mArrTableView_DB[indexPath.row];
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
#pragma mark - XZIndexTVCellBottomViewDelegate
/**
 *  修改数组指定位置的模型的isFavorite的值, 从而修改收藏状态
 *
 *  @param indexPath indexPath确定修改数组的具体下标
 */
- (void)changeFavoriteStatusInArrayWithIndexPath:(NSIndexPath *)indexPath {
    XZIndexTVModel *indexTVModel = _mArrTableView_DB[indexPath.row];
    if ([indexTVModel.isFavorite isEqualToString:@"T"]) {
        indexTVModel.isFavorite = @"F";
    } else {
        indexTVModel.isFavorite = @"T";
    }
    [_mArrTableView_DB replaceObjectAtIndex:indexPath.row withObject:indexTVModel];
}
- (void)shareWithIndexPath:(NSIndexPath *)indexPath {
    XZIndexTVModel *indexTVModel = _mArrTableView_DB[indexPath.row];
    
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



#pragma mark - 本地数据库
//查询数据
- (void)selectDataFromDB {
    //查询数据
    FMDTSelectCommand *cmd = [[XZDBSet shared].indexSqliteModel createSelectCommand];
    
    //获取前10条
    //SQL:select * from Users limit 10
    [cmd setLimit:10];
    [cmd fetchArray];
    __weak typeof(self) weakSelf = self;
    [cmd fetchArrayInBackground:^(NSArray *result) {
        for (int i=0; i<result.count; i++) {
            XZIndexSqliteModel *indexSqliteModel = result[i];
            XZIndexTVModel *indexTVModel = [XZIndexTVModel indexTVModelWithIndexSqliteModel:indexSqliteModel];
            [_mArrTableView_DB addObject:indexTVModel];
        }
        [weakSelf.tableView reloadData];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end










