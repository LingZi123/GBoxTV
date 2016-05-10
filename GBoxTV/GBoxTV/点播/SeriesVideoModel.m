//
//  SeriesVideoModel.m
//  WOTV
//
//  Created by PC_201310113421 on 15/6/24.
//  Copyright (c) 2015年 Gf_zgp. All rights reserved.
//

#import "SeriesVideoModel.h"

@implementation SeriesVideoModel
+(id)getModelWithDictionary:(NSDictionary *)dic{
    if (dic==nil||dic==(id)[NSNull null]) {
        return nil;
    }
    
    SeriesVideoModel *model=[[SeriesVideoModel alloc]init];
    model.Name=[dic objectForKey:@"Name"];
    model.Sequence=[dic objectForKey:@"Sequence"];
    model.PhysicalContentID=[dic objectForKey:@"PhysicalContentID"];
    model.Domain=[dic objectForKey:@"Domain"];
    model.Duration=[dic objectForKey:@"Duration"];
    model.CoverUrl=[dic objectForKey:@"CoverUrl"];
    model.PlayUrl=[dic objectForKey:@"PlayUrl"];
    return model;
}
@end
