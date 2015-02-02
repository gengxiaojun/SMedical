//
//  DataManager.m
//  SMedical
//
//  Created by _SS on 14/11/20.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#define keyArray [[NSArray alloc]initWithObjects:@"name",@"cause",@"room",@"isWarning",@"age",@"bloodType",@"birthDate",@"isDiagnosis",@"isBussesInsurance",@"admissionDate",@"stayDate",@"surgeryAfter", nil]

#define selectArray [[NSArray alloc]initWithObjects:@"_name",@"_cause",@"_room",@"_isWarning",@"_age",@"_bloodType",@"_birthDate",@"_isDiagnosis",@"_isBussesInsurance",@"_admissionDate",@"_stayDate",@"_surgeryAfter", nil]

#import "DataManager.h"
#import "Header.h"
#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "ListPatient.h"
#import "NameManager.h"
@implementation DataManager
{
    FMDatabase *db ;
}

+ (DataManager *)shareInstance{
    static DataManager *shower = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shower = [[DataManager alloc] init];
    });
    return shower;
}

- (id)init{
    self = [super init];
    if (self) {
        db = [FMDatabase databaseWithPath:[DoucumentDir stringByAppendingPathComponent:@"mydatabase.sqlite"]];
        if (![db open]) {
            NSLog(@"Could not open db");
        }
    }
    return self;
}

- (NSMutableArray *)selectAllPatients{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:@"SELECT * From information_basic "];
        while ([rs next]) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            for (int i = 0; i < 12; i++) {
                NSString *result = [rs stringForColumn:[selectArray objectAtIndex:i]];
                [dic setObject:result forKey:[keyArray objectAtIndex:i]];
            }
            [data addObject:dic];
        }
    }
    [db close];
    return data;
}

- (NSMutableArray *)selectPatientWithName:(NSString *)name{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", name];
    NSMutableArray *AllArray = [self selectAllPatients];
    for (NSDictionary *dic in AllArray) {
        if ([[dic allValues] filteredArrayUsingPredicate:predicate].count > 0) {
            [resultArray addObject:dic];
        }
    }
    return resultArray;
}

- (NSMutableArray *)selectAllFocusPatients{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSMutableArray *allPatients = [self selectAllPatients];
    for (NSMutableDictionary *dic in allPatients) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:[dic objectForKey:@"name"]];
        if (array.count > 0) {
            [dic setObject:@"noTask" forKey:@"noTask"];
            [resultArray addObject:dic];
        }
    }
    return resultArray;
}

- (NSMutableArray *)selectPatientWithRoomA{
    NSMutableArray *resultArray = [self selectPatientWithRoom:@"病房A"];
    return resultArray;
}

- (NSMutableArray *)selectPatientWithRoomB{
    NSMutableArray *resultArray = [self selectPatientWithRoom:@"病房B"];
    return resultArray;
}

