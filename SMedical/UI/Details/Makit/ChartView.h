//
//  ChartView.h
//  SMedical
//
//  Created by _SS on 15/1/26.
//  Copyright (c) 2015年 shanshan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartView : UIScrollView
@property (nonatomic, strong) UIImageView *pressureView;    // 血压
@property (nonatomic, strong) UIScrollView *pressureScrollView;


@property (nonatomic, strong) UIImageView *temperatureView; // 体温
@property (nonatomic, strong) UIScrollView *temperatureScrollView;


@property (nonatomic, strong) UIImageView *pulseView;       // 脉搏
@property (nonatomic, strong) UIScrollView *pulseScrollView;

@end

