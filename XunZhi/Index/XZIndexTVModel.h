//
//  XZIndexTableViewModel.h
//  XunZhi
//
//  Created by 李雷 on 16/5/22.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XZIndexSqliteModel;

@interface XZIndexTVModel : NSObject


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

/** 不是网络数据, 是用来判断本地收藏的, 之前用BOOL, 结果数据库存不了 */
@property (nonatomic, copy) NSString *isFavorite;

+ (instancetype)indexTVModelWithDict:(NSDictionary *)dict;

+ (instancetype)indexTVModelWithIndexSqliteModel:(XZIndexSqliteModel *)indexSqliteModel;

@end
//{
//    "media_name": "军事天地",
//    "ban_comment": 0,
//    "abstract": "对于我军的第一代步兵战车我想大家都非常的清楚，那就是中国北方工业公司于上世纪80年代初基于苏联BMP-1步兵战车仿制的86式履带步兵战车，当时的工程代号WZ501。该车在研制成功后立即就承接了国外的订货，并且与1987年进行了小量试生产，整个系统国产化率逐步提高后于1992年进行",
//    "image_list": [],
//    "has_video": false,
//    "article_type": 0,
//    "tag": "news_military",
//    "has_m3u8_video": 0,
//    "keywords": "苏联,装甲输送车,大宝贝,通过性,履带式,军事博物馆,中国北方工业公司,BTR-70,红箭73反坦克导弹,我军,滑膛炮,步战车,BMP-1步兵战车,橡胶轮胎,俄罗斯",
//    "has_mp4_video": 0,
//    "display_url": "http://toutiao.com/group/6289744561284792577/",
//    "article_sub_type": 0,
//    "bury_count": 5,
//    "title": "终于明白中国为何坚定选择履带式战车：俄方白送了个大宝贝也不换",
//    "ignore_web_transform": 1,
//    "source_icon_style": 1,
//    "tip": 0,
//    "hot": 0,
//    "share_url": "http://toutiao.com/group/6289744561284792577/?iid=4315625960&app=news_article",
//    "source": "军事天地",
//    "comment_count": 37,
//    "article_url": "http://toutiao.com/group/6289744561284792577/",
//    "aggr_type": 1,
//    "publish_time": 1464445643,
//    "action_list": [
//                    {
//                        "action": 1,
//                        "extra": {},
//                        "desc": ""
//                    },
//                    {
//                        "action": 3,
//                        "extra": {},
//                        "desc": ""
//                    },
//                    {
//                        "action": 7,
//                        "extra": {},
//                        "desc": ""
//                    },
//                    {
//                        "action": 9,
//                        "extra": {},
//                        "desc": ""
//                    }
//                    ],
//    "display_title": " ",
//    "gallary_image_count": 4,
//    "tag_id": 6289744561284792000,
//    "item_id": 6289746147137308000,
//    "user_like": 0,
//    "natant_level": 0,
//    "reback_flag": 0,
//    "is_subscribe": false,
//    "level": 0,
//    "url": "http://toutiao.com/group/6289744561284792577/",
//    "source_open_url": "sslocal://media_account?media_id=5719720493",
//    "repin_count": 374,
//    "like_count": 53,
//    "digg_count": 2,
//    "behot_time": 1464485203,
//    "cursor": 1464485203000,
//    "cell_flag": 299,
//    "preload_web": 2,
//    "has_image": true,
//    "media_info": {
//        "avatar_url": "http://p2.pstatp.com/large/9059/6606002390",
//        "media_id": 5719720493,
//        "name": "军事天地",
//        "user_verified": false
//    },
//    "group_id": 6289744561284792000,
//    "middle_image": {
//        "url": "http://p1.pstatp.com/list/412001b60ae466f650a",
//        "width": 501,
//        "url_list": [
//                     {
//                         "url": "http://p1.pstatp.com/list/412001b60ae466f650a"
//                     },
//                     {
//                         "url": "http://pb3.pstatp.com/list/412001b60ae466f650a"
//                     },
//                     {
//                         "url": "http://pb3.pstatp.com/list/412001b60ae466f650a"
//                     }
//                     ],
//        "uri": "list/412001b60ae466f650a",
//        "height": 349
//    }
//},





#pragma mark - 视频
// >http://v6.pstatp.com/video/c/d1dcf5d87df844ab86a8148010c96fdf/?Signature=KFXXODNk01%2FQztprSpJPTQsQSQ4%3D&Expires=1464599295&KSSAccessKeyId=qh0h9TdcEMrm1VlR2ad/

