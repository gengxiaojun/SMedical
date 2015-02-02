//
//  ShowTableViewCell.h
//  SMedical
//
//  Created by _SS on 14/12/11.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//  doctorAdvice treatmentProgress clinicalTask Cell

#import <UIKit/UIKit.h>
#import "ShowModel.h"

@interface ShowTableViewCell : UITableViewCell
@property (nonatomic, strong) ShowModel *doctorAdviceModel;
@property (nonatomic, strong) ShowModel *treatmentProgressModel;
@property (nonatomic, strong) ShowModel *clinicalTaskModel;

@end
