//
//  MovieInfoView.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/27.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgramModel.h"
#import "ProgramInfo.h"

@protocol MovieInfoViewDelegate <NSObject>

@optional
-(void)didSelectedRaletePrograme:(ProgramInfo *)programInfo;

@end

@interface MovieInfoView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UISegmentedControl *segControl;//选择
    
    UITextView *detailstextview;//详情
    
    UITextView *actortextview;//演员
    
    UICollectionView *raletedCollectionview;//相关
    NSMutableArray *raletedmArray;//相关
     ProgramInfo *currentModel;//当前的影片信息
}
@property (strong,nonatomic)NSString *supContentID;
@property(nonatomic,assign)id<MovieInfoViewDelegate> movieDelegate;

-(void)GetProgramInfo;

@end
