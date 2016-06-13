//
//  XZIndexSubVC.h
//  XunZhi
//
//  Created by 李雷 on 16/5/24.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZIndexSubVC : UIViewController

/** 属性, 目前子页面是一个网页, 参数webViewStrUrl是要载入的网页内容接口的地址, 通过它获得接口数据在载入网页 */
@property (nonatomic, retain) NSString *webViewStrUrl;

@end
