//
//  DataManager.h
//  SMedical
//
//  Created by _SS on 14/11/20.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
@interface DataManager : NSObject

+ (DataManager *)shareInstance;

- (NSMutableArray *)selectPatientWithRoomA;
- (NSMutableArray *)selectPatientWithRoomB;

- (NSMutableArray *)selectAllFocusPatients;

- (NSMutableArray *)selectPatientWithName:(NSString *)name;

- (NSMutableArray *)selectAllPatients;

- (void)createPersonalcommentTable;
- (void)insertWithPatientName:(NSString *)patientName content:(NSString *)content;
- (NSString *)showPersonalcommentTableContentWithPatientName:(NSString *)patientname;
- (void)removeData4PersonalcommentTableContentWithPatientName:(NSString *)patientname;

- (void)createClinicalTaskTableWithPatientName:(NSString *)patientName;
- (void)insertWithPatientName:(NSString *)patientName dic:(NSDictionary *)dic;
- (NSMutableDictionary *)showClinicalTaskTableContentWithPatientName:(NSString *)patientname;

//- (void)createRecordContentTabe;
//- (void)insertRecordContentTabeWithName:(NSString *)name count:(CGFloat)count;
//- (NSString *)selectContentFromRecordTableWithName:(NSString *)name;
@end
