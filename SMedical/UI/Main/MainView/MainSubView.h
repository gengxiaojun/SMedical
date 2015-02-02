//
//  MainSubView.h
//  SMedical
//
//  Created by _SS on 14/12/2.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainSubView : UIView

@property (nonatomic, strong, readwrite) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UISegmentedControl *segmentCtr;

@end
