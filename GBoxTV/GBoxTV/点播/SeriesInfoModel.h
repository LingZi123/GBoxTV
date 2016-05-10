//
//  SeriesInfoModel.h
//  WOTV
//
//  Created by PC_201310113421 on 15/6/24.
//  Copyright (c) 2015年 Gf_zgp. All rights reserved.
//

#import "BaseModel.h"

@interface SeriesInfoModel : BaseModel
@property(nonatomic,copy) NSString *ContentID	;//	节目ID
@property(nonatomic,copy) NSString *Name	;//	节目名称
@property(nonatomic,copy) NSString *Actors	;//	演员
@property(nonatomic,copy) NSString *Directors	;//	导演
@property(nonatomic,copy) NSString *ViewPoint	;//	看点
@property(nonatomic,copy) NSString *Description	;//	描述
@property(nonatomic,copy) NSString *CoverUrl	;	//海报地址

@end
