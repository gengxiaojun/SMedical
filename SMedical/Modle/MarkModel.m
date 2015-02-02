//
//  MarkModel.m
//  SMedical
//
//  Created by _SS on 14/12/4.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "MarkModel.h"

@implementation MarkModel

- (id)initWithDic:(NSMutableDictionary *)dic{
    self = [super init];
    if (self) {
        self.markColor = [dic objectForKey:@"color"];
        self.markInstructions = [dic objectForKey:@"instructions"];
    }
    return self;
}
@end
