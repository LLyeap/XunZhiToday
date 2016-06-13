//
//  XZPictureSubVC.m
//  XunZhi
//
//  Created by 李雷 on 16/5/25.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZPictureSubVC.h"

#import "UIWebView+Blocks.h"

@interface XZPictureSubVC ()

@property (nonatomic, retain) UIWebView *webView;

@end

@implementation XZPictureSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_webViewStrUrl]];
    self.webView = [UIWebView loadRequest:urlRequest loaded:^(UIWebView *webView) {
//        XZLog(@"视频网页加载成功");
    } failed:^(UIWebView *webView, NSError *error) {
        [MBProgressHUD showError:@"加载失败"];
    }];
    self.webView.frame = CGRectMake(0, NAVIBARHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVIBARHEIGHT - TABBARHEIGHT);
    [self.view addSubview:_webView];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end






