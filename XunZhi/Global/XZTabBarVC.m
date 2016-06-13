//
//  XZTabBarVC.m
//  XunZhi
//
//  Created by 李雷 on 16/5/15.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZTabBarVC.h"

@interface XZTabBarVC ()

@end

@implementation XZTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // >修改选中item的颜色, 设置夜间模式
    self.tabBar.tintColor = [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    self.tabBar.nightBarTintColor = [UIColor colorWithRed:185.0f/255.0f green:42.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}







@end














