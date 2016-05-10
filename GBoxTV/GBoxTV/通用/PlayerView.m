//
//  PlayerView.m
//  Vitamio-Demo
//
//  Created by PC_201310113421 on 16/4/14.
//  Copyright © 2016年 yixia. All rights reserved.
//

#import "PlayerView.h"
#import "VSegmentSlider.h"
#import "Utilities.h"
#import "SVProgressHUD.h"

@implementation PlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor blackColor];
        [self createTopView];
        [self addSubview:topview];
        [self createMideView];
        [self addSubview:mideView];
        [self createBottomView];
        [self addSubview:bottomview];
        
        [self addObserver:self forKeyPath:@"isFullScress" options:NSKeyValueObservingOptionNew context:nil];
        if (!mMPayer) {
            mMPayer = [VMediaPlayer sharedInstance];
            [mMPayer setupPlayerWithCarrierView:self withDelegate:self];
            [self setupObservers];
        }
        smallFrameRect=frame;
        _playStatus=PlayStatus_isClose;
    }
    return self;
}

-(void)createTopView{
    topview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    topview.backgroundColor=[UIColor clearColor];
    
    titleandbackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, topview.frame.size.width-100, topview.frame.size.height)];
    titleandbackView.backgroundColor=[UIColor clearColor];
    [topview addSubview:titleandbackView];
    
    backBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 9, 52, 22)];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    backBtn.tag=100;
    backBtn.titleLabel.tintColor=[UIColor whiteColor];
    backBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [titleandbackView addSubview:backBtn];
    
    programeTitle=[[UILabel alloc]initWithFrame:CGRectMake(backBtn.frame.origin.x+backBtn.frame.size.width+10, 5, titleandbackView.frame.size.width-CGRectGetMaxX(backBtn.frame), 30)];
    programeTitle.textAlignment=NSTextAlignmentLeft;
    programeTitle.font=DE_FONT_BOLD_16;
    programeTitle.textColor=[UIColor whiteColor];
    [titleandbackView addSubview:programeTitle];
    [self addObserver:self forKeyPath:@"currentTitle" options:NSKeyValueObservingOptionNew context:nil];
    
    UIButton *tvchangeBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 28)];
    tvchangeBtn.center=CGPointMake(topview.frame.size.width-35, topview.center.y);
    [tvchangeBtn setImage:[UIImage imageNamed:@"TV投放"] forState:UIControlStateNormal];
    [tvchangeBtn addTarget:self action:@selector(sendToTV:) forControlEvents:UIControlEventTouchUpInside];
    tvchangeBtn.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    [topview addSubview:tvchangeBtn];
    
}

-(void)createMideView{
//    midPlayBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//    midPlayBtn addTarget:<#(nullable id)#> action:<#(nonnull SEL)#> forControlEvents:<#(UIControlEvents)#>
//    midPlayBtn.center=self.center;
    
    mideView=[[UIView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-120)/2,CGRectGetHeight(self.frame)/2-25, 120, 50)];
    mideView.backgroundColor=[UIColor clearColor];
//    mideView.center=self.center;
    mideView.hidden=YES;
    [self addSubview:mideView];
    
    activityView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(mideView.frame.size.width/2-10, 5, 20, 20)];
