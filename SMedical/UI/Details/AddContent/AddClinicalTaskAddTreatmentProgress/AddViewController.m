//
//  AddViewController.m
//  SMedical
//
//  Created by _SS on 14/12/23.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//  AddClinicalTaskAddTreatmentProgress
#import "AddViewController.h"
#import "Header.h"
#import "DataManager.h"
#import "AddScrollView.h"
#import "SelectTableViewController.h"
#import "DateSelectViewController.h"
#import "TextTableViewController.h"
#import "NSData+Base64.h"
#import "RecordAndPlayMenager.h"

@interface AddViewController ()<UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>{
    AddScrollView *_addView;
    NSString *_principal;
    int _recordingCount;          // 录音文件的个数
    int _takePicturesCount;
    NSMutableArray *_selectDic;   // 选择了的数据
    NSMutableArray *_titleArray;  // 选择数据的title内容
    BOOL _isRecording;            // 是否处于录音状态
    BOOL _isHaveFile;             // 是否已经有存在的文件
    BOOL _canNotSend;
    CGFloat _curCount;            //当前计数,初始为0
    NSTimer *_timer;
    AVAudioPlayer *_player;
    NSTimer * _playtimer; // 用NSTimer监控音频播放进度

    // 播放录音
    UILabel *_begainLabel;
    UILabel *_endLabel;
    UISlider *_slider;
    BOOL _isPause;
    NSTimeInterval _timeinterval;


}
@end

