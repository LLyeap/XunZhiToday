//
//  XZMeTVModel.h
//  XunZhi
//
//  Created by 李雷 on 16/5/31.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZMeTVModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;

+ (instancetype)meTVModelWithDict:(NSDictionary *)dict;

@end
