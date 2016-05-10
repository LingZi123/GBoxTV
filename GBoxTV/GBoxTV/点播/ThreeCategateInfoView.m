//
//  ThreeCategateInfoView.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/27.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "ThreeCategateInfoView.h"
#import "AppDelegate.h"
#import "CommonBaseData.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"

@implementation ThreeCategateInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

-(void)makeView{
    self.backgroundColor=[UIColor whiteColor];
    seriesLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.frame.size.width-40, 30)];
    
//    [seriesLabel addTarget:seriesLabel action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
//    seriesLabel.backgroundColor=[UIColor whiteColor];
    seriesLabel.textColor=[UIColor orangeColor];
    seriesLabel.text=@"剧 集";
    seriesLabel.font=DE_FONT_BOLD_16;
    seriesLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:seriesLabel];

    threeTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-60)];
    threeTableview.dataSource=self;
    threeTableview.delegate=self;
    
    [self addSubview:threeTableview];
    
}

#pragma mark-UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (threemArray) {
        return  threemArray.count;
    }
    return 0;
}
#pragma mark-UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *indentif=@"threecell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentif];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentif];
    }
    
    ProgramModel *model=[threemArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text=model.Name;
    cell.textLabel.numberOfLines=0;
    cell.textLabel.font=DE_FONT_14;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProgramModel *model=[threemArray objectAtIndex:indexPath.row];
    [self IsProgramWithContentID:model.ContentID];
}

#pragma mark- appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
#pragma mark-获取数据填充tableview
//搜索影片
-(void)SearchPrograms{
    
//    NSInteger states=[self appdelegate].networkStatus;
//    if (states==UnknowNetwork||states==WithoutNetwork||states==CDMA1xNetwork||
//        states==CDMAEVDORev0||states==CDMAEVDORevA||states==CDMAEVDORevB) {
//        [SVProgressHUD showErrorWithStatus:@"该网络无法访问"];
//        return;
//    }
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeNone];
    CommonBaseData *bodyData=[[CommonBaseData alloc]init];
    bodyData.action=DE_Action_SearchPrograms;
    [bodyData.device setObject:@"123" forKey:@"dnum"];
    [bodyData.user setObject:[self appdelegate].userInfo.username forKey:@"userid"];
    [bodyData.param setObject:_supperModel.CategoryID forKey:@"categoryId"];
    [bodyData.param setObject:@"" forKey:@"keyWord"];
    [bodyData.param setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    [bodyData.param setObject:[NSNumber numberWithInt:999] forKey:@"pageSize"];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:DE_mainUrl parameters:[bodyData getDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            id error=[responseObject objectForKey:@"error"];
            if (error) {
                int errorCode=[[error objectForKey:@"code"] intValue];
                if (errorCode==0) {
                    
                    NSArray  *array= [responseObject objectForKey:@"datas"];
                    if ([array isKindOfClass:[NSArray class]]) {
                        
                        if (threemArray == nil) {
                            threemArray = [[NSMutableArray alloc]initWithCapacity:0];
                        }
                        [threemArray removeAllObjects];
                        for (NSDictionary *dic in array) {
                            ProgramModel *model=[ProgramModel getModelWithDictionary:dic];
                            [threemArray addObject:model];
                        }
                        [threeTableview reloadData];
                        
                    }
                    [SVProgressHUD dismiss];
                    
                }
                else{
                    [SVProgressHUD showErrorWithStatus:[error objectForKey:@"info"]];
                }
            }
            else{
                [SVProgressHUD dismiss];
            }
        }
        else{
            [SVProgressHUD dismiss];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD  showErrorWithStatus:error.description];
    }];
    
}

//判断是电视剧还是电影
-(void)IsProgramWithContentID:(NSString *)contentID{
//    NSInteger states=[self appdelegate].networkStatus;
//    if (states==UnknowNetwork||states==WithoutNetwork||states==CDMA1xNetwork||
//        states==CDMAEVDORev0||states==CDMAEVDORevA||states==CDMAEVDORevB) {
//        [SVProgressHUD showErrorWithStatus:@"该网络无法访问"];
//        return;
//    }
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeNone];
    CommonBaseData *bodyData=[[CommonBaseData alloc]init];
    bodyData.action=DE_Action_IsProgram;
    [bodyData.device setObject:@"123" forKey:@"dnum"];
    [bodyData.user setObject:[self appdelegate].userInfo.username forKey:@"userid"];
    [bodyData.param setObject:contentID forKey:@"contentID"];
    
    NSLog(@"---%@----test",[bodyData getDictionary]);
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:DE_mainUrl parameters:[bodyData getDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            id error=[responseObject objectForKey:@"error"];
            if (error) {
                int errorCode=[[error objectForKey:@"code"] intValue];
                if (errorCode==0) {
                    NSDictionary *dic=[responseObject objectForKey:@"data"];
                    if (dic) {
                        int result=[[dic objectForKey:@"result"] intValue];
                        
                        if (result==1) {
                            //获取电影详情
                            [self GetProgramInfo:contentID];
                            
                        }
                        else{
                            //获取电视剧详情
                            [self GetSeriesInfo:contentID];
                        }
                    }
                }
                else{
                    NSLog(@"%@",[error objectForKey:@"info"]);
                    [SVProgressHUD showErrorWithStatus:[error objectForKey:@"info"]];
                }
            }
        }
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.description];
    }];
}

//获取电视剧详情
-(void)GetSeriesInfo:(NSString *)contentID{
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
    [bodyData.param setObject:contentID forKey:@"contentID"];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:DE_mainUrl parameters:[bodyData getDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            id error=[responseObject objectForKey:@"error"];
            if (error) {
                int errorCode=[[error objectForKey:@"code"] intValue];
                if (errorCode==0) {
                    NSDictionary *dic=[responseObject objectForKey:@"data"];
                    if (dic) {
//                        _currentPlayUrl=[dic objectForKey:@"PlayUrl"];
//                        if (![_currentPlayUrl isEqualToString:@""]) {
//                            //                            VDLPlaybackViewController *vcl=[[LocalHelper share]getPlayerVideoWithUrl:_currentPlayUrl];
//                            //                            [self presentViewController:vcl animated:YES completion:nil];
//                        }
                    }
                    
                }
                else{
                    [SVProgressHUD showErrorWithStatus:[error objectForKey:@"info"]];
                }
            }
        }
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.description];
    }];
}


-(void)GetProgramInfo:(NSString *)contentID{
    
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
    [bodyData.param setObject:contentID forKey:@"contentID"];
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
                        
                        [self.threeDelegate didSelectedProgram:[data objectForKey:@"PlayUrl"] titlename:[data objectForKey:@""]];
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
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.description];
    }
     ];
}


@end
