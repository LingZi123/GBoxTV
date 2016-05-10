//
//  ThreeCategateInfoView.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/27.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgramModel.h"
#import "IptvCategoryModel.h"

@protocol ThreeCategateInfoViewDelegate <NSObject>

@optional
-(void)didSelectedProgram:(NSString *)playurl titlename:(NSString *)titlename;

@end

@interface ThreeCategateInfoView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *seriesLabel;//选择
    
    UITableView *threeTableview;//三级目录的
    NSMutableArray *threemArray;//三级目录的剧集
    ProgramModel *currentPlayModel;//当前播放的节目
}
@property(nonatomic,retain)IptvCategoryModel *supperModel;
@property(nonatomic,assign)id<ThreeCategateInfoViewDelegate> threeDelegate;
-(void)SearchPrograms;
@end
