//
//  XZMeAboutVC.m
//  XunZhi
//
//  Created by 李雷 on 16/6/1.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZMeAboutVC.h"

@interface XZMeAboutVC ()

@end

@implementation XZMeAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于迅知";
    [self createView];
}

- (void)createView {
    UIImageView *imgV_bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIBARHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVIBARHEIGHT-TABBARHEIGHT)];
    [self.view addSubview:imgV_bg];
    imgV_bg.image = [UIImage imageNamed:@"aboutBG"];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, NAVIBARHEIGHT + SCREENHEIGHT/3, SCREENWIDTH, 40)];
    [self.view addSubview:lblName];
    lblName.text = @"迅知今日";
    lblName.textColor = UIColorFromRGB(0xffffff);
    lblName.nightTextColor = UIColorFromRGB(0xffffff);
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.font = [UIFont systemFontOfSize:25.0f];
    
    UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, lblName.frame.origin.y + 50, SCREENWIDTH, 20)];
    [self.view addSubview:lblDesc];
    lblDesc.text = @"迅速获知\t\t\t\t今日新闻";
    lblDesc.textColor = UIColorFromRGB(0xffffff);
    lblDesc.nightTextColor = UIColorFromRGB(0xffffff);
    lblDesc.textAlignment = NSTextAlignmentCenter;
    lblDesc.font = [UIFont systemFontOfSize:20.0f];
    
    UILabel *lblCopyRight = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-TABBARHEIGHT-50, SCREENWIDTH, 40)];
    [self.view addSubview:lblCopyRight];
    lblCopyRight.text = @"Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.";
    lblCopyRight.textColor = UIColorFromRGB(0xffffff);
    lblCopyRight.nightTextColor = UIColorFromRGB(0xffffff);
    lblCopyRight.textAlignment = NSTextAlignmentCenter;
    lblCopyRight.font = [UIFont systemFontOfSize:14.0f];
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}













@end











