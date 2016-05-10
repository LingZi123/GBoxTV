//
//  SeriesVideoModel.h
//  WOTV
//
//  Created by PC_201310113421 on 15/6/24.
//  Copyright (c) 2015年 Gf_zgp. All rights reserved.
//

#import "BaseModel.h"

@interface SeriesVideoModel : BaseModel
@property(nonatomic,copy)NSString *Name	;//	节目ID
@property(nonatomic,copy)NSString *Sequence	;//	集数
@property(nonatomic,copy)NSString *PhysicalContentID	;//	MovieId
@property(nonatomic,copy)NSString *Domain	;//	服务协议
@property(nonatomic,copy)NSString *Duration	;//	播放时长HHMISSFF （时分秒帧）
@property(nonatomic,copy)NSString *CoverUrl	;//	海报地址
@property(nonatomic,copy)NSString *PlayUrl	;//	播出地址
@end
