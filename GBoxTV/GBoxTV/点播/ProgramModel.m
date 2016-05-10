//
//  ProgramModel.m
//  WOTV
//
//  Created by PC_201310113421 on 15/6/23.
//  Copyright (c) 2015年 Gf_zgp. All rights reserved.
//

#import "ProgramModel.h"

@implementation ProgramModel
+(id)getModelWithDictionary:(NSDictionary *)dic{
    if (dic==nil||dic==(id)[NSNull null]){
        return nil;
    }
    ProgramModel *model=[[ProgramModel alloc]init];
    model.ContentID=[dic objectForKey:@"ContentID"];
    model.Name=[dic objectForKey:@"Name"];
    model.PicUrl=[dic objectForKey:@"PicUrl"];
    NSString *modelstr=[dic objectForKey:@"model"];
    if (modelstr) {
        model.model=modelstr;
    }
    return model;
}

@end
