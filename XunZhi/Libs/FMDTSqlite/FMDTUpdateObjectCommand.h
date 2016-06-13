//
//  FMDTUpdateObjectCommand.h
//  FMDataTable
//
//  Created by bing.hao on 16/3/9.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDTCommand.h"

// 项目打包上线都不会打印日志，因此可放心。
#ifdef DEBUG
#define DBLog(s, ... ) NSLog( @"[%@ in line %d] =====>%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DBLog(s, ... )
#endif

@interface FMDTUpdateObjectCommand : NSObject<FMDTCommand>

- (FMDTUpdateObjectCommand *)add:(FMDTObject *)obj;
- (FMDTUpdateObjectCommand *)addWithArray:(NSArray *)array;

- (void)saveChanges;
- (void)saveChangesInBackground:(void(^)())complete;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com