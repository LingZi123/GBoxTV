//
//  enmuHelper.h
//  WOTV
//
//  Created by PC_201310113421 on 15/6/15.
//  Copyright (c) 2015年 Gf_zgp. All rights reserved.
//


#import <Foundation/Foundation.h>

//终端类型
typedef NS_ENUM(NSInteger, en_TerminalFlag) {
    STB = 1,
    mobile = 2,
    PC = 4,
    PAD=8
};

//加密解密
typedef NS_ENUM(NSInteger, CCOperation) {
    kCCDecrypt,
    kENcrypt
};

//栏目等级
typedef NS_ENUM(NSInteger, en_Category) {
    CategoryParent,
    CategorySubOne,
    CategorySubTwo,
};

//收藏类型，1电影2电视剧
typedef NS_ENUM(int, en_FavoriteType) {
    FavoriteType_Moive=1,
    FavoriteType_Serie,
};

typedef enum
{
    AUDIO_MODE_OFF          = 0,
    AUDIO_MODE_SPEAKER      = 1,
    AUDIO_MODE_MICROPHONE   = 2,
}ENUM_AUDIO_MODE;

//登录类型
typedef NS_ENUM(NSInteger, en_LoginType) {
    LoginType,
    ReLoginType
};



@interface enmuHelper : NSObject

@end
