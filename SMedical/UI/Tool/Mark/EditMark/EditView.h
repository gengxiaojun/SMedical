//
//  EditView.h
//  SMedical
//
//  Created by _SS on 14/12/5.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkModel.h"
@interface EditView : UIView

@property (nonatomic, strong) MarkModel *markModel;
@property (nonatomic, strong) UITextField *markTextField;

@end
