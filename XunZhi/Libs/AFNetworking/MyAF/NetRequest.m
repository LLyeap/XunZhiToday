//
//  NetRequest.m
//  CV嵌套TV
//
//  Created by 李日红 on 15/12/21.
//  Copyright © 2015年 李日红. All rights reserved.
//

#import "NetRequest.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonCrypto.h>
#import "Reachability.h"

@implementation NetRequest

+ (void)getDataWithURL:(NSString *)urlStr dic:(NSDictionary *)dic success:(void (^)(id))response filed:(void (^)(NSError *))err {
    
#pragma mark 2.判断网络状态
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if (0 != reach.currentReachabilityStatus) { // 判断网络状态(不等于0代表有网)
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //有的返回数据类型,AFN不支持解析,我们需要设置一下,让AFN支持解析
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain", @"application/x-javascript", @"application/javascript",nil]];
        [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
           //返回数据给调用方  response(是个Block) responseObject(返回的数据类型id类型)
            response(responseObject);
            //调用获取缓存路径方法,把网址和网络请求成功的值传进去
            [self cachePath:urlStr response:responseObject type:0 dic:dic];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            err(error);
        }];
    }
    else { //无网,走缓存
        //拿到缓存路径
        // response 后面参数,因为我们没走网络请求,我不是要缓存数据,而是要获取数据
        id data = [self cachePath:urlStr response:nil type:1 dic:dic];
        if (data != nil) { // (写个保护)防止为没有文件crash
            
            response(data);
        }
    }
}

+ (void)postDataWithURL:(NSString *)urlStr dic:(NSDictionary *)dic success:(void (^)(id))response filed:(void (^)(NSError *))err {
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if (0 != reach.currentReachabilityStatus) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain", @"application/x-javascript", @"application/javascript",nil]];
        
        [manager POST:urlStr parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            response(responseObject);
            [self cachePath:urlStr response:responseObject type:0 dic:dic];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            err(error);
        }];
    }else {
        
        id data = [self cachePath:urlStr response:nil type:1 dic:dic];
        if (data != nil) {
            
            response(data);
        }
    }
}

+ (id)cachePath:(NSString *)urlStr response:(id)responseObject type:(NSInteger)type dic:(NSDictionary *)dic {
    
#pragma mark 1.开始缓存
    //1.把我们的网址利用MD5加密算法转换成数字和字符串的组合(因为网址不能直接作为文件名)
    //如果self后面调用的是减号方法,那么这个self就是本类的对象,例如Person *per = nil; self就是这个per
    //如果self后面调用的是加号方法,那么这个self就是本类的名字, Person就是self
    NSString *name = [self fileNameWithstrUrl:urlStr dic:dic];
    NSString *fileName = [self cachedFileNameForKey:name];
    //2.找到cache文件夹在沙盒中的路径
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    //3.路径和路径名拼接
    NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
    
//    XZLog(@"缓存位置%@", filePath);
    //4.把网络请求成功的数据归档一下
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseObject];
    
    if (0 == type) { //如果type是0,则代表我要写入 1 读取
        //5.写入本地
        [data writeToFile:filePath atomically:YES];
        return nil;
    }else if (1 == type) {
        
        id data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        return data;
    }
    return nil;
}

+ (NSString *)fileNameWithstrUrl:(NSString *)strUrl dic:(NSDictionary *)dic {
    
    NSMutableString *str = [NSMutableString string];
    for (NSString *key in dic.allKeys) {
        
        NSString *strValue = [dic objectForKey:key];
        [str appendString:[NSString stringWithFormat:@"%@=%@", key, strValue]];
    }
    return [NSString stringWithFormat:@"%@%@", strUrl, str];
}

// 利用MD5算法把网址转换成一串数字加字母
+ (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return filename;
}

@end
