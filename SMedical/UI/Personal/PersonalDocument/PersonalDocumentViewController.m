//
//  PersonalDocumentViewController.m
//  SMedical
//
//  Created by _SS on 14/12/12.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "PersonalDocumentViewController.h"
#import "Header.h"
@interface PersonalDocumentViewController (){
    UIImageView *_showImageView;
    UIScrollView * _showScrollView;
}

@end

@implementation PersonalDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.documentModel.style isEqualToString:@"1"]) {
        self.navigationItem.title = [[NSString alloc] initWithFormat:@"%@(页码 1 / 1)",self.documentModel.name];
        _showImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_showImageView];
        _showImageView.backgroundColor = [UIColor yellowColor];
    }else{
        self.navigationItem.title = self.documentModel.name;
        if ([self.documentModel.style isEqualToString:@"2"]) {
            _showScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT * 2)];
            aImageView.backgroundColor = [UIColor blueColor];
            _showScrollView.showsVerticalScrollIndicator = YES;
            _showScrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT * 2);
            [_showScrollView addSubview:aImageView];
            [self.view addSubview:_showScrollView];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = RGBACOLOR(0, 0, 0, 1);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = RGBACOLOR(245, 245, 245, 1);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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
