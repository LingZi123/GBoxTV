//
//  IptvCategoryModel.h
//  WOTV
//
//  Created by PC_201310113421 on 15/6/19.
//  Copyright (c) 2015年 Gf_zgp. All rights reserved.
//

#import "BaseModel.h"

@interface IptvCategoryModel : BaseModel

@property(nonatomic,copy)NSString *CategoryID	;//	栏目ID
@property(nonatomic,copy)NSString *ParentID	;//	父ID
@property(nonatomic,copy)NSString *Name	;//	栏目名称
@property(nonatomic,copy)NSString *Sequence	;//	显示顺序号
@property(nonatomic,copy)NSString *Description	;//	描述信息
@property(nonatomic,copy)NSString *PicUrl	;//	分类图片

@end

