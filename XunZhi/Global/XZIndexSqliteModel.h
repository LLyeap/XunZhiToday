//
//  XZIndexSqliteModel.h
//  XunZhi
//
//  Created by 李雷 on 16/6/1.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "FMDTObject.h"

#import "XZIndexTVModel.h"

@interface XZIndexSqliteModel : FMDTObject

@property (nonatomic, copy) NSString *Publish_Time;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *source_avatar;
@property (nonatomic, assign) NSInteger like_count;
@property (nonatomic, assign) NSInteger comment_count;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *behot_time;
@property (nonatomic, copy) NSString *share_url;

/** 以下信息用来判断tableViewCell的样式 */
// >@property (nonatomic, assign) Boolean has_image;
@property (nonatomic, assign) BOOL has_video;
@property (nonatomic, retain) NSDictionary *video_detail_info;
@property (nonatomic, assign) NSInteger video_duration;
@property (nonatomic, assign) NSInteger gallary_image_count;
@property (nonatomic, retain) NSArray *image_list;
@property (nonatomic, retain) NSArray *large_image_list;
@property (nonatomic, retain) NSDictionary *middle_image;

/** 不是网络数据, 是用来判断本地收藏的 */
@property (nonatomic, copy) NSString *isFavorite;


@end








