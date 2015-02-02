//
//  NameManager.m
//  SMedical
//
//  Created by _SS on 14/12/3.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "NameManager.h"

@implementation NameManager

+ (instancetype)sharedShower{
    static NameManager *shower = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shower = [[NameManager alloc] init];
    });
    return shower;
}

- (int)convertToInt:(NSString*)strtemp {
    int strlength = 0;
    char *p = (char *)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0 ; i < [strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i ++) {
        if (*p) {
            p ++;
            strlength ++;
        }
        else {
            p ++;
        }
    }
    return (strlength + 1) / 2;
}

- (NSString *)letter4name:(NSString *)name{
    NSMutableString *aName = [[NSMutableString alloc] initWithString:name];
    int number = [self convertToInt:aName];
    CFRange range = CFRangeMake(0, number);
    if ( ! CFStringTransform((__bridge CFMutableStringRef) aName, &range, kCFStringTransformMandarinLatin, NO) ||
        ! CFStringTransform((__bridge CFMutableStringRef) aName, &range, kCFStringTransformStripDiacritics, NO)) {
        return @"";
    }
    NSString *result;
    result = [aName stringByReplacingOccurrencesOfString:@" " withString:@""];
    return result;
    
}

@end
