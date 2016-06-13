//
//  XZPictureTVModel.h
//  XunZhi
//
//  Created by 王旭 on 16/5/25.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZPictureTVModel : NSObject

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, retain) NSDictionary *large_image; // >动图
// >width, url_list(数组), uri, height
@property (nonatomic, assign) NSInteger digg_count; // >喜欢
@property (nonatomic, assign) NSInteger bury_count; // >不喜欢
@property (nonatomic, assign) NSInteger comment_count;
@property (nonatomic, retain) NSDictionary *middle_image; // >静图
@property (nonatomic, retain) NSString *behot_time;
// >width, url_list(数组), uri, height
@property (nonatomic, retain) NSString *share_url;

+ (instancetype)pictureTVModelWithDict:(NSDictionary *)dict;

@end
//{
//    "create_time": 1464489546,
//    "user_verified": false,
//    "cell_type": 3,
//    "user_id": 3681608602,
//    "bury_count": 547,
//    "tip": 0,
//    "share_url": "http://toutiao.com/group/6629198074/?iid=4315625960",
//    "label": "趣图",
//    "content": "我学历不够",
//    "comment_count": 8593,
//    "display_time": 1464508655,
//    "large_image": {
//        "width": 490,
//        "url_list": [
//                     {
//                         "url": "http://p2.pstatp.com/large/5e10006659bbf939c45"
//                     }
//                     ],
//        "uri": "large/5e10006659bbf939c45",
//        "height": 470
//    },
//    "group_flags": 0,
//    "screen_name": "执念21645807",
//    "repin_count": 487,
//    "digg_count": 5199,
//    "behot_time": 1464508655,
//    "cursor": 1464508655000,
//    "avatar_url": "http://p1.pstatp.com/thumb/411001370637d1899da",
//    "label_style": 4,
//    "group_id": 6629198074,
//    "middle_image": {
//        "width": 490,
//        "url_list": [
//                     {
//                         "url": "http://p2.pstatp.com/w480/5e10006659bbf939c45"
//                     }
//                     ],
//        "uri": "w480/5e10006659bbf939c45",
//        "height": 470
//    }
//}








