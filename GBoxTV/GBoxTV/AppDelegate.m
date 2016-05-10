//
//  AppDelegate.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "enmuHelper.h"
#import "LiveViewController.h"
#import "HistoricalPlayViewController.h"
#import "MyViewController.h"

@interface AppDelegate ()<LoginViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    _mainStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
     [self writeTerminalFlag];
    
    //获取是否登录
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL isFirstLoad=[[defaults objectForKey:DE_Save_isFirstLoad] boolValue];
    //必须先登录授权默认为登出
    BOOL isLogin=[[defaults objectForKey:DE_Save_isLogin] boolValue];
    NSData *logindata=[defaults objectForKey:DE_Save_userInfo];
    if (logindata) {
        _userInfo=[NSKeyedUnarchiver unarchiveObjectWithData:logindata];
    }
    
    ////是否首次启动，首次启动
    if (!isLogin||!isFirstLoad||_userInfo==nil) {
        if (!isFirstLoad) {
            [defaults setBool:YES forKey:DE_Save_isFirstLoad];
            isFirstLoad=YES;
        }
        
        LoginViewController *loginvc=[_mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        [loginvc loginSuccess:^{
//            [self createMainTabPage];
//            self.window.rootViewController=_mainTabbarCon;
//
//        }];
        loginvc.delegate=self;
        
        if (_loginNavCon==nil) {
            _loginNavCon=[[UINavigationController alloc]initWithRootViewController:loginvc];
        }
        
        self.window.rootViewController=_loginNavCon;
        
    }
    else{
        //进入主界面
        [self createMainTabPage];
        self.window.rootViewController=_mainTabbarCon;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.gf.GBoxTV" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GBoxTV" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GBoxTV.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark-私有方法
-(void)writeTerminalFlag{
    //获取设备类型
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _terminalFlag= [defaults integerForKey:DE_Save_TerminalFlag];
    if (_terminalFlag) {
        NSLog(@"-------->存在TerminalFlag=%ld",_terminalFlag);
        
        if (_terminalFlag==PAD){
            _terminalFlag=PAD;
        }
        else{
            _terminalFlag=mobile;
        }
        
    }
    else{
        // 取设备类型
        UIUserInterfaceIdiom df=[[UIDevice currentDevice]userInterfaceIdiom];
        if (df==UIUserInterfaceIdiomPad){
            _terminalFlag=PAD;
            
        }
        else{
            _terminalFlag=mobile;
        }
        [defaults setInteger:_terminalFlag forKey:DE_Save_TerminalFlag];
        //让数据立刻保存
        [defaults synchronize];
        
    }
}

#pragma mark-初始化主界面
-(void)createMainTabPage{
    if (_mainTabbarCon!=nil) {
        _mainTabbarCon.selectedIndex=0;
        return;
    }
    
    LiveViewController *livevc=[_mainStoryboard instantiateViewControllerWithIdentifier:@"LiveViewController"];
    livevc.title=@"直播";
    HistoricalPlayViewController *historyvc=[_mainStoryboard instantiateViewControllerWithIdentifier:@"HistoricalPlayViewController"];
    historyvc.title=@"历史播放";
    MyViewController *myvc=[_mainStoryboard instantiateViewControllerWithIdentifier:@"MyViewController"];
    myvc.title=@"我的";
    
    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:livevc];
    [nav1.tabBarItem setImage:[UIImage imageNamed:@"直播底部图标"]];
    [nav1.tabBarItem setSelectedImage:[UIImage imageNamed:@"直播底部图标高亮"]];
    [nav1.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],NSForegroundColorAttributeName, nil] forState:UIControlStateHighlighted];
    UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:historyvc];
    [nav2.tabBarItem setImage:[UIImage imageNamed:@"历史播放图标灰色"]];
    [nav2.tabBarItem setSelectedImage:[UIImage imageNamed:@"历史播放高亮"]];
    
    [nav2.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],NSForegroundColorAttributeName, nil] forState:UIControlStateHighlighted];
    UINavigationController *nav3=[[UINavigationController alloc]initWithRootViewController:myvc];
    [nav3.tabBarItem setImage:[UIImage imageNamed:@"智慧沃家底部图标"]];
    [nav3.tabBarItem setSelectedImage:[UIImage imageNamed:@"智慧沃家底部图标高亮"]];
    
    [nav3.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],NSForegroundColorAttributeName, nil] forState:UIControlStateHighlighted];
    
    if (_mainTabbarCon==nil) {
        _mainTabbarCon=[[UITabBarController alloc]init];
    }
    
    _mainTabbarCon.tabBar.tintColor=[UIColor orangeColor];
    _mainTabbarCon.viewControllers=@[nav1,nav2,nav3];
    _mainTabbarCon.selectedIndex=0;
    
}

#pragma mark-loginviewdelegate
-(void)loinSuccess{
    [self createMainTabPage];
     self.window.rootViewController=_mainTabbarCon;
}
@end
