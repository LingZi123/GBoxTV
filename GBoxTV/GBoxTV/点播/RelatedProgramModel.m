//
//  RelatedProgramModel.m
//  WOTV
//
//  Created by PC_201310113421 on 15/6/23.
//  Copyright (c) 2015年 Gf_zgp. All rights reserved.
//

#import "RelatedProgramModel.h"

@implementation RelatedProgramModel
+(id)getModelWithDictionary:(NSDictionary *)dic{
    RelatedProgramModel *model=[[RelatedProgramModel alloc]init];
    model.Name=[dic objectForKey:@"Name"];
    model.PicUrl=[dic objectForKey:@"PicUrl"];
    model.ContentID=[dic objectForKey:@"ContentID"];
    model.model=[dic objectForKey:@"model"];
    return model;
}
@end
