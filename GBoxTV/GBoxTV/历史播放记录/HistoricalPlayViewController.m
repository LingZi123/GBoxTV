//
//  HistoricalPlayViewController.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "HistoricalPlayViewController.h"
#import "IptvChannelMode.h"


@interface HistoricalPlayViewController ()

@end

@implementation HistoricalPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    phonemArray=[[NSMutableArray alloc]init];
     NSMutableArray *s1=[[NSMutableArray alloc]initWithObjects:@"重庆卫视",@"湖南卫视",@"四川卫视",nil];
    NSMutableArray *s2=[[NSMutableArray alloc]initWithObjects:@"女人的天空",@"行骗天下" ,nil];
    [phonemArray addObject:s1];
    [phonemArray addObject:s2];
    
    boxmArray=[[NSMutableArray alloc]init];
    NSMutableArray *s3=[[NSMutableArray alloc]initWithObjects:@"东方卫视",@"CCTV-1",nil];
    NSMutableArray *s4=[[NSMutableArray alloc]initWithObjects:@"女人的天空",@"行骗天下",@"好莱坞庄园",nil];
    [boxmArray addObject:s3];
    [boxmArray addObject:s4];
    tableviewArray=[[NSMutableArray alloc]init];
    
    [self makeNavTitle];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark-初始化界面
-(void)makeNavTitle{
    
    titleSegCon=[[UISegmentedControl alloc]initWithItems:@[@"本机",@"盒子"]];
    titleSegCon.frame=CGRectMake(0, 0, 120, 30);
    [titleSegCon addTarget:self action:@selector(titleSegValueChange:) forControlEvents:UIControlEventValueChanged];
    titleSegCon.tintColor=[UIColor whiteColor];
    titleSegCon.selectedSegmentIndex=0;
    self.navigationItem.titleView=titleSegCon;
    [self titleSegValueChange:titleSegCon];
    
}

#pragma  mark-响应事件
-(void)titleSegValueChange:(UISegmentedControl *)sender{
    //都要重新获取
    [tableviewArray removeAllObjects];
    if (sender.selectedSegmentIndex==0) {
        //获取本机的
        [tableviewArray addObjectsFromArray:phonemArray];
        
    }
    else{
        //获取盒子的
        [tableviewArray addObjectsFromArray:boxmArray];
    }
    [historyTableview reloadData];
}

#pragma mark-UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableviewArray) {
        return tableviewArray.count;

    }
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *indentif=@"historycell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentif];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentif];
    }
    NSMutableArray *s1=[tableviewArray objectAtIndex:indexPath.section];
    cell.textLabel.text=[s1 objectAtIndex:indexPath.row];
    //直播电视剧频道
    if (indexPath.section==0) {
        cell.imageView.image=[UIImage imageNamed:cell.textLabel.text];
    }
    else{
        //电影类节目
        cell.imageView.image=[UIImage imageNamed:@"不二情书"];

    }
    return cell;
}
#pragma mark-UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableviewArray) {
        NSMutableArray *tempArray= [tableviewArray objectAtIndex:section];
        if (tempArray) {
            return tempArray.count;
        }
        return 0;
    }
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"直播频道";
    }
    return @"点播节目";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进入直播
    if (indexPath.section==0) {
        
    }
    else{
        //进入点播
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
@end
