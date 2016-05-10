//
//  MainRootViewController.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/29.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "MainSupperViewController.h"
#import "AppDelegate.h"
#import "RemoteControlViewController.h"

@interface MainSupperViewController ()

@end

@implementation MainSupperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"小遥控器"] style:UIBarButtonItemStylePlain  target:self action:@selector(remoteControlBtnClick:)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-遥控器
-(void)remoteControlBtnClick:(UIBarButtonItem *)sender{
    RemoteControlViewController *vc=[[self appdelegate].mainStoryboard instantiateViewControllerWithIdentifier:@"RemoteControlViewController"];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
}

#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}


@end
