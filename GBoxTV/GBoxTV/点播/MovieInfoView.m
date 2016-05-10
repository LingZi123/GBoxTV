//
//  MovieInfoView.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/27.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "MovieInfoView.h"
#import "RelatedProgramModel.h"
#import "SVProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "CommonBaseData.h"
#import "AppDelegate.h"

@implementation MovieInfoView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

-(void)makeView{
    
    self.backgroundColor=[UIColor whiteColor];
    segControl=[[UISegmentedControl alloc]initWithItems:@[@"详情",@"演员",@"相关"]];
    segControl.frame=CGRectMake(20, 20, self.frame.size.width-40, 30);
    [segControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    segControl.backgroundColor=[UIColor whiteColor];
    segControl.tintColor=[UIColor orangeColor];
    segControl.selectedSegmentIndex=0;
    [self addSubview:segControl];
    
    if (raletedCollectionview == nil) {
        UICollectionViewFlowLayout *raletedgrid = [[UICollectionViewFlowLayout alloc] init];
        raletedgrid.itemSize = CGSizeMake(90.0, 150.0);
        raletedgrid.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 20.0, 10.0);
        
        raletedCollectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, self.frame.size.width,self.frame.size.height-60) collectionViewLayout:raletedgrid];
        raletedCollectionview.hidden = YES;
        raletedCollectionview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        raletedCollectionview.delegate = self;
        raletedCollectionview.dataSource = self;
        raletedCollectionview.backgroundColor = [UIColor whiteColor];
        [self addSubview:raletedCollectionview];
        [raletedCollectionview registerNib:[UINib nibWithNibName:@"OndemandCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ondemand"];
        [raletedCollectionview reloadData];
    }
    
    [self addSubview:raletedCollectionview];
    
    detailstextview=[[UITextView alloc]initWithFrame:CGRectMake(10, 60, CGRectGetWidth(self.frame)-20, CGRectGetHeight(self.frame)-60)];
    detailstextview.font=DE_FONT_14;
    [self addSubview:detailstextview];
    
    
    actortextview=[[UITextView alloc]initWithFrame:CGRectMake(10, 60, CGRectGetWidth(self.frame)-20, CGRectGetHeight(self.frame)-60)];
    actortextview.font=DE_FONT_14;
    [self addSubview:actortextview];
    
    [self segmentValueChanged:segControl];
}

-(void)segmentValueChanged:(UISegmentedControl *)sender{
    
    if (sender.selectedSegmentIndex==0) {
        detailstextview.hidden=NO;
        actortextview.hidden=YES;
        raletedCollectionview.hidden=YES;
        
    }
    else if (sender.selectedSegmentIndex==1){
        detailstextview.hidden=YES;
        actortextview.hidden=NO;
        raletedCollectionview.hidden=YES;
    }
    else{
        detailstextview.hidden=YES;
        actortextview.hidden=YES;
        raletedCollectionview.hidden=NO;
        if (raletedmArray==nil||raletedmArray.count<=0) {
            [self GetRelatedPrograms];
        }
    }
}


#pragma mark-UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView==raletedCollectionview&&raletedmArray) {
        return raletedmArray.count;
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
    RelatedProgramModel *dict = [raletedmArray objectAtIndex:indexPath.row];
    _supContentID=dict.ContentID;
    [self GetProgramInfo];
}


#pragma mark-UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
        NSString *identifier = @"ondemand";
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        UILabel *lable = (UILabel *)[cell.contentView viewWithTag:301];
        __weak UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:300];
        
        RelatedProgramModel *dict = [raletedmArray objectAtIndex:indexPath.row];
        if (dict&&dict!=(id)[NSNull null]) {
            lable.text = [NSString stringWithFormat:@"%@",dict.Name];
            imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict.PicUrl]]];
            //            [NetEngine imageAtURL:dict.PicUrl onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
            //                imageView.image = fetchedImage;
            //            }];
        }
    return cell;
    
}

#pragma mark-获取网络数据
-(void)GetProgramInfo{
    
//    NSInteger states=[self appdelegate].networkStatus;
//    if (states==UnknowNetwork||states==WithoutNetwork||states==CDMA1xNetwork||
//        states==CDMAEVDORev0||states==CDMAEVDORevA||states==CDMAEVDORevB) {
//        [SVProgressHUD showErrorWithStatus:@"该网络无法访问"];
//        return;
//    }
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeNone];
    
    CommonBaseData *bodyData=[[CommonBaseData alloc]init];
    bodyData.action=DE_Action_GetProgramInfo;
    [bodyData.device setObject:@"123" forKey:@"dnum"];
    [bodyData.user setObject:[self appdelegate].userInfo.username forKey:@"userid"];
    [bodyData.param setObject:_supContentID forKey:@"contentID"];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:DE_mainUrl parameters:[bodyData getDictionary]  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            id error=[responseObject objectForKey:@"error"];
            if (error) {
                int errorCode=[[error objectForKey:@"code"] intValue];
                if (errorCode==0) {
                    NSDictionary *data=[responseObject objectForKey:@"data"];
                    if (data) {
                        currentModel=[ProgramInfo getModelWithDictionary:data];
//                        [self IsFavorite];
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
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }
     ];
}

-(void)GetRelatedPrograms{
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
    
    CommonBaseData *bodyData=[[CommonBaseData alloc]init];
    bodyData.action=DE_Action_GetRelatedPrograms;
    [bodyData.device setObject:@"123" forKey:@"dnum"];
    [bodyData.user setObject:[self appdelegate].userInfo.username forKey:@"userid"];
    [bodyData.param setObject:_supContentID forKey:@"contentID"];
    [bodyData.param setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    [bodyData.param setObject:[NSNumber numberWithInt:999] forKey:@"pageSize"];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:DE_mainUrl parameters:[bodyData getDictionary]  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            id error=[responseObject objectForKey:@"error"];
            if (error) {
                int errorCode=[[error objectForKey:@"code"] intValue];
                if (errorCode==0) {
                    NSArray *datas=[responseObject objectForKey:@"datas"];
                    if (datas) {
                        if (raletedmArray==nil) {
                            raletedmArray=[[NSMutableArray alloc]init];
                        }
                        [raletedmArray removeAllObjects];
                        
                        for (NSDictionary *dic in datas) {
                            RelatedProgramModel *model=[RelatedProgramModel getModelWithDictionary:dic];
                            [raletedmArray addObject:model];
                            
                        }
                        [raletedCollectionview reloadData];
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
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }
     ];
    
}

- (void)updateDetail
{
    
//    __weak UIImageView *imageView = (UIImageView *)[headerView viewWithTag:100];
//    [NetEngine imageAtURL:currentModel.CoverUrl onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
//        imageView.image = fetchedImage;
//    }];
//    self.navigationItem.title =currentModel.Name;

    [self.movieDelegate didSelectedRaletePrograme:currentModel];
    actortextview.text=[NSString stringWithFormat:@"主演:%@\n\n导演:%@",currentModel.Actors,currentModel.Directors];
    detailstextview.text=currentModel.Description;
    
    
}

#pragma  mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

@end
