//
//  BackWatchView.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/22.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "BackWatchView.h"
#import "SVProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "CommonBaseData.h"
#import "AppDelegate.h"

@implementation BackWatchView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

-(void)makeView{
    
    self.backgroundColor=[UIColor whiteColor];
    topview=[[UIView alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.frame), 45)];
    [self addSubview:topview];
    
    UILabel *backseeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 12, 60, 21)];
    backseeLabel.text=@"回看 》";
    backseeLabel.font=DE_FONT_16;
    [topview addSubview:backseeLabel];
    
    timeSegments=[[UISegmentedControl alloc] initWithItems:@[@"今天",@"昨天",@"前天"]];
    timeSegments.frame=CGRectMake(CGRectGetMaxX(backseeLabel.frame)+20, 7.5, CGRectGetWidth(topview.frame)-CGRectGetMaxX(backseeLabel.frame)-50, 30);
    [timeSegments addTarget:self action:@selector(timeSegmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    timeSegments.backgroundColor=[UIColor whiteColor];
    timeSegments.tintColor=[UIColor orangeColor];
    timeSegments.selectedSegmentIndex=0;
    [topview addSubview:timeSegments];
    
    backseeTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topview.frame), CGRectGetWidth(self.frame), self.frame.size.height-CGRectGetMaxY(topview.frame))];
    backseeTableview.dataSource=self;
    backseeTableview.delegate=self;
    [self addSubview:backseeTableview];
}
- (void)timeSegmentValueChanged:(id)sender {
    [self reloadTableViewDataSourceForLive];
}

-(void)viewAppear
{
    NSDate *now=[NSDate date];
    if (![now isEqual:today]) {
        today=now;
        
        if (bfyesterArray&&timeSegments.selectedSegmentIndex!=2) {
            [bfyesterArray removeAllObjects];
        }
        if (yesterArray&&timeSegments.selectedSegmentIndex!=1) {
            [yesterArray removeAllObjects];
        }
    }
    if (timeSegments.selectedSegmentIndex==0) {
        //选择今天的
        [self reloadTableViewDataSourceForLive];
    }
    
}
-(void)viewDisappear{
    
}

#pragma mark-UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableviewmArray) {
        return tableviewmArray.count;
    }
    else{
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IptvScheduleInfoModel *model=[tableviewmArray objectAtIndex:indexPath.row];
    [self.backseeDelegate backSeeTableviewSelectedModel:model];
}
#pragma mark-UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *indentif=@"backseecell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentif];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentif];
    }
    IptvScheduleInfoModel *dict = [tableviewmArray objectAtIndex:indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *startstr = [NSString stringWithFormat:@"%@ %@",dict.StartDate,dict.StartTime];
    
    //        int duration=[[LocalHelper share]getNumberWithString:dict.Duration];
    
    NSDate *startdate = [formatter dateFromString:startstr];
    
    NSDate *enddate =[[NSDate alloc]initWithTimeInterval:dict.Duration sinceDate:startdate] ;
    
    NSDate *currentdate = [NSDate date];
    
    //    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",dict.StartTime,dict.ProgramName];
    cell.textLabel.text=dict.ProgramName;
    cell.textLabel.numberOfLines=0;
    cell.textLabel.font=DE_FONT_14;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",dict.StartTime];
    
    
    
    return cell;
}

