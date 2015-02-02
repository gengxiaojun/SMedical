//
//  LoginViewController.m
//  SMedical
//
//  Created by _SS on 14/11/25.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "LoginViewController.h"
#import "Header.h"
#import "ActivityIndicatorView.h"
#import "GesturePasswordController.h"
#import "KeychainItemWrapper.h"
#import "ImageManager.h"
@interface LoginViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    BOOL _isNewUser;
}
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UIImageView *userImageView;
@property (strong, nonatomic) UITextField *userTextField;
@property (strong, nonatomic) UIImageView *passwordImageView;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIButton *loginButton;
@property (nonatomic, strong) UIButton *forgetPasswordButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatSubView];
    self.userTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    // 手动调用NSUserDefaults去执行同步synchronize的动作，以及时保存（修改了的）数据。
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"oldUserName"]) {
        [[NSUserDefaults standardUserDefaults] setObject:USERNAME_TEST forKey:@"oldUserName"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLogin"];
        // 清空手势
        KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
        [keychin resetKeychainItem];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)creatSubView{
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT / 4)];
    [self.view addSubview:self.logoImageView];
//    NSString *imagePath  = [[NSBundle mainBundle] pathForResource:@"zejialogo" ofType:@"png"];
//    [[ImageManager sharedShower] scaleToSize:[UIImage imageWithContentsOfFile:imagePath] size:self.logoImageView.frame.size];
//    self.logoImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    self.logoImageView.backgroundColor = [UIColor yellowColor];
    
    self.userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, SCREENHEIGHT / 4 + 5 , SCREENHEIGHT / 8 - 10, SCREENHEIGHT / 8 - 10)];
    [self.view addSubview:self.userImageView];
    self.userImageView.backgroundColor = [UIColor yellowColor];
    
    self.userTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREENHEIGHT / 8 - 10 + 20, SCREENHEIGHT / 4 + 5 ,SCREENWIDTH - ( SCREENHEIGHT / 8 - 10 + 20 ) - 10, SCREENHEIGHT / 8 - 10)];
    [self.view addSubview:self.userTextField];
    self.userTextField.backgroundColor = [UIColor greenColor];
    self.userTextField.placeholder = @"请输入工号或者手机号";
    
    self.passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, SCREENHEIGHT / 4 + 5 + 10 +  SCREENHEIGHT / 8 - 10 , SCREENHEIGHT / 8 - 10 , SCREENHEIGHT / 8 - 10)];
    [self.view addSubview:self.passwordImageView];
    self.passwordImageView.backgroundColor = [UIColor yellowColor];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREENHEIGHT / 8 - 10 + 20,  SCREENHEIGHT / 4 + 5 + 10 +  SCREENHEIGHT / 8 - 10 ,SCREENWIDTH - ( SCREENHEIGHT / 8 - 10 + 20 ) - 10, SCREENHEIGHT / 8 - 10)];
    [self.view addSubview:self.passwordTextField];
    self.passwordTextField.backgroundColor = [UIColor greenColor];
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.secureTextEntry = YES;
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loginButton.frame = CGRectMake(10, SCREENHEIGHT / 4 * 2 + 5 , SCREENWIDTH - 20, SCREENHEIGHT / 8 - 10);
    [self.view addSubview:self.loginButton];
    self.loginButton.backgroundColor = [UIColor greenColor];
    [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchDown];
    [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    self.loginButton.tintColor = [UIColor blackColor];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:19.0];
    
    self.forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.forgetPasswordButton.frame = CGRectMake(SCREENWIDTH / 2 , SCREENHEIGHT / 4 * 2 + 15 +(SCREENHEIGHT / 8 - 10), SCREENWIDTH / 2 - 10 , SCREENHEIGHT / 8 - 10);
    [self.view addSubview:self.forgetPasswordButton];
    self.forgetPasswordButton.backgroundColor = [UIColor greenColor];
    [self.forgetPasswordButton addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchDown];
    self.forgetPasswordButton.tintColor = [UIColor blackColor];
    self.forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    self.forgetPasswordButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark - 回收键盘

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

#pragma mark -
#pragma makr - 登陆
- (void )login:(id)sender {
    [self.userTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    if (!(self.userTextField.text && self.userTextField.text.length > 0)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }else if (![self.userTextField.text isEqualToString:USERNAME_TEST]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的用户名不存在" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
    if (!(self.passwordTextField.text && self.passwordTextField.text.length > 0) && [self.userTextField.text isEqualToString:USERNAME_TEST]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }else if (![self.passwordTextField.text isEqualToString:USERPASSWORD_TEST]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的密码错误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }
#pragma mark -
#pragma mark - 测试登陆
    if ([self.userTextField.text isEqualToString:USERNAME_TEST] && [self.passwordTextField.text isEqualToString:USERPASSWORD_TEST] ) {
        ActivityIndicatorView *activityIndicatorView = [[ActivityIndicatorView alloc] init];
        activityIndicatorView.lableTitle = @"登录中,请稍后...";
        [activityIndicatorView creatSubviewActivityIndicatorView];
        __block int timeout = 1.5; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), (uint64_t) (1.0*NSEC_PER_SEC), 0); //每秒执行
        
        dispatch_source_set_event_handler(_timer, ^{
            
            if(timeout<=0){ //倒计时结束，关闭
                
                dispatch_source_cancel(_timer);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [activityIndicatorView endAcIndicator];
                    //  验证成功后调用手势密码
                    GesturePasswordController *gesturePwController = [[GesturePasswordController alloc] init];
                    gesturePwController.isNewUser = _isNewUser;
                    [self presentViewController:gesturePwController animated:YES completion:nil];
                });
                if ([self.userTextField.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"oldUserName"]]) {
                    _isNewUser = NO;
                }else{
                    _isNewUser = YES;
                }
                if (self.presentingViewController) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }

            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
                
                timeout--;
            }
            
        });
        
        dispatch_resume(_timer);
    }
}

- (void)forgetPassword:(id)sender {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"找回密码请拨打客服电话 185-1342-4723" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    alertView.tag = ALERT_TELPHONRTAG;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == ALERT_TELPHONRTAG) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://18513424723"]];
        }else{
            return;
        }
    }
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

@end
