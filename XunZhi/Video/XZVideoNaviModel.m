//
//  XZVideoNaviModel.m
//  XunZhi
//
//  Created by 李雷 on 16/5/27.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZVideoNaviModel.h"

@implementation XZVideoNaviModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        /** KVC赋值 */
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}

+ (instancetype)videoNaviModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    XZLog(@"有没找到的key");
}


@end
