//
//  ImageManager.h
//  SMedical
//
//  Created by _SS on 14/12/3.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageManager : NSObject

+ (instancetype)sharedShower;
//  将图片压缩成指定大小
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
//  加载图片
- (UIImage *)sourceForResource:(NSString *)name ofType:(NSString *)type;

@end
