//
//  GesturePasswordController.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com


#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>
#import "GesturePasswordController.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "KeychainItemWrapper.h"
#import "AppDelegate.h"
#import "Header.h"
@interface GesturePasswordController ()<UIAlertViewDelegate,UIAlertViewDelegate>
{
    BOOL _haveGesture;
    NSInteger _count;
}

@property (nonatomic,strong) GesturePasswordView * gesturePasswordView;
@end

@implementation GesturePasswordController {
    NSString * previousString;
    NSString * password;
}
@synthesize gesturePasswordView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _count = 0;
    previousString = [NSString string];
    // 钥匙串 如果密码是空的 就进行手势重置 否则就进行手势验证
    if (![self exist] ) {
        [self reset];
        
    }else{
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"setting"]) {
            [self reset];

        }else{
            [self verify];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 验证手势密码
- (void)verify{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesturePasswordView.tentacleView setRerificationDelegate:self];
    [gesturePasswordView.tentacleView setStyle:1];
    [gesturePasswordView setGesturePasswordDelegate:self];
    [gesturePasswordView.forgetButton setHidden:NO];
    [self.view addSubview:gesturePasswordView];
}

#pragma mark - 重置手势密码
- (void)reset{
    if ([self exist]) {

        gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [gesturePasswordView.tentacleView setResetDelegate:self];
        [gesturePasswordView.tentacleView setStyle:2];
        [self.view addSubview:gesturePasswordView];
    }else{
        [self showAlertView:@"为了您的账户安全,请设置手势密码" tag:101];
        gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [gesturePasswordView.tentacleView setResetDelegate:self];
        [gesturePasswordView.tentacleView setStyle:2];
        [self.view addSubview:gesturePasswordView];
    }
}
- (void)showAlertView:(NSString *)alter tag:(NSInteger)tag{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:alter delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alterView.tag = tag;
    [alterView show];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"setting"]) {
        gesturePasswordView.state.text = @"请输入新的密码";
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"setting"];

    }else{
        gesturePasswordView.state.text = @"请输入密码";
        
    }

}

#pragma mark - 判断是否已存在手势密码
- (BOOL)exist{
    if (self.isNewUser) {
        [self clear];
    }
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    password = [keychin objectForKey:(__bridge id)kSecValueData];
    if ([password isEqualToString:@""])return NO;
    return YES;
}

#pragma mark - 清空记录
- (void)clear{
    // 清空手势
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    [keychin resetKeychainItem];
}


#pragma mark - 忘记手势密码
- (void)forget{
    [self clear];
    [self showAlertView:@"忘记密码需要重新登陆" tag:100];
    // 忘记手势密码需要重新登录
    // 调用登录界面 用alter的代理方法
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100 || alertView.tag == 102) {
        if (buttonIndex == 0) {
            if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(goLoginView)]) {
                [[UIApplication sharedApplication].delegate performSelector:@selector(goLoginView)];

            }
        }
    }
}
#pragma mark - 手势审核结果
- (BOOL)verification:(NSString *)result{
    _count ++;
    NSInteger count = 5-_count;
    if ([result isEqualToString:password]) {
        [gesturePasswordView.state setTextColor:RGBACOLOR(2, 174, 240, 1)];
        [gesturePasswordView.state setText:@"输入正确"];
        // 进入到主页面面
        [[UIApplication sharedApplication].delegate performSelector:@selector(goMainView)];

        return YES;
    }else{
    if ( count == 4) {
        [self showAlertView:@"手势密码错误,密码输入不能超过5次" tag:103];
               
    }else if (count < 4 && count > 0) {
        [gesturePasswordView.state setTextColor:[UIColor redColor]];
        [gesturePasswordView.state setText:[[NSString alloc] initWithFormat:@"手势密码错误,还可输入%ld",count]];
    }else{
        [self clear];
        [self showAlertView:@"已经超过输入次数,需要重新登陆" tag:102];

    }
        return NO;
    }
}

#pragma mark - 重置密码结果
- (BOOL)resetPassword:(NSString *)result{

    if ([previousString isEqualToString:@""]) {
        previousString=result;
        [gesturePasswordView.tentacleView enterArgin];
        [gesturePasswordView.state setTextColor:RGBACOLOR(2, 174, 240, 1)];
        [gesturePasswordView.state setText:@"请验证输入密码"];
        return YES;
    }
    else {
        if ([result isEqualToString:previousString]) {
            KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
            [keychin setObject:@"<帐号>" forKey:(__bridge id)kSecAttrAccount];
            [keychin setObject:result forKey:(__bridge id)kSecValueData];
            [gesturePasswordView.state setTextColor:RGBACOLOR(2, 174, 240, 1)];
            [gesturePasswordView.state setText:@"已保存手势密码"];
            [[NSUserDefaults standardUserDefaults] setObject:@"isLogin" forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            // 进入到主页面
            [[UIApplication sharedApplication].delegate performSelector:@selector(goMainView)];
            return YES;
        }
        else{
            previousString =@"";
            [gesturePasswordView.state setTextColor:[UIColor redColor]];
            [gesturePasswordView.state setText:@"两次密码不一致，请重新输入"];
            return NO;
        }
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
