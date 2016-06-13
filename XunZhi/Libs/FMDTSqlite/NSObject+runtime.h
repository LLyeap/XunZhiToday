//
//  NSObject+runtime.h
//  FMDataTable
//
//  Created by bing.hao on 15/9/1.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (runtime)

+ (void)enumeratePropertiesWithClassType:(Class)ctype usingBlick:(void(^)(BOOL read, NSString *name, NSString *type, NSArray *attrs))block;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com