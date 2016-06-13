//
//  FMDTSet.m
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import "FMDTContext.h"

@implementation FMDTContext

- (instancetype)initWithSchema:(FMDTSchemaTable *)schema {
    self = [super init];
    if (self) {
        _schema = schema;
        [self autoCreateTable];
    }
    return self;
}

- (FMDTSelectCommand *)createSelectCommand {
    return [[FMDTSelectCommand alloc] initWithSchema:self.schema];
}

- (FMDTUpdateCommand *)createUpdateCommand {
    return [[FMDTUpdateCommand alloc] initWithSchema:self.schema];
}

- (FMDTInsertCommand *)createInsertCommand {
    return [[FMDTInsertCommand alloc] initWithSchema:self.schema];
}

- (FMDTDeleteCommand *)createDeleteCommand {
    return [[FMDTDeleteCommand alloc] initWithSchema:self.schema];
}

- (FMDTUpdateObjectCommand *)createUpdateObjectCommand {
    return [[FMDTUpdateObjectCommand alloc] initWithSchema:self.schema];
}

- (void)autoCreateTable {
    //获取表结构
    NSString   *ts = [NSString stringWithFormat:@"select * from sqlite_master where type='table' and name='%@'", _schema.tableName];
    FMDatabase *db = [FMDatabase databaseWithPath:_schema.storage];
    [db open];
    FMResultSet *set = [db executeQuery:ts];
    //如果为YES，说明数据库已经有表了，那么我们需要判断是否要对字段更新
    if ([set next]) {
        NSString *text = [self getAlterTableSql:_schema dbts:[set stringForColumn:@"sql"]];
        @try {
            if (text.length > 0) {
                [db executeStatements:text];
            }
        }
        @catch (NSException *exception) {
            DBLog(@"数据更新错误:更新字段冲突.");
        }
        @finally {
            [db close];
        }
    } else {
        NSString * text = [self getCrateSql:_schema];
        if (text) {
            [db executeUpdate:text];
        }
        [db close];
    }
}

- (NSString *)getCrateSql:(FMDTSchemaTable *)dts
{
    if (dts.fields.count == 0) {
        return nil;
    }
    
    NSMutableString *text = [NSMutableString stringWithFormat:@"create table if not exists [%@] (", dts.tableName];
    Class cls = NSClassFromString(dts.className);
    NSString *pk = [(id)cls performSelector:@selector(primaryKeyFieldName) withObject:nil];
    
    for (FMDTSchemaField *entry in dts.fields) {
        if (pk && [entry.objName isEqualToString:pk]) {
            [text appendFormat:@"[%@] %@ not null unique,", entry.name, entry.type];
        } else {
            [text appendFormat:@"[%@] %@,", entry.name, entry.type];
        }
    }
    [text deleteCharactersInRange:NSMakeRange(text.length - 1, 1)];
    [text appendString:@")"];
    return text;
}

- (NSString *)getAlterTableSql:(FMDTSchemaTable *)ldts dbts:(NSString *)dbts
{
    NSMutableString *text = [[NSMutableString alloc] init];
    NSRange s = [dbts rangeOfString:@"("];
    NSRange e = [dbts rangeOfString:@")"];
    NSString * findStr = [dbts substringWithRange:NSMakeRange(s.location, e.location - s.location)];
    for (FMDTSchemaField *entry in ldts.fields) {
        if (![findStr containsString:entry.name]) {
            [text appendFormat:@"alter table [%@] add column [%@] %@;", ldts.tableName, entry.name, entry.type];
        }
    }
    return text;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com