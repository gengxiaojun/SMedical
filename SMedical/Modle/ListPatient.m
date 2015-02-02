//
//  ListPatient.m
//  SMedical
//
//  Created by _SS on 14/11/20.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "ListPatient.h"

@implementation ListPatient

- (instancetype)initMainViewWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = [dic objectForKey:@"name"];
        self.cause = [dic objectForKey:@"cause"];
        self.room = [dic objectForKey:@"room"];
        self.isWaring = [dic objectForKey:@"isWarning"];
    }
    return self;
}

- (instancetype)initPersonalViewWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = [dic objectForKey:@"name"];
        self.cause = [dic objectForKey:@"cause"];
        self.room = [dic objectForKey:@"room"];
        self.isWaring = [dic objectForKey:@"isWarning"];
        self.bloodType = [dic objectForKey:@"bloodType"];
        self.birthDate = [dic objectForKey:@"birthDate"];
        self.isDiagnosis = [dic objectForKey:@"isDiagnosis"];
        self.isBussesInsurance = [dic objectForKey:@"isBussesInsurance"];
        self.age = [dic objectForKey:@"age"];
        self.stayDate = [dic objectForKey:@"stayDate"];
        self.sugeryAfter = [dic objectForKey:@"sugeryAfter"];
        self.admissionDate = [dic objectForKey:@"admissionDate"];
    }
    return self;
}

@end
