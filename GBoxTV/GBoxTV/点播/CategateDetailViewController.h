//
//  CategateDetailViewController.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/28.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgramModel.h"
#import "IptvCategoryModel.h"

@interface CategateDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
    NSMutableArray *programArray;
    IptvCategoryModel *supperModel;
}
-(instancetype)initWithSuperModel:(IptvCategoryModel *)supCategory;
@end
