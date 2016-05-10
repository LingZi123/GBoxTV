//
//  LiveViewController.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "LiveViewController.h"
#import "IptvChannelMode.h"
#import "AppDelegate.h"
#import "CommonBaseData.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "LiveDetailViewController.h"

@interface LiveViewController ()

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userId=[self appdelegate].userInfo.username;
    session=[self appdelegate].userInfo.sesion;
    cqmArray=[[NSMutableArray alloc]init];
    zymArray=[[NSMutableArray alloc]init];
    wsmArray=[[NSMutableArray alloc]init];
    iptvmArray=[[NSMutableArray alloc]init];
    othermArray=[[NSMutableArray alloc]init];
//     [self makeTitleView];
    
    //添加左右滑动的手势
    UISwipeGestureRecognizer *leftreg=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeValueChange:)];
    leftreg.delegate=self;
    leftreg.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftreg];
    
    UISwipeGestureRecognizer *rightreg=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeValueChange:)];
    rightreg.delegate=self;
    rightreg.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightreg];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController setHidesBottomBarWhenPushed:YES];
    //从服务器获取一次数据
    if (liveArray==nil) {
        [self reloadTableViewDataSourceForLive];
    }
    
}

-(void)swipeValueChange:(UISwipeGestureRecognizer *)reg{
    if (reg.direction==UISwipeGestureRecognizerDirectionRight) {
        if (seletedIndex+1<=livetitleview.items.count) {
            [livetitleview btnClick:[livetitleview.items objectAtIndex:seletedIndex+1]];
        }
    }
    if (reg.direction==UISwipeGestureRecognizerDirectionLeft) {
        if (seletedIndex-1>=0) {
            [livetitleview btnClick:[livetitleview.items objectAtIndex:seletedIndex-1]];
        }
    }
    mytableview.scrollEnabled=YES;
    
}

#pragma mark-UIGestureRecognizerDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    mytableview.scrollEnabled=NO;
    return YES;
}


-(void)makeTitleView{
    livetitleview=[[LiveTitleView alloc]initWithFrame:CGRectMake(0, 0, 250, 34)];
    livetitleview.liveTitleDelegate=self;
    self.navigationItem.titleView=livetitleview;
    [livetitleview defaultSelectIndex:0];

}

#pragma mark-UICollectionViewDelegateFlowLayout

#pragma mark-UICollectionViewDelegate

#pragma mark-UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark-UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *indentif=@"livetableviewcell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentif];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentif];
    }
    IptvChannelMode *celldata=nil;
    if (tableView==mytableview) {
        celldata=[tablemArray objectAtIndex:indexPath.row];
    }
    else{
        celldata=[othermArray objectAtIndex:indexPath.row];
    }
 
    if (celldata) {
            [cell.imageView setImage:[UIImage imageNamed:celldata.Name]];

    }
        cell.textLabel.text=celldata.Name;
//        cell.detailTextLabel.text=celldata.
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark-UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==mytableview) {
        return tablemArray.count;
    }
    else{
        return othermArray.count;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IptvChannelMode *celldata=nil;
    if (tableView==mytableview) {
        celldata=[tablemArray objectAtIndex:indexPath.row];
    }
    else{
        celldata=[othermArray objectAtIndex:indexPath.row];
    }
    LiveDetailViewController *liveDetailvc=[[LiveDetailViewController alloc]initWithChannelModel:celldata];
    liveDetailvc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:liveDetailvc animated:YES];
    
}
#pragma mark-从网络哪数据
#pragma mark LoadLiveTableView Data

