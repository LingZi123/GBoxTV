//
//  PlayerView.h
//  Vitamio-Demo
//
//  Created by PC_201310113421 on 16/4/14.
//  Copyright © 2016年 yixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSegmentSlider.h"
#import "Vitamio.h"


@protocol PlayerViewDelegate <NSObject>

-(void)backViewController;
-(void)viewFrameChange:(BOOL)isSmall;
-(void)playComplate;


@end

//播放状态
typedef NS_ENUM(NSInteger,en_PlayStatus) {
    PlayStatus_isPlaying,
    PlayStatus_isPause,
    PlayStatus_isClose
};

@interface PlayerView : UIView<VMediaPlayerDelegate>
{
    UIView *topview;//顶部视图
    UIView *titleandbackView;//顶部子视图
    UIView *mideView;//中间视图
    UIButton *midPlayBtn;//中间播放按钮
    UIActivityIndicatorView *activityView;//进度
    UILabel  *bubbleMsgLbl;
    
    UIView *bottomview;//底部视图
    VSegmentSlider *slider;//底部子视图
    UIButton *fullScreenBtn;//底部子视图
    UIButton *seriesBtn;//底部子视图
    NSURL *curentUrl;//当前播放的url
    VMediaPlayer       *mMPayer;
    long               mDuration;
    long               mCurPostion;
    NSTimer            *mSyncSeekTimer;
    UIButton *playandpauseBtn;
    UILabel *currentPlayTimeLabel;
    UILabel *totolTimeLabel;
    CGRect smallFrameRect;
    UIButton *backBtn;
    UILabel *programeTitle;
    
}
@property(nonatomic,assign)BOOL isFullScress;//是否全屏
@property(nonatomic,copy)  NSString *currentTitle;//当前播放的title
@property (nonatomic, assign) BOOL progressDragging;
@property(nonatomic,assign)CGRect controlframe;
@property(nonatomic,assign) id<PlayerViewDelegate> delegate;
@property(nonatomic,assign) BOOL isLive;//直播还是点播
@property(nonatomic,assign) BOOL isMulSeries;//是一集还是多集
@property(nonatomic,assign)en_PlayStatus playStatus;//播放状态
@property(nonatomic,retain)NSMutableArray *seriesmArray;//电视剧
@property(nonatomic,assign)NSInteger currentIndex;//当前播放的集数

-(void)playVideoWithURL:(NSURL *)url title:(NSString *)title;
-(void)closeFrame;
-(void)quicklyStopMovie;
@end
