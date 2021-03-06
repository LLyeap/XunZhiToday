//
//  FMDTQuery.m
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import "FMDTSelectCommand.h"

@interface FMDTSelectCommand ()

@property (nonatomic, strong) NSMutableArray *whereArray;
@property (nonatomic, strong) NSMutableArray *orderArray;

@end

@implementation FMDTSelectCommand
@synthesize schema = _schema;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.whereArray = [NSMutableArray new];
        self.orderArray = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithSchema:(FMDTSchemaTable *)schema {
    self = [self init];
    if (self) {
        _schema = schema;
    }
    return self;
}

- (FMDTSelectCommand *)where:(NSString *)key equalTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ = '%@'", key, object]];
    return self;
}

- (FMDTSelectCommand *)where:(NSString *)key notEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ <> '%@'", key, object]];
    return self;
}

- (FMDTSelectCommand *)where:(NSString *)key lessThan:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ < '%@'", key, object]];
    return self;
}

- (FMDTSelectCommand *)where:(NSString *)key lessThanOrEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ <= '%@'", key, object]];
    return self;
}

- (FMDTSelectCommand *)where:(NSString *)key greaterThan:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ > '%@'", key, object]];
    return self;
}

- (FMDTSelectCommand *)where:(NSString *)key greaterThanOrEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ >= '%@'", key, object]];
    return self;
}

- (FMDTSelectCommand *)where:(NSString *)key containedIn:(NSArray *)array {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ in ('%@')", key, [array componentsJoinedByString:@"','"]]];
    return self;
}

- (FMDTSelectCommand *)where:(NSString *)key notContainedIn:(NSArray *)array {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ not in ('%@')", key, [array componentsJoinedByString:@"','"]]];
    return self;
}

- (FMDTSelectCommand *)where:(NSString *)key containsString:(NSString *)string {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ like '%@'", key, string]];
    return self;
}

- (FMDTSelectCommand *)where:(NSString *)key notContainsString:(NSString *)string {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ not like '%@'", key, string]];
    return self;
}

- (FMDTSelectCommand *)whereOr:(NSString *)key equalTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ = '%@'", key, object]];
    return self;
}

- (FMDTSelectCommand *)whereOr:(NSString *)key notEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ <> '%@'", key, object]];
    return self;
}

- (FMDTSelectCommand *)whereOr:(NSString *)key lessThan:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ < '%@'", key, object]];
    return self;
}

- (FMDTSelectCommand *)whereOr:(NSString *)key lessThanOrEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ <= '%@'", key, object]];
    return self;
}

- (FMDTSelectCommand *)whereOr:(NSString *)key greaterThan:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ > '%@'", key, object]];
    return self;
}

- (FMDTSelectCommand *)whereOr:(NSString *)key greaterThanOrEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ >= '%@'", key, object]];
    return self;
}

- (FMDTSelectCommand *)whereOr:(NSString *)key containedIn:(NSArray *)array {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ in ('%@')", key, [array componentsJoinedByString:@"','"]]];
    return self;
}

- (FMDTSelectCommand *)whereOr:(NSString *)key notContainedIn:(NSArray *)array {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ not in ('%@')", key, [array componentsJoinedByString:@"','"]]];
    return self;
}

- (FMDTSelectCommand *)whereOr:(NSString *)key containsString:(NSString *)string {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ like '%@'", key, string]];
    return self;
}

- (FMDTSelectCommand *)whereOr:(NSString *)key notContainsString:(NSString *)string {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ not like '%@'", key, string]];
    return self;
}

- (FMDTSelectCommand *)orderByDescending:(NSString *)key {
    [self.orderArray addObject:[NSString stringWithFormat:@" %@ desc", key]];
    return self;
}

- (FMDTSelectCommand *)orderByAscending:(NSString *)key {
    [self.orderArray addObject:[NSString stringWithFormat:@" %@ asc", key]];
    return self;
}

- (NSArray *)fetchArray {
    return [self fetchArrayWithDb:nil];
}

