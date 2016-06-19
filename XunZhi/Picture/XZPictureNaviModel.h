//
//  XZPictureNaviModel.h
//  XunZhi
//
//  Created by 李雷 on 16/6/19.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZPictureNaviModel : NSObject

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger tip_new;

+ (instancetype)pictureNaviModelWithDict:(NSDictionary *)dict;

@end
