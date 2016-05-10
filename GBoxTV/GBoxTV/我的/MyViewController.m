//
//  MyViewController.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "MyViewController.h"
#import "OndemandViewController.h"
#import "AppointmentViewController.h"
#import "AppDelegate.h"
#import "EditPwdViewController.h"
#import "BindingViewController.h"
#import "LoginViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 组建数据
    
    NSMutableArray *arry1=[[NSMutableArray alloc]initWithObjects:@"影视点播",nil];
    NSMutableArray *arry2=[[NSMutableArray alloc]initWithObjects:@"预约",@"绑定账号",@"修改密码", nil];
    NSMutableArray *arry3=[[NSMutableArray alloc]initWithObjects:@"版本信息", nil];
    
    if (datamArray==nil) {
        datamArray=[[NSMutableArray alloc]initWithObjects:arry1,arry2,arry3,nil];
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    version= [infoDictionary objectForKey:@"CFBundleShortVersionString"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logoutBtnClick:(id)sender {
    NSUserDefaults *defuauts=[NSUserDefaults standardUserDefaults];
    [defuauts setBool:NO forKey:DE_Save_isLogin];
    [defuauts synchronize];
    
    if([self appdelegate].loginNavCon==nil){
        LoginViewController *loginvc=[[self appdelegate].mainStoryboard  instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //        [loginvc loginSuccess:^{
        //            [self createMainTabPage];
        //            self.window.rootViewController=_mainTabbarCon;
        //
        //        }];
        loginvc.delegate=[self appdelegate];
        
            [self appdelegate].loginNavCon=[[UINavigationController alloc]initWithRootViewController:loginvc];
        
        
    }
     [self appdelegate].window.rootViewController= [self appdelegate].loginNavCon;
    

}

#pragma mark-UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (datamArray) {
        return datamArray.count;
    }
    else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *indentif=@"mycell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentif];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentif];
    }
    NSMutableArray *itemArray=[datamArray objectAtIndex:indexPath.section];
    cell.textLabel.text=[itemArray objectAtIndex:indexPath.row];
    if (indexPath.section==0||indexPath.section==1) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        cell.detailTextLabel.text=version;
    }
    return cell;
}

#pragma mark-UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        OndemandViewController *ondemandvc=[[OndemandViewController alloc]init];
        ondemandvc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:ondemandvc animated:YES];
    }
    else if (indexPath.section==1){
        if (indexPath.row==0) {
            AppointmentViewController *vc=[[self appdelegate].mainStoryboard instantiateViewControllerWithIdentifier:@"AppointmentViewController"];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row==1){
            BindingViewController *vc=[[self appdelegate].mainStoryboard instantiateViewControllerWithIdentifier:@"BindingViewController"];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            EditPwdViewController *vc=[[self appdelegate].mainStoryboard instantiateViewControllerWithIdentifier:@"EditPwdViewController"];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *itemarray=[datamArray objectAtIndex:section];
    if (itemarray) {
        return itemarray.count;
    }
    else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

#pragma  mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

#pragma mark-loginviewdelegate
-(void)loinSuccess{
    [[self appdelegate] createMainTabPage];
    [self appdelegate].window.rootViewController=[self appdelegate].mainTabbarCon;
}
@end
