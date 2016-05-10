//
//  IptvScheduleInfoModel.m
//  WOTV
//
//  Created by PC_201310113421 on 15/6/18.
//  Copyright (c) 2015年 Gf_zgp. All rights reserved.
//

#import "IptvScheduleInfoModel.h"
#import "CommonHelper.h"

@implementation IptvScheduleInfoModel
+(id)getModelWithDictionary:(NSDictionary *)dic{
    IptvScheduleInfoModel *model=[[IptvScheduleInfoModel alloc]init];
    model.ContentID= [dic objectForKey:@"ContentID"];
    model.ChannelID= [dic objectForKey:@"ChannelID"];
    model.ProgramName=[dic objectForKey:@"ProgramName"];
    model.StartDate=[dic objectForKey:@"StartDate"];
    model.StartTime=[dic objectForKey:@"StartTime"];
    model.Duration=[[CommonHelper share]getNumberWithString:[dic objectForKey:@"Duration"]];
    model.Description=[dic objectForKey:@"Description"];
    model.PhysicalContentID=[dic objectForKey:@"PhysicalContentID"];
    model.Domain=[dic objectForKey:@"Domain"];
    model.PlayUrl=[dic objectForKey:@"PlayUrl"];
    return model;

}
@end
