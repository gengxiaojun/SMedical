//
//  ChartView.m
//  SMedical
//
//  Created by _SS on 15/1/26.
//  Copyright (c) 2015年 shanshan. All rights reserved.
//

#import "ChartView.h"
#import "Header.h"
@implementation ChartView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView{
    self.backgroundColor = [UIColor yellowColor];
    self.contentSize = CGSizeMake(SCREENWIDTH, (SCREENHEIGHT_INBAR - 60) / 2 * 3 + 35 + 40 * 2 + 10);
    
    UILabel *pressureLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, SCREENWIDTH - 70, 35)];
    pressureLabel.text = @"收缩压/舒张压";
    [self addSubview:pressureLabel];
    
    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,(SCREENHEIGHT_INBAR - 60) / 2 + 35, SCREENWIDTH - 70, 35)];
    temperatureLabel.text = @"体温(35.00 - 38.6 ℃)";
    [self addSubview:temperatureLabel];
    
    UILabel *pulseLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,2 *(SCREENHEIGHT_INBAR - 60) / 2 + 35 + 40, SCREENWIDTH - 70, 35)];
    pulseLabel.text = @"脉搏(50.00 - 120.00 bpm)";
    [self addSubview:pulseLabel];

    self.pressureScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(60, 35, SCREENWIDTH - 70, (SCREENHEIGHT_INBAR - 60 )/ 2)];
    self.pressureScrollView.contentSize = CGSizeMake(SCREENWIDTH * 2, (SCREENHEIGHT_INBAR - 60) / 2);
    [self addSubview:self.pressureScrollView];
    self.pressureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1.8 * SCREENWIDTH,  (SCREENHEIGHT_INBAR - 60) / 2)];
    [self.pressureScrollView addSubview:self.pressureView];
    
    self.temperatureScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(60, (SCREENHEIGHT_INBAR - 60) / 2 + 40 + 35, SCREENWIDTH - 70, (SCREENHEIGHT_INBAR - 60 )/ 2)];
    self.temperatureScrollView.contentSize = CGSizeMake(SCREENWIDTH * 2, (SCREENHEIGHT_INBAR - 60) / 2);
    [self addSubview:self.temperatureScrollView];
    self.temperatureView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 1.8 * SCREENWIDTH,  (SCREENHEIGHT_INBAR - 60) / 2)];
    [self.temperatureScrollView addSubview:self.temperatureView];
    
    self.pulseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(60, 2 * (SCREENHEIGHT_INBAR - 60) / 2 + 40 + 35 + 40, SCREENWIDTH - 70, (SCREENHEIGHT_INBAR - 60 )/ 2)];
    self.pulseScrollView.contentSize = CGSizeMake(SCREENWIDTH * 2, (SCREENHEIGHT_INBAR - 60) / 2);
    [self addSubview:self.pulseScrollView];
    self.pulseView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1.8 * SCREENWIDTH,  (SCREENHEIGHT_INBAR - 60) / 2)];
    [self.pulseScrollView addSubview:self.pulseView];

    self.pressureView.backgroundColor = [UIColor redColor];
    self.temperatureView.backgroundColor = [UIColor grayColor];
    self.pulseView.backgroundColor = [UIColor greenColor];
    
}
   @end
