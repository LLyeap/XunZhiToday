//
//  XZMeVC.m
//  XunZhi
//
//  Created by user on 16/5/23.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZMeVC.h"

#import "XZMeTVModel.h"
#import "XZMeSwitchTVCell.h"
#import "XZMeTVCell.h"
#import "XZMeFavoriteVC.h"
#import "LLQRVC.h"
#import "XZMeAboutVC.h"

#define tableViewHeaderHeight SCREENHEIGHT/4

@interface XZMeVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerImgaeView;
@property (nonatomic, retain) NSArray *arrTableView_plist;

@end

@implementation XZMeVC

#pragma mark - 懒加载
- (NSArray *)arrTableView_plist {
    if (!_arrTableView_plist) {
        // 懒加载数据
        // 1> 找到plist文件的路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"XZMe.plist" ofType:nil];
        // 2> 加载plist文件
        NSArray *arrayArr = [NSArray arrayWithContentsOfFile:path];
        
        // 使用arrTmp是因为我的plist是［数组［数组｛字典｝］］，所以字典转完得放到一个数组中，最后把这个数组放到_fours里
        NSMutableArray *arrTmp = [NSMutableArray array];
        for (int i=0; i<[arrayArr count]; i++) {
            // 获得外层数组下的内层数组(内层数组中才是字典)
            NSArray *arrayDict = (NSArray *)[arrayArr objectAtIndex:i];
            // 3> 遍历字典数组中的每个字典，把字典转成模型，把模型放到arrayModel数组中
            NSMutableArray *arrayModel = [NSMutableArray array];
            for (NSDictionary *dict in arrayDict) {
                //创建模型对象
                XZMeTVModel *meTVModel = [XZMeTVModel meTVModelWithDict:dict];
                [arrayModel addObject:meTVModel];
            }
            [arrTmp addObject:arrayModel];
        }
        // 4> 为_fours赋数组
        _arrTableView_plist = arrTmp;
    }
    return _arrTableView_plist;
}
- (void)viewWillAppear:(BOOL)animated {
    /** 在页面将要载入时刷新清除缓存cell, 重新查看缓存数据大小 */
    if (_tableView) {
        // >清除缓存cell*******************************************************
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // >这里做一个naviBar的假象
    UILabel *lbl_title = [[UILabel alloc] initWithFrame:CGRectMake(-10, 0, SCREENWIDTH + 20, 40)];
    lbl_title.text = @"我";
    lbl_title.font = [UIFont systemFontOfSize:20.0f];
    lbl_title.textColor = UIColorFromRGB(0xffffff);
    lbl_title.nightTextColor = UIColorFromRGB(0xffffff);
    lbl_title.backgroundColor = [UIColor redColor];
    lbl_title.nightBackgroundColor = [UIColor colorWithRed:185.0f/255.0f green:42.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
    lbl_title.textAlignment = NSTextAlignmentCenter;
    UIView *view_title = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    [view_title addSubview:lbl_title];
    self.navigationItem.titleView = view_title;
    
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.nightBackgroundColor = UIColorFromRGB(0x343434);
    [self layoutHeaderImageView];
}

#pragma mark - 自定义函数
/** 给tableView的header创建一个可拉伸的图片 */
- (void)layoutHeaderImageView {
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, tableViewHeaderHeight)];
    headerBackView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerBackView;
    
    self.headerImgaeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, tableViewHeaderHeight)];
    self.headerImgaeView.backgroundColor = [UIColor whiteColor];
    self.headerImgaeView.image = [UIImage imageNamed:@"header"];
    self.headerImgaeView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImgaeView.clipsToBounds = YES;
    [headerBackView addSubview:self.headerImgaeView];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrTableView_plist.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arrModel = [self.arrTableView_plist objectAtIndex:section];
    return arrModel.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arrModel = [self.arrTableView_plist objectAtIndex:indexPath.section];
    XZMeTVModel *meTVModel = arrModel[indexPath.row];
    static NSString *meTVCellID = @"meTVCellID";
    XZMeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:meTVCellID];
    if (!cell) {
        cell = [[XZMeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:meTVCellID];
    }
    cell.meTVModel = meTVModel;
    cell.backgroundColor = UIColorFromRGB(0xffffff);
    cell.nightBackgroundColor = UIColorFromRGB(0x343434);
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([meTVModel.type isEqualToString:@"more"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0 && indexPath.row==0) { // >收藏
        XZMeFavoriteVC *meFavoriteVC = [[XZMeFavoriteVC alloc] init];
        [self.navigationController pushViewController:meFavoriteVC animated:YES];
    } else if (indexPath.section==0 && indexPath.row==1) { // >夜间模式
        
    } else if (indexPath.section==0 && indexPath.row==2) { // >清除缓存
        [self clearFile];
    } else if (indexPath.section==1 && indexPath.row==0) { // >扫一扫
        LLQRVC *qrVC = [[LLQRVC alloc] init];
        [self.navigationController pushViewController:qrVC animated:YES];
    } else if (indexPath.section==2 && indexPath.row==0) { // >关于迅知
        XZMeAboutVC *meAboutVC = [[XZMeAboutVC alloc] init];
        [self.navigationController pushViewController:meAboutVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0f;
}
#pragma mark - UIScrollViewDelegate(因为tableView继承于UIScrollView, 所以可以实现UIScrollView的代理方法)
/** 控制tableView的header的拉伸 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.view.frame.size.width;// 图片宽度
    CGFloat yOffset = scrollView.contentOffset.y; //偏移量
//    XZLog(@"拉伸%.2f", yOffset);
    if (yOffset < 0) {
        CGFloat totalOffset = tableViewHeaderHeight + ABS(yOffset);
        CGFloat f = totalOffset / (tableViewHeaderHeight); //缩放系数
        // >拉伸后的frame是同比例缩放
        self.headerImgaeView.frame = CGRectMake(-(width * f - width) / 2, yOffset, width * f, totalOffset);
    }
}

#pragma mark - 清除缓存
- (void)clearFile {
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    
    for (NSString *p in files) {
        NSError *error = nil;
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
    [self performSelectorOnMainThread:@selector(clearCachSuccess) withObject:nil waitUntilDone:YES];
}
- (void)clearCachSuccess {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"缓存清理完毕" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    
    // >清理完之后重新导入数据
    [_tableView reloadData];
}
#pragma mark - 网络数据





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}










@end













