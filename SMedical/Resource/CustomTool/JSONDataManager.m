//
//  JSONDataManager.m
//  SMedical
//
//  Created by _SS on 14/11/21.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "JSONDataManager.h"

@implementation JSONDataManager
+ (JSONDataManager *)shareInstance{
    
    static JSONDataManager *shower = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shower = [[JSONDataManager alloc] init];
    });
    return shower;
}

- (id)troubleInfoWithName:(NSString *)name{
    id responseJSONResult = [self InfoWithName:name];
    id demandResult = [responseJSONResult objectForKey:@"_trouble"];
    return demandResult;
}

- (id)documentInfoWithName:(NSString *)name{
    id responseJSONResult = [self InfoWithName:name];
    id demandResult = [responseJSONResult objectForKey:@"_document"];
    return demandResult;
}

- (id)imageInfoWithName:(NSString *)name{
    id responseJSONResult = [self InfoWithName:name];
    id demandResult = [responseJSONResult objectForKey:@"_image"];
    return demandResult;
}

- (id)doctorAdciceInfoWithName:(NSString *)name{
    id responseJSONResult = [self InfoWithName:name];
    id demandResult = [responseJSONResult objectForKey:@"_doctorAdvice"];
    return demandResult;
}

- (id)treatmentProgressInfoWithName:(NSString *)name{
    id responseJSONResult = [self InfoWithName:name];
    id demandResult = [responseJSONResult objectForKey:@"_treatmentProgress"];
    return demandResult;
}

- (id)clinicalTaskInfoWithName:(NSString *)name{
    id responseJSONResult = [self InfoWithName:name];
    id demandResult = [responseJSONResult objectForKey:@"_clinicalTask"];
    return demandResult;
}

- (id)dataInfoWithName:(NSString *)name{
    id responseJSONResult = [self InfoWithName:name];
    id demandResult = [responseJSONResult objectForKey:@"_data"];
    return demandResult;
}

- (id)InfoWithName:(NSString *)name{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Data"
                                                     ofType:@"json"];
    
    NSData *theData = [NSData dataWithContentsOfFile:path];
    id responseJSON = [NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingMutableContainers error:nil];

    id responseJSONResult = [responseJSON objectForKey:name];
    return responseJSONResult;
}

@end
