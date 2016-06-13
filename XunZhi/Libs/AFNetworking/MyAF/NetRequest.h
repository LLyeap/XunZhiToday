//
//  NetRequest.h
//  CV嵌套TV
//
//  Created by 李日红 on 15/12/21.
//  Copyright © 2015年 李日红. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetRequest : NSObject

+ (void)getDataWithURL:(NSString *)urlStr dic:(NSDictionary *)dic success:(void(^)(id responseObject))response filed:(void(^)(NSError *error))err;

+ (void)postDataWithURL:(NSString *)urlStr dic:(NSDictionary *)dic success:(void(^)(id responseObject))response filed:(void(^)(NSError *error))err;

@end
