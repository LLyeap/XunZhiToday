//
//  XZIndexTableViewModel.m
//  XunZhi
//
//  Created by 李雷 on 16/5/22.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZIndexTVModel.h"

#import "XZIndexSqliteModel.h"

@implementation XZIndexTVModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        /** KVC赋值 */
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}

+ (instancetype)indexTVModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//        XZLog(@"有没找到的key");
    if ([key isEqualToString:@"publish_time"]) {
        self.Publish_Time = [NSString stringWithFormat:@"%@", value];
    }
}

+ (instancetype)indexTVModelWithIndexSqliteModel:(XZIndexSqliteModel *)indexSqliteModel {
    XZIndexTVModel *indexTVModel = [[self alloc] init];
    indexTVModel.Publish_Time = indexSqliteModel.Publish_Time;
    
    indexTVModel.title = indexSqliteModel.title;
    indexTVModel.source = indexSqliteModel.source;
    indexTVModel.source_avatar = indexSqliteModel.source_avatar;
    indexTVModel.like_count = indexSqliteModel.like_count;
    indexTVModel.comment_count = indexSqliteModel.comment_count;
    indexTVModel.label = indexSqliteModel.label;
    indexTVModel.behot_time = indexSqliteModel.behot_time;
    indexTVModel.share_url = indexSqliteModel.share_url;
    
    indexTVModel.has_video = indexSqliteModel.has_video;
    indexTVModel.video_detail_info = indexSqliteModel.video_detail_info;
    indexTVModel.video_duration = indexSqliteModel.video_duration;
    indexTVModel.gallary_image_count = indexSqliteModel.gallary_image_count;
    indexTVModel.image_list = indexSqliteModel.image_list;
    indexTVModel.large_image_list = indexSqliteModel.large_image_list;
    indexTVModel.middle_image = indexSqliteModel.middle_image;
    
    indexTVModel.isFavorite = indexSqliteModel.isFavorite;
    
    
    return indexTVModel;
}



@end





