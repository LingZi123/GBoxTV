//
//  ProgramDetailViewController.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/26.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "ProgramDetailViewController.h"
#import "ProgramModel.h"
#import "IptvCategoryModel.h"
#import "RelatedProgramModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "CommonBaseData.h"

#define DE_program @"program"
#define DE_series @"series"

@interface ProgramDetailViewController ()

@end

@implementation ProgramDetailViewController

-(instancetype)initWithModel:(NSObject *)obj{
    self=[super init];
    if (self) {
        objmodel=obj;
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

-(void)makeView{
    //16:9
    
    CGFloat playerviewWith=CGRectGetWidth(self.view.bounds);
    CGFloat playerviewheight=playerviewWith*9/16;
    smallplayerview=[[PlayerView alloc]initWithFrame:CGRectMake(0, 20, playerviewWith, playerviewheight)];
    smallplayerview.isFullScress=NO;
    [self.view addSubview:smallplayerview];
    
    backPlayBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    backPlayBtnOriginFrame=backPlayBtn.frame;
    [backPlayBtn setImage:[UIImage imageNamed:@"点播按钮"] forState:UIControlStateNormal];
    backPlayBtn.center=CGPointMake(smallplayerview.center.x, smallplayerview.center.y-10);
    [backPlayBtn addTarget:self action:@selector(playBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [smallplayerview addSubview:backPlayBtn];
    
    bottomView=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(smallplayerview.frame), playerviewWith, CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(smallplayerview.frame))];
    [self.view addSubview:bottomView];
    
    if ([objmodel isKindOfClass:[ProgramModel class]]) {
        ProgramModel *model=(ProgramModel *)objmodel;
        smallplayerview.currentTitle=model.Name;
        if ([model.model isEqualToString:DE_program]) {
            moviebottomView=[[MovieInfoView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bottomView.frame), CGRectGetHeight(bottomView.frame))];
            moviebottomView.supContentID=model.ContentID;
            [bottomView addSubview:moviebottomView];
            [moviebottomView GetProgramInfo];
            
        }
        else{
            
            seriesBottomView=[[SeriesInfoView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bottomView.frame), CGRectGetHeight(bottomView.frame))];
            seriesBottomView.supContentID=model.ContentID;
            [bottomView addSubview:seriesBottomView];
            [seriesBottomView GetSeriesInfo];
        }
    }
    
//    else{
//        threeCategateBottomView=[[ThreeCategateInfoView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bottomView.frame), CGRectGetHeight(bottomView.frame))];
//        [bottomView addSubview:threeCategateBottomView];
//        IptvCategoryModel *model=(IptvCategoryModel *)objmodel;
//        smallplayerview.currentTitle=model.Name;
//        threeCategateBottomView.supperModel=model;
//        [threeCategateBottomView SearchPrograms];
//    }
}

-(void)viewWillAppear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:YES];
    smallplayerview.delegate=self;
    if (moviebottomView) {
        moviebottomView.movieDelegate=self;
    }
    if(seriesBottomView){
        seriesBottomView.seriesDelegate=self;
    }
//    if(threeCategateBottomView){
//        threeCategateBottomView.threeDelegate=self;
//    }

}
-(void)viewWillDisappear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:NO];
    smallplayerview.delegate=nil;
    if (moviebottomView) {
        moviebottomView.movieDelegate=nil;
    }
    if(seriesBottomView){
        seriesBottomView.seriesDelegate=nil;
    }
//    if(threeCategateBottomView){
//        threeCategateBottomView.threeDelegate=nil;
//    }

}

