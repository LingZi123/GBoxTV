//
//  ProgramInfo.h
//  WOTV
//
//  Created by PC_201310113421 on 15/6/23.
//  Copyright (c) 2015年 Gf_zgp. All rights reserved.
//

#import "SeriesInfoModel.h"

@interface ProgramInfo : SeriesInfoModel

@property(nonatomic,copy) NSString *PhysicalContentID	;//	MovieID
@property(nonatomic,copy) NSString *Domain	;//	服务协议
@property(nonatomic,copy) NSString *Duration	;//	播放时长HHMISSFF （时分秒帧）
@property(nonatomic,copy) NSString *PlayUrl	;//	播放地址
@property float *PriceTaxIn	;//	影片价格

@end