@implementation AddViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showSelectDate" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendsectonmassege" object:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];

    _principal = @"护士";
    _selectDic = [[NSMutableArray alloc] init];
    _titleArray = [[NSMutableArray alloc] init];
    _recordingCount = 0;
    _takePicturesCount = 0;
    
    if (self.isAddClinicalTask == YES) {
        self.navigationItem.title = @"新临床任务";
    }else{
        self.navigationItem.title = @"新治疗进度";
    }
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = RGBACOLOR(245, 245, 245, 1);

    UIBarButtonItem *leftBBI = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(dismissAddView:)];
    self.navigationItem.leftBarButtonItem = leftBBI;
    
    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:(UIBarButtonItemStylePlain) target:self action:@selector(createNewClinicalTask:)];
    self.navigationItem.rightBarButtonItem = rightBBI;
    
    if (self.isAddClinicalTask == YES) {
        [self inputAccessoryView4ClinicalTasktextViewAction];
    }else{
        _addView = [[AddScrollView alloc] initAddTreatmentProgressViewWithFrame:[UIScreen mainScreen].bounds];
    }
    [self.view addSubview:_addView];
    
    // 类别选择
    [self view:_addView.selectView addTapGestureRecognizerwithAction:@selector(selectCategoryItem:)];
    
    // 文本
    _addView.textView.delegate = self;
    
    // 录音
    [self view:_addView.recordingImageView addTapGestureRecognizerwithAction:@selector(recording:)];
    UIImageView *aimageView = (UIImageView *)[_addView.pushView viewWithTag:PUSHVIEW_IMAGEVIEW];
    aimageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecord = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginRecording:)];
    // 点击录音开始键开始录音
    [aimageView addGestureRecognizer:tapRecord];
    // 点击录音同时推出覆盖层，点击覆盖层回收录音界面同时覆盖层消失
    UITapGestureRecognizer *tapCorver = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCorver:)];
    [[_addView viewWithTag:MAIN_COVERIMAGEVIEW] addGestureRecognizer:tapCorver];
    // 点击重新摄录按键的响应事件
    UIButton *newRecordBtn = (UIButton *)[_addView.showRecordView viewWithTag:SHOWRECORDVIEW_NEWRECORDBTN];
    [newRecordBtn addTarget:self action:@selector(recordNewOne:) forControlEvents:(UIControlEventTouchDown)];
    // 点击使用按键的响应事件
    UIButton *useBtn = (UIButton *)[_addView.showRecordView viewWithTag:SHOWRECORDVIEW_USEBTN];
    [useBtn addTarget:self action:@selector(userecord:) forControlEvents:(UIControlEventTouchDown)];
    UIButton *showBtn = (UIButton *)[_addView.showRecordView viewWithTag:SHOWRECORDVIEW_SHOWBUTTON];
    [showBtn addTarget:self action:@selector(palyRecord:) forControlEvents:UIControlEventTouchDown];
    
    _isHaveFile = NO;
    _isRecording = NO;
    [RecordAndPlayMenager shareInstance].recorder.delegate = self;
    
    // 播放录音
    _player.delegate = self;
    _begainLabel = (UILabel *)[_addView.showRecordView viewWithTag:SHOWRECORDVIEW_BEGINLABEL];
    _endLabel = (UILabel *)[_addView.showRecordView viewWithTag:SHOWRECORDVIEW_ENDLABEL];
    _slider = (UISlider *)[_addView.showRecordView viewWithTag:SHOWRECORDVIEW_SLIDER];
    [_slider addTarget:self action:@selector(handlePlayProgress:) forControlEvents:UIControlEventValueChanged];

    // 照相
    [self view:_addView.takepicturesImageView addTapGestureRecognizerwithAction:@selector(takePictures:)];
    
    // 消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDate:) name:@"showSelectDate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addmesaage:) name:@"sendsectonmassege" object:nil];
    
}
#pragma mark - 初始化控件的响应方法
#pragma mark - 头部按钮事件
- (void)dismissAddView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)createNewClinicalTask:(id)sender{
    [_addView.textView resignFirstResponder];
    UIActionSheet *aActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"创建",@"创建和新建", nil];
    [aActionSheet showInView:self.view];
    
}
#pragma mark - 内容响应事件
#pragma mark - 类别选择事件
- (void)selectCategoryItem:(id)sender{
    [UIView animateWithDuration:0.3 animations:^{
        _addView.categoryMarkLabel.alpha = 0.1;
    } completion:^(BOOL finished) {
        _addView.categoryMarkLabel.alpha = 1;
    }];
    
    SelectTableViewController *selectTVC = [[SelectTableViewController alloc] init];
    if (self.isAddClinicalTask == YES) {
        selectTVC.isAddClinicalTask = YES;
    }else{
        selectTVC.isAddClinicalTask = NO;
    }
    [self.navigationController pushViewController:selectTVC animated:YES];
}
#pragma mark - AddClinicalTask键盘按键响应事件
- (void)inputAccessoryView4ClinicalTasktextViewAction{
    _addView = [[AddScrollView alloc] initAddClinicalTaskViewWithFrame:[UIScreen mainScreen].bounds];
    // 负责人选择事件
    [_addView.segmentCtr addTarget:self action:@selector(selectSegmentIndecx:) forControlEvents:UIControlEventTouchDown];
    // 键盘响应事件
    [_addView.clinicalTaskdateButton addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchDown];
    [_addView.markButton addTarget:self action:@selector(showMarkInfo:) forControlEvents:UIControlEventTouchDown];
    [self view:_addView.XRLabel addTapGestureRecognizerwithAction:@selector(tapcontent:)];
    [self view:_addView.XRLabel addLongPressRecognizerwithAction:@selector(longPresscontent:)];
    
    [self view:_addView.checkCxLabel addTapGestureRecognizerwithAction:@selector(tapcontent:)];
    [self view:_addView.checkCxLabel addLongPressRecognizerwithAction:@selector(longPresscontent:)];
    
    [self view:_addView.makeCxLabel addTapGestureRecognizerwithAction:@selector(tapcontent:)];
    [self view:_addView.makeCxLabel addLongPressRecognizerwithAction:@selector(longPresscontent:)];
    
    [self view:_addView.checkResultLabel addTapGestureRecognizerwithAction:@selector(tapcontent:)];
    [self view:_addView.checkResultLabel addLongPressRecognizerwithAction:@selector(longPresscontent:)];
    [_addView.othButton addTarget:self action:@selector(showOthInfo:) forControlEvents:UIControlEventTouchDown];
}

- (void)inputAccessoryView4TreatmentProgressViewAction{
    
}
#pragma mark - 为视图添加tap手势
- (void)view:(UIView *)view addTapGestureRecognizerwithAction:(SEL)action{
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    [view addGestureRecognizer:tap];
}

#pragma mark - 为视图添加LongPress手势
- (void)view:(UIView *)view addLongPressRecognizerwithAction:(SEL)action{
    view.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:action];
    [view addGestureRecognizer:longPress];
}

#pragma mark - 录音播放界面
#pragma mark - 录音相关

//  单击录音按钮
- (void)beginRecording:(UITapGestureRecognizer *)tap{
    if (_isRecording == NO) {
        _isRecording = YES;
        [[RecordAndPlayMenager shareInstance] beginRecord];
        _canNotSend = NO;
        tap.view.backgroundColor = [UIColor redColor];
        [tap.view.layer addAnimation:[self opacityForever_Animation:0.5] forKey:@"flash"];
    }else{
        _isRecording = NO;
        [self showRecordPalyView];
        [[RecordAndPlayMenager shareInstance] endRecord];
    }
}

