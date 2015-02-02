//
//  SettingViewController.m
//  GesturePasswordTest
//
//  Created by _SS on 14/11/13.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "SettingViewController.h"
#import "GesturePasswordController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       // Do any additional setup after loading the view from its nib.
}
- (IBAction)set:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"setting" forKey:@"setting"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    GesturePasswordController *gesturePasswordController = [[GesturePasswordController alloc] init];
    [self presentViewController:gesturePasswordController animated:YES completion:nil];
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