//    activityView.center=CGPointMake(mideView.center.x, 15);
    [mideView addSubview:activityView];
    
    bubbleMsgLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 35, mideView.frame.size.width, 21)];
    bubbleMsgLbl.font=DE_FONT_14;
    bubbleMsgLbl.textColor=[UIColor whiteColor];
    bubbleMsgLbl.textAlignment=NSTextAlignmentCenter;
    [mideView addSubview:bubbleMsgLbl];
    
}
-(void)createBottomView{
    bottomview=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-40, CGRectGetWidth(self.frame), 40)];
    bottomview.backgroundColor=[UIColor clearColor];
    [bottomview setAutoresizesSubviews:YES];
    bottomview.alpha=0.5f;
    
    playandpauseBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    [playandpauseBtn addTarget:self action:@selector(playPauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [playandpauseBtn setImage:[UIImage imageNamed:@"播放小按钮"] forState:UIControlStateNormal] ;
    playandpauseBtn.tintColor=[UIColor whiteColor];
    playandpauseBtn.titleLabel.font=[UIFont systemFontOfSize:8];
    [bottomview addSubview:playandpauseBtn];
    
    UIView *rollView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(playandpauseBtn.frame)+10, 0,bottomview.frame.size.width-CGRectGetWidth(playandpauseBtn.frame)-80, bottomview.frame.size.height)];
    rollView.backgroundColor=[UIColor clearColor];
    [rollView setAutoresizesSubviews:YES];
    [bottomview addSubview:rollView];
    rollView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
    
    currentPlayTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,9 , 60, 22)];
    currentPlayTimeLabel.text=@"00:00:00";
    currentPlayTimeLabel.textColor=[UIColor whiteColor];
    currentPlayTimeLabel.font=[UIFont systemFontOfSize:12];
    [rollView addSubview:currentPlayTimeLabel];
    
    slider=[[VSegmentSlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(currentPlayTimeLabel.frame), 9, rollView.frame.size.width-120, 21)];
    [slider addTarget:self action:@selector(progressSliderDownAction:) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(progressSliderUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(dragProgressSliderAction:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(progressSliderUpAction:) forControlEvents:UIControlEventTouchCancel];
    slider.autoresizingMask=UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    [rollView addSubview:slider];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(progressSliderTapped:)];
    [slider addGestureRecognizer:gr];
    [slider setThumbImage:[UIImage imageNamed:@"pb-seek-bar-btn"] forState:UIControlStateNormal];
    [slider setMinimumTrackImage:[UIImage imageNamed:@"pb-seek-bar-fr"] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[UIImage imageNamed:@"pb-seek-bar-bg"] forState:UIControlStateNormal];
    
    
    totolTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(rollView.frame)-60,9, 60, 21)];
    totolTimeLabel.text=@"00:00:00";
    totolTimeLabel.font=[UIFont systemFontOfSize:12];
    totolTimeLabel.textColor=[UIColor whiteColor];
    totolTimeLabel.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    [rollView addSubview:totolTimeLabel];
    
    fullScreenBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rollView.frame)+10, 5, 30, 30)];
    fullScreenBtn.tag=101;
    [fullScreenBtn setImage:[UIImage imageNamed:@"大屏切换"] forState:UIControlStateNormal];
    fullScreenBtn.titleLabel.font=[UIFont systemFontOfSize:8];
    fullScreenBtn.tintColor=[UIColor whiteColor];
    [fullScreenBtn addTarget:self action:@selector(fullAndSmallView:) forControlEvents:UIControlEventTouchUpInside];
//    fullScreenBtn.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    [bottomview addSubview:fullScreenBtn];
    
    seriesBtn=[[UIButton alloc]initWithFrame:fullScreenBtn.frame];
    [seriesBtn setTitle:@"剧集" forState:UIControlStateNormal];
    seriesBtn.titleLabel.font=[UIFont systemFontOfSize:10];
    seriesBtn.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
     [self addObserver:self forKeyPath:@"isMulSeries" options:NSKeyValueObservingOptionNew context:nil];
    [bottomview addSubview:seriesBtn];
}
-(void)back:(UIButton *)sender{
    if (self.isFullScress) {
        
        [self fullAndSmallView:nil];
    }
    else{
        // 结束播放
        [self closeFrame];
        [self.delegate backViewController];
    }
}
-(void)fullAndSmallView:(UIButton *)sender{
    if (self.isFullScress) {
        //变小
        [UIView animateWithDuration:0.3f animations:^{
            [self setTransform:CGAffineTransformIdentity];
            self.controlframe=smallFrameRect;
             [self.delegate viewFrameChange:YES];
        } completion:^(BOOL finished) {
            self.isFullScress=NO;
        }];
        
    }
    else{
        //放大
        if (self.isFullScress) {
            [self setTransform:CGAffineTransformMakeRotation(M_PI)];
        }
        
        CGFloat height=[[UIScreen mainScreen]bounds].size.width;
        CGFloat width=[[UIScreen mainScreen]bounds].size.height;
        CGRect myframe=CGRectMake(-124,124, width, height);
        
        
        [UIView animateWithDuration:0.3f animations:^{
            self.controlframe=myframe;
             [self.delegate viewFrameChange:NO];
            [self setTransform:CGAffineTransformMakeRotation(M_PI_2)];
            
        } completion:^(BOOL finished) {
            
            self.isFullScress=YES;
        }];
        
    }

    
}

