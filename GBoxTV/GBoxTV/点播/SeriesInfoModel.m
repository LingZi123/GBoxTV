//
//  SeriesInfoModel.m
//  WOTV
//
//  Created by PC_201310113421 on 15/6/24.
//  Copyright (c) 2015年 Gf_zgp. All rights reserved.
//

#import "SeriesInfoModel.h"

@implementation SeriesInfoModel

+(id)getModelWithDictionary:(NSDictionary *)dic{
    if (dic==nil||dic==(id)[NSNull null]) {
        return nil;
    }
    SeriesInfoModel *model=[[SeriesInfoModel alloc]init];
    model.ContentID= [dic objectForKey:@"ContentID"];
    model.Name=[dic objectForKey:@"Name"];
    model.Actors=[dic objectForKey:@"Actors"];
    model.Directors=[dic objectForKey:@"Directors"];
    model.ViewPoint=[dic objectForKey:@"ViewPoint"];
    model.Description=[dic objectForKey:@"Description"];
    model.CoverUrl=[dic objectForKey:@"CoverUrl"];
    return model;

}
@end
