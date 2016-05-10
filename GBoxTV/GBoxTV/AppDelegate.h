//
//  AppDelegate.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UserInfoModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property(nonatomic,retain)UINavigationController *loginNavCon;//登录界面
@property(nonatomic,retain)UITabBarController *mainTabbarCon;//主界面
@property(nonatomic,retain)UserInfoModel *userInfo;//用户信息
@property(nonatomic,retain)UIStoryboard *mainStoryboard;
@property(nonatomic,assign)NSInteger terminalFlag;//终端标示


-(void)createMainTabPage;
@end

