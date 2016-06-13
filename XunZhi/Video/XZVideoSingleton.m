//
//  XZVideoSingleton.m
//  XunZhi
//
//  Created by 李雷 on 16/6/13.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZVideoSingleton.h"


static XZVideoSingleton *share = nil;

@interface XZVideoSingleton ()

@end

@implementation XZVideoSingleton

/**
 *  单例: 一般用于在整个应用程序中使用的变量, 而且这个变量一般不做修改
 *  特性: 内存不释放且内存唯一
 *  单列不能用 alloc init 对其初始化 不用释放, 没有 dealloc
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

// >单例的创建
+ (XZVideoSingleton *)defaultVideoSingleton {
    // >单例安全, 第一种写法
//    @synchronized(self)
//    {
//        if (share == nil) {
//            share = [[Singleton alloc] init];
//        }
//    }
    
    // >单例安全, 第二种写法
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (share == nil) {
//            share = [[Singleton alloc] init];
            share = [[super allocWithZone:NULL] init];
        }
    });
    return share;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [XZVideoSingleton defaultVideoSingleton];
}
+ (id)copyWithZone:(struct _NSZone *)zone {
    return [XZVideoSingleton defaultVideoSingleton];
}









@end







