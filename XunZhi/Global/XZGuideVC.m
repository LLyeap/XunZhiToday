//
//  XZGuideVC.m
//  XunZhi
//
//  Created by 李雷 on 16/6/2.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZGuideVC.h"

#import "SDCycleScrollView.h"
#import "XZIndexVC.h"
#import "XZIndexSubVC.h"

@interface XZGuideVC () <SDCycleScrollViewDelegate>

@property (nonatomic, retain) UIButton *btnPass;
@property (nonatomic, retain) NSMutableArray *mArrADUrl;
@property (nonatomic, retain) NSMutableArray *mArrAdPicUrl;
@property (nonatomic, retain) NSMutableArray *mArrADDesc;

@end

@implementation XZGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mArrADUrl = [NSMutableArray array];
    self.mArrAdPicUrl = [NSMutableArray array];
    self.mArrADDesc = [NSMutableArray array];
    [self downloadData];
}

#pragma mark - 自定义函数
- (void)createSDCycleScrollView {
    UIScrollView *adContainerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    adContainerView.contentSize = CGSizeMake(self.view.frame.size.width, 0);
    [self.view addSubview:adContainerView];
    
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) delegate:self placeholderImage:[UIImage imageNamed:@"sourceHeader"]];
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    // >赋值文字数组
    cycleScrollView2.titlesGroup = _mArrADDesc;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [adContainerView addSubview:cycleScrollView2];
    
    // >赋值图片数组
    cycleScrollView2.imageURLStringsGroup = _mArrAdPicUrl;
    
    // >跳过 按钮, 数字给定
    _btnPass = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH-60, 30, 50, 25)];
    [adContainerView addSubview:_btnPass];
    [_btnPass setTitle:@"跳过" forState:UIControlStateNormal];
    [_btnPass addTarget:self action:@selector(btnPassAction:) forControlEvents:UIControlEventTouchUpInside];
    _btnPass.backgroundColor = [UIColor grayColor];
    _btnPass.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _btnPass.layer.cornerRadius = 8.0f;
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    XZLog(@"点击了第%ld张图片", (long)index);
    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"XZMain" bundle:[NSBundle mainBundle]];
    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
    UITabBarController *tabVC = [story instantiateViewControllerWithIdentifier:@"XZMain"];
    [self presentViewController:tabVC animated:YES completion:^{
        XZIndexSubVC *indexSubVC = [[XZIndexSubVC alloc] init];
        // >点击第几张图片时获得对应的链接
        indexSubVC.webViewStrUrl = _mArrADUrl[index];
        UINavigationController *indexNaviVC = [tabVC.viewControllers firstObject];
        [indexNaviVC pushViewController:indexSubVC animated:YES];
    }];
}
//// >滚动到第几张图回调
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
//    XZLog(@"滚动到第%ld张图", (long)index);
//}
#pragma mark - 跳过广告按钮, 进入主界面
- (void)btnPassAction:(UIButton *)btnPass {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"XZMain" bundle:[NSBundle mainBundle]];
    // >由storyboard根据myView的storyBoardID来获取我们要切换的视图
    UITabBarController *tabBarVC = [story instantiateViewControllerWithIdentifier:@"XZMain"];
    [self presentViewController:tabBarVC animated:YES completion:^{
        
    }];
}
#pragma mark - 网络数据
// >http://123.206.54.81/xzToday/AD/xzAD_json.php
- (void)downloadData {
    NSString *strUrl = @"http://123.206.54.81/xzToday/AD/xzAD_json.php";
    NSDictionary *dic = @{};
    __weak typeof(self) weakSelf = self;
    [NetRequest postDataWithURL:strUrl dic:dic success:^(id responseObject) {
        NSDictionary *dictDown = (NSDictionary *)responseObject;
        NSArray *mainArr = [dictDown objectForKey:@"data"];
        for (int i=0; i<mainArr.count; i++) {
            NSDictionary *dictEach = mainArr[i];
            [_mArrADUrl addObject:[dictEach objectForKey:@"adUrl"]];
            [_mArrAdPicUrl addObject:[dictEach objectForKey:@"adPicUrl"]];
            [_mArrADDesc addObject:[dictEach objectForKey:@"adDesc"]];
        }
        [weakSelf createSDCycleScrollView];
    } filed:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end