// 重新摄录事件
- (void)recordNewOne:(UIButton *)button{
    [self dismissRecordPlayView];
    [_addView.pushView viewWithTag:PUSHVIEW_IMAGEVIEW].hidden = NO;
    [[RecordAndPlayMenager shareInstance] removeFilePath];
}

// 录音使用事件
- (void)userecord:(UIButton *)button{
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [_addView viewWithTag:MAIN_COVERIMAGEVIEW].hidden = YES;
        _addView.pushView.transform = CGAffineTransformMakeTranslation(0, 200);
        if (_isHaveFile == YES) {
        }else{
            _addView.textView.frame = CGRectMake(20, 160, SCREENWIDTH - 40, SCREENHEIGHT_INBAR - 220);
        }
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 回收录音时推出来的覆盖层
- (void)dismissCorver:(UITapGestureRecognizer *)tap{
    // 数据变化
    [[RecordAndPlayMenager shareInstance] endRecord];
    [[RecordAndPlayMenager shareInstance] removeFilePath];
    // 界面变化
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [_addView viewWithTag:MAIN_COVERIMAGEVIEW].hidden = YES;
        _addView.pushView.transform = CGAffineTransformMakeTranslation(0, 200);
        [self dismissRecordPlayView];
        if (_isHaveFile == YES) {
        }else{
            _addView.textView.frame = CGRectMake(20, 160, SCREENWIDTH - 40, SCREENHEIGHT_INBAR - 220);
        }
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 播放录音相关
// 播放录音
- (void)palyRecord:(UIButton *)abutton{
    _player = [[RecordAndPlayMenager shareInstance] creatPlayer];
    if ([abutton.backgroundColor isEqual:[UIColor redColor]]) {
        abutton.backgroundColor = [UIColor yellowColor];
        // NSTimer继续
        [_playtimer setFireDate:[NSDate date]];
        if (_isPause == YES) {
            _player.currentTime = _timeinterval;
        }
        [_player play];
        
    }else{
        abutton.backgroundColor = [UIColor redColor];
        _isPause = YES;
        _timeinterval = _slider.value * _player.duration;
        // NSTimer暂停
        [_playtimer setFireDate:[NSDate distantFuture]];
    }
}
// 展示录音播放界面
- (void)showRecordPalyView{
    _isPause = NO;
    [[_addView.pushView viewWithTag:PUSHVIEW_IMAGEVIEW].layer removeAnimationForKey:@"flash"];
    [_addView.pushView viewWithTag:PUSHVIEW_IMAGEVIEW].backgroundColor = [UIColor yellowColor];
    [_addView.pushView viewWithTag:PUSHVIEW_IMAGEVIEW].hidden = YES;
    _addView.showRecordView.hidden = NO;
    // 初始化NSTimer 监控音频播放进度
    _playtimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playProgress) userInfo:nil repeats:YES];
    
}
#pragma mark - 录音界面消失
- (void)dismissRecordPlayView{
    _addView.showRecordView.hidden = YES;
    [_playtimer invalidate];
    _player = nil;
    [RecordAndPlayMenager shareInstance].recorder = nil;
    _playtimer = nil;
}

/**
 *  监控录音播放时相关数据的变化
 */
- (void)playProgress{
    NSString *nowCurrTime = [self timeShowWithPlayerTime:_player.currentTime];
    NSLog(@"%@",nowCurrTime);

    NSString * dTime = [self timeShowWithPlayerTime:(_player.duration - _player.currentTime)];
    _slider.value = _player.currentTime / _player.duration;
    _begainLabel.text = nowCurrTime;
    _endLabel.text = [NSString stringWithFormat:@"-%@",dTime];
}

// 播放器的时间转化
- (NSString *)timeShowWithPlayerTime:(CGFloat )playerTime{
    NSInteger currTime = round(playerTime);
    //int value_h= timeCount/(60*60);
    int value_m = currTime%(60*60)/60;
    int value_s = currTime%(60*60)%60%60;
    NSString *minString;
    NSString *secString;
    if (value_m<10){
        minString=[NSString stringWithFormat:@"0%d:",value_m];
    }
    else {
        minString=[NSString stringWithFormat:@"%d:",value_m];
    }
    if (value_s<10){
        secString=[NSString stringWithFormat:@"0%d",value_s];
    }
    else {
        secString=[NSString stringWithFormat:@"%d",value_s];
    }
    //当前播放时间字符串MM:SS
    NSString *time=[minString stringByAppendingString:secString];
    return time;
}
/**
 *  点击录音按钮事件
 *
 *  @param sender bton
 */
