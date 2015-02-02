//
//  AppDelegate.m
//  SMedical
//
//  Created by _SS on 14/11/18.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Header.h"
#import "GesturePasswordController.h"
#import "MainViewController.h"
#import "LoginViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self copyDatabaseIfNeed];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 第一次登录需要用户名密码登录,已经登录过的再次使用调用手势密码
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"]) {
        GesturePasswordController *rootVC = [[GesturePasswordController alloc] init];
        self.window.rootViewController = rootVC;

    }else{
        [self goLoginView];
    }
    return YES;
}

- (void)copyDatabaseIfNeed{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *dbPath = [DoucumentDir stringByAppendingPathComponent:@"mydatabase.sqlite"];
    if (![fileManager fileExistsAtPath:dbPath]) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mydatabase.sqlite"];
        if (![fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error]) {
            NSLog(@"未能创建可读写的数据库,原因是：%@",[error localizedDescription]);
        }
    }
}

- (void)goMainView{
    MainViewController *mainVC = [[MainViewController alloc] init];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = mainNC;
}

- (void)goLoginView{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    self.window.rootViewController = loginVC;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"]) {
        GesturePasswordController *rootVC = [[GesturePasswordController alloc] init];
        self.window.rootViewController = rootVC;
    }else{
        [self goLoginView];

    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
