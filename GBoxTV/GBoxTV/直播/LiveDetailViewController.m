//
//  LiveDetailViewController.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/20.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "LiveDetailViewController.h"
#import "SVProgressHUD.h"
#import "CommonBaseData.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "IptvScheduleInfoModel.h"

@interface LiveDetailViewController ()

@end

@implementation LiveDetailViewController

-(instancetype)initWithChannelModel:(IptvChannelMode *)model{
    self=[super init];
    if (self) {
        channel=model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeView];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    //获取今天的时间，如果今天的时间相同那么昨天和前天的时间就相同，就没必要清除。
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [backseeview viewAppear];
    smallplayerview.delegate=self;
    backseeview.backseeDelegate=self;
//    backseeview.currentChannel=channel;
//    self.preferredStatusBarStyle=UIStatusBarStyleDefault;
    
    }
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [backseeview viewDisappear];
    smallplayerview.delegate=nil;
    backseeview.backseeDelegate=nil;
}
-(void)makeView{
    
    self.navigationItem.title=channel.Name;
//    self.navigationItem.st
    //播放器16:9的比例
    CGFloat playerviewWith=CGRectGetWidth(self.view.bounds);
    CGFloat playerviewheight=playerviewWith*9/16;
    smallplayerview=[[PlayerView alloc]initWithFrame:CGRectMake(0, 20, playerviewWith, playerviewheight)];
    smallplayerview.isFullScress=NO;
    [self.view addSubview:smallplayerview];
    
    liveBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    liveBtnOriginFrame=liveBtn.frame;
    [liveBtn setImage:[UIImage imageNamed:@"直播按钮"] forState:UIControlStateNormal];
    liveBtn.center=CGPointMake(smallplayerview.center.x, smallplayerview.center.y-10);
    [liveBtn addTarget:self action:@selector(playLive:) forControlEvents:UIControlEventTouchUpInside];
    [smallplayerview addSubview:liveBtn];
    
    backseeview=[[BackWatchView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(smallplayerview.frame), playerviewWith, CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(smallplayerview.frame))];
    backseeview.superChannel=channel;
    [self.view addSubview:backseeview];
}

//- (IBAction)backseeSegmentValueChanged:(id)sender {
//    [self reloadTableViewDataSourceForLive];
//}

- (void)playLive:(id)sender {
    liveBtn.hidden=YES;
    [smallplayerview playVideoWithURL:[NSURL URLWithString:channel.PlayUrl] title:channel.Name];
}


#pragma mark-PlayerViewDelegate
-(void)backViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewFrameChange:(BOOL)isSmall{
    if (isSmall) {
        backseeview.hidden=NO;
        //更换位置
        liveBtn.frame=liveBtnOriginFrame;
        liveBtn.center=CGPointMake(smallplayerview.center.x, smallplayerview.center.y-10);

    }
    else{
        backseeview.hidden=YES;
        liveBtn.frame=CGRectMake(smallplayerview.frame.size.width/2-25, smallplayerview.frame.size.height/2-25, 50, 50);
    }
}

-(void)backSeeTableviewSelectedModel:(IptvScheduleInfoModel *)model{
    [smallplayerview quicklyStopMovie];
    [smallplayerview playVideoWithURL:[NSURL URLWithString:model.PlayUrl] title:channel.Name];
}

-(void)playComplate{
    liveBtn.hidden=NO;
}
@end
