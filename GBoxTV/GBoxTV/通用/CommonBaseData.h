//
//  CommonBaseData.h
//  WOTV
//
//  Created by PC_201310113421 on 15/6/16.
//  Copyright (c) 2015年 Gf_zgp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonBaseData : NSObject
@property(nonatomic,copy)NSString *action;
@property(nonatomic,retain)NSMutableDictionary *device;
@property(nonatomic,retain)NSMutableDictionary *user;
@property(nonatomic,retain)NSMutableDictionary *param;
-(NSMutableDictionary *)getDictionary;
@end
