//
//  XZIndexSubVC.m
//  XunZhi
//
//  Created by 李雷 on 16/5/24.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZIndexSubVC.h"

#import "UIWebView+Blocks.h"

@interface XZIndexSubVC () <UIWebViewDelegate>

@property (nonatomic, retain) UIWebView *webView;

@end

@implementation XZIndexSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_webViewStrUrl]];
    self.webView = [UIWebView loadRequest:urlRequest loaded:^(UIWebView *webView) {
//        XZLog(@"视频网页加载成功");
    } failed:^(UIWebView *webView, NSError *error) {
//        [MBProgressHUD showError:@"加载失败"];
        _webView.delegate = self;
    }];
    self.webView.frame = CGRectMake(0, NAVIBARHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVIBARHEIGHT - TABBARHEIGHT);
    [self.view addSubview:_webView];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // >暂时先这么写吧
    NSString *strUrlTmp = [NSString stringWithFormat:@"%@", request.URL];
    NSString *groupid = [self findGroupIDWithUrl:strUrlTmp];
    if (![groupid isEqualToString:@""]) { // groupid不为空才可以继续访问
        XZIndexSubVC *indexSubVC = [[XZIndexSubVC alloc] init];
        indexSubVC.webViewStrUrl = [NSString stringWithFormat:@"http://toutiao.com/a%@/", groupid];
        [self.navigationController pushViewController:indexSubVC animated:NO];
    } else {
        [MBProgressHUD showError:@"加载失败"];
    }
    return YES;
}
/**
 *  根据代理方法的retuest.URL来获得URL中的groupid值
 *
 *  @param url 代理方法的retuest.URL
 *
 *  @return 字符串groupid
 */
- (NSString *)findGroupIDWithUrl:(NSString *)url {
    NSInteger start = 0;
//    for (int i=0; i<url.length; i++) {
//        NSRange range = NSMakeRange(i, 7);
//        NSString *groupid = [url substringWithRange:range];
//        XZLog(@"%@", groupid);
//        if ([groupid isEqualToString:@"groupid"]) {
//            NSString *ch = [url substringWithRange:NSMakeRange(i+7, 1)];
//            XZLog(@"%@", ch);
//            if ([ch isEqualToString:@"="]) {
//                start = i + 8;
//            } else {
//                start = i + 10;
//            }
//            break;
//        }
//    }
    NSString *searchStr = url;
    if ([searchStr rangeOfString:@"groupid"].location != NSNotFound) { // >条件为真，表示字符串searchStr包含一个自字符串substr
        NSInteger i = [searchStr rangeOfString:@"groupid"].location;
        NSString *ch = [url substringWithRange:NSMakeRange(i+7, 1)];
        if ([ch isEqualToString:@"="]) {
            start = i + 8;
        } else {
            start = i + 10;
        }
    } else { // >条件为假，表示不包含要检查的字符串
        start = -1;
    }
    if (start != -1) { // >start != -1 表示请求url中找到了groupid, 可以继续请求
        NSRange range = NSMakeRange(start, 19);
        NSString *groupID = [url substringWithRange:range];
        return groupID;
    } else { // url中没有groupid, 打断访问
        return @"";
    }
}
//snssdk141://detail?groupid=6291798140505620737&gd_label=click_weixin_ios_deeplink
//http://toutiao.com/a6291798140505620737/



#pragma mark - 网络数据








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}







@end







