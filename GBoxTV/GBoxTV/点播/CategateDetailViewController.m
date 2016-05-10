//
//  CategateDetailViewController.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/28.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "CategateDetailViewController.h"
#import "AppDelegate.h"
#import "CommonBaseData.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "ProgramDetailViewController.h"


@interface CategateDetailViewController ()

@end

@implementation CategateDetailViewController

-(instancetype)initWithSuperModel:(IptvCategoryModel *)supCategory{
    self=[super init];
    if (self) {
        supperModel=supCategory;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeView];
    [self SearchPrograms];

   
}

-(void)makeView{
    self.view.backgroundColor=[UIColor whiteColor];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-20)];
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
    
    [tableview registerNib:[UINib nibWithNibName:@"ThreeCategateTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ThreeCategateTableViewCell"];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title=supperModel.Name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (programArray) {
        return  programArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}

#pragma mark-UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *indentif=@"ThreeCategateTableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentif];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentif];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:102];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:101];
    
    ProgramModel *model=[programArray objectAtIndex:indexPath.row];
    
    label.text=model.Name;
//    cell.textLabel.font=DE_FONT_14;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.PicUrl]]];
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProgramModel *model=[programArray objectAtIndex:indexPath.row];
    ProgramDetailViewController *programvc=[[ProgramDetailViewController alloc]initWithModel:model];
    [self.navigationController pushViewController:programvc animated:YES];
}

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
    [bodyData.param setObject:supperModel.CategoryID forKey:@"categoryId"];
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
                        
                        if (programArray == nil) {
                            programArray = [[NSMutableArray alloc]initWithCapacity:0];
                        }
                        [programArray removeAllObjects];
                        for (NSDictionary *dic in array) {
                            ProgramModel *model=[ProgramModel getModelWithDictionary:dic];
                            [programArray addObject:model];
                        }
                        [tableview reloadData];
                        
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

#pragma mark- appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}


@end
