//
//  MarkTableViewCell.h
//  SMedical
//
//  Created by _SS on 14/12/4.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkModel.h"
@interface MarkTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) MarkModel *markModel;
@end
