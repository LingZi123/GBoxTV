//
//  SeriesInfoView.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/27.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "SeriesInfoView.h"
#import "SVProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "CommonBaseData.h"
#import "AppDelegate.h"
#import "SeriesVideoModel.h"

@implementation SeriesInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

-(void)makeView{
    self.backgroundColor=[UIColor whiteColor];
    segControl=[[UISegmentedControl alloc]initWithItems:@[@"详情",@"演员",@"剧集"]];
    segControl.frame=CGRectMake(20, 20, self.frame.size.width-40, 30);
    [segControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    segControl.backgroundColor=[UIColor whiteColor];
    segControl.tintColor=[UIColor orangeColor];
    segControl.selectedSegmentIndex=0;
    [self addSubview:segControl];
    
    if (seriesCollectionview == nil) {
        UICollectionViewFlowLayout *seriesgrid = [[UICollectionViewFlowLayout alloc] init];
        seriesgrid.itemSize = CGSizeMake(45, 45);
        seriesgrid.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 20.0, 10.0);
        
        seriesCollectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 60) collectionViewLayout:seriesgrid];
        seriesCollectionview.hidden = YES;
        seriesCollectionview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        seriesCollectionview.delegate = self;
        seriesCollectionview.dataSource = self;
        seriesCollectionview.backgroundColor = [UIColor whiteColor];
        [self addSubview:seriesCollectionview];
        [seriesCollectionview registerNib:[UINib nibWithNibName:@"mEpisodeCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"mEpisodeCollectionViewCell"];
        [seriesCollectionview reloadData];
    }
    [self addSubview:seriesCollectionview];
    
    detailsTextview=[[UITextView alloc]initWithFrame:CGRectMake(10, 60, CGRectGetWidth(self.frame)-20, CGRectGetHeight(self.frame)-60)];
    detailsTextview.font=DE_FONT_14;
    [self addSubview:detailsTextview];
    
    
    actorTextview=[[UITextView alloc]initWithFrame:CGRectMake(10, 60, CGRectGetWidth(self.frame)-20, CGRectGetHeight(self.frame)-60)];
    actorTextview.font=DE_FONT_14;
    [self addSubview:actorTextview];
    [self segmentValueChanged:segControl];
    oldPlayIndex=1;

}

#pragma mark-UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView==seriesCollectionview&&seriesmArray){
        return seriesmArray.count;
    }
    return 0;
    
}

- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    UICollectionViewTransitionLayout *myCustomTransitionLayout =
    [[UICollectionViewTransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
    return myCustomTransitionLayout;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark-UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    
    NSString *EpisodeIdentifier = @"mEpisodeCollectionViewCell";
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:EpisodeIdentifier forIndexPath:indexPath];
    //        SeriesVideoModel *dict = [_mEpisodeCollectionViewDataSource objectAtIndex:indexPath.row];
    UIButton *Btn = (UIButton *)[cell.contentView viewWithTag:301];
    
    NSString *btntitle=[NSString stringWithFormat:@"%ld",indexPath.row+1];
    [Btn setTitle:btntitle forState:UIControlStateNormal];
    Btn.backgroundColor = [DEFAULTTEXTBlackColor colorWithAlphaComponent:0.2];
    [Btn addTarget:self action:@selector(playBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [Btn.layer setCornerRadius:5];
    if (oldPlayIndex==(indexPath.row+1)) {
        [Btn setTintColor:[UIColor orangeColor]];
        [self playBackBtnClick:Btn];
    }
    else{
        [Btn setTintColor:[UIColor blackColor]];
    }

    return cell;
    
}

#pragma mark-事件
-(void)playBackBtnClick:(UIButton *)sender{
    
    NSInteger index=[sender.titleLabel.text integerValue]-1;
    if (oldPlayIndex!=index+1) {
        oldPlayIndex=index+1;
    }
    
    SeriesVideoModel *selectModel = [seriesmArray objectAtIndex:index];
    selectModel.Name=[NSString stringWithFormat:@"%@ 第%ld 集",currentSeriesInfo.Name,oldPlayIndex];
    [self.seriesDelegate didSelectedSeries:selectModel];
}

-(void)segmentValueChanged:(UISegmentedControl *)sender{
    
    if (sender.selectedSegmentIndex==0){
        detailsTextview.hidden=NO;
        actorTextview.hidden=YES;
        seriesCollectionview.hidden=YES;
    }
    else  if (sender.selectedSegmentIndex==1){
        detailsTextview.hidden=YES;
        actorTextview.hidden=NO;
        seriesCollectionview.hidden=YES;
    }
    else{
        seriesCollectionview.hidden=NO;
        actorTextview.hidden=YES;
        detailsTextview.hidden=YES;
        if (seriesmArray==nil||seriesmArray.count<=0) {
            [self GetSeriesVideos];
        }
    }
    
}

#pragma mark-网络通讯
//获取电视剧详情
-(void)GetSeriesInfo{
    
//    NSInteger states=[self appdelegate].networkStatus;
//    if (states==UnknowNetwork||states==WithoutNetwork||states==CDMA1xNetwork||
//        states==CDMAEVDORev0||states==CDMAEVDORevA||states==CDMAEVDORevB) {
//        [SVProgressHUD showErrorWithStatus:@"该网络无法访问"];
//        return;
//    }
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeNone];
    CommonBaseData *bodyData=[[CommonBaseData alloc]init];
    bodyData.action=DE_Action_GetSeriesInfo;
    [bodyData.device setObject:@"123" forKey:@"dnum"];
    [bodyData.user setObject:[self appdelegate].userInfo.username forKey:@"userid"];
    [bodyData.param setObject:_supContentID forKey:@"contentID"];
    
    NSLog(@"GetSeriesInfo %@",bodyData);
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:DE_mainUrl parameters:[bodyData getDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"GetSeriesInfo end%@",responseObject);
        
        if (responseObject) {
            id error=[responseObject objectForKey:@"error"];
            if (error) {
                int errorCode=[[error objectForKey:@"code"] intValue];
                if (errorCode==0) {
                    NSDictionary *dic=[responseObject objectForKey:@"data"];
                    if (dic) {
                        currentSeriesInfo=[SeriesInfoModel getModelWithDictionary:dic];
                        if (seriesmArray==nil||seriesmArray.count<=0) {
                            [self GetSeriesVideos];
                        }
//                        [self IsFavorite];
                    }
                    
                }
                else{
                    [SVProgressHUD showErrorWithStatus:[error objectForKey:@"info"]];
                }
            }
        }
        [SVProgressHUD dismiss];
        [self updateDetail];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.description];
    }];
}

