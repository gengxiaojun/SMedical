//
//  DataArchive.h
//  SMedical
//
//  Created by _SS on 14/12/18.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataArchive : NSObject

+ (instancetype)sharedShower;

- (void)archiveDetalsShowWithDic:(NSDictionary *)dic;
- (id)unArchiveDetalsShowWithKey:(NSString *)key;
@end
