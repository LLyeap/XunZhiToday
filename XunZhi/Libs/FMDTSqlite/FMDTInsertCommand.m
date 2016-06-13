//
//  FMDTInsertCommand.m
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import "FMDTInsertCommand.h"

@interface FMDTInsertCommand ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FMDTInsertCommand
@synthesize schema = _schema;

- (instancetype)initWithSchema:(FMDTSchemaTable *)schema {
    self = [super init];
    if (self) {
        _schema = schema;
        _dataArray = [NSMutableArray new];
    }
    return self;
}

- (FMDTInsertCommand *)add:(FMDTObject *)obj {
    [self.dataArray addObject:obj];
    return self;
}

- (FMDTInsertCommand *)addWithArray:(NSArray *)array {
    [self.dataArray addObjectsFromArray:array];
    return self;
}

- (void)saveChanges {
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.schema.storage];
    
    [db open];
    for (FMDTObject *entry in self.dataArray) {
        NSArray *array = [self getObjectValues:entry];
        NSString *statement = nil;
        if (self.relpace) {
            statement = self.schema.statementReplace;
        } else {
            statement = self.schema.statementInsert;
        }
        [db executeUpdate:statement withArgumentsInArray:array];
    }
    [db close];
    [self.dataArray removeAllObjects];
}

- (void)saveChangesInBackground:(void (^)())complete {
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.schema.storage];
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for (FMDTObject *entry in self.dataArray) {
                NSArray *array = [self getObjectValues:entry];
                NSString *statement = nil;
                if (self.relpace) {
                    statement = self.schema.statementReplace;
                } else {
                    statement = self.schema.statementInsert;
                }
                [db executeUpdate:statement withArgumentsInArray:array];
            }
        }
        @catch (NSException *exception) {
            *rollback = YES;
        }
        
        if (complete) {
            complete();
        }
        
        [self.dataArray removeAllObjects];
    }];
}

- (NSArray *)getObjectValues:(FMDTObject *)obj {
    NSMutableArray *result = [NSMutableArray new];
    for (FMDTSchemaField *entry in self.schema.fields) {
        id val = [obj valueForKey:entry.objName];
        if (val) {
            if (FMDT_IsCollectionObject(entry.objType)) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:val
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:nil];
                if (data) {
                    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    [result addObject:str];
                } else {
                    [result addObject:[NSNull null]];
                }
            } else if (FMDT_IsDateObject(entry.objType)) {
                [result addObject:@([val timeIntervalSince1970])];
            } else {
                [result addObject:val];
            }
        } else {
            [result addObject:[NSNull null]];
        }
    }
    return result;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com