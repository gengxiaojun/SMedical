//
//  ShowModel.h
//  SMedical
//
//  Created by _SS on 14/12/11.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//  show Document Image DoctorAdvice TreatmentProgress ClinicalTask Model

#import <Foundation/Foundation.h>

@interface ShowModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *use;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *finishDate;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *style;

- (instancetype)initDocumentInfoWithDic:(NSDictionary *)dic;
- (instancetype)initImageInfoWithDic:(NSDictionary *)dic;
- (instancetype)initDoctorAdviceInfoWithDic:(NSDictionary *)dic;
- (instancetype)initTreatmentProgressInfoWithDic:(NSDictionary *)dic;
- (instancetype)initClinicalTaskInfoWithDic:(NSDictionary *)dic;

@end