- (void)recording:(id)sender{
    [_addView.pushView viewWithTag:PUSHVIEW_IMAGEVIEW].hidden = NO;
    _addView.showRecordView.hidden = YES;
    _isRecording = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        _addView.pushView.backgroundColor = [UIColor whiteColor];
        _addView.pushView.transform = CGAffineTransformMakeTranslation(0, -200);
        _addView.textView.frame = CGRectMake(20, 160, SCREENWIDTH - 40, SCREENHEIGHT_INBAR - 220 - 90);
    } completion:^(BOOL finished) {
        [_addView viewWithTag:MAIN_COVERIMAGEVIEW].hidden = NO;
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }];
    
}


#pragma mark - 照相相关
- (void)takePictures:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;//UIImagePicker选择器的类型，UIImagePickerControllerSourceTypeCamera调用系统相机
        picker.delegate = self;//设置UIImagePickerController的代理，同时要遵循UIImagePickerControllerDelegate，UINavigationControllerDelegate协议
        // 添加备注
        UIView *showLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 100, SCREENWIDTH,30)];
        showLabelView.backgroundColor = [UIColor blackColor];
        UILabel *alabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
        alabel.text = @"XXXXXXXXXXXXXXXXXX";
        alabel.textColor = [UIColor whiteColor];
        [showLabelView addSubview:alabel];
        showLabelView.alpha = 0.6;
        [picker.view addSubview:showLabelView];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        //如果当前设备没有摄像头
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"当前设备没有摄像头 " delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}


#pragma mark - slider调整播放进度的响应方法
- (void)handlePlayProgress:(UISlider *)slider{
    [_addView.showRecordView viewWithTag:SHOWRECORDVIEW_SHOWBUTTON].backgroundColor = [UIColor redColor];
    [_playtimer setFireDate:[NSDate distantFuture]];
    [_player pause];
    _isPause = YES;
    _timeinterval = _slider.value * _player.duration;
}

#pragma mark - 消息响应事件
// 给文本框添加时间
- (void)addDate:(NSNotification *)notifivation{
    NSDictionary *info = notifivation.userInfo;
    NSString *time = [info objectForKey:@"time"];
    NSString *oldStr = _addView.textView.text;
    _addView.textView.text = [oldStr stringByAppendingString:time];
}
// 给文本框添加可选择的内容
- (void)addmesaage:(NSNotification *)notifivation{
    NSDictionary *info = notifivation.userInfo;
    NSString *message = [[info objectForKey:@"dic"] objectForKey:@"title"];
    NSString *oldStr = _addView.textView.text;
    _addView.textView.text = [oldStr stringByAppendingString:message];
    [[NSUserDefaults standardUserDefaults] setObject:[info objectForKey:@"dic"]forKey:message];
}

#pragma mark - 闪烁动画
- (CABasicAnimation *)opacityForever_Animation:(float)time{
    CABasicAnimation *animation   = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue           = [NSNumber numberWithFloat:1.0f];
    animation.toValue             = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses        = YES;
    animation.duration            = time;
    animation.repeatCount         = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode            = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}
#pragma mark - AVAudioRecorder Delegate Methods
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    // NSLog(@"录音停止");
    [[RecordAndPlayMenager shareInstance] stopTimer];
    _curCount = 0;
}
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    NSLog(@"录音开始");
    [[RecordAndPlayMenager shareInstance] stopTimer];
    _curCount = 0;
}
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags{
    NSLog(@"录音中断");
    [[RecordAndPlayMenager shareInstance] stopTimer];
    _curCount = 0;
}

#pragma mark - AVAudioPlayerDelegate
//  音频播放完成时
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    // 音频播放完成时，调用该方法。
    // 参数flag：如果音频播放无法解码时，该参数为NO。
    // 当音频被终端时，该方法不被调用。而会调用audioPlayerBeginInterruption方法
    // 和audioPlayerEndInterruption方法

    _slider.value = 0;
    _begainLabel.text = @"00:00";
    _endLabel.text =[NSString stringWithFormat:@"-%@",[self timeShowWithPlayerTime:_player.duration]];
    _isPause = NO;
    _player.currentTime = 0;
    [_playtimer setFireDate:[NSDate distantFuture]];
    [_addView.showRecordView viewWithTag:SHOWRECORDVIEW_SHOWBUTTON].backgroundColor = [UIColor redColor];
}

