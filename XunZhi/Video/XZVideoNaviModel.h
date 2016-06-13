//
//  XZVideoNaviModel.h
//  XunZhi
//
//  Created by 李雷 on 16/5/27.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZVideoNaviModel : NSObject

/** 导航条文字 */
@property (nonatomic, copy) NSString *tname;
/** 导航条文字对应的后台ID值, 用于查询对应的内容 */
@property (nonatomic, copy) NSString *tid;

+ (instancetype)videoNaviModelWithDict:(NSDictionary *)dict;

@end
//{
//    "tname": "推荐",
//    "tid": "T1457068979049"
//}
