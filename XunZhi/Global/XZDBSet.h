//
//  XZDBSet.h
//  XunZhi
//
//  Created by 李雷 on 16/6/1.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "FMDTManager.h"

@interface XZDBSet : FMDTManager

@property (nonatomic, strong, readonly) FMDTContext *indexSqliteModel;

@end
