//
//  XZVideoTVModel.m
//  XunZhi
//
//  Created by 李雷 on 16/5/25.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZVideoTVModel.h"

@implementation XZVideoTVModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        /** KVC赋值 */
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}

+ (instancetype)videoTVModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    XZLog(@"有没找到的key");
}




@end