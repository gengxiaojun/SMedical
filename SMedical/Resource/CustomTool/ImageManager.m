//
//  ImageManager.m
//  SMedical
//
//  Created by _SS on 14/12/3.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "ImageManager.h"

@implementation ImageManager

+ (instancetype)sharedShower{
    static ImageManager *shower = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shower = [[ImageManager alloc] init];
    });
    return shower;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)sourceForResource:(NSString *)name ofType:(NSString *)type{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    UIImage *aimage = [[UIImage alloc] initWithContentsOfFile:path];
    return aimage;
}
@end
