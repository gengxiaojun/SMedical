//
//  RecordAndPlayMenager.h
//  SMedical
//
//  Created by _SS on 15/1/23.
//  Copyright (c) 2015年 shanshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
@class VoiceRecorderBaseVC;
@interface RecordAndPlayMenager : NSObject
@property (nonatomic, strong) AVAudioRecorder *recorder; // 录音器

@property (nonatomic, strong) NSString *originWav; // 录音文件名
@property (nonatomic, strong) NSString *recordFilePath; // 录音文件夹
@property (nonatomic, strong) VoiceRecorderBaseVC *recordBaseVC; // 录音基本处理类


+ (RecordAndPlayMenager *)shareInstance;
/**
 *  开始录音
 */
- (void)beginRecord;
/**
 *  结束录音
 */
- (void)endRecord;
/**
 *  当文件不允许保存的时候删除问价
 */
- (void)removeFilePath;
/**
 *  关闭计时器
 */
- (void)stopTimer;
/**
 *  创建播放器
 */
- (AVAudioPlayer *)creatPlayer;
@end
