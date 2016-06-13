//
//  XZNaviModel.h
//  XunZhi
//
//  Created by 李雷 on 16/5/21.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZIndexNaviModel : NSObject

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger tip_new;

+ (instancetype)indexNaviModelWithDict:(NSDictionary *)dict;

@end
//{
//    "category": "news_hot",
//    "web_url": "",
//    "flags": 0,
//    "name": "热点",
//    "tip_new": 0,
//    "default_add": 1,
//    "concern_id": "",
//    "type": 4,
//    "icon_url": ""
//}







