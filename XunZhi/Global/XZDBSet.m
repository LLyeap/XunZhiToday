//
//  XZDBSet.m
//  XunZhi
//
//  Created by 李雷 on 16/6/1.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZDBSet.h"

#import "XZIndexSqliteModel.h"

@implementation XZDBSet

- (FMDTContext *)indexSqliteModel {
    /**
     *  缓存FMDTContext对象,第一次创建时会自动生成表结构
     *  默认存储在默认会存储在沙盒下的Library/Caches/{Bundle Identifier}.db,
     *  如果想要对每一个用户生成一个库,可以自定义Path,
     *  使用[self cacheWithClass: dbPath:]方法
     */
    return [self cacheWithClass:[XZIndexSqliteModel class]];
}

@end
