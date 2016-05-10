//
//  commonHelper.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "commonHelper.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <netdb.h>

__strong static CommonHelper *_helper=nil;

@implementation CommonHelper

+(id)share{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _helper=[[CommonHelper alloc]init];
    });
    
    return _helper;
}

#pragma mark-地址操作

//获取host的名称
- (NSString *) hostname
{
    char baseHostName[256]; // Thanks, Gunnar Larisch
    int success = gethostname(baseHostName, 255);
    if (success != 0) return nil;
    baseHostName[255] = '/0';
    
#if TARGET_IPHONE_SIMULATOR
    return [NSString stringWithFormat:@"%s", baseHostName];
#else
    return [NSString stringWithFormat:@"%s.local", baseHostName];
#endif
}

//从host获取地址
- (NSString *) getIPAddressForHost: (NSString *) theHost
{
    struct hostent *host = gethostbyname([theHost UTF8String]);
    if (!host) {herror("resolv"); return NULL; }
    struct in_addr **list = (struct in_addr **)host->h_addr_list;
    NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
    return addressString;
}

//获取IP地址
-(NSString *)getIpAddress{
    
    struct hostent *host = gethostbyname([[self hostname] UTF8String]);
    if (!host) {herror("resolv"); return nil;}
    struct in_addr **list = (struct in_addr **)host->h_addr_list;
    return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
}

//必须是000000格式的字符串，主要用于获取回看信息的时间
-(int)getNumberWithString:(NSString *)str{
    int seconds=0;//返回的秒数
    
    if (![str isEqualToString:@""]) {
        NSString *str1=[str substringToIndex:(2)];
        NSString *str2=[str substringWithRange:NSMakeRange(2, 2)];
        NSString *str3=[str substringFromIndex:4];
        
        seconds=[str1 intValue]*60*60+[str2 intValue]*60+[str3 intValue];
    }
    
    return seconds;
}
-(void)writeDefaultsData:(id)value andKey:(NSString *)key{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
    
}

@end
