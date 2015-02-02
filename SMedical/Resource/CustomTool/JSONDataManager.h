//
//  JSONDataManager.h
//  SMedical
//
//  Created by _SS on 14/11/21.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONDataManager : NSObject
@property (nonatomic, retain) NSArray *doctor_adviceKey;

+ (JSONDataManager *)shareInstance;

// Data.json数据的解析
- (id)doctorAdciceInfoWithName:(NSString *)name;
- (id)troubleInfoWithName:(NSString *)name;
- (id)documentInfoWithName:(NSString *)name;
- (id)imageInfoWithName:(NSString *)name;
- (id)treatmentProgressInfoWithName:(NSString *)name;
- (id)clinicalTaskInfoWithName:(NSString *)name;
- (id)dataInfoWithName:(NSString *)name;

// TestResults.json数据的解析

@end