-(void)sendToTV:(UIButton *)sender{
    [SVProgressHUD showErrorWithStatus:@"正在投放..." duration:5];
}
-(void)playPauseBtnClick:(UIButton *)sender{
    BOOL isPlaying = [mMPayer isPlaying];
    if (isPlaying) {
        [mMPayer pause];
        
        [playandpauseBtn setImage:[UIImage imageNamed:@"播放小按钮"] forState:UIControlStateNormal] ;
        _playStatus=PlayStatus_isPause;
    } else {
        [mMPayer start];
         [playandpauseBtn setImage:[UIImage imageNamed:@"暂停按钮"] forState:UIControlStateNormal] ;
         _playStatus=PlayStatus_isPlaying;
    }
}

-(IBAction)progressSliderDownAction:(id)sender
{
    self.progressDragging = YES;
    NSLog(@"NAL 4HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
    NSLog(@"NAL 1DOW &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& Touch Down");
}

-(IBAction)progressSliderUpAction:(id)sender
{
    UISlider *sld = (UISlider *)sender;
    NSLog(@"NAL 1BVC &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& seek = %ld", (long)(sld.value * mDuration));
    [self startActivityWithMsg:@"Buffering"];
    //    [self quicklyStopMovie];
    [mMPayer seekTo:(long)(sld.value * mDuration)];
    //    [mMPayer seekTo:(long)100000];
    NSString *news=[NSString stringWithFormat:@"%@&BreakPoint=%ld",[curentUrl absoluteString] ,(long)(sld.value * mDuration)];
    NSURL *newurl=[NSURL URLWithString:news];
    [self quicklyReplayMovie:newurl title:_currentTitle seekToPos:0];
}

-(void)quicklyReplayMovie:(NSURL*)fileURL title:(NSString*)title seekToPos:(long)pos
{
    [self quicklyStopMovie];
    [self quicklyPlayMovie:fileURL title:title seekToPos:pos];
}

-(IBAction)dragProgressSliderAction:(id)sender
{
    UISlider *sld = (UISlider *)sender;
    currentPlayTimeLabel.text = [Utilities timeToHumanString:(long)(sld.value * mDuration)];
}

-(void)progressSliderTapped:(UIGestureRecognizer *)g
{
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted)
        return;
    CGPoint pt = [g locationInView:s];
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES];
    long seek = percentage * mDuration;
    currentPlayTimeLabel.text = [Utilities timeToHumanString:seek];
    NSLog(@"NAL 2BVC &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& seek = %ld", seek);
    [self startActivityWithMsg:@"Buffering"];
    [mMPayer seekTo:seek];
}


#pragma mark-观察
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"isFullScress"]) {
        
        //todo
        //缩小视频按钮不显示
        fullScreenBtn.hidden=self.isFullScress;
        if (!self.isFullScress) {
            seriesBtn.hidden=YES;
        }
    }
    if ([keyPath isEqualToString:@"isMulSeries"]) {
        if (self.isFullScress) {
            seriesBtn.hidden=!self.isMulSeries;
        }
    }
    if ([keyPath isEqualToString:@"currentTitle"]) {
        programeTitle.text=self.currentTitle;
    }

}
-(void)playVideoWithURL:(NSURL *)url title:(NSString *)title{
    curentUrl=url;
    self.currentTitle=title;
    _playStatus=PlayStatus_isPlaying;
    [self quicklyPlayMovie:curentUrl title:title seekToPos:0];
}
-(void)quicklyPlayMovie:(NSURL*)fileURL title:(NSString*)title seekToPos:(long)pos
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self setBtnEnableStatus:NO];
    
    [mMPayer setDataSource:curentUrl];
    
    [mMPayer prepareAsync];
    [self startActivityWithMsg:@"Loading..."];
}

