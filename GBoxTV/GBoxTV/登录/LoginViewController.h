//
//  LoginViewController.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonRootViewController.h"

//typedef void(^loginSuccessBlock)();
@protocol LoginViewControllerDelegate <NSObject>

-(void)loinSuccess;

@end


@interface LoginViewController : CommonRootViewController
{
    __weak IBOutlet UITextField *phoneTextField;
    __weak IBOutlet UITextField *pwdTextField;
}

- (IBAction)loginBtnClick:(id)sender;

//@property(nonatomic,strong) loginSuccessBlock loginSuccessBlock;
//-(void)loginSuccess:(loginSuccessBlock)block;
@property(nonatomic,assign) id<LoginViewControllerDelegate>delegate;
@end
