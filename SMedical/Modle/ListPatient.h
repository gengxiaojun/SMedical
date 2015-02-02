//
//  ListPatient.h
//  SMedical
//
//  Created by _SS on 14/11/20.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//  personal main detail showPatientInfoModel

#import <Foundation/Foundation.h>

@interface ListPatient : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cause;
@property (nonatomic, strong) NSString *room;
@property (nonatomic, strong) NSString *isWaring;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *bloodType;
@property (nonatomic, strong) NSString *birthDate;
@property (nonatomic, strong) NSString *isDiagnosis;
@property (nonatomic, strong) NSString *isBussesInsurance;
@property (nonatomic, strong) NSString *admissionDate;
@property (nonatomic, strong) NSString *stayDate;
@property (nonatomic, strong) NSString *sugeryAfter;
@property (nonatomic, strong) NSArray *focus;

- (instancetype)initMainViewWithDic:(NSDictionary *)dic;
- (instancetype)initPersonalViewWithDic:(NSDictionary *)dic;
@end