- (void)setupObservers
{
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    [def addObserver:self
            selector:@selector(applicationDidEnterForeground:)
                name:UIApplicationDidBecomeActiveNotification
              object:[UIApplication sharedApplication]];
    [def addObserver:self
            selector:@selector(applicationDidEnterBackground:)
                name:UIApplicationWillResignActiveNotification
              object:[UIApplication sharedApplication]];
}

- (void)unSetupObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   
}

- (void)applicationDidEnterForeground:(NSNotification *)notification
{
    [mMPayer setVideoShown:YES];
    if (![mMPayer isPlaying]) {
        [mMPayer start];
        _playStatus=PlayStatus_isPlaying;
         [playandpauseBtn setImage:[UIImage imageNamed:@"暂停按钮"] forState:UIControlStateNormal] ;
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    if ([mMPayer isPlaying]) {
        [mMPayer pause];
        _playStatus=PlayStatus_isPause;
        [mMPayer setVideoShown:NO];
    }
}

-(void)quicklyStopMovie
{
    [mMPayer reset];
    [mSyncSeekTimer invalidate];
    mSyncSeekTimer = nil;
//    self.progressSld.value = 0.0;
//    self.progressSld.segments = nil;
//    self.curPosLbl.text = @"00:00:00";
//    self.durationLbl.text = @"00:00:00";
//    self.downloadRate.text = nil;
    mDuration = 0;
    mCurPostion = 0;
    [self stopActivity];
    [self setBtnEnableStatus:YES];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

#pragma mark - Sync UI Status

-(void)syncUIStatus
{
    if (!self.progressDragging) {
        mCurPostion  = [mMPayer getCurrentPosition];
        [slider setValue:(float)mCurPostion/mDuration];
        currentPlayTimeLabel.text = [Utilities timeToHumanString:mCurPostion];
        totolTimeLabel.text = [Utilities timeToHumanString:mDuration];
    }
}

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    [player setVideoFillMode:VMVideoFillModeStretch];
    
    mDuration = [player getDuration];
    [player start];
    
    [self setBtnEnableStatus:YES];
    [self stopActivity];
    mSyncSeekTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/3
                                                      target:self
                                                    selector:@selector(syncUIStatus)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
//    [self goBackButtonAction:nil];
    [self quicklyStopMovie];

    //如果电视剧就自动跳到下一集
    if (_seriesmArray) {
        if (_currentIndex+1<_seriesmArray.count) {
            //播放下一个
//            self playVideoWithURL:<#(NSURL *)#> title:<#(NSString *)#>
            return;
        }
    }
    
    if (_isFullScress) {
        [self fullAndSmallView:backBtn];
    }
    [self.delegate playComplate];
    
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
    NSLog(@"NAL 1RRE &&&& VMediaPlayer Error: %@", arg);
    [self stopActivity];
//    //	[self showVideoLoadingError];
    [self setBtnEnableStatus:YES];
}

#pragma mark VMediaPlayerDelegate Implement / Optional

- (void)mediaPlayer:(VMediaPlayer *)player setupManagerPreference:(id)arg
{
    player.decodingSchemeHint = VMDecodingSchemeSoftware;
    player.autoSwitchDecodingScheme = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player setupPlayerPreference:(id)arg
{
    // Set buffer size, default is 1024KB(1*1024*1024).
    //	[player setBufferSize:256*1024];
    [player setBufferSize:512*1024];
    //	[player setAdaptiveStream:YES];
    
    [player setVideoQuality:VMVideoQualityHigh];
    
    player.useCache = YES;
    [player setCacheDirectory:[self getCacheRootDirectory]];
}

- (void)mediaPlayer:(VMediaPlayer *)player seekComplete:(id)arg
{
}

- (void)mediaPlayer:(VMediaPlayer *)player notSeekable:(id)arg
{
    self.progressDragging = NO;
    NSLog(@"NAL 1HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingStart:(id)arg
{
    self.progressDragging = YES;
    NSLog(@"NAL 2HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
    if (![Utilities isLocalMedia:curentUrl]) {
        [player pause];
         [playandpauseBtn setImage:[UIImage imageNamed:@"播放小按钮"] forState:UIControlStateNormal] ;
        [self startActivityWithMsg:@"Buffering... 0%"];
    }
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingUpdate:(id)arg
{
    if (!mideView.hidden) {
        bubbleMsgLbl.text = [NSString stringWithFormat:@"Buffering... %d%%",
                                  [((NSNumber *)arg) intValue]];
    }
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingEnd:(id)arg
{
    if (![Utilities isLocalMedia:curentUrl]) {
        [player start];
         [playandpauseBtn setImage:[UIImage imageNamed:@"暂停按钮"] forState:UIControlStateNormal] ;
        [self stopActivity];
    }
    self.progressDragging = NO;
    NSLog(@"NAL 3HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
}

- (void)mediaPlayer:(VMediaPlayer *)player downloadRate:(id)arg
{
//    if (![Utilities isLocalMedia:curentUrl]) {
//        self.downloadRate.text = [NSString stringWithFormat:@"%dKB/s", [arg intValue]];
//    } else {
//        self.downloadRate.text = nil;
//    }
}

- (void)mediaPlayer:(VMediaPlayer *)player videoTrackLagging:(id)arg
{
    //	NSLog(@"NAL 1BGR video lagging....");
}

#pragma mark VMediaPlayerDelegate Implement / Cache

- (void)mediaPlayer:(VMediaPlayer *)player cacheNotAvailable:(id)arg
{
    NSLog(@"NAL .... media can't cache.");
    slider.segments = nil;
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheStart:(id)arg
{
    NSLog(@"NAL 1GFC .... media caches index : %@", arg);
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheUpdate:(id)arg
{
    NSArray *segs = (NSArray *)arg;
    //	NSLog(@"NAL .... media cacheUpdate, %d, %@", segs.count, segs);
    if (mDuration > 0) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < segs.count; i++) {
            float val = (float)[segs[i] longLongValue] / mDuration;
            [arr addObject:[NSNumber numberWithFloat:val]];
        }
        slider.segments = arr;
    }
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheSpeed:(id)arg
{
    //	NSLog(@"NAL .... media cacheSpeed: %dKB/s", [(NSNumber *)arg intValue]);
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheComplete:(id)arg
{
    NSLog(@"NAL .... media cacheComplete");
    slider.segments = @[@(0.0), @(1.0)];
}

- (NSString *)getCacheRootDirectory
{
    NSString *cache = [NSString stringWithFormat:@"%@/Library/Caches/MediasCaches", NSHomeDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cache]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cache
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    return cache;
}

-(void)setControlframe:(CGRect)frame {
    [self setFrame:frame];
    [bottomview setFrame:CGRectMake(0, self.frame.size.height-40, frame.size.width, 40)];
    [bottomview setNeedsLayout];
    [bottomview layoutIfNeeded];
    
    mideView.center=CGPointMake(frame.size.width/2, frame.size.height/2);
    
    [topview setFrame:CGRectMake(0, 0, frame.size.width, 40)];
    [topview setNeedsLayout];
    [topview layoutIfNeeded];
}
-(void)closeFrame{
    if (_playStatus!=PlayStatus_isClose) {
        [self quicklyStopMovie];
    }
    //移除观察
    [self removeObserver:self forKeyPath:@"isFullScress"];
    [self removeObserver:self forKeyPath:@"isMulSeries"];
    [self removeObserver:self forKeyPath:@"currentTitle"];
    [self unSetupObservers];
    [mMPayer unSetupPlayer];
}

#pragma mark Others

-(void)startActivityWithMsg:(NSString *)msg
{
    mideView.hidden = NO;
    bubbleMsgLbl.text = msg;
    [activityView startAnimating];
}

-(void)stopActivity
{
    mideView.hidden = YES;
    bubbleMsgLbl.text = nil;
    [activityView stopAnimating];
}

-(void)setBtnEnableStatus:(BOOL)enable
{
    playandpauseBtn.enabled = enable;
//    self.prevBtn.enabled = enable;
//    self.nextBtn.enabled = enable;
//    self.modeBtn.enabled = enable;
}

@end