-(void)playBackBtnClick:(UIButton *)sendere{
    backPlayBtn.hidden=YES;
    if ([currentModel isKindOfClass:[ProgramInfo class]]) {
        smallplayerview.isMulSeries=NO;
        ProgramInfo *tempmodel=(ProgramInfo *)currentModel;
        [smallplayerview playVideoWithURL:[NSURL URLWithString:tempmodel.PlayUrl] title:tempmodel.Name];
    }
    if ([currentModel isKindOfClass:[SeriesVideoModel class]]) {
        smallplayerview.isMulSeries=YES;
        SeriesVideoModel *tempmodel=(SeriesVideoModel *)currentModel;
        [smallplayerview playVideoWithURL:[NSURL URLWithString:tempmodel.PlayUrl] title:tempmodel.Name];
    }
    if ([currentModel isKindOfClass:[NSString class]]) {
        smallplayerview.isMulSeries=NO;
        NSString *tempmodel=(NSString *)currentModel;
        [smallplayerview playVideoWithURL:[NSURL URLWithString:tempmodel] title:@""];
    }

}

#pragma mark-PlayerViewDelegate
-(void)backViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewFrameChange:(BOOL)isSmall{
    if (isSmall) {
        bottomView.hidden=NO;
        //更换位置
        backPlayBtn.frame=backPlayBtnOriginFrame;
        backPlayBtn.center=CGPointMake(smallplayerview.center.x, smallplayerview.center.y-10);
    }
    else{
        bottomView.hidden=YES;
        backPlayBtn.frame=CGRectMake(smallplayerview.frame.size.width/2-25, smallplayerview.frame.size.height/2-25, 50, 50);
    }
}

-(void)playComplate{
    backPlayBtn.hidden=NO;
}
//-(void)backSeeTableviewSelectedModel:(IptvScheduleInfoModel *)model{
//    [smallplayerview quicklyStopMovie];
//    [smallplayerview playVideoWithURL:[NSURL URLWithString:model.PlayUrl] title:channel.Name];
//}


#pragma  mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

#pragma mark-MovieInfoViewDelegate
-(void)didSelectedRaletePrograme:(ProgramInfo *)programInfo{
    //比较
    if ([currentModel isKindOfClass:[ProgramInfo class]]) {
        ProgramInfo *temodel=(ProgramInfo *)currentModel;
        if ([temodel.ContentID isEqualToString:programInfo.ContentID]) {
            return;
        }
    }
    currentModel=programInfo;
    smallplayerview.currentTitle=programInfo.Name;
    if (smallplayerview.playStatus!=2) {
        smallplayerview.isMulSeries=NO;
        [smallplayerview quicklyStopMovie];
        [smallplayerview playVideoWithURL:[NSURL URLWithString:programInfo.PlayUrl] title:programInfo.Name];
    }
}

#pragma mark-SeriesInfoViewDelegate
-(void)didSelectedSeries:(SeriesVideoModel *)seriesVideo{
    
    if ([currentModel isKindOfClass:[SeriesVideoModel class]]) {
        SeriesVideoModel *temodel=(SeriesVideoModel *)currentModel;
        if ([temodel.Name isEqualToString:seriesVideo.Name]) {
            return;
        }
    }
    currentModel=seriesVideo;
    smallplayerview.currentTitle=seriesVideo.Name;
    if (smallplayerview.playStatus!=2) {
        smallplayerview.isMulSeries=NO;
        [smallplayerview quicklyStopMovie];
        [smallplayerview playVideoWithURL:[NSURL URLWithString:seriesVideo.PlayUrl] title:seriesVideo.Name];
    }

}

//#pragma mark-ThreeCategateInfoViewDelegate
//-(void)didSelectedProgram:(NSString *)playurl titlename:(NSString *)titlename{
//    if ([currentModel isKindOfClass:[NSString class]]) {
//        NSString *temodel=(NSString *)currentModel;
//        if ([temodel isEqualToString:playurl]) {
//            return;
//        }
//    }
//    currentModel=playurl;
//    smallplayerview.currentTitle=titlename;
//    if (smallplayerview.playStatus!=2) {
//        smallplayerview.isMulSeries=NO;
//        [smallplayerview quicklyStopMovie];
//        [smallplayerview playVideoWithURL:[NSURL URLWithString:playurl] title:titlename];
//    }
//}
@end
