//
//  ChartViewController.m
//  SMedical
//
//  Created by _SS on 15/1/26.
//  Copyright (c) 2015年 shanshan. All rights reserved.
//

#import "ChartViewController.h"
#import "ChartView.h"
@interface ChartViewController ()<UIScrollViewDelegate>{
    ChartView *_chartView;
    
}
@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"图表";
    self.navigationItem.leftBarButtonItem.title = @"详细信息";
   // 设置背景图片
    _chartView = [[ChartView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _chartView;
    _chartView.temperatureScrollView.delegate = self;
    _chartView.pulseScrollView.delegate = self;
    _chartView.pressureScrollView.delegate = self;
}
#pragma mark - 几个滚动视图的偏移量相互影响
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_chartView.pressureScrollView]) {
        _chartView.temperatureScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
        _chartView.pulseScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
    if ([scrollView isEqual:_chartView.temperatureScrollView]) {
        _chartView.pressureScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
        _chartView.pulseScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
    if ([scrollView isEqual:_chartView.pulseScrollView]) {
        _chartView.temperatureScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
        _chartView.pressureScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