- (NSArray *)fetchArrayWithDb:(FMDatabase *)db {

    NSString *sql = [self runSql:@"*"];
    
    NSMutableArray *resultArray = [NSMutableArray new];
    
    if (db == nil) {
        db = [FMDatabase databaseWithPath:self.schema.storage];
    }
    
    [db open];
    
    FMResultSet *set = [db executeQuery:sql];
    while ([set next]) {
        id obj = [NSClassFromString(self.schema.className) new];
        
        for (FMDTSchemaField *entry in self.schema.fields) {
            if (![set columnIsNull:entry.name]) {
                if (FMDT_IsCollectionObject(entry.objType)) {
                    NSString *jsonStr = [set stringForColumn:entry.name];
                    id data = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:NSJSONReadingAllowFragments
                                                                error:nil];
                    if (data) {
                        [obj setValue:data forKeyPath:entry.objName];
                    }
                } else if (FMDT_IsDateObject(entry.objType)) {
                    NSNumber *dateNum = [set objectForColumnName:entry.name];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateNum doubleValue]];
                    if (date) {
                        [obj setValue:date forKeyPath:entry.objName];
                    }
                } else {
                    id val = [set objectForColumnName:entry.name];
                    [obj setValue:val forKeyPath:entry.objName];
                }
            }
        }
        [resultArray addObject:obj];
    }
    [db close];
    [self removeCacheAllObject];
    return resultArray;
}

- (void)fetchArrayInBackground:(void (^)(NSArray *))callback {
    
    if (callback) {
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.schema.storage];
        [queue inDatabase:^(FMDatabase *db) {
            callback([self fetchArrayWithDb:db]);
        }];
        [queue close];
    }
}

- (id)fetchObject {
    return [[self fetchArray] firstObject];
}

- (void)fetchObjectInBackground:(void (^)(id))callback {
    if (callback) {
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.schema.storage];
        [queue inDatabase:^(FMDatabase *db) {
            callback([[self fetchArrayWithDb:db] firstObject]);
        }];
        [queue close];
    }
}

- (NSInteger)fetchCount {
    return [self fetchCountWithDb:nil];
}

- (NSInteger)fetchCountWithDb:(FMDatabase *)db {
    NSString *sql = [self runSql:@"count(*)"];
    
    NSInteger count = 0;
    if (db == nil) {
        db = [FMDatabase databaseWithPath:self.schema.storage];
    }
    
    [db open];
    
    FMResultSet *set = [db executeQuery:sql];
    if ([set next]) {
        count = [set intForColumnIndex:0];
    }
    
    [db close];
    [self removeCacheAllObject];
    
    return count;
}

- (void)fetchCountInBackground:(void (^)(NSInteger))callback {
    if (callback) {
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.schema.storage];
        [queue inDatabase:^(FMDatabase *db) {
            NSInteger count = [self fetchCountWithDb:db];
            callback(count);
        }];
        [queue close];
    }
}

- (void)removeCacheAllObject {
    [self.whereArray removeAllObjects];
    [self.orderArray removeAllObjects];
}

- (NSString *)runSql:(NSString *)resultField {
    
    NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"select %@ from [%@]", resultField, self.schema.tableName];
    if (self.whereArray.count > 0) {
        NSString *str = [self.whereArray componentsJoinedByString:@" "];
        if ([str hasPrefix:@"and"]) {
            str = [str substringFromIndex:3];
        } else {
            str = [str substringFromIndex:2];
        }
        [sql appendFormat:@" where %@", str];
    }
    if (self.orderArray.count > 0) {
        NSString *str = [self.orderArray componentsJoinedByString:@","];
        [sql appendFormat:@" order by %@", str];
    }
    NSInteger limit = MAX(self.limit, 0);
    NSInteger skip  = MAX(self.skip, 0);
    if (limit > 0) {
        [sql appendFormat:@" limit %@", @(limit)];
        if (skip > 0) {
            [sql appendFormat:@" offset %@", @(skip)];
        }
    }
    return sql;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com