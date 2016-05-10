//
//  AppointmentViewController.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/28.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "AppointmentViewController.h"

@interface AppointmentViewController ()

@end

@implementation AppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"预约";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)callBtnClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10011"]];
}

- (IBAction)okBtnClick:(id)sender {
}

@end
