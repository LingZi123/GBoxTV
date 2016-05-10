//
//  ProgramModel.h
//  WOTV
//
//  Created by PC_201310113421 on 15/6/23.
//  Copyright (c) 2015年 Gf_zgp. All rights reserved.
//

#import "BaseModel.h"

@interface ProgramModel : BaseModel
@property(nonatomic,copy) NSString *ContentID	;//	节目ID
@property(nonatomic,copy) NSString *Name	;//	节目名称
@property(nonatomic,copy) NSString *PicUrl	;//	海报地址
@property(nonatomic,copy)NSString *model;//是电影还是电视剧

@end
