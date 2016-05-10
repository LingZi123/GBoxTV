//
//  IptvChannelMode.h
//  WTV
//
//  Created by Gf_zgp on 14-3-17.
//  Copyright (c) 2014年 Gf_zgp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface IptvChannelMode :BaseModel<NSCoding>

@property (nonatomic,strong) NSString *ContentID ;//频道id
@property (nonatomic,strong) NSString *CallSign;//台标名称
@property (nonatomic,strong) NSString *ChannelNumber;//频道号
@property (nonatomic,strong) NSString *TimeShift;//时移标志0:不生效 1:生效
@property (nonatomic,strong) NSString *Logo;//频道logo
@property (nonatomic,strong) NSString *Name;    //频道名称
@property (nonatomic,strong) NSString *PlayUrl;//单播地址
@property (nonatomic,strong) NSString *MultiCastUrl;//组播地址
@property  int IsSchedule;//是否有回看 0：无回看 1：有回看
@property (nonatomic,strong) NSString *Hd;//是否高清频道

@end
