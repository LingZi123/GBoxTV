//
//  LoginViewController.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "CommonHelper.h"
#import "NSString+ThreeDES.h"
#import "CommonBaseData.h"
#import "UserInfoModel.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航的背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航背景"] forBarMetrics:UIBarMetricsCompact];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([self appdelegate].userInfo) {
        phoneTextField.text=[self appdelegate].userInfo.username;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [phoneTextField resignFirstResponder];
    [pwdTextField resignFirstResponder];
}

#pragma mark-按钮事件

- (IBAction)loginBtnClick:(id)sender {
    
    [phoneTextField resignFirstResponder];
    [pwdTextField resignFirstResponder];
    [self beginLogin];

}

#pragma mark-按钮相关方法
-(void)beginLogin{
    //验证
    if (phoneTextField.text.length<=0){
        
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
        return;
    }
    if (pwdTextField.text.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    
    [self getEncryToken:phoneTextField.text andPassword:pwdTextField.text];
}

#pragma mark-AppDelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

#pragma mark-网络数据交互

-(void)getEncryToken:(NSString *)userId andPassword:(NSString *)password{
    //开始获取信息EncryToken
    NSString *str=[NSString stringWithFormat:@"http://%@:%@/iptvbms/mobilelogin.jsp?UserID=%@&Action=Login&TerminalFlag=%ld",DE_loginhost,DE_loginport ,userId,(long)[self appdelegate].terminalFlag];
    
    NSLog(@"%@",str);
    
    [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeNone];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        {
            if (responseObject) {
                //取得EncryToken
                NSString *encryToken=[responseObject objectForKey:@"EncryToken"];
                if (![encryToken isEqualToString:@""]) {
                    
                    //3DES加密
                    NSString *authenticator=[self getAuthenticator:userId andPassword:password andEncryToken:encryToken];
                    
                    [self getUserToken:userId andAuthenticator:authenticator];
                    
                }
                else{
                    NSLog(@"getEncryToken---->error=%@",[responseObject objectForKey:@"ErrorMsg"]);
                    [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"ErrorMsg"]];
                }
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络错误,请确保是否是重庆联通网络"];
    }];
    
}

-(void)getUserToken:(NSString *)userId andAuthenticator:(NSString *)authenticator{
    NSLog(@"----getUserToken--andAuthenticator:%@",authenticator);
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    NSString *getStr=[NSString stringWithFormat:@"http://%@:%@/iptvbms/mobilegetusertoken.jsp?&UserID=%@&Authenticator=%@&TerminalFlag=%ld",DE_loginhost,DE_loginport,userId,authenticator,(long)[self appdelegate].terminalFlag];
    
    NSLog(@"-----getUserToken---getStr:%@",getStr);
    
    [manager GET:getStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"---getUserToken---operation:%@   responseObject=%@  errormsg=%@",operation,responseObject,[responseObject objectForKey:@"ErrorMsg"]);
        
        if (responseObject) {
            
            NSNumber  *returnCode=[responseObject objectForKey:@"ReturnCode"];
            if ([returnCode intValue]==0) {
                
                //找出UserToken
                NSString *userToken=[responseObject objectForKey:@"UserToken"];
                //                NSString *userTokenExpiredTime=[responseObject objectForKey:@"UserTokenExpiredTime"];
                
                //通过userTocken获取Session
                [self getEpgAuth:userId andUserToken:userToken];
                
            }
            else{
                NSString *errorMes=[responseObject objectForKey:@"ErrorMsg"];
                NSLog(@"----getUserToken---errormes:%@", errorMes);
                [SVProgressHUD showErrorWithStatus:errorMes];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"----getUserToken----error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络错误,请确保是否是重庆联通网络"];
    }];
}

//组合加密数据
-(NSString *)getAuthenticator:(NSString *)userId andPassword:(NSString *)passWord andEncryToken:(NSString *)encryToken{
    
    
    
    //  userID:gf001
    //PWD:111111
    NSString *Mac=@"0C:F0:B4:04:87:51";
    NSString *STBMac=@"00000200002218A015010CF0B40487510CF0B4048751";
    int s=arc4random_uniform(10000000+1);
    NSString *ip=[[CommonHelper share]getIpAddress];
    //取随机数
    
    NSString *authenticaStr=[NSString stringWithFormat:@"%d$%@$%@$%@$%@$%@$$CTC",s,encryToken,userId,STBMac,ip,Mac];
    NSLog(@"-----getAuthenticator----authenticaStr:%@",authenticaStr);
    
    
    //    NSString *test2Str=[NSString stringWithFormat:@"%C",authenticaStr];
    //    NSLog(@"---------->test2Str=%@",test2Str);
    
    
    
    NSString *str=[NSString encrypt:authenticaStr withKey:@"11111100"];
    
    NSLog(@"-----getAuthenticator-----encryptStr:%@",str);
    
    return str;
}

//首页鉴权EpgAuth

-(void)getEpgAuth:(NSString *)userId andUserToken:(NSString *)userToken{
    
    CommonBaseData *postData=[[CommonBaseData alloc]init];
    postData.action=@"EpgAuth";
    [postData.device setObject:@"123" forKey:@"dnum"];
    [postData.user setObject:userId forKey:@"userid"];
    [postData.param setObject:userToken forKey:@"userToken"];
    
//    NSLog(@"---getEpgAuth----commondata %@",[postData getDictionary]);
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:DE_mainUrl parameters:[postData getDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"---getEpgAuth---responseObject:%@------operation:%@",responseObject,operation);
        if (responseObject) {
            id error= [responseObject objectForKey:@"error"];
            if (error) {
                NSNumber *errorcode= [error objectForKey:@"code"];
                if ([errorcode intValue]!=0) {
                    NSLog(@"---getEpgAuth----errorMes:%@",[error objectForKey:@"info"]);
                }
                else{
                    //取session值
                    id data=[responseObject objectForKey:@"data"];
                    if (data) {
                        NSString *Session=[data objectForKey:@"Session"];
                        NSString *ExpiredTime=[data objectForKey:@"ExpiredTime"];
                        
                        //保存值
                        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                        UserInfoModel *loginUser=[[UserInfoModel alloc]init];
                        loginUser.username=userId;
                        loginUser.pwd=pwdTextField.text;
                        loginUser.expiredtime=ExpiredTime;
                        loginUser.sesion=Session;
                        loginUser.isuse=YES;
                        
//                        if ([UserInfoOpr existModelWithUsername:userId]) {
//                            [UserInfoOpr updateModel:loginUser];
//                        }
//                        else{
//                            [UserInfoOpr insertModel:loginUser];
//                        }
                        NSData *savedata = [NSKeyedArchiver archivedDataWithRootObject:loginUser];
                        [defaults setObject:savedata forKey:DE_Save_userInfo];
                        [defaults setBool:YES forKey:DE_Save_requestOnlinelive];
                        [defaults setBool:YES forKey:DE_Save_requestOndemand];
                        [defaults setBool:YES forKey:DE_Save_isLogin];
                        [defaults synchronize];
                        [self appdelegate].userInfo=loginUser;
                        
                        //进入主页面
//                        if (_loginSuccessBlock) {
//                            self.loginSuccessBlock();
//                        }
                        [self.delegate loinSuccess];
                    }
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"---getEpgAuth---error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络错误,请确保是否是重庆联通网络"];
    }];
    
    
}

@end
