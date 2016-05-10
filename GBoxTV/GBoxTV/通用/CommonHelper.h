//
//  commonHelper.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonHelper : NSObject

+(id)share;
-(NSString *)getIpAddress;//获取IP地址
-(int)getNumberWithString:(NSString *)str;//通过次序时间获取总秒数
-(void)writeDefaultsData:(id)value andKey:(NSString *)key;//写入

@end
