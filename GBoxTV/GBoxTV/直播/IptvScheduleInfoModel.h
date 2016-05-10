//
//  IptvScheduleInfoModel.h
//  WOTV
//
//  Created by PC_201310113421 on 15/6/18.
//  Copyright (c) 2015年 Gf_zgp. All rights reserved.
//

#import "BaseModel.h"

@interface IptvScheduleInfoModel : BaseModel

@property(nonatomic,retain)NSString *ContentID;//	节目ID
@property(nonatomic,retain)NSString *ChannelID;//	频道ID
@property(nonatomic,retain)NSString *ProgramName;//	节目名称
@property(nonatomic,retain)NSString *StartDate	;//	播出日期
@property(nonatomic,retain)NSString *StartTime	;//	播出时间
@property(nonatomic,assign)long Duration	;//	持续时间
@property(nonatomic,retain)NSString *Description;//	描述
@property(nonatomic,retain)NSString *PhysicalContentID	;//	MovieID
@property(nonatomic,retain)NSString *Domain	;//	服务协议
@property(nonatomic,retain)NSString *PlayUrl	;//	回看地址

@end
