//
//  NameManager.h
//  SMedical
//
//  Created by _SS on 14/12/3.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NameManager : NSObject

+ (instancetype)sharedShower;

- (NSString *)letter4name:(NSString *)name;

@end
