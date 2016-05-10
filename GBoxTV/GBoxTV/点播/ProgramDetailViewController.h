//
//  ProgramDetailViewController.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/26.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerView.h"
#import "MovieInfoView.h"
#import "SeriesInfoView.h"
#import "ThreeCategateInfoView.h"

@interface ProgramDetailViewController : UIViewController<PlayerViewDelegate,MovieInfoViewDelegate,SeriesInfoViewDelegate>
{
    NSInteger oldPlayIndex;//当前播放的集数

    NSObject *objmodel;//model
    PlayerView *smallplayerview;//播放器
    UIButton *backPlayBtn;//回放按钮
    CGRect backPlayBtnOriginFrame;//原位置
    
    UIView *bottomView;
    MovieInfoView *moviebottomView;//底部视图
    SeriesInfoView *seriesBottomView;
//    ThreeCategateInfoView *threeCategateBottomView;
    NSObject *currentModel;
    
}

-(instancetype)initWithModel:(NSObject *)obj;

@property (strong,nonatomic)NSString *supContentID;

@end
