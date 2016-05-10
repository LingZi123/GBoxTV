//
//  RemoteControlViewController.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/5/5.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "RemoteControlViewController.h"

@interface RemoteControlViewController ()

@end

@implementation RemoteControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    titleBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    keyField.enabled=NO;
   [key setTitle:@"启用键盘" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (keyField.enabled) {
        [keyField resignFirstResponder];
    }
}

- (IBAction)titleBtnClick:(id)sender {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"搜索结果" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelBtn=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    for (int i=0; i<4; i++) {
        UIAlertAction *otherBtn=[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"GBOX %D",i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:otherBtn];
    }
    
    [alert addAction:cancelBtn];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (IBAction)cancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)keyBtnClick:(id)sender {
    if ([key.titleLabel.text isEqualToString:@"启用键盘"]) {
        keyField.enabled=YES;
        [keyField becomeFirstResponder];
        [key setTitle:@"取消键盘" forState:UIControlStateNormal];
    }
    else{
        keyField.enabled=NO;
        [keyField resignFirstResponder];
        [key setTitle:@"启用键盘" forState:UIControlStateNormal];
        keyField.text=@"";
    }
}
@end
