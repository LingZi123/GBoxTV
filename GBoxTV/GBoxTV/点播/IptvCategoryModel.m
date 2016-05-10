//
//  IptvCategoryModel.m
//  WOTV
//
//  Created by PC_201310113421 on 15/6/19.
//  Copyright (c) 2015年 Gf_zgp. All rights reserved.
//

#import "IptvCategoryModel.h"

@implementation IptvCategoryModel

+(id)getModelWithDictionary:(NSDictionary *)dic{
    IptvCategoryModel *model=[[IptvCategoryModel alloc]init];
    model.CategoryID= [dic objectForKey:@"CategoryID"];
    model.ParentID=[dic objectForKey:@"ParentID"];
    model.Name=[dic objectForKey:@"Name"];
    model.Sequence=[dic objectForKey:@"Sequence"];
    model.Description=[dic objectForKey:@"Description"];
    model.PicUrl=[dic objectForKey:@"PicUrl"];
    return model;
}

@end