- (NSMutableArray *)selectPatientWithRoom:(NSString *)room{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSMutableArray *allPatients = [self selectAllPatients];
    for (NSDictionary *dic in allPatients) {
       NSArray *patient = @[[dic objectForKey:@"name"],[dic objectForKey:@"room"]];
        if ([patient filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF contains[cd] %@", room]].count > 0) {
            [resultArray addObject:dic];
        }else{
        }
    }
    return resultArray;
}
//#pragma mark - recordContentTable
//- (void)createRecordContentTabe{
//    if ([db open]) {
//        NSString *sql = @"CREATE TABLE IF NOT EXISTS 'recordContent'('name' TEXT NOT NULL, 'content'TEXT NOT NULL)";//sql语句
//        BOOL success = [db executeUpdate:sql];
//        if (!success) {
//            NSLog(@"error when create table ");
//        }else{
//            NSLog(@"create table succeed");
//        }
//        [db close];
//    }
//}
//
//- (void)insertRecordContentTabeWithName:(NSString *)name count:(CGFloat )count{
//    NSString *countStr = [[NSString stringWithFormat:@"%0.2f",count] stringByReplacingOccurrencesOfString:@"." withString:@":"];
//    if ([db open]) {
//        [db executeUpdate:@"INSERT INTO 'recordContent' ('name','content') VALUES (?,?);",name,countStr];
//    }
//    [db close];
//    
//}
//- (NSString *)selectContentFromRecordTableWithName:(NSString *)name{
//    NSString *resultStr = [[NSString alloc] init];
//    if ([db open]) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT * From recordContent "];
//        FMResultSet *rs = [db executeQuery:sql];
//        while ([rs next]) {
//            NSString *recordname = [rs stringForColumn:@"name"];
//            NSString *content = [rs stringForColumn:@"content"];
//            if ([recordname isEqualToString:name]) {
//                resultStr = content;
//            }
//        }
//    }
//    [db close];
//    return resultStr;
//}



#pragma mark - ClinicalTaskTable
- (void)createClinicalTaskTableWithPatientName:(NSString *)patientName{
    NSString *name = [[NameManager sharedShower] letter4name:patientName];
    if ([db open]) {
        BOOL res = [db executeUpdate:[[NSString alloc]  initWithFormat:@"CREATE TABLE IF NOT EXISTS %@_clinicalTaskTable(name text NOT NULL, date text NOT NULL, category text NOT NULL, state text NOT NULL, id text NOT NULL, content text);",name]];
        if (!res) {
            NSLog(@"error when creating db_clinicalTaskTable table");
        } else {
            NSLog(@"success to creating db_clinicalTaskTable table");
        }
        [db close];
    }
}

- (void)insertWithPatientName:(NSString *)patientName dic:(NSDictionary *)dic{
    NSString *tabelname = [[NameManager sharedShower] letter4name:patientName];
    NSMutableDictionary *mDic = [dic objectForKey:patientName];
    if ([db open]) {
        NSString *insertSql = [[NSString alloc] initWithFormat:@"INSERT INTO %@_clinicalTaskTable (name,date,category,state,id,content) VALUES ('%@','%@','%@','%@','%@','%@')",tabelname,[mDic objectForKey:@"name"],[mDic objectForKey:@"date"],[mDic objectForKey:@"category"],[mDic objectForKey:@"state"],[mDic objectForKey:@"ID"],[mDic objectForKey:@"content"]];
        [db executeUpdate:insertSql];
    }
    [db close];
}

- (NSMutableDictionary *)showClinicalTaskTableContentWithPatientName:(NSString *)patientname{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSString *name = [[NameManager sharedShower] letter4name:patientname];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:[[NSString alloc] initWithFormat:@"SELECT * From %@_clinicalTaskTable",name]];
        while ([rs next]) {
            NSString *name = [rs stringForColumn:@"name"];
            [resultDic setObject:name forKey:@"name"];
            NSString *date = [rs stringForColumn:@"date"];
            [resultDic setObject:date forKey:@"date"];
            NSString *category = [rs stringForColumn:@"category"];
            [resultDic setObject:category forKey:@"category"];
            NSString *state = [rs stringForColumn:@"state"];
            [resultDic setObject:state forKey:@"state"];
            NSString *ID = [rs stringForColumn:@"id"];
            [resultDic setObject:ID forKey:@"ID"];
            NSString *content = [rs stringForColumn:@"content"];
            [resultDic setObject:content forKey:@"content"];
        }
    }
    [db close];
    NSLog(@"%@",resultDic);
    return resultDic;
}

#pragma mark -
#pragma mark - PersonalcommentTable
- (void)createPersonalcommentTable{
    if ([db open]) {
        BOOL res = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS personalcomment(content text NOT NULL);"];
        if (!res) {
            NSLog(@"error when creating db_personalcomment table");
        } else {
            NSLog(@"success to creating db_personalcomment table");
        }
        [db close];
    }
}

- (void)insertWithPatientName:(NSString *)patientName content:(NSString *)content{
    if ([db open]) {
        [db executeUpdate:@"INSERT INTO personalcomment (content) VALUES (?);",[[NSString alloc] initWithFormat:@"%@,%@",patientName,content]];
    }
    [db close];
}

- (NSString *)showPersonalcommentTableContentWithPatientName:(NSString *)patientname{
    NSString *resultStr = [[NSString alloc] init];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:@"SELECT content From personalcomment"];
        while ([rs next]) {
            NSString *content = [rs stringForColumn:@"content"];
            NSString *patientName = [[content componentsSeparatedByString:@","] firstObject];
            if ([patientName isEqualToString:patientname]) {
                NSString *patientContent = [[content componentsSeparatedByString:@","] lastObject];
                resultStr = patientContent;
            }
        }
    }
    [db close];
    return resultStr;
}

- (void)removeData4PersonalcommentTableContentWithPatientName:(NSString *)patientname{
    if ([db open]) {
        NSString *content;
        FMResultSet *rs = [db executeQuery:@"SELECT content From personalcomment "];
        while ([rs next]) {
            content = [rs stringForColumn:@"content"];
            NSString *patientName = [[content componentsSeparatedByString:@","] firstObject];
            if ([patientName isEqualToString:patientname]) {
                BOOL operaResult = [db executeUpdate:@"DELETE FROM personalcomment WHERE content = ?",content];
                if (!operaResult) {
                    NSLog(@"error when delete db table");
                }else{
                    NSLog(@"success to delete db table");
                }
            }
        }
    }
    [db close];
}
@end