//  解码错误
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"解码错误！");
}

//  当音频播放过程中被中断时
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    // 当音频播放过程中被中断时，执行该方法。比如：播放音频时，电话来了！
    // 这时候，音频播放将会被暂停。
}
//  当中断结束时
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    NSLog(@"中断结束，恢复播放");
    if (flags == AVAudioSessionInterruptionOptionShouldResume  && player != nil){
        [player play];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectcellisclick"];
    if (str) {
        _addView.categoryMarkLabel.text = str;
    }else{
        _addView.categoryMarkLabel.text = @"未选择类别";
    }
    
}
#pragma mark - Delegate
#pragma mark - texteViewDelegate
// 键盘推出的状态
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.4 animations:^{
        if (self.isAddClinicalTask == YES) {
            _addView.textView.frame = CGRectMake(20, 160, SCREENWIDTH - 40, SCREENHEIGHT_INBAR - 365);
            _addView.contentOffset = CGPointMake(0, 130);
        }else{
            _addView.textView.frame = CGRectMake(20, 95, SCREENWIDTH - 40, SCREENHEIGHT_INBAR - 365);
            _addView.contentOffset = CGPointMake(0, 65);
        }
    }];
    return YES;
}
// 键盘回收的状态
- (void)textViewDidEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.4 animations:^{
        if (self.isAddClinicalTask == YES) {
            _addView.textView.frame = CGRectMake(20, 160, SCREENWIDTH - 40, SCREENHEIGHT_INBAR - 220);
            _addView.contentOffset = CGPointMake(0, 0);
        }else{
            _addView.textView.frame = CGRectMake(20, 95, SCREENWIDTH - 40, SCREENHEIGHT_INBAR - 155);
            _addView.contentOffset = CGPointMake(0, 0);
        }
    }];
}
#pragma mark - segmentDelegate
- (void)selectSegmentIndecx:(UISegmentedControl *)segmentedCtr{
    switch (segmentedCtr.selectedSegmentIndex) {
        case 0:{
            _principal = @"护士";
        }
            break;
        case 1:{
            _principal = @"医师";
        }
            break;
        case 2:{
            _principal = @"本人";
        }
            break;
        case 3:{
            _principal = @"其他";
        }
            break;
            
        default:
        break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
#pragma mark - 拍照结束
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原始图片
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//把图片存到图片库
        NSLog(@"进行后续操作");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 取消拍照
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [_addView.textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([@"\n" isEqualToString:text] == YES){
        if (_addView.markShowView.hidden == NO) {
            _addView.markShowView.hidden = YES;
        }else{
            [_addView.textView resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *nowTime = [self getNowTime];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:_addView.textView.text forKey:@"name"];
    [dic setObject:nowTime forKey:@"date"];
    [dic setObject:_addView.categoryMarkLabel.text forKey:@"category"];
    [dic setObject:_principal forKey:@"ID"];
    [dic setObject:@"Dr.Michael Schneider,医师" forKey:@"state"];
    
    NSString *recordingStr;
    NSString *takePicturesStr;
    if(_recordingCount > 0){
        recordingStr = [[NSString alloc] initWithFormat:@"音频 %d",_recordingCount];
    }else{
        recordingStr = @"";
    }
    if (_takePicturesCount > 0) {
        takePicturesStr = [[NSString alloc] initWithFormat:@"影像 %d",_takePicturesCount];
    }else{
        takePicturesStr = @"";
    }
    
    NSString *contentStr = [[NSString alloc] initWithFormat:@"%@%@",recordingStr,takePicturesStr];
    [dic setObject:contentStr forKey:@"content"];
    
    NSString *rsKey = [[NSString alloc] initWithFormat:@"%@",self.patientName];
    NSDictionary *resultDic = [[NSDictionary alloc] initWithObjectsAndKeys:dic,rsKey, nil];
    
    switch (buttonIndex) {
        case 0:{
            if (_addView.textView.text.length > 0) {
                [[DataManager shareInstance] createClinicalTaskTableWithPatientName:self.patientName];
                [[DataManager shareInstance] insertWithPatientName:self.patientName dic:resultDic];
                // 测试输入数据
                [[DataManager shareInstance] showClinicalTaskTableContentWithPatientName:self.patientName];
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文本内容不能不空" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alertView show];
            }
        }
            break;
        case 1:{
            if (_addView.textView.text.length > 0) {
                [[DataManager shareInstance] createClinicalTaskTableWithPatientName:self.patientName];
                [[DataManager shareInstance] insertWithPatientName:self.patientName dic:resultDic];
                // 测试输入数据
                [[DataManager shareInstance] showClinicalTaskTableContentWithPatientName:self.patientName];
                _addView.textView.text = @"";
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文本内容不能不空" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alertView show];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 获取当前的时间
- (NSString *)getNowTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy/MM/dd ah:mm"];
    NSDate * nowDate = [NSDate date];
    NSString * nowTime = [formatter stringFromDate:nowDate];
    return nowTime;
}
#pragma mark - textView的inputAccessoryView控件的点击事件
#pragma mark - ClinicalTaskView
- (void)selectDate:(id)sender{
    if (_addView.markShowView.hidden == NO) {
        _addView.showMarkLabel.text = @"没有可用模板";
    }else{
        DateSelectViewController *dateSelectVC = [[DateSelectViewController alloc] init];
        [self.navigationController pushViewController:dateSelectVC animated:YES];
    }
}

- (void)showMarkInfo:(id)sender{
    _addView.showMarkLabel.text = @"输入标记";
    if (_addView.markShowView.hidden == NO) {
    }else{
        NSString *text = _addView.textView.text;
        _addView.textView.text = [text stringByAppendingString:@"\n#"];
        _addView.markShowView.hidden = NO;
    }
}

- (void)tapcontent:(UITapGestureRecognizer *)tap{
    if ([tap.view isEqual:_addView.XRLabel]) {
        [self showMarkLabelTextOrTextViewText:@"审核放射医学影像"];
    }
    if ([tap.view isEqual:_addView.makeCxLabel]) {
        [self showMarkLabelTextOrTextViewText:@"制备培养标本"];
    }
    if ([tap.view isEqual:_addView.checkCxLabel]) {
        [self showMarkLabelTextOrTextViewText:@"检查培养报告"];
    }
    if ([tap.view isEqual:_addView.checkResultLabel]) {
        [self showMarkLabelTextOrTextViewText:@"检查化验报告"];
    }
   
}

- (void)showMarkLabelTextOrTextViewText:(NSString *)textviewtext{
    if (_addView.markShowView.hidden == NO) {
        _addView.showMarkLabel.text = @"没有可用模板";
    }else{
        NSString *text = _addView.textView.text;
        _addView.textView.text = [text stringByAppendingString:textviewtext];
    }

}

- (void)longPresscontent:(UILongPressGestureRecognizer *)longPress{
    _addView.showView.hidden = NO;
    if ([longPress.view isEqual:_addView.XRLabel]) {
       _addView.showLabel.text = @"审核放射医学影像";
    }
    if ([longPress.view isEqual:_addView.checkCxLabel]) {
        _addView.showLabel.text = @"检查培养报告";
    }
    if ([longPress.view isEqual:_addView.makeCxLabel]) {
        _addView.showLabel.text = @"制备培养标本";
    }
    if ([longPress.view isEqual:_addView.checkResultLabel]) {
        _addView.showLabel.text = @"检查化验报告";
    }
    [UIView animateWithDuration:0.5 animations:^{
        _addView.showView.transform = CGAffineTransformMakeTranslation(0, - 50);
        [self delay2secondsShowView];
    } completion:^(BOOL finished) {
    }];
}

- (void)showMarkLabelTextOrShowLabelText:(NSString *)labeltext{
    if (_addView.markShowView.hidden == NO) {
        _addView.showMarkLabel.text = @"没有可用模板";
    }else{
        _addView.showLabel.text = labeltext;
    }
}

- (void)delay2secondsShowView{
    __block int timeout = 2.0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _stimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_stimer,dispatch_walltime(NULL, 0), (uint64_t) (1.0 * NSEC_PER_SEC), 0);
    dispatch_source_set_event_handler(_stimer, ^{
        if(timeout <= 0){
            dispatch_source_cancel(_stimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    _addView.showView.transform = CGAffineTransformMakeTranslation(0, 0);
                } completion:^(BOOL finished) {
                    _addView.showView.hidden = YES;
                }];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
            });
            timeout--;
        }
    });
    dispatch_resume(_stimer);
}

- (void)showOthInfo:(id)sender{
    TextTableViewController *textTVC = [[TextTableViewController alloc] init];
    [self.navigationController pushViewController:textTVC animated:YES];
}

#pragma mark - TreatmentProgress

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
