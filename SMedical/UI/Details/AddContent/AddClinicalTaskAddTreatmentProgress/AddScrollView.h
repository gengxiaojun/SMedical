//
//  AddScrollView.h
//  SMedical
//
//  Created by _SS on 14/12/23.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddScrollView : UIScrollView
@property (nonatomic, strong) UITextView *textView;               // 文本输入框
@property (nonatomic, strong) UIView *selectView;                 // 类别选择视图
@property (nonatomic, strong) UILabel *categoryMarkLabel;         // 类别展示label
@property (nonatomic, strong) UISegmentedControl *segmentCtr;     // 负责人选择segmentCtr
@property (nonatomic, strong) UIImageView *recordingImageView;    // 点击录音
@property (nonatomic, strong) UIImageView *takepicturesImageView; // 点击照相
@property (nonatomic, strong) UIView *pushView;                   // 点击录音推出来的view
@property (nonatomic, strong) UIView *showRecordView;             // 展示录音内容

//  键盘按键
@property (nonatomic, strong) UIButton *clinicalTaskdateButton;
@property (nonatomic, strong) UIButton *markButton;
@property (nonatomic, strong) UILabel *XRLabel;
@property (nonatomic, strong) UILabel *checkCxLabel;
@property (nonatomic, strong) UILabel *makeCxLabel;
@property (nonatomic, strong) UILabel *checkResultLabel;
@property (nonatomic, strong) UIButton *othButton;

//  长按键盘按键显示视图
@property (nonatomic, strong) UILabel *showLabel; // 长按键盘显示数据
@property (nonatomic, strong) UIView *showView;

//  点击markButton显示的视图
@property (nonatomic, strong) UIImageView *markShowView;
@property (nonatomic, strong) UILabel *showMarkLabel;

- (instancetype)initAddClinicalTaskViewWithFrame:(CGRect)frame;
- (instancetype)initAddTreatmentProgressViewWithFrame:(CGRect)frame;
@end