#pragma mark-请求数据
- (void)reloadTableViewDataSourceForLive
{
    //    NSInteger states=[self appdelegate].networkStatus;
    //    if (states==UnknowNetwork||states==WithoutNetwork||states==CDMA1xNetwork||
    //        states==CDMAEVDORev0||states==CDMAEVDORevA||states==CDMAEVDORevB) {
    //        [SVProgressHUD showErrorWithStatus:@"该网络无法访问"];
    //        return;
    //    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond  ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *temptoday = [cal dateByAddingComponents:components toDate:[NSDate date] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    
    NSDate *tempyesterday = [cal dateByAddingComponents:components toDate:[NSDate date] options:0];
    
    [components setHour:-48];
    [components setMinute:0];
    [components setSecond:0];
    
    NSDate *beforeyesterday = [cal dateByAddingComponents:components toDate:[NSDate date] options:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strtoday = [dateFormatter stringFromDate:temptoday];
    NSString *stryesterday = [dateFormatter stringFromDate:tempyesterday];
    NSString *strbfyesterday = [dateFormatter stringFromDate:beforeyesterday];
    
    NSString *strdate = @"";
    if (timeSegments.selectedSegmentIndex==0) {
        strdate = strtoday;
    }
    else if (timeSegments.selectedSegmentIndex==1)
    {
        strdate = stryesterday;
    }
    else if (timeSegments.selectedSegmentIndex==2)
    {
        strdate = strbfyesterday;
    }
    
    NSLog(@"%@",strdate);
    
    //        NSString *stryesterday = [dateFormatter stringFromDate:tempyesterday];
    NSString *channelid = @"cctv1";
    if (![_superChannel.ContentID isEqual:[NSNull null]] && [_superChannel.ContentID rangeOfString:@"null"].location == NSNotFound) {
        channelid = [NSString stringWithFormat:@"%@",_superChannel.ContentID];
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    CommonBaseData *bodyData=[[CommonBaseData alloc]init];
    bodyData.action=DE_Action_GetSchedules;
    [bodyData.device setObject:@"123" forKey:@"dnum"];
    [bodyData.user setObject:[self appdelegate].userInfo.username forKey:@"userid"];
    [bodyData.param setObject:_superChannel.ContentID forKey:@"channelID"];
    [bodyData.param setObject:strdate forKey:@"date"];
    [bodyData.param setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    [bodyData.param setObject:[NSNumber numberWithInt:999] forKey:@"pageSize"];
    [bodyData.param setObject:[NSNumber numberWithInt:-1] forKey:@"sort"];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:DE_mainUrl parameters:[bodyData getDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"----getSchedules-----responseObject---%@",responseObject);
        [SVProgressHUD dismiss];
        if (responseObject) {
            id error= [responseObject objectForKey:@"error"];
            if (error) {
                int errorCode= [[error objectForKey:@"code"]intValue];
                if (errorCode==0) {
                    //                    [self showErrorView:NO];
                    NSArray *array = [responseObject objectForKey:@"datas"];
                    if ([array isKindOfClass:[NSArray class]]) {
                        
                        if (tableviewmArray == nil) {
                            tableviewmArray= [[NSMutableArray alloc]initWithCapacity:0];
                            
                        }
                        
                        NSLog(@"%@",array);
                        
                        if (array.count > 0) {
                            [tableviewmArray removeAllObjects];
                            for (NSDictionary *dict in array) {
                                IptvScheduleInfoModel *newModel=[IptvScheduleInfoModel getModelWithDictionary:dict];
                                [tableviewmArray addObject:newModel];
                            }
                            if (timeSegments.selectedSegmentIndex==1) {
                                if (yesterArray==nil) {
                                    yesterArray=[[NSMutableArray alloc]init];
                                }
                                [yesterArray removeAllObjects];
                                [yesterArray addObjectsFromArray:tableviewmArray];
                            }
                            else if (timeSegments.selectedSegmentIndex==2) {
                                if (bfyesterArray==nil) {
                                    bfyesterArray=[[NSMutableArray alloc]init];
                                }
                                [bfyesterArray removeAllObjects];
                                [bfyesterArray addObjectsFromArray:tableviewmArray];
                            }
                            
                            //                            [self doneLoadingTableViewDataForLive];
                            [backseeTableview reloadData];
                        }
                        
                    }
                }
                else{
                    
                    //                    [self showErrorView:YES];
                }
            }
            else{
                //                [self showErrorView:YES];
            }
        }
        else{
            //            [self showErrorView:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        NSLog(@"----getSchedules-----error---%@",error);
        //        [self showErrorView:YES];
    }];
}

- (void)doneLoadingTableViewDataForLive{
    
    //    reloadingForLive = NO;
    //    [refreshHeaderViewForLive egoRefreshScrollViewDataSourceDidFinishedLoading:mTableView];
    
    if ([tableviewmArray count] > 0) {
        
        NSIndexPath *liveindex ;
        for (int i = 0 ; i<tableviewmArray.count; i++) {
            IptvScheduleInfoModel *dict = [tableviewmArray objectAtIndex:i];
            
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            
            NSString *startstr = [NSString stringWithFormat:@"%@ %@",dict.StartDate,dict.StartTime];
            //            int duration=[[LocalHelper share]getNumberWithString:dict.Duration];
            
            
            NSDate *startdate = [formatter dateFromString:startstr];
            NSDate *enddate =[[NSDate alloc]initWithTimeInterval:dict.Duration sinceDate:startdate];
            
            NSDate *currentdate = [NSDate date];
            if ([startdate laterDate:currentdate] == currentdate && [enddate laterDate:currentdate] == enddate) {
                liveindex = [NSIndexPath indexPathForRow:i inSection:0];
            }
            
        }
        
        
        
        [backseeTableview reloadData];
        
        if (liveindex) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [backseeTableview scrollToRowAtIndexPath:liveindex atScrollPosition:UITableViewScrollPositionTop animated:YES];
            });
        }
    }
    
}
#pragma  mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

@end