- (void)reloadTableViewDataSourceForLive
{
    if (userId==nil) {
        return;
    }
    
//    NSInteger states=[self appdelegate].networkStatus;
//    if (states==UnknowNetwork||states==WithoutNetwork||states==CDMA1xNetwork||
//        states==CDMAEVDORev0||states==CDMAEVDORevA||states==CDMAEVDORevB) {
//        [SVProgressHUD showErrorWithStatus:@"该网络无法访问"];
//        return;
//    }
    
    //    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    CommonBaseData *bodyData=[[CommonBaseData alloc]init];
    bodyData.action=DE_Action_GetChannels;
    [bodyData.device setObject:@"123" forKey:@"dnum"];
    [bodyData.user setObject:userId forKey:@"userid"];
    [bodyData.param setObject:@"" forKey:@"categoryId"];
    [bodyData.param setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    [bodyData.param setObject:[NSNumber numberWithInt:999] forKey:@"pageSize"];
    [bodyData.param setObject:session forKey:@"Session"];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    [manager POST:DE_mainUrl parameters:[bodyData getDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"---GetChannels---responseObject--->%@",responseObject);
        [SVProgressHUD dismiss];
        
        if (responseObject) {
            id error=[responseObject objectForKey:@"error"];
            if (error) {
                int errorCode=[[error objectForKey:@"code"] intValue];
                if (errorCode!=0) {
                    NSString *errorInfo=[error objectForKey:@"info"];
                    NSLog(@"----GetChannels---error--->%@",errorInfo);
                    //从本地获取
//                    NSArray *localLiveArray=[self getLiveDataFromLocal];
//                    if (localLiveArray) {
//                        [self fullLiveArray:localLiveArray];
//                    }
//                    else{
//                        [SVProgressHUD showErrorWithStatus:@"无数据"];
//                    }
                    
                }
                else{
//                    liveNum= [[responseObject objectForKey:@"num"] intValue];
//                    liveTotal=[[responseObject objectForKey:@"total"] intValue];
                    
                    NSArray  *array= [responseObject objectForKey:@"datas"];
                    if ([array isKindOfClass:[NSArray class]]) {
                        
                        if (liveArray == nil) {
                            liveArray = [[NSMutableArray alloc]initWithCapacity:0];
                        }
                        
                        NSLog(@"%@",array);
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[array copy]];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:data forKey:DE_Save_liveData];
                        
                        [self fullLiveArray:array];
                    }
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"---GetChannels---error--->%@",error);
        
//        NSArray *localLiveArray=[self getLiveDataFromLocal];
//        if (localLiveArray) {
//            [self fullLiveArray:localLiveArray];
//        }
//        else{
//            [SVProgressHUD showErrorWithStatus:@"无数据"];
//        }
//        [self doneLoadingTableViewDataForLive];
    }];
    
}

#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

#pragma mark-填充数据

-(void)fullLiveArray:(NSArray *)array{
    
    if ([array isKindOfClass:[NSArray class]]) {
        if (liveArray == nil) {
            liveArray = [[NSMutableArray alloc]initWithCapacity:0];
        }
        [liveArray removeAllObjects];
        
        for (NSDictionary *dic in array) {
            IptvChannelMode *model=[IptvChannelMode getModelWithDictionary:dic];
            if ([model.Hd intValue]==0&&![model.Name containsString:@"高清"]) {
                [liveArray addObject:model];//屏蔽高清
                if ([model.Name containsString:@"重庆"]||[model.Name containsString:@"CQ"]) {
                    [cqmArray addObject:model];
                }
                else if ([model.Name containsString:@"中央"]||[model.Name containsString:@"CCTV"]) {
                    [zymArray addObject:model];
                }
                else if ([model.Name containsString:@"卫视"]) {
                    [wsmArray addObject:model];
                }
                else if ([model.Name containsString:@"IPTV"]) {
                    [iptvmArray addObject:model];
                }
                else{
                    [othermArray addObject:model];
                }
            }
            
        }
        NSLog(@"%@",array);
        [self doneLoadingTableViewDataForLive];
    }
}
- (void)doneLoadingTableViewDataForLive{
    
//    _reloadingForLive = NO;
//    [_refreshHeaderViewForLive egoRefreshScrollViewDataSourceDidFinishedLoading:allLiveCollectview];
    
    if ([liveArray count] > 0) {
        if (seletedIndex!=4) {
            [mytableview reloadData];
        }
        else{
            [otherTablevew reloadData];
        }
        
    }
}

#pragma mark-LiveTitleViewDelegate
-(void)LiveTitleViewClickWithIndex:(NSInteger)index{
    seletedIndex=index;
    switch (index) {
        case 0:
            tablemArray=cqmArray;
            [mytableview reloadData];
            mytableview.hidden=NO;
            otherTablevew.hidden=YES;
            break;
        case 1:
            tablemArray=zymArray;
            [mytableview reloadData];
            mytableview.hidden=NO;
            otherTablevew.hidden=YES;
            break;

        case 2:
            tablemArray=wsmArray;
            [mytableview reloadData];
            mytableview.hidden=NO;
            otherTablevew.hidden=YES;
            break;
        case 3:
            tablemArray=iptvmArray;
            [mytableview reloadData];
            mytableview.hidden=NO;
            otherTablevew.hidden=YES;
            break;
        case 4:
            [otherTablevew reloadData];
            mytableview.hidden=YES;
            otherTablevew.hidden=NO;
            break;
        default:
            break;
    }
}
@end
