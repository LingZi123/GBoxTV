//
//  UserInfoModel.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString *expiredtime;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, copy) NSString *sesion;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) BOOL isuse;

+(void)insertModel:(UserInfoModel *)model;
+(void)deleteModelWithUsername:(NSString *)userName;
+(BOOL)existModelWithUsername:(NSString *)userName;
+(void)updateModel:(UserInfoModel *)model;

@end
