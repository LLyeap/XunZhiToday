//
//  XZVideoTVModel.h
//  XunZhi
//
//  Created by 李雷 on 16/5/25.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZVideoTVModel : NSObject

/** 视频的图片封面, 放在主页面里面 */
@property (nonatomic, copy)NSString *cover;
/** 视频的URL地址 */
@property (nonatomic, copy)NSString *mp4_url;
/** 视频的名字 */
@property (nonatomic, copy)NSString *title;
/** 点击视频进入子页面时查询URL需要的ID值 */
@property (nonatomic, copy)NSString *vid;

+ (instancetype)videoTVModelWithDict:(NSDictionary *)dict;

@end
//{
//    "topicImg": "http://vimg1.ws.126.net/image/snapshot/2016/2/U/L/VBG7H0SUL.jpg",
//    "replyCount": 0,
//    "videosource": "新媒体",
//    "mp4Hd_url": null,
//    "topicDesc": "不说不笑不热闹",
//    "topicSid": "VBFGARMFR",
//    "cover": "http://vimg1.ws.126.net/image/snapshot/2016/5/0/U/VBNAG4L0U.jpg",
//    "title": "魔镜魔镜 谁是这世界上最美的女人",
//    "playCount": 615,
//    "replyBoard": "video_bbs",
//    "videoTopic": {
//        "alias": "不说不笑不热闹",
//        "tname": "搞笑一箩筐",
//        "ename": "T1460515708679",
//        "tid": "T1460515708679"
//    },
//    "sectiontitle": "",
//    "replyid": "BNAFSBH9008535RB",
//    "description": "小咖秀合作",
//    "mp4_url": "http://flv2.bn.netease.com/tvmrepo/2016/5/2/7/EBNAFS627/SD/EBNAFS627-mobile.mp4",
//    "length": 10,
//    "playersize": 0,
//    "m3u8Hd_url": null,
//    "vid": "VBNAFSBH9",
//    "m3u8_url": "http://flv2.bn.netease.com/tvmrepo/2016/5/2/7/EBNAFS627/SD/movie_index.m3u8",
//    "ptime": "2016-05-29 15:03:00",
//    "topicName": "搞笑一箩筐"
//},






