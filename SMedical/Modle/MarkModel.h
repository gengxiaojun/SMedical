//
//  MarkModel.h
//  SMedical
//
//  Created by _SS on 14/12/4.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//  标注里颜色和标注内容的model

#import <Foundation/Foundation.h>

@interface MarkModel : NSObject
@property (nonatomic, strong) NSString *markColor;
@property (nonatomic, strong) NSString *markInstructions;

- (id)initWithDic:(NSMutableDictionary *)dic;
@end