-(void)GetSeriesVideos{
    
    if ([_supContentID isEqualToString:@""] ||_supContentID==nil||_supContentID==(id)[NSNull null]) {
        return;
    }
//    NSInteger states=[self appdelegate].networkStatus;
//    if (states==UnknowNetwork||states==WithoutNetwork||states==CDMA1xNetwork||
//        states==CDMAEVDORev0||states==CDMAEVDORevA||states==CDMAEVDORevB) {
//        [SVProgressHUD showErrorWithStatus:@"该网络无法访问"];
//        return;
//    }
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeNone];
    
    CommonBaseData *bodyData=[[CommonBaseData alloc]init];
    bodyData.action=DE_Action_GetSeriesVideos;
    [bodyData.device setObject:@"123" forKey:@"dnum"];
    [bodyData.user setObject:[self appdelegate].userInfo.username forKey:@"userid"];
    [bodyData.param setObject:_supContentID forKey:@"contentID"];
    [bodyData.param setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    [bodyData.param setObject:[NSNumber numberWithInt:999] forKey:@"pageSize"];
    
    NSLog(@"GetSeriesVideos %@",bodyData);
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:DE_mainUrl parameters:[bodyData getDictionary]  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"GetSeriesVideos end %@",responseObject);
        if (responseObject) {
            id error=[responseObject objectForKey:@"error"];
            if (error) {
                int errorCode=[[error objectForKey:@"code"] intValue];
                if (errorCode==0) {
                    NSArray *datas=[responseObject objectForKey:@"datas"];
                    if (datas) {
                        if (seriesmArray==nil) {
                            seriesmArray=[[NSMutableArray alloc]init];
                        }
                        [seriesmArray removeAllObjects];
                        
                        for (NSDictionary *dic in datas) {
                            SeriesVideoModel *model=[SeriesVideoModel getModelWithDictionary:dic];
                            [seriesmArray addObject:model];
                            
                        }
                        [seriesCollectionview reloadData];
                    }
                }
                else{
                    [SVProgressHUD showErrorWithStatus:[error objectForKey:@"info"]];
                }
            }
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"请求数据错误"];
        }
        [self updateDetail];
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.description];
    }
     ];
}

- (void)updateDetail
{
            
            if (currentSeriesInfo.Description&&currentSeriesInfo.Description!=(id)[NSNull null]) {
                detailsTextview.text =currentSeriesInfo.Description;
            }
//            if (currentSeriesInfo.Actors&&currentSeriesInfo.Actors!=(id)[NSNull null]||) {
                actorTextview.text=[NSString stringWithFormat:@"主演:%@\n\n导演:%@",currentSeriesInfo.Actors,currentSeriesInfo.Directors];
//            }
//            if (currentSeriesInfo.Directors&&currentSeriesInfo.Directors!=(id)[NSNull null]) {
//                actortextview.text=
//            }
}

#pragma  mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

@end
