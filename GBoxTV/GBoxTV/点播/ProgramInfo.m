//
//  ProgramInfo.m
//  WOTV
//
//  Created by PC_201310113421 on 15/6/23.
//  Copyright (c) 2015年 Gf_zgp. All rights reserved.
//

#import "ProgramInfo.h"

@implementation ProgramInfo

+(id)getModelWithDictionary:(NSDictionary *)dic{
    if (dic==nil||dic==(id)[NSNull null]) {
        return nil;
    }
    ProgramInfo *model=[[ProgramInfo alloc]init];
    model.ContentID= [dic objectForKey:@"ContentID"];
    model.Name=[dic objectForKey:@"Name"];
    model.Actors=[dic objectForKey:@"Actors"];
    model.Directors=[dic objectForKey:@"Directors"];
    model.ViewPoint=[dic objectForKey:@"ViewPoint"];
    model.Description=[dic objectForKey:@"Description"];
    model.PhysicalContentID=[dic objectForKey:@"PhysicalContentID"];
    model.Domain=[dic objectForKey:@"Domain"];
    model.Duration=[dic objectForKey:@"Duration"];
    model.CoverUrl=[dic objectForKey:@"CoverUrl"];
    model.PlayUrl=[dic objectForKey:@"PlayUrl"];
//    model.PriceTaxIn=[[dic objectForKey:@"PriceTaxIn"] floatValue];
    return model;
}

@end
