//
//  FMDTObject.h
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 *  获取UUID字符串
 *
 *  @return NSString
 */
NSString * FMDT_UUID();

/**
 *  实体对像
 */
@interface FMDTObject : NSObject

/**
 *  设置主键字段
 *
 *  @return NSString
 */
+ (NSString *)primaryKeyFieldName;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com