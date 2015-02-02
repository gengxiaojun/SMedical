//
//  ActivityIndicatorView.m
//  Medical
//
//  Created by _SS on 14/11/12.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityIndicatorView.h"
#import "Header.h"

@interface ActivityIndicatorView ()
{
    UIActivityIndicatorView *_activityIndicatorView;
    UIView *_view;
}
@end

@implementation ActivityIndicatorView

- (void)creatSubviewActivityIndicatorView{
    _view = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREENWIDTH, SCREENHEIGHT)];
    _view.backgroundColor = [UIColor blackColor];
    _view.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:_view];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    _activityIndicatorView.center = _view.center;
    _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [_view addSubview:_activityIndicatorView];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 39.0f)];
    CGPoint point = CGPointMake(_view.center.x, _view.center.y + 25);
    titleLable.center = point;
    titleLable.text = _lableTitle;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = [UIColor whiteColor];
    titleLable.font = [UIFont systemFontOfSize:16.0];
    [_view addSubview:titleLable];
    
    [_activityIndicatorView startAnimating];
}

- (void)endAcIndicator{
    [_view removeFromSuperview];
    [_activityIndicatorView stopAnimating];
}
@end
