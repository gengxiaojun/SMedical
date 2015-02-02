//
//  ActivityIndicatorView.h
//  Medical
//
//  Created by _SS on 14/11/12.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityIndicatorView : NSObject

@property (strong, nonatomic) NSString *lableTitle;

- (void)creatSubviewActivityIndicatorView;
- (void)endAcIndicator;
@end
