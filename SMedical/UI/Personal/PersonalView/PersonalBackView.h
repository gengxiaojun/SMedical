//
//  PersonalBackView.h
//  SMedical
//
//  Created by _SS on 14/12/15.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListPatient.h"
@interface PersonalBackView : UIScrollView
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *personalTable;
@property (nonatomic, strong) UIView *selectView;

@property (nonatomic, strong) ListPatient *patient;

@end
