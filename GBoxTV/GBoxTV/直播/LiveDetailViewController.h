//
//  LiveDetailViewController.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/20.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerView.h"
#import "IptvChannelMode.h"
#import "BackWatchView.h"
#import "MainSupperViewController.h"

@interface LiveDetailViewController : MainSupperViewController<UITableViewDataSource,UITableViewDelegate,PlayerViewDelegate,BackWatchViewDelegate>
{
    
    PlayerView *smallplayerview;//播放器
//    __weak IBOutlet UIView *backseeview;//回看
//    __weak IBOutlet UISegmentedControl *backSegment;
//    __weak IBOutlet UITableView *backseeTableview;
    UIButton *liveBtn;
    CGRect liveBtnOriginFrame;
    BackWatchView *backseeview;
    IptvChannelMode *channel;
        
   
}
- (IBAction)backseeSegmentValueChanged:(id)sender;
-(instancetype)initWithChannelModel:(IptvChannelMode *)model;

//@property (strong,nonatomic) IptvChannelMode *currentChannel;

@end
