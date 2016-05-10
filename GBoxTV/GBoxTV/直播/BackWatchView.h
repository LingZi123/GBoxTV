//
//  BackWatchView.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/22.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IptvScheduleInfoModel.h"
#import "IptvChannelMode.h"

@protocol BackWatchViewDelegate <NSObject>

-(void)backSeeTableviewSelectedModel:(IptvScheduleInfoModel *)model;

@end

@interface BackWatchView : UIView<UITableViewDataSource,UITableViewDelegate>{
    UIView *topview;
    UISegmentedControl *timeSegments;//时间选择
    UITableView *backseeTableview;//回看列表
    NSMutableArray *tableviewmArray;//显示的数组
    NSMutableDictionary *backseeMdic;//回看列表数组
    NSMutableArray *yesterArray;//昨天
    NSMutableArray *bfyesterArray;//前天
    NSDate *today;//今天的日期
}

- (void)timeSegmentValueChanged:(id)sender;
-(void)viewAppear;
-(void)viewDisappear;

@property(nonatomic,retain) IptvChannelMode *superChannel;
@property(nonatomic,assign) id<BackWatchViewDelegate> backseeDelegate;

@end
