//
//  RemoteControlViewController.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/5/5.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoteControlViewController : UIViewController{
    
    __weak IBOutlet UITextField *keyField;
    __weak IBOutlet UIButton *key;
    __weak IBOutlet UIButton *titleBtn;
}
- (IBAction)titleBtnClick:(id)sender;

- (IBAction)cancelBtnClick:(id)sender;
- (IBAction)keyBtnClick:(id)sender;
@end
