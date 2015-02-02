//
//  ShowModel.m
//  SMedical
//
//  Created by _SS on 14/12/11.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "ShowModel.h"

@implementation ShowModel

- (id)initDocumentInfoWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = [dic objectForKey:@"name"];
        self.date = [dic objectForKey:@"date"];
        self.category = [dic objectForKey:@"category"];
        self.use = [dic objectForKey:@"use"];
        self.style = [dic objectForKey:@"style"];
    }
    return self;
}

- (id)initImageInfoWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = [dic objectForKey:@"name"];
        self.date = [dic objectForKey:@"date"];
        self.category = [dic objectForKey:@"category"];
        self.use = [dic objectForKey:@"use"];
        self.number = [dic objectForKey:@"number"];
    }
    return self;
}

- (instancetype)initDoctorAdviceInfoWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = [dic objectForKey:@"name"];
        self.date = [dic objectForKey:@"date"];
        self.category = [dic objectForKey:@"category"];
        self.state = [dic objectForKey:@"state"];
    }
    return self;
}

- (instancetype)initTreatmentProgressInfoWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = [dic objectForKey:@"name"];
        self.date = [dic objectForKey:@"date"];
        self.category = [dic objectForKey:@"category"];
        self.state = [dic objectForKey:@"state"];
    }
    return self;
}

- (instancetype)initClinicalTaskInfoWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = [dic objectForKey:@"name"];
        self.date = [dic objectForKey:@"date"];
        self.state = [dic objectForKey:@"state"];
    }
    return self;
}

@end
