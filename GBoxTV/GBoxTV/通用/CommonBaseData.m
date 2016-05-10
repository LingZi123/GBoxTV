//
//  CommonBaseData.m
//  WOTV
//
//  Created by PC_201310113421 on 15/6/16.
//  Copyright (c) 2015年 Gf_zgp. All rights reserved.
//

#import "CommonBaseData.h"

@implementation CommonBaseData

-(instancetype)init{
    self=[super init];
    if (self) {
        _user=[[NSMutableDictionary alloc]init];
        _device=[[NSMutableDictionary alloc]init];
        _param=[[NSMutableDictionary alloc]init];
    }
    return self;
}

-(NSMutableDictionary *)getDictionary{
    NSMutableDictionary *result=[[NSMutableDictionary alloc]init];
    [result setObject:_action forKey:@"action"];
    [result setObject:_device forKey:@"device"];
    [result setObject:_user forKey:@"user"];
    [result setObject:_param forKey:@"param"];
    return  result;
}
@end
