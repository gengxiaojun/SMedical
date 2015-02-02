//
//  RecordAndPlayMenager.m
//  SMedical
//
//  Created by _SS on 15/1/23.
//  Copyright (c) 2015年 shanshan. All rights reserved.
//

#import "RecordAndPlayMenager.h"
#import "VoiceRecorderBaseVC.h"

@interface RecordAndPlayMenager ()<VoiceRecorderBaseVCDelegate>{
    CGFloat _curCount;            //当前计数,初始为0
    NSTimer *_timer;

}

@end
@implementation RecordAndPlayMenager

+ (RecordAndPlayMenager *)shareInstance{
    static RecordAndPlayMenager *shower = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shower = [[RecordAndPlayMenager alloc] init];
    });
    return shower;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.recordBaseVC = [[VoiceRecorderBaseVC alloc] init];
        self.recordBaseVC.vrbDelegate = self;
    }
    return self;
}
- (void)beginRecord{
    self.originWav = [VoiceRecorderBaseVC getCurrentTimeString];
    self.recordFilePath = [VoiceRecorderBaseVC getPathByFileName:self.originWav ofType:@"wav"];
    // 初始化录音
    NSError *error;
    NSDictionary *dic = [VoiceRecorderBaseVC getAudioRecorderSettingDict];
    self.recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:self.recordFilePath]
                                           settings:dic
                                              error:&error];
    self.recorder.meteringEnabled = YES;  // 计量
    [self.recorder prepareToRecord];
    _curCount = 0;
   
    //开始录音
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [_recorder record];
    [self startTimer];

}

- (void)endRecord{
    [self stopTimer];
    if (_recorder.isRecording == YES) {
        [_recorder stop];
    }
    if ([self respondsToSelector:@selector(VoiceRecorderBaseVCRecordFinish:fileName:)]) {
        [self VoiceRecorderBaseVCRecordFinish:self.recordFilePath fileName:self.originWav];
    }
    NSLog(@"%@",self.recordFilePath);

}
#pragma mark - 停止定时器
- (void)stopTimer{
    if (_timer && _timer.isValid){
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - 启动定时器
- (void)startTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateRecordMeters) userInfo:nil repeats:YES];
}

#pragma mark - 更新音频峰值
- (void)updateRecordMeters{
    if (_recorder.isRecording){
        //更新峰值
        [_recorder updateMeters];
        _curCount += 0.1f;
        //倒计时
        if (_curCount >= _recordBaseVC.maxRecordTime){
            //时间到
            [self endRecord];
        }
    }
}

- (void)removeFilePath{
    // 不能使用，删除文件
    [VoiceRecorderBaseVC deleteFileAtPath:self.recordFilePath];
}

- (AVAudioPlayer *)creatPlayer{
    AVAudioPlayer *player;
    NSError *playerError;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:self.recordFilePath] error:&playerError];
    if (player == nil){
        NSLog(@"ERror creating player: %@", [playerError description]);
    }
    return player;
}

#pragma mark - VoiceRecorderBaseVC Delegate Methods
//录音完成回调，返回文件路径和文件名
- (void)VoiceRecorderBaseVCRecordFinish:(NSString *)_filePath fileName:(NSString*)_fileName{
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //  转换格式 为了给用户省流量
    //    NSString *path = [[[paths objectAtIndex:0]
    //                       stringByAppendingPathComponent:@"Voice"]
    //                      stringByAppendingPathComponent:[[_fileName
    //                                                       stringByAppendingString:@".amr"] stringByReplacingOccurrencesOfString:@".wav" withString:@""]];
    //    NSFileManager *fileManager = [[NSFileManager alloc]init];
    //    if ([fileManager fileExistsAtPath:path]) {
    //        NSData *data = [NSData dataWithContentsOfFile:path];
    //        NSString *base64 = [data base64EncodedString]; 与服务器交互的时候使用
    //    }
}



@end
