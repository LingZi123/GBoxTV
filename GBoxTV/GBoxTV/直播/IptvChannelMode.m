//
//  IptvChannelMode.m
//  WTV
//
//  Created by Gf_zgp on 14-3-17.
//  Copyright (c) 2014年 Gf_zgp. All rights reserved.
//

#import "IptvChannelMode.h"
//#import "GDataXMLNode.h"
@implementation IptvChannelMode
//@synthesize ContentID,CallSign,ChannelNumber,TimeShift,Logo,Name,PlayUrl,MultiCastUrl,IsSchedule,Hd;

+(id)getModelWithDictionary:(NSDictionary *)dic
{
    IptvChannelMode *model=[[IptvChannelMode alloc]init];
    
        model.ContentID= [dic objectForKey:@"ContentID"];
        model.CallSign=[dic objectForKey:@"CallSign"];
        model.ChannelNumber= [dic objectForKey:@"ChannelNumber"];
        model.TimeShift=[dic objectForKey:@"TimeShift"];
        model.Logo= [dic objectForKey:@"Logo"];
        model.Name=[dic objectForKey:@"Name"];
        
        model.PlayUrl=[dic objectForKey:@"PlayUrl"];
        model.MultiCastUrl= [dic objectForKey:@"MultiCastUrl"];
        model.IsSchedule=[[dic objectForKey:@"IsSchedule"] intValue];
        model.Hd= [dic objectForKey:@"Hd"];
    
    return model;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.ContentID forKey:@"ContentID"];
    [aCoder encodeObject:self.CallSign forKey:@"CallSign"];
    [aCoder encodeObject:self.ChannelNumber forKey:@"ChannelNumber"];
    [aCoder encodeObject:self.TimeShift forKey:@"TimeShift"];
    [aCoder encodeObject:self.Logo forKey:@"Logo"];
    [aCoder encodeObject:self.Name forKey:@"Name"];
    [aCoder encodeObject:self.PlayUrl forKey:@"PlayUrl"];
    [aCoder encodeObject:self.MultiCastUrl forKey:@"MultiCastUrl"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.IsSchedule] forKey:@"IsSchedule"];
    [aCoder encodeObject:self.Hd forKey:@"Hd"];
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self) {
        self.ContentID=[aDecoder decodeObjectForKey:@"ContentID"];
        self.CallSign=[aDecoder decodeObjectForKey:@"CallSign"];
        self.ChannelNumber=[aDecoder decodeObjectForKey:@"ChannelNumber"];
        self.TimeShift=[aDecoder decodeObjectForKey:@"TimeShift"];
        self.Logo=[aDecoder decodeObjectForKey:@"Logo"];
        self.Name=[aDecoder decodeObjectForKey:@"Name"];
        self.PlayUrl=[aDecoder decodeObjectForKey:@"PlayUrl"];
        self.MultiCastUrl=[aDecoder decodeObjectForKey:@"MultiCastUrl"];
        self.IsSchedule=[[aDecoder decodeObjectForKey:@"IsSchedule"] intValue];;
        self.Hd=[aDecoder decodeObjectForKey:@"Hd"];
    }
    return self;
}

@end
