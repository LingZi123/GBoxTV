//
//  SeriesInfoView.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/27.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeriesInfoModel.h"
#import "SeriesVideoModel.h"

@protocol SeriesInfoViewDelegate <NSObject>

@optional
-(void)didSelectedSeries:(SeriesVideoModel *)seriesVideo;

@end

@interface SeriesInfoView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger oldPlayIndex;//当前播放的集数
    UISegmentedControl *segControl;//选择
    
    UITextView *detailsTextview;//详情
    
    UICollectionView *seriesCollectionview;//电视剧集
    NSMutableArray *seriesmArray;
    
    UITextView *actorTextview;//演员
    SeriesInfoModel *currentSeriesInfo;// 当前影片信息

}
@property (strong,nonatomic)NSString *supContentID;
@property(nonatomic,assign) id<SeriesInfoViewDelegate> seriesDelegate;

-(void)GetSeriesInfo;
@end