// >http://v6.pstatp.com/video/c/d1dcf5d87df844ab86a8148010c96fdf/?Expires=1464599295/
// >video_detail_info里的video_id和behot_time
//{
//    "video_id": "0aec24e59f654bc08690efe2a86ed201",
//    "media_name": "天天鬼步舞",
//    "ban_comment": 0,
//    "abstract": "北京三里屯帅哥靓妹《小苹果》舞蹈快闪！",
//    "video_detail_info": {
//        "group_flags": 32832,
//        "video_id": "0aec24e59f654bc08690efe2a86ed201",
//        "direct_play": 1,
//        "detail_video_large_image": {
//            "url": "http://p2.pstatp.com/video1609/71b0002253a8565ca93",
//            "width": 580,
//            "url_list": [
//                         {
//                             "url": "http://p2.pstatp.com/video1609/71b0002253a8565ca93"
//                         },
//                         {
//                             "url": "http://p4.pstatp.com/video1609/71b0002253a8565ca93"
//                         },
//                         {
//                             "url": "http://p.pstatp.com/video1609/71b0002253a8565ca93"
//                         }
//                         ],
//            "uri": "video1609/71b0002253a8565ca93",
//            "height": 326
//        },
//        "show_pgc_subscribe": 1,
//        "video_watch_count": 23867
//    },
//    "image_list": [],
//    "has_video": true,
//    "article_type": 0,
//    "tag": "video_ent",
//    "has_m3u8_video": 0,
//    "keywords": "三里屯,小苹果",
//    "video_duration": 342,
//    "has_mp4_video": 0,
//    "aggr_type": 1,
//    "cell_type": 0,
//    "article_sub_type": 0,
//    "group_flags": 32832,
//    "bury_count": 17,
//    "title": "北京三里屯帅哥靓妹《小苹果》舞蹈快闪！",
//    "ignore_web_transform": 1,
//    "source_icon_style": 4,
//    "tip": 0,
//    "hot": 0,
//    "share_url": "http://toutiao.com/a6290142713362776578/?iid=4315625960&app=news_article",
//    "label": "视频",
//    "source": "天天鬼步舞",
//    "comment_count": 24,
//    "article_url": "http://toutiao.com/group/6290142713362776578/",
//    "filter_words": [
//                     {
//                         "id": "8:0",
//                         "name": "重复、旧闻",
//                         "is_selected": false
//                     },
//                     {
//                         "id": "9:1",
//                         "name": "内容质量差",
//                         "is_selected": false
//                     },
//                     {
//                         "id": "5:349709416",
//                         "name": "来源:天天鬼步舞",
//                         "is_selected": false
//                     },
//                     {
//                         "id": "6:142297",
//                         "name": "小苹果",
//                         "is_selected": false
//                     },
//                     {
//                         "id": "6:15799",
//                         "name": "北京",
//                         "is_selected": false
//                     }
//                     ],
//    "publish_time": 1464576192,
//    "action_list": [
//                    {
//                        "action": 1,
//                        "extra": {},
//                        "desc": ""
//                    },
//                    {
//                        "action": 3,
//                        "extra": {},
//                        "desc": ""
//                    },
//                    {
//                        "action": 7,
//                        "extra": {},
//                        "desc": ""
//                    },
//                    {
//                        "action": 9,
//                        "extra": {},
//                        "desc": ""
//                    }
//                    ],
//    "has_image": false,
//    "cell_layout_style": 1,
//    "tag_id": 6290142713362777000,
//    "video_style": 0,
//    "display_url": "http://toutiao.com/group/6290142713362776578/",
//    "large_image_list": [
//                         {
//                             "url": "http://p2.pstatp.com/video1609/71b0002253a8565ca93",
//                             "width": 580,
//                             "url_list": [
//                                          {
//                                              "url": "http://p2.pstatp.com/video1609/71b0002253a8565ca93"
//                                          },
//                                          {
//                                              "url": "http://p4.pstatp.com/video1609/71b0002253a8565ca93"
//                                          },
//                                          {
//                                              "url": "http://p.pstatp.com/video1609/71b0002253a8565ca93"
//                                          }
//                                          ],
//                             "uri": "video1609/71b0002253a8565ca93",
//                             "height": 326
//                         }
//                         ],
//    "item_id": 6290142713362777000,
//    "repin_count": 117,
//    "cell_flag": 43,
//    "source_open_url": "sslocal://media_account?media_id=4696556867",
//    "level": 0,
//    "like_count": 25,
//    "digg_count": 25,
//    "behot_time": 1464595066,
//    "cursor": 1464595066999,
//    "url": "http://toutiao.com/group/6290142713362776578/",
//    "preload_web": 0,
//    "user_repin": 0,
//    "label_style": 1,
//    "item_version": 0,
//    "media_info": {
//        "avatar_url": "http://p1.pstatp.com/large/11547/332989240",
//        "media_id": 4696556867,
//        "name": "天天鬼步舞",
//        "user_verified": false
//    },
//    "group_id": 6290142713362777000,
//    "middle_image": {
//        "url": "http://p2.pstatp.com/list/71b0002253a8565ca93",
//        "width": 640,
//        "url_list": [
//                     {
//                         "url": "http://p2.pstatp.com/list/71b0002253a8565ca93"
//                     },
//                     {
//                         "url": "http://p4.pstatp.com/list/71b0002253a8565ca93"
//                     },
//                     {
//                         "url": "http://p.pstatp.com/list/71b0002253a8565ca93"
//                     }
//                     ],
//        "uri": "list/71b0002253a8565ca93",
//        "height": 360
//    }
//}







