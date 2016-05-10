//
//  MyViewController.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSupperViewController.h"
#import "LoginViewController.h"

@interface MyViewController : MainSupperViewController<UITableViewDataSource,UITableViewDelegate,LoginViewControllerDelegate>
{
    
    __weak IBOutlet UITableView *dataTableview;
    NSMutableArray *datamArray;
    NSString *version;//版本号
}
- (IBAction)logoutBtnClick:(id)sender;
@end
